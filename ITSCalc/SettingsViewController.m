//
//  SettingsViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 14.06.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "SettingsViewController.h"
#import "CalcButton.h"
#import "SoundView.h"
#import "ArchiveSizeView.h"
#import "CloudView.h"
#import "ClearHistoryButton.h"
#import "DesignButton.h"
#import "DesignViewFromButton.h"
#import "newButtonView.h"
#import "TrialClockView.h"

#import "Transition.h"
#import "DesignViewController.h"
#import "CildDesignViewController.h"
#import "designButtonView.h"
#import "PlusButton.h"

//#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)
#define INDENT 20.0f

@interface SettingsViewController() /*SKPaymentTransactionObserver, SKProductsRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design>*/

//transition
@property (weak,nonatomic) Transition* rightTransition;
@property (weak,nonatomic) DesignViewController *designViewController;
@property (nonatomic) CildDesignViewController* childDesignController;

@property (weak, nonatomic) IBOutlet newButtonView *smallButtonView;
@property (weak, nonatomic) IBOutlet newButtonView *bigButtonView;
@property (weak, nonatomic) IBOutlet UISwitch *isBigSizeSwitcher;

@property (weak, nonatomic) IBOutlet SoundView *soundOff;
@property (weak, nonatomic) IBOutlet SoundView *soundOn;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitcher;
@property (weak, nonatomic) IBOutlet DesignButton *changeDesignButton;
@property (weak, nonatomic) IBOutlet ClearHistoryButton *clearHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *keyboardDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *buyAdditionsButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UIStackView *trailStackView;
@property (weak, nonatomic) IBOutlet CalcButton *calcButton;
@property (weak, nonatomic) IBOutlet UILabel *trailPeriodLabel;
@property (weak, nonatomic) IBOutlet UIButton *extendTrailButton;
@property (weak, nonatomic) IBOutlet TrialClockView *trialClockView;
@property (weak, nonatomic) IBOutlet UILabel *leftTrailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstrain;

@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;
@property (weak, nonatomic) UIActivityIndicatorView* processSpinnerBuing;

@end

@implementation SettingsViewController
@dynamic  cView;

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark TRANSITION DELEGATE
-(id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    Transition* trans = [[Transition alloc] init];
    self.rightTransition = trans;
    
    self.rightTransition.isGravity = NO;
    self.rightTransition.isForward = NO;
    
    return self.rightTransition;
}

-(id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    BackTransition *transition = [[BackTransition alloc] init];
    transition.isGravity = NO;
    transition.isForward= NO;
    self.transition = transition;
    
    return transition;
}

-(void) showDesignViewcontroller
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DesignViewController *designVC = [storyBoard instantiateViewControllerWithIdentifier:@"DesignViewController"];
    designVC.delegate = self;
    designVC.designObj = self.designObj;
    self.designViewController = designVC;
    self.designViewController.transitioningDelegate = self;
    self.designViewController.paymentObj = self.paymetnObj;
    [self presentViewController:self.designViewController animated:YES completion:nil];    
}

#pragma mark BUTTON ACTION
#pragma mark ALERT VIEW

- (IBAction)calcButtonTapped:(id)sender {
    [self dismis];
}

- (IBAction)pressedClearHistoryButton:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:TITLE_CLEAR_HISTORY_BUTTON
                                                                   message:ALERT_MESSAGE_CLEAR_HOSTORY
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:ALERT_CANCEL_BUTTON_TITLE style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [alert addAction:cancel];

    UIAlertAction* clearHistoryAction = [UIAlertAction actionWithTitle:ALERT_CLEAR_BUTTON_TITLE style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       NSNumber *message = [NSNumber numberWithBool:YES];
                                                       NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"cleanHistoryArchive",nil];
                                                       NSNotification *note = [[NSNotification alloc] initWithName:CHANGE_NOTIFICATION object:self userInfo:userInfo];
                                                       [[NSNotificationCenter defaultCenter] postNotification:note];
                                                   }];
    [alert addAction:clearHistoryAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)pressedDesignButton:(DesignButton *)sender {
     [self showDesignViewcontroller];
}

- (IBAction)pressedKeyboardDefaultButton:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:TITLE_RESET_BUTTON
                                                                   message:ALERT_MESAGE_RESET_BUTTONS
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:ALERT_CANCEL_BUTTON_TITLE style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alert addAction:cancel];
    
    UIAlertAction* defaultButtonAction = [UIAlertAction actionWithTitle:ALERT_RESTORE_BUTTON_TITLE style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction * action) {
                                                                    NSNumber *message = [NSNumber numberWithBool:YES];
                                                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"setKeyboardDefaultAction",nil];
                                                                    NSNotification *note = [[NSNotification alloc] initWithName:CHANGE_NOTIFICATION object:self userInfo:userInfo];
                                                                    [[NSNotificationCenter defaultCenter] postNotification:note];

                                                                }];
    [alert addAction:defaultButtonAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)infoAdditionalButtonTapped:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoViewController *infoVC = [storyBoard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    infoVC.delegate = self;
    infoVC.transitioningDelegate = self;
    infoVC.paymetnObj = self.paymetnObj;
    infoVC.buyEnabling = self.paymetnObj.CanMakeAPayment;
    [self presentViewController:infoVC animated:YES completion:nil];
}
- (IBAction)extendTrialPressed:(id)sender {
    NSLog(@"Extend Trial Button Tapped");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ITUNES_LINK] options:@{}
                             completionHandler:^(BOOL success) {
                                  [self.paymetnObj reviewHaveLived:YES];
                                 /*NSNumber *message = [NSNumber numberWithBool:YES];
                                 NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"userHaveLivedReview",nil];
                                 NSNotification *note = [[NSNotification alloc] initWithName:CHANGE_NOTIFICATION object:self userInfo:userInfo];
                                 [[NSNotificationCenter defaultCenter] postNotification:note];*/
                                 [self setShowedNecessaryViews];
                             }];
}


- (IBAction)pressedBuyAdditionsButton:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:BUY_REQUEST_MESSAGE
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:ALERT_CANCEL_BUTTON_TITLE style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    [alert addAction:cancel];
    
    UIAlertAction* buyAction = [UIAlertAction actionWithTitle:ALLERT_BUTTON_BUY
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    [self.paymetnObj buyUnlockKeyboard];
                                                                     [self visualBuingProccesStart:YES];
                                                                }];
    [alert addAction:buyAction];
    
    UIAlertAction* restorePurchaise = [UIAlertAction actionWithTitle:ALLERT_BUTTON_RESTORE
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self.paymetnObj restorePurchase];
                                                           [self visualBuingProccesStart:YES];
                                                      }];
    [alert addAction:restorePurchaise];

    [self presentViewController:alert animated:YES completion:nil];
}

//buying spinner
-(void)visualBuingProccesStart:(BOOL)start{
    if(start){
        if(!self.processSpinnerBuing){
            UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc]init];
            [self.view addSubview:processSpinner];
            processSpinner.hidesWhenStopped = YES;
            processSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            self.processSpinnerBuing = processSpinner;
            [self.processSpinnerBuing setCenter:self.cView.center];
        }
        [self.processSpinnerBuing startAnimating];
    } else {
        if(self.processSpinnerBuing){
            [self.processSpinnerBuing stopAnimating];
            [self.processSpinnerBuing removeFromSuperview];
        }
    }
}

#pragma mark RECIVE PAYMENT NOTIFICATIONS
#pragma mark PURCHAISING
-(void)respondsToPayReuest:(BOOL)canPay{
    [self.buyAdditionsButton setEnabled:canPay];
    if(self.processSpinner){
        //stop and remove process spinner
        [self.processSpinner stopAnimating];
        [self.processSpinner removeFromSuperview];
    }
}

-(void)rejectedByUserAlert{
     if(DEBUG_MODE) NSLog(@"Was rejectedByUser transaction from setting controller");
    [self visualBuingProccesStart:NO];
}
-(void)userHaveLivedReview{
    
    if(DEBUG_MODE) NSLog(@"userHaveLivedReview from setting controller");
    if(self.childDesignController){
        [self.childDesignController userHaveLivedReview];
    } else {// only for test
        NSLog(@"There is no child controller");
    }
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.extendTrailButton.alpha = 0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.8 animations:^{
                             [self setShowedNecessaryViews];
                         }];
                     }];
}

-(void) wasSuccesTransaction //wasSuccesTransaction
{
   // [self setNeedViews];
    [self visualBuingProccesStart:NO];
    if(self.childDesignController){
        [self.childDesignController wasSuccesTransaction];
    } else {// only for test
        NSLog(@"There is no child controller");
    }
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.trailStackView.alpha = 0;
                         self.buyAdditionsButton.alpha = 0;
                         self.infoButton.alpha = 0;
                         self.trailPeriodLabel.alpha = 0;
                         self.trialClockView.alpha = 0;
                         self.extendTrailButton.alpha = 0;
                         self.leftTrailLabel.alpha = 0;
                         self.numberOfDayLabel.alpha = 0;
                         self.daysLabel.alpha = 0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.8 animations:^{
                              [self setShowedNecessaryViews];
                         }];
                     }];
}


#pragma mark SWITCHER ACTIONS
- (IBAction)isBigSizeButtonSwitch:(UISwitch*)sender {
    self.isBigSizeButtons = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isBigSizeButtons",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:CHANGE_NOTIFICATION object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}


- (IBAction)isSoundSwitch:(UISwitch*)sender {
    self.isSoundOn = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isSoundOn",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:CHANGE_NOTIFICATION object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
#pragma mark OVERRIDE ABSTRACT FUNCTION
-(void)setNeedViews
{
    self.backGroundView.backgroundColor = self.cView.backgroundColor;

    [self.calcButton setTintColor:[UIColor whiteColor]];
    
    //SIZE BUTTON
    [self.isBigSizeSwitcher setOn:self.isBigSizeButtons];
    self.isBigSizeSwitcher.onTintColor = [UIColor whiteColor];

    self.smallButtonView.title = @"=";
    self.smallButtonView.buttonColor = [UIColor whiteColor];
    
    self.bigButtonView.title = @"=";
    self.bigButtonView.buttonColor = [UIColor whiteColor];
    
    //SOUND SWITCH
    [self.soundSwitcher setOn:self.isSoundOn];
    self.soundSwitcher.onTintColor = [UIColor whiteColor];

    self.soundOff.on = NO;
    self.soundOff.backgroundColor = [UIColor clearColor];

    self.soundOn.on = YES;
    self.soundOn.backgroundColor = [UIColor clearColor];
    //CLEAR HISTORY
    self.clearHistoryButton.normalColor = [UIColor whiteColor];
    
    //CHANGE DESIGN BUTTON
    //if((self.wasPurshaised) || (self.isTrialPeriod)){
    //    if(!IS_IPAD){
    
    //fro iPad its only pictures
    self.changeDesignButton.storkeColor = [UIColor whiteColor];
    self.changeDesignButton.fillColor = self.cView.backgroundColor;
        
        //set KEYBOARD DEFAULT BUTTON

    [self.keyboardDefaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.keyboardDefaultButton.titleLabel.numberOfLines = 0;
    [self.keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
}

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
   // [self setShowedNecessaryViews];
    //[self updateViewConstraints];
    if(DEBUG_MODE) NSLog(@"viewDidLayoutSubviews settings VC");
}

-(void) setShowedNecessaryViews{
    if(self.paymetnObj.wasPurshaised){
        self.buyAdditionsButton.hidden = YES;
        self.infoButton.hidden = YES;
        self.trailPeriodLabel.hidden = YES;
        self.trialClockView.hidden = YES;
        self.extendTrailButton.hidden = YES;
        self.leftTrailLabel.hidden = YES;
        self.numberOfDayLabel.hidden = YES;
        self.daysLabel.hidden = YES;
        
    } else if(!self.paymetnObj.isTrialPeriod && self.paymetnObj.isUserLeaveReview){
        self.trailPeriodLabel.hidden = YES;
        self.trialClockView.hidden = YES;
        self.extendTrailButton.hidden = YES;
        self.leftTrailLabel.hidden = YES;
        self.numberOfDayLabel.hidden = YES;
        self.daysLabel.hidden = YES;
    } else  if(self.paymetnObj.isTrialPeriod || !self.paymetnObj.isUserLeaveReview){
        if(self.paymetnObj.isUserLeaveReview){
            //hide liave review buttons if user have not leave review
            self.extendTrailButton.hidden = YES;
        }
        NSInteger leftDays = [self.paymetnObj.finishTrialDate timeIntervalSinceNow]/SEC_IN_DAY;
        leftDays = (leftDays<0)? 0: leftDays; //if trial done but user still not leaved review show 0 days to end
        self.numberOfDayLabel.text = [NSString stringWithFormat:@"%ld", leftDays];
        self.trialClockView.outTrialDays = (CGFloat) (self.paymetnObj.totalTrialDays - leftDays);
        self.trialClockView.totalTrialDays =(CGFloat) self.paymetnObj.totalTrialDays;
    }
    
    if(!self.paymetnObj.wasPurshaised){
        self.buyAdditionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.buyAdditionsButton.titleLabel.numberOfLines = 0;
        [self.buyAdditionsButton setTitle:BUY_REQUEST_BUTTON forState:UIControlStateNormal];
        //self.buyAdditionsButton.enabled = NO;
        [self.buyAdditionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
        self.trailPeriodLabel.text = TRIAL_PERIOD;
        [self.extendTrailButton setTitle:LEAVE_A_REVIEW_FOR_EXTEND forState:UIControlStateNormal];
        
        self.extendTrailButton.enabled = [self.paymetnObj canConnectItunes];
        [self.extendTrailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        self.leftTrailLabel.text =LEFT;
        self.daysLabel.text =DAYS;
    }
    [self updateViewConstraints];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(IS_X){
        self.topViewConstrain.constant = 84;
        self.bottomViewConstrain.constant = 64;
    }

    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(applicationDidEnterBackground:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:[UIApplication sharedApplication]];

    for (UIViewController *childViewController in [self childViewControllers])
    {
        if ([childViewController isKindOfClass:[CildDesignViewController class]])
        {
            CildDesignViewController *cildDesignViewController = (CildDesignViewController *)childViewController;
            cildDesignViewController.designObj = self.designObj;
            cildDesignViewController.paymetObj = self.paymetnObj;
            self.childDesignController = cildDesignViewController;
            break;
        }
    }
    if(!self.paymetnObj.wasPurshaised){
        [self.paymetnObj startTransationObserving];
        //add background for trial stackView
        UIView* trialBackgroundView = [[UIView alloc]initWithFrame:self.trailStackView.bounds];
        trialBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                                UIViewAutoresizingFlexibleHeight);
        trialBackgroundView.backgroundColor = [UIColor colorWithWhite:1. alpha:0.2];
        trialBackgroundView.layer.cornerRadius = 15.;
        [self.trailStackView insertSubview:trialBackgroundView atIndex:0];
    }
}
#pragma mark DESIGN CONTROLLER DELEGATE
-(void)designViewControllerDidCloseWithString:(NSString*) str
{
    
    if([str isEqualToString:@"TO CALC"]){
        [self dismis];
    } else if([str isEqualToString:@"BACKGROUND"]){
        [self dismis];
    }
    
}

#pragma mark INFO CONTROLLER DELEGATE
-(void)infoViewControllerDidCloseWithString:(NSString*)str {
    if([str isEqualToString:@"TO CALC"]){
        [self dismis];
    } else if([str isEqualToString:@"BACKGROUND"]){
        [self dismis];
    }
}

-(void) dismis
{
    [self.paymetnObj stopTransactionObserving];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismis];
}
-(void) viewWillAppear:(BOOL)animated{
    if(!self.paymetnObj.wasPurshaised){
        self.paymetnObj.delegate = self;
        self.paymetnObj.askedController = self;
        if(self.paymetnObj.CanMakeAPayment){
            self.buyAdditionsButton.enabled = YES;
        } else {
            //setProcessSpine
            if(!self.processSpinner){
                UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc]init];
                [self.buyAdditionsButton addSubview:processSpinner];
                processSpinner.hidesWhenStopped = YES;
                self.processSpinner = processSpinner;
                [self.processSpinner setCenter:CGPointMake(self.buyAdditionsButton.bounds.size.width/2., self.buyAdditionsButton.bounds.size.height/2.)];
            }
            [self.processSpinner startAnimating];
            self.buyAdditionsButton.enabled = NO;
        }
    }
    [self setShowedNecessaryViews];
}

-(void)applicationDidEnterBackground:(NSNotification *)note{
    [self dismis];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(!self.processSpinner){
        [self.processSpinner stopAnimating];
        [self.processSpinner removeFromSuperview];
    }
    [self visualBuingProccesStart:NO];
}
@end
