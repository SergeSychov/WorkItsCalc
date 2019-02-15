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
#import "PaymentObj.h"

#define DEBUG_MODE YES

/*
#define CHANGE_NOTIFICATION @"SendChangedNotification"

#define TITLE_CLEAR_HISTORY_BUTTON NSLocalizedStringFromTable(@"TITLE_CLEAR_HISTORY_BUTTON",@"ACalcTryViewControllerTable", @"Clear history button title")
#define ALERT_MESSAGE_CLEAR_HOSTORY NSLocalizedStringFromTable(@"ALERT_MESSAGE_CLEAR_HOSTORY",@"ACalcTryViewControllerTable", @"delete history. all results will be lost")
#define ALERT_CLEAR_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_CLEAR_BUTTON_TITLE",@"ACalcTryViewControllerTable", @"clear")

#define TITLE_RESET_BUTTON NSLocalizedStringFromTable(@"TITLE_RESET_BUTTON",@"ACalcTryViewControllerTable", @"reset button title")
#define ALERT_MESAGE_RESET_BUTTONS NSLocalizedStringFromTable(@"ALERT_MESAGE_RESET_BUTTONS",@"ACalcTryViewControllerTable", @"reset button alert mesage")
#define ALERT_RESTORE_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_RESTORE_BUTTON_TITLE ",@"ACalcTryViewControllerTable", @"restore buton title")


#define ALERT_CANCEL_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_CANCEL_BUTTON_TITLE",@"ACalcTryViewControllerTable", @"alert cancel buton title")
#define ALLERT_TITLE_CHANGE_KEYBOARD NSLocalizedStringFromTable(@"ALLERT_TITLE_CHANGE_KEYBOARD",@"ACalcTryViewControllerTableAdditional", @"Change keyboard")
#define ALLERT_BUTTON_BUY NSLocalizedStringFromTable(@"ALLERT_BUTTON_BUY",@"ACalcTryViewControllerTableAdditional", @"Buy")
#define ALLERT_BUTTON_RESTORE NSLocalizedStringFromTable(@"ALLERT_BUTTON_RESTORE",@"ACalcTryViewControllerTableAdditional", @"Restore purshace")

#define TRIAL_PERIOD NSLocalizedStringFromTable(@"ПРОБНЫЙ ПЕРИОД",@"ACalcTryViewControllerTableAdditionalTwo", @"TRIAL_PERIOD")
#define LEFT NSLocalizedStringFromTable(@"осталось",@"ACalcTryViewControllerTableAdditionalTwo", @"LEFT")
#define LEAVE_A_REVIEW NSLocalizedStringFromTable(@"Оставьте отзыв, чтобы продлить",@"ACalcTryViewControllerTableAdditionalTwo", @"LEAVE_A_REVIEW")
 */

@interface SettingsViewController : SecondViewController <DesignViewControllerProtocol, UIViewControllerTransitioningDelegate,PaymentDelegateProtocol>


@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cViewWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cViewHeigthConstrain;
//need for size controllers transition
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (nonatomic) BOOL isSoundOn;
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons
@property (nonatomic) DesignObject* designObj;
@property (nonatomic, nullable) PaymentObj* paymetnObj;

//@property (nonatomic) BOOL wasPurshaised;
//@property (nonatomic) BOOL isTrialPeriod;
//@property (nonatomic) BOOL isUserLeaveReview;
//@property (nonatomic) NSDate* finishTrialDate;
//@property (nonatomic) NSInteger totalTrialDays;
//@property (nonatomic) NSDate* lastShowedTralAlertInDesignChoosingDate;
//@property (nonatomic) NSInteger daysSpentTrial;

-(void) setShowedNecessaryViews;
//-(void) willRotatetoSize:(CGSize)size;

@end
