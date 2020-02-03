//
//  ShowedViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 28.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ShowedViewController.h"
#import "DesignObject.h"
#import "AtrStrStore.h"
#import "CalcButton.h"
#import "ShareButton.h"
#import "CleanButton.h"
#import "BezierInterpView.h"

#define INDENT 20.0f

NSString *const ShowedViewIsDirtyNotification = @"ShowedViewIsDirtyNotification";


@interface ShowedViewController()


@property (strong) NSAttributedString* expressionString;
@property (strong) NSAttributedString* resultString;
@property (strong) NSAttributedString* descrString;

@property (weak, nonatomic) IBOutlet UIStackView *buttonsStackView;
@property (weak, nonatomic) IBOutlet UIButton *redPanButton;
@property (weak, nonatomic) IBOutlet UIButton *bluePanButton;
@property (weak, nonatomic) IBOutlet CalcButton *calcButton;
@property (weak, nonatomic) IBOutlet ShareButton *shareButton;

@property (weak, nonatomic) IBOutlet CleanButton *cleanButton;
@property (weak, nonatomic) IBOutlet BezierInterpView *beizerPatchView;

@end

@implementation ShowedViewController

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

static BOOL isCompactClassSize;

-(void) willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if((newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)|| (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)){
        isCompactClassSize = YES;
    } else {
        isCompactClassSize = NO;
    }
}

-(void)viewDidLayoutSubviews{
    
    if((self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)|| (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)){
        isCompactClassSize = YES;
    } else {
        isCompactClassSize = NO;
    }
}


-(void)setNeedStrings:(NSAttributedString *)descr expStr:(NSAttributedString *)count andRes:(NSAttributedString *)res{

    if([descr length]>0){
      self.descrString = descr;
    } else {
        self.descrString = nil;
        self.descrLabelHeightConstrain.constant = 0;
    }
    self.descrString = descr;
    self.expressionString = count;
    self.resultString = res;
}

static BOOL isStringsBuzy;

-(void)upDateStringsWithInfSize:(CGSize)infSize exprSize:(CGSize)exprSize resSize:(CGSize)resSize {
    
    if(!isStringsBuzy){
        isStringsBuzy = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat infFontPoint;
        CGFloat expFontPoint;
        CGFloat resFontPoint;
        //CGFloat redLineBeizerPatchWidth;
        if(isCompactClassSize ){
            infFontPoint = 24.;
            expFontPoint = 54.;
            resFontPoint = 90.;
        } else {
            infFontPoint = 32.;
            expFontPoint = 74.;
            resFontPoint = 120.;
        }
        //redLineBeizerPatchWidth = expFontPoint*0.8;
        
        if(self.descrString){
            self.descrString = [AtrStrStore resizeAttrString:self.descrString
                                           WithInitPointSize:infFontPoint
                                              accordingBound:infSize
                                                    byHeight:YES];
        }
       

        self.expressionString = [AtrStrStore resizeAttrString:self.expressionString
                             WithInitPointSize:expFontPoint
                                accordingBound:exprSize
                                      byHeight:YES];
        //redLineBeizerPatchWidth = [AtrStrStore pointSizeOfAtrString:self.expressionString ];
        
        self.resultString = [AtrStrStore resizeAttrString:self.resultString
                             WithInitPointSize:resFontPoint
                                accordingBound:resSize
                                      byHeight:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.descriptionLabel.attributedText = self.descrString;
            self.expressionLabel.attributedText = self.expressionString;
            self.resultLabel.attributedText = self.resultString;

            //self.beizerPatchView.lineWidth = redLineBeizerPatchWidth;
           // [self cleanBeizerPatch];
            isStringsBuzy = NO;
            //NSLog(@"Finish");
        });
    });
    }
}


#pragma mark ACTION

- (IBAction)redPanButtonTapped:(id)sender {
    self.beizerPatchView.isBlueColor = NO;
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanSelected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanUnselected2.png"] forState:normal];
    
}

- (IBAction)bluePanButtonTapped:(id)sender {
    self.beizerPatchView.isBlueColor = YES;
    //set new image for that button
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanUnselected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanSelected2.png"] forState:normal];
   
}

- (IBAction)cleanButtonTapped:(id)sender {
    [self cleanBeizerPatch];
}

-(void) cleanBeizerPatch {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.beizerPatchView.alpha = 0.;
                     } completion:^(BOOL finished) {
                         [self.beizerPatchView clearPatch];
                         self.beizerPatchView.alpha = 1.;
                     }];
    self.cleanButton.enabled = NO;
}

- (IBAction)shareButtonTapped:(id)sender {

    UIGraphicsBeginImageContextWithOptions(self.viewForRenderImage.bounds.size, self.containerView.opaque, 0.0);
    
    
    [self.viewForRenderImage.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * ItsCalc = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects:ItsCalc, nil];//strToShare
    
    UIActivityViewController *activity = [[UIActivityViewController alloc]
                                          initWithActivityItems:activityItems
                                          applicationActivities:nil];
    //very important for ipad!!!
    if(IS_IPAD){
        activity.popoverPresentationController.sourceView = self.view;
    }
    
    activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact];
    [self presentViewController:activity animated:YES completion:nil];
    self.buttonsStackView.alpha = 1;
}

- (IBAction)calcButtonTapped:(id)sender {
    [self dismis];
}


//recive selector for notification from beizerview (painted view)
-(void) DurtyBezierView
{
    self.cleanButton.enabled = YES;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    if(IS_X){
        self.buttonsLeadingConstrain.constant = 64;
        self.stackTrailingConstrain.constant = 64;
    }
    if(IS_IPAD){
        self.calcButton.hidden = NO;
    } else {
        self.calcButton.hidden = YES;
    }
    [self.containerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych1.png"]]];
    [self.viewForRenderImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych1.png"]]];
    isStringsBuzy = NO;
    self.beizerPatchView.isBlueColor = YES;
    self.cleanButton.enabled = NO;

   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DurtyBezierView) name:@"BezierViewIsDirtyNotification" object:nil];
     /*
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appWillGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)appWillGoToBackground:(NSNotification *)note{
   // self.transitioningDelegate = self;
    [self dismis];

}
*/

@end
