//
//  SettingsViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 14.06.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "SecondViewController.h"
#import "DesignObject.h"
#import "DesignViewController.h"
#import "InfoViewController.h"
#import "PaymentObj.h"

#define DEBUG_MODE YES

@interface SettingsViewController : SecondViewController <DesignViewControllerProtocol,InfoViewControllerProtocol, UIViewControllerTransitioningDelegate,PaymentDelegateProtocol>


@property (weak, nonatomic) IBOutlet UIView * _Nullable cView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _Nullable cViewWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _Nullable cViewHeigthConstrain;
//need for size controllers transition
@property (weak, nonatomic) IBOutlet UIView * _Nullable backGroundView;
@property (nonatomic) BOOL isSoundOn;
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons
@property (nonatomic) DesignObject* _Nullable designObj;
@property (nonatomic, nullable) PaymentObj* paymetnObj;


-(void) setShowedNecessaryViews;

@end
