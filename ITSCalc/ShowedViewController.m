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
#import "ShowedView.h"
#import "CalcButton.h"
#import "ShareButton.h"
#import "CleanButton.h"

//#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
//#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)

#define INDENT 20.0f

NSString *const ShowedViewIsDirtyNotification = @"ShowedViewIsDirtyNotification";


@interface ShowedViewController()


@property (strong) NSAttributedString* expressionString;
@property (strong) NSAttributedString* resultString;
@property (strong) NSAttributedString* descrString;

@property (weak, nonatomic) IBOutlet UIButton *redPanButton;
@property (weak, nonatomic) IBOutlet UIButton *bluePanButton;
@property (weak, nonatomic) IBOutlet CalcButton *calcButton;
@property (weak, nonatomic) IBOutlet ShareButton *shareButton;

@property (weak, nonatomic) IBOutlet CleanButton *cleanButton;
@property (weak, nonatomic) IBOutlet ShowedView *showedView;


@end

@implementation ShowedViewController

//set this property to allow tap botton buttons in buttonsCollectionView
/*
-(BOOL) prefersStatusBarHidden
{
    return YES;
}
*/

#pragma mark LAZY INITIALIZATION
/*
-(NSAttributedString*)attrStrForLabel
{
    if(!_attrStrForLabel){
        _attrStrForLabel = [[NSAttributedString alloc] initWithString:@"1 + 2 + 3 + 4 = "];
    }
    return _attrStrForLabel;
}

-(NSAttributedString*)resStringforShow
{
    if(!_resStringforShow){
        _resStringforShow = [[NSAttributedString alloc] initWithString:@"NO RESULT"];
    }
    return _resStringforShow;
}
*/
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


-(void)setNeedStrings:(NSAttributedString *)descr :(NSAttributedString *)count andRes:(NSAttributedString *)res{
    NSMutableAttributedString *mutStr = [descr mutableCopy];
    
    //NSLog(@"inf attr %@",self.design.attributesInfo );

    [mutStr beginEditing];
    if([mutStr length]>0 && self.design.attributesInfo){
    [mutStr addAttributes:self.design.attributesInfo range:NSMakeRange(0, [descr length])];
    }
    [mutStr endEditing];
    
    //[mutStr setValuesForKeysWithDictionary:self.design.attributesInfo];
    self.descrString = [mutStr copy];
    
    mutStr = [count mutableCopy];
    [mutStr beginEditing];
    //NSLog(@"Epl attr %@",self.design.attributesExpl );

    if([mutStr length]>0 && self.design.attributesExpl){
        [mutStr addAttributes:self.design.attributesExpl range:NSMakeRange(0, [count length])];
    }
    [mutStr endEditing];
    //[mutStr setValuesForKeysWithDictionary:self.design.attributesInfo];
    self.expressionString = [mutStr copy];
    
    mutStr = [res mutableCopy];
    [mutStr beginEditing];
    //NSLog(@"Res attr %@",self.design.attributesResult );
    if([mutStr length]>0 && self.design.attributesResult){
        [mutStr addAttributes:self.design.attributesResult range:NSMakeRange(0, [res length])];
    }
    [mutStr endEditing];

    //[mutStr setValuesForKeysWithDictionary:self.design.attributesResult]; //
    self.resultString = [mutStr copy];
    //NSLog(@"res attr: %@", [self.resultString attributesAtIndex:0 effectiveRange:NULL]);
}

-(void)upDateStringsWithInfSize:(CGSize)infSize exprSize:(CGSize)exprSize resSize:(CGSize)resSize {
    CGFloat infFontPoint;
    CGFloat expFontPoint;
    CGFloat resFontPoint;
    if(isCompactClassSize ){
        infFontPoint = 24.;
        expFontPoint = 54.;
        resFontPoint = 90.;
    } else {
        infFontPoint = 32.;
        expFontPoint = 74.;
        resFontPoint = 120.;
    }
    
    //NSLog(@"resStr attr: %@", [self.resultString attributesAtIndex:0 effectiveRange:NULL]);
    
    self.descriptionLabel.attributedText = [AtrStrStore resizeAttrString:self.descrString
                                   WithInitPointSize:infFontPoint
                                      accordingBound:infSize
                                            byHeight:YES];
    self.expressionLabel.attributedText = [AtrStrStore resizeAttrString:self.expressionString
                                                      WithInitPointSize:expFontPoint accordingBound:exprSize byHeight:YES];
    self.resultLabel.attributedText = [AtrStrStore resizeAttrString:self.resultString
                                                  WithInitPointSize:resFontPoint
                                                     accordingBound:resSize
                                                           byHeight:NO];
    //NSLog(@"expressionLabel attr: %@", [self.expressionLabel.attributedText attributesAtIndex:0 effectiveRange:NULL]);
    
    //NSLog(@"res attr: %@", [self.resultLabel.attributedText attributesAtIndex:0 effectiveRange:NULL]);

    [self.view setNeedsDisplay];

}


#pragma mark ACTION

- (IBAction)redPanButtonTapped:(id)sender {
    //self.showedView.isBluePanOrRed = NO;
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanSelected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanUnselected2.png"] forState:normal];
    
}

- (IBAction)bluePanButtonTapped:(id)sender {
    //self.showedView.isBluePanOrRed = YES;
    //set new image for that button
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanUnselected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanSelected2.png"] forState:normal];
   
}

- (IBAction)cleanButtonTapped:(id)sender {
    //[self.showedView clearPaintedView];
    /*[UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.paintedView.alpha = 0.;
                     } completion:^(BOOL finished) {
                         [self.paintedView removeFromSuperview];
                         BezierInterpView *paintedView = [[BezierInterpView alloc] initWithFrame:self.bounds];
                         paintedView.backgroundColor = [UIColor clearColor];
                         
                         paintedView.isBlueColor = self.isBluePanOrRed;
                         
                         [self addSubview:paintedView];
                         self.paintedView = paintedView;
                         [self countRedLineSize];
                     }];*/
    self.cleanButton.enabled = NO;
}

- (IBAction)shareButtonTapped:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.showedView.bounds.size, self.showedView.opaque, 0.0);
    [self.showedView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects:img, nil];//strToShare
    
    UIActivityViewController *activity = [[UIActivityViewController alloc]
                                          initWithActivityItems:activityItems
                                          applicationActivities:nil];
    //very important for ipad!!!
    if(IS_IPAD){
        activity.popoverPresentationController.sourceView = self.view;
    }
    
    activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact];
    [self presentViewController:activity animated:YES completion:nil];
}

- (IBAction)calcButtonTapped:(id)sender {
    [self dismis];
}

/*
//recive selector for notification from beizerview (painted view)
-(void) DurtyBezierView
{
        self.cleanButton.enabled = YES;
}
*/

#pragma mark SUBVIEWS LOAD

/*
-(void) setHeightOfElementAccordingToScreenIPhone
{
    CGRect buttonsRect = CGRectMake(0, 0, 60, 60);
    if(IS_IPAD){
        CGFloat cVWidth = self.cView.bounds.size.width;
        CGFloat cVHeight = self.cView.bounds.size.height;
        CGFloat quardSize = sqrtf(powf(cVWidth,2)+powf(cVHeight,2));
        
        
        [self.testView setFrame:CGRectMake((cVWidth-quardSize)/2,(cVHeight-quardSize)/2, quardSize, quardSize)];
        if(self.cView.bounds.size.width < self.cView.bounds.size.height){
            [self.showedView setFrame:CGRectMake((quardSize-cVHeight)/2, (quardSize-cVWidth)/2, cVHeight, cVWidth)];
        } else {
            [self.showedView setFrame:CGRectMake((quardSize-cVWidth)/2, (quardSize-cVHeight)/2, cVWidth, cVHeight)];
        }

        
        //define bounds for all buttons in PDF View
        [self.calcButton setBounds:buttonsRect];
        [self.shareButton setBounds:buttonsRect];
        [self.redPanButton setBounds:buttonsRect];
        [self.bluePanButton setBounds:buttonsRect];
        [self.cleanButton setBounds:buttonsRect];
        
        //it will be total five buttons in PDFView and two empty parts at the bottom and top of view
        //define one segment
        CGFloat oneSegment = self.showedView.bounds.size.height / 8;
        
        //define x center for all buttons
        CGFloat xCenter = (self.testView.bounds.size.width - self.showedView.bounds.size.width)/2 + oneSegment/1.5;
        CGFloat yStart = (self.testView.bounds.size.width - self.showedView.bounds.size.height)/2;
        
        //set centers for each button
        [self.calcButton setCenter:CGPointMake(xCenter, yStart + 2*oneSegment)];
        [self.shareButton setCenter:CGPointMake(xCenter, yStart + 3*oneSegment)];
        [self.redPanButton setCenter:CGPointMake(xCenter, yStart + 4*oneSegment)];
        [self.bluePanButton setCenter:CGPointMake(xCenter, yStart + 5*oneSegment)];
        [self.cleanButton setCenter:CGPointMake(xCenter, yStart + 6*oneSegment)];
        //else if iPhone
    } else if(IS_568_SCREEN){
        [self.testView setFrame:CGRectMake(-42,-166, 652, 652)];
        
        [self.showedView setFrame:CGRectMake(42, 166, 568, 320)];
        
        buttonsRect.origin.x = 60;
        buttonsRect.origin.y = 176;
        [self.shareButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.redPanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.bluePanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.cleanButton setFrame:buttonsRect];
        

    } else {

        [self.testView setFrame:CGRectMake(-48, -128, 577, 577)];
        
        [self.showedView setFrame:CGRectMake(48, 128, 480, 320)];
        
        
        buttonsRect.origin.x = 70;
        buttonsRect.origin.y = 140;
        [self.shareButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.redPanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.bluePanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.cleanButton setFrame:buttonsRect];
        
        
    }
    
}


-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    [self setHeightOfElementAccordingToScreenIPhone];
}

-(void)setNeedViews
{
    //setup container view (not cView its important
    UIView *testView = [[UIView alloc] init];
    [testView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]]];
    [self.cView addSubview:testView];
    self.testView = testView;
    
    //setup showed view
    ShowedView *showedView = [[ShowedView alloc] initWithFrame:self.cView.frame];
    [showedView setShowedViewWithCountedStr:self.attrStrForLabel resultStr:self.resStringforShow andBluePan:YES];
    [self.testView addSubview:showedView];
    self.showedView = showedView;
    
    //setup all buttons
    
    UIButton *redPanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redPanButton addTarget:self action:@selector(redPanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [redPanButton setImage:[UIImage imageNamed:@"redPanUnselected2.png"] forState:normal];
    [self.testView addSubview:redPanButton];
    self.redPanButton = redPanButton;
    
    UIButton *bluePanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bluePanButton addTarget:self action:@selector(bluePanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bluePanButton setImage:[UIImage imageNamed:@"bluePanSelected2.png"] forState:normal];
    [self.testView addSubview:bluePanButton];
    self.bluePanButton = bluePanButton;
    
    UIColor *tintColor = [UIColor colorWithRed:0.25
                                                   green:0.61
                                                    blue:.80
                                                   alpha:1.];
    
    
    ShareButton *shareButton = [ShareButton buttonWithType:UIButtonTypeSystem];
    [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[shareButton set]
    [shareButton setTintColor:tintColor];
    

    [self.testView addSubview:shareButton];
    self.shareButton = shareButton;
    
    CleanButton *cleanButton = [CleanButton buttonWithType:UIButtonTypeSystem];
    [cleanButton addTarget:self action:@selector(cleanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.testView addSubview:cleanButton];
    [cleanButton setTintColor:tintColor];

    cleanButton.enabled = NO;
    self.cleanButton = cleanButton;
    
    if(IS_IPAD){
        CalcButton *calcButton = [CalcButton buttonWithType:UIButtonTypeSystem];
        [calcButton addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [calcButton setTintColor:tintColor];

        [self.testView addSubview:calcButton];
        self.calcButton = calcButton;

    }
}
*/

/*
-(void) viewWillAppear:(BOOL)animated
{
    if(IS_IPAD){
        if(self.cView.bounds.size.width < self.cView.bounds.size.height){
            CGFloat angle = M_PI/2;
            UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
            if(orient == UIDeviceOrientationPortrait || orient == UIDeviceOrientationPortraitUpsideDown){
                
                switch (orient) {
                    case UIDeviceOrientationPortrait:
                        angle = M_PI/2;
                        break;
                    case UIDeviceOrientationPortraitUpsideDown:
                        angle =-M_PI/2;
                        
                    default:
                        break;
                }
            }
            [self.testView setTransform:CGAffineTransformMakeRotation(angle)];
        }
        
    }
}

-(void)viewDidLayoutSubviews{
    self.expressionLabel.adjustsFontSizeToFitWidth=YES;
    self.expressionLabel.minimumScaleFactor=0.2;
}
 */


-(void) viewDidLoad
{
    [super viewDidLoad];
    if(IS_X){
        self.buttonsLeadingConstrain.constant = 64;
        self.stackTrailingConstrain.constant = 64;
        //UIEdgeInsets insets = UIEdgeInsetsZero;
        //insets.bottom = 34.;
        //insets.top = 44.;
        //self.additionalSafeAreaInsets = insets;
    }
    if(IS_IPAD){
        self.calcButton.hidden = NO;
    } else {
        self.calcButton.hidden = YES;
    }
    //[self prepareStringsforLables];
    

   // self.expressionLabel.adjustsFontSizeToFitWidth=YES;
    //self.expressionLabel.minimumScaleFactor=0.2;
     //   self.expressionLabel.attributedText = self.expressionString;
    //[self.expressionLabel setTextColor:[UIColor darkTextColor]];
    //[self.expressionLabel setTextAlignment:NSTextAlignmentLeft];
    
    //self.resultLabel.attributedText = self.resultString;
    
    //NSLog(@"showedController viewDidLoad restext: %@", [self.resultLabel.attributedText  string]);
    //[self.resultLabel setTextColor:[UIColor darkTextColor]];
    //[self.resultLabel setTextAlignment:NSTextAlignmentRight];

    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DurtyBezierView) name:@"BezierViewIsDirtyNotification" object:nil];
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
