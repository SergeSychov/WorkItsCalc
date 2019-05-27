//
//  DesignViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 13.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "DesignViewController.h"
#import "CildDesignViewController.h"
#import "designButtonView.h"
#import "Transition.h"
#import "CalcButton.h"
#import "SettingButton.h"
#import "TestButtonBackGroundView.h"
#import "newButtonView.h"
#import "PlusButton.h"
#import "Clr.h"


@interface DesignViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design

//@property (nonatomic, weak) UIView *cView;

/*
@property (nonatomic,weak) CalcButton* calcButton;
@property (nonatomic,weak) SettingButton *settingButton;

@property (nonatomic,weak) UILabel* chooseDesignLabel;

@property (nonatomic,weak) UIView *classicPartView;
@property (nonatomic,weak) TestButtonBackGroundView *classicButton;
@property (nonatomic,weak) designButtonView *classicButtonView;

@property (nonatomic,weak) UIView *paperPartView;
@property (nonatomic,weak) TestButtonBackGroundView *paperButton;
@property (nonatomic,weak) designButtonView *paperButtonView;

@property (nonatomic,weak) UIView *colorPartView;
@property (nonatomic,weak) designButtonView *colorButtonView;
@property (nonatomic,weak) TestButtonBackGroundView *clolorBlueButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorPinkButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorGreenButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorYelowButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorBlackButton;

@property (nonatomic,weak) UIImageView *photo;
@property (nonatomic,weak) UIView *photoPartView;
@property (nonatomic,weak) designButtonView *photoButtonView;
@property (nonatomic,weak) TestButtonBackGroundView *photButton;
@property (nonatomic,weak) PlusButton *addNewPhotoButton; //"+"
*/

//necessary to add plus button


@end

@implementation DesignViewController
@dynamic cView;

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark TAP ACTION SEND NOTIFICATION

- (IBAction)calcButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate designViewControllerDidCloseWithString:@"TO CALC"];
    }];
}
- (IBAction)settingButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.delegate designViewControllerDidCloseWithString:@"BACK"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    for (UIViewController *childViewController in [self childViewControllers])
    {
        if ([childViewController isKindOfClass:[CildDesignViewController class]])
        {
            CildDesignViewController *cildDesignViewController = (CildDesignViewController *)childViewController;
            cildDesignViewController.designObj = self.designObj;
            cildDesignViewController.paymetObj = self.paymentObj;
            break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appDidGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification//UIApplicationDidEnterBackgroundNotification
                                                 object:[UIApplication sharedApplication]];
    [super viewWillAppear:animated];
}

#pragma mark ROTATION
-(void)viewDidLayoutSubviews{
    
    CGSize viewSize = self.view.bounds.size;
    CGSize windowSize = self.view.window.bounds.size;
    if(viewSize.width != windowSize.width){
        [self.view setFrame:self.view.window.bounds];
    }
    if(!IS_IPAD){
        
        if(viewSize.width < viewSize.height){
            self.cViewWidthConstrain.constant = 0;
            self.cViewHeigthConstrain.constant = 0;
        } else {
            self.cViewWidthConstrain.constant = -viewSize.width+viewSize.height;
            self.cViewHeigthConstrain.constant = -viewSize.height+viewSize.width;
            ;
        }
    }
    
    [self updateViewConstraints];
}


-(void)appDidGoToBackground:(NSNotification *)note
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
   [self dismissViewControllerAnimated:NO completion:^{
        // [self dismis];
    [self.delegate designViewControllerDidCloseWithString:@"BACKGROUND"];
    }];
}

-(void) dismis {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismis];
}

@end
