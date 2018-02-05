//
//  SettingsViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 14.06.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "SettingsViewController.h"
#import "CalcButton.h"
#import "SoundView.h"
#import "ArchiveSizeView.h"
#import "CloudView.h"
#import "ClearHistoryButton.h"
#import "DesignButton.h"
#import "DesignViewFromButton.h"
#import "newButtonView.h"

#import "Transition.h"
#import "DesignViewController.h"

//#import "LineView.h"

//#import "TestButtonBackGroundView.h"
#import "designButtonView.h"
#import "PlusButton.h"
//#import "CLr.h"
//#import "RoundedGroundView.h"

//#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)
#define INDENT 20.0f


#define kInAppPurchaseProductID @"ItsCalc.changekeyboard"
NSString *const SettingReciveChangedNotification=@"SendChangedNotification";

@interface SettingsViewController() <SKPaymentTransactionObserver, SKProductsRequestDelegate, DesignViewControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design>

@property (nonatomic, strong) SKProduct *product;
@property (nonatomic,strong) SKProductsRequest *request;



//@property (nonatomic,weak) CalcButton *calcButton;

//transition
@property (weak,nonatomic) Transition* rightTransition;
@property (weak,nonatomic) DesignViewController *designViewController;

//copied from main controller
//@property (weak, nonatomic) UILabel *buttonSwitcherLabel;
//@property (weak, nonatomic) UILabel *soundSwitcherLabel;
//@property (weak, nonatomic) UILabel *archiveSwitcherLabel;
//@property (weak,nonatomic) UILabel *changeDesignButtonLabel;
//@property (weak,nonatomic) UILabel* clearHistoryButtonLabel;
@property (weak, nonatomic) IBOutlet newButtonView *smallButtonView;
@property (weak, nonatomic) IBOutlet newButtonView *bigButtonView;
@property (weak, nonatomic) IBOutlet UISwitch *isBigSizeSwitcher;

@property (weak, nonatomic) IBOutlet SoundView *soundOff;
@property (weak, nonatomic) IBOutlet SoundView *soundOn;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitcher;

@property (weak, nonatomic) IBOutlet ArchiveSizeView *archsizeViewSmall;
@property (weak, nonatomic) IBOutlet ArchiveSizeView *archivesizeBigView;
@property (weak, nonatomic) IBOutlet UISwitch *isBigDataBaseSwitcher;

@property (weak, nonatomic) IBOutlet CloudView *cloudOffView;
@property (weak, nonatomic) IBOutlet CloudView *cloudOnView;
@property (weak, nonatomic) IBOutlet UISwitch *isiCloudUseSwitcher;

@property (weak, nonatomic) IBOutlet DesignButton *changeDesignButton;
@property (weak, nonatomic) IBOutlet ClearHistoryButton *clearHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *keyboardDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *buyAdditionsButton;

@property (weak, nonatomic) IBOutlet CalcButton *calcButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstrain;

@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;

@property (nonatomic) BOOL fristLunchWithicloudAvailable;

//@property (weak,nonatomic) DesignViewFromButton *designViewFromButton;




//@property (weak, nonatomic) UIButton *buyAdditionsButton;
//add spin activity to show process of purchaising

//end copied from main controller

//FOR IAPD SET DESIGN CHOOSING
/*
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


@end

@implementation SettingsViewController


-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark NOTIFICATION
-(void) recivedNotification:(NSNotification*)notification
{
    NSArray *keys = notification.userInfo.allKeys;
    if(keys.count && (keys.count < 2) && [keys[0] isKindOfClass:[NSString class]]){
        //NSLog(@"Ok recived notification %@ for key %@", [notification.userInfo objectForKey:keys[0]], keys[0]);
        NSString *key = keys[0];
        if([key isEqualToString:@"ChangedDesign"]){
            
            //self.design = [[notification.userInfo objectForKey:keys[0]] integerValue];
            [self.view setNeedsDisplay];
        }
        //NSLog(@"recived wrong notification");
    }
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
    DesignViewController *designViewController = [[DesignViewController alloc] init];
    designViewController.delegate = self;
    designViewController.transitioningDelegate = self;
    designViewController.designObj = self.designObj;
    self.designViewController = designViewController;
    
    [self presentViewController:self.designViewController animated:YES completion:nil];
    
}



#pragma mark ROTATION
-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self willRotatetoSize:size];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)willRotatetoSize:(CGSize)size
{
    CGRect rct = CGRectMake(0,0,size.width,size.height);
     [self setLayOutOfSettingsView:rct];
}

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

#pragma mark ALERT VIEW
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:ALERT_RESTORE_BUTTON_TITLE]){
        
        NSNumber *message = [NSNumber numberWithBool:YES];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"setKeyboardDefaultAction",nil];
        NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
        
    }  else if ([title isEqualToString:ALERT_CLEAR_BUTTON_TITLE]){
        
        NSNumber *message = [NSNumber numberWithBool:YES];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"cleanHistoryArchive",nil];
        NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_RESTORE]){
        [self restorePurchase];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_BUY]){
        [self buyUnlockKeyboard];
        
    }
}


#pragma mark BUTTON ACTION


- (IBAction)calcButtonTapped:(id)sender {
    [self dismis];
}
- (IBAction)pressedClearHistoryButton:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TITLE_CLEAR_HISTORY_BUTTON
                                                    message:ALERT_MESSAGE_CLEAR_HOSTORY//@"delete history. all results will be lost"
                                                   delegate:self
                                          cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                          otherButtonTitles:ALERT_CLEAR_BUTTON_TITLE, nil]; //@"Clear"
    [alert show];
}

- (IBAction)pressedDesignButton:(DesignButton *)sender {
     [self showDesignViewcontroller];
}

- (IBAction)pressedKeyboardDefaultButton:(UIButton *)sender {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:TITLE_RESET_BUTTON
                                       message:ALERT_MESAGE_RESET_BUTTONS//@"restore initial buttons settings"
                                      delegate:self
                             cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                             otherButtonTitles:ALERT_RESTORE_BUTTON_TITLE, nil]; //@"Restore"
    
    [alert show];
}
- (IBAction)pressedBuyAdditionsButton:(UIButton *)sender {
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:ALLERT_TITLE_CHANGE_KEYBOARD//@"Change keyboard"//TITLE_RESET_BUTTON
                                       message:@""
                                      delegate:self
                             cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                             otherButtonTitles: ALLERT_BUTTON_BUY,ALLERT_BUTTON_RESTORE, nil]; //@"Restore"
    
    [alert show];
}


#pragma mark SWITCHER ACTIONS

NSString *const SettingSendChangedNotification=@"SendChangedNotification";


- (IBAction)isBigSizeButtonSwitch:(UISwitch*)sender {
    self.isBigSizeButtons = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isBigSizeButtons",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}


- (IBAction)isSoundSwitch:(UISwitch*)sender {
    self.isSoundOn = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isSoundOn",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
- (IBAction)switchIsBigDataBase:(UISwitch *)sender {
    self.isBigDataBase = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isBigDataBase", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (IBAction)isiCloudSwitch:(UISwitch *)sender {
    self.isiCloudInUse = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isiCloudInUse", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

#pragma mark OVERRIDE ABSTRACT FUNCTION

#define NAME_BUTTON_SWITCH NSLocalizedStringFromTable(@"Buttons size",@"ACalcTryViewControllerTableTwo", @"Button size")
#define NAME_SOUND_SWITCH NSLocalizedStringFromTable(@"Sound",@"ACalcTryViewControllerTableTwo", @"Sound")
#define NAME_ARCHIVE_SWITCH NSLocalizedStringFromTable(@"History archive size",@"ACalcTryViewControllerTableTwo", @"Archive size")
#define NAME_ICLOUD_SWITCH NSLocalizedStringFromTable(@"iCloud",@"ACalcTryViewControllerTableTwo", @"iCloud")
#define TITLE_RESET_BUTTON NSLocalizedStringFromTable(@"TITLE_RESET_BUTTON",@"ACalcTryViewControllerTable", @"reset button title")
#define BUY_REQUEST_BUTTON NSLocalizedStringFromTable(@"BUY_REQUEST_BUTTON",@"ACalcTryViewControllerTable", @"buy button title")

#define TITLE_CLEAR_HISTORY_BUTTON NSLocalizedStringFromTable(@"TITLE_CLEAR_HISTORY_BUTTON",@"ACalcTryViewControllerTable", @"Clear history button title")
//------new------
#define NAME_DESIGN_BUTTON NSLocalizedStringFromTable(@"Change design",@"ACalcTryViewControllerTableAdd", @"Change design")

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
   
    //ARCHIVE SIZE
    [self.isBigDataBaseSwitcher setOn:self.isBigDataBase];
    self.isBigDataBaseSwitcher.onTintColor = [UIColor whiteColor];

    self.archsizeViewSmall.isBig=NO;
    self.archsizeViewSmall.backgroundColor = [UIColor clearColor];

    self.archivesizeBigView.isBig=YES;
    self.archivesizeBigView.backgroundColor = [UIColor clearColor];
    
    //iCloud use
    [self.isiCloudUseSwitcher setOn:self.isiCloudInUse];
    self.isiCloudUseSwitcher.enabled = self.isiCloudUseSwitcherEnabled;
    self.isiCloudUseSwitcher.onTintColor = [UIColor whiteColor];

    self.cloudOnView.on = YES;
    self.cloudOnView.backgroundColor = [UIColor clearColor];

    self.cloudOffView.on = NO;
    self.cloudOffView.backgroundColor = [UIColor clearColor];
    //CLEAR HISTORY

    self.clearHistoryButton.normalColor = [UIColor whiteColor];
    
    
    
    //CHANGE DESIGN BUTTON
    //if((self.wasPurshaised) || (self.isTrialPeriod)){
    //    if(!IS_IPAD){
    
    //fro iPad its only pictures
    self.changeDesignButton.storkeColor = [UIColor whiteColor];
    self.changeDesignButton.fillColor = self.cView.backgroundColor;
    /*
        } else {
            DesignViewFromButton *designViewFromButton = [[DesignViewFromButton alloc]init];
            designViewFromButton.backgroundColor = [UIColor clearColor];
            //fro iPad its only pictures
            [self.cView addSubview:designViewFromButton];
            self.designViewFromButton = designViewFromButton;
        }
     */
        
        //set KEYBOARD DEFAULT BUTTON

        [self.keyboardDefaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.keyboardDefaultButton.titleLabel.numberOfLines = 0;
        //keyboardDefaultButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        //keyboardDefaultButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];

    
    
    //set BUY ADDITIONS BUTTON
    if(!self.wasPurshaised){
        
        //UIButton *buyAdditionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        //[buyAdditionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // buyAdditionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.];
        self.buyAdditionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.buyAdditionsButton.titleLabel.numberOfLines = 0;
        //self.buyAdditionsButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        //self.buyAdditionsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.buyAdditionsButton setTitle:BUY_REQUEST_BUTTON forState:UIControlStateNormal];
        
        self.buyAdditionsButton.enabled = NO;
        [self.buyAdditionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

        
        
        //setProcessSpiner
        
        UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc]init];
        [processSpinner startAnimating];
        [self.buyAdditionsButton addSubview:processSpinner];
        self.processSpinner = processSpinner;
        
        
        
        
        //make product request
        if([SKPaymentQueue canMakePayments]) {
            
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kInAppPurchaseProductID]];
            request.delegate = self;
            self.request = request;
            
            [request start];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        } else {
            //if cant make purchaising stop and remove spinner
            [self.processSpinner stopAnimating];
            [self.processSpinner removeFromSuperview];
            self.buyAdditionsButton.titleLabel.textColor = [UIColor grayColor];
        }
        
        
    }
    
    /*if(IS_IPAD){
        UILabel *soundSwitcherLabel = [[UILabel alloc]init];
        soundSwitcherLabel.text = NAME_SOUND_SWITCH;
        soundSwitcherLabel.textAlignment = NSTextAlignmentCenter;
        soundSwitcherLabel.adjustsFontSizeToFitWidth = YES;
        soundSwitcherLabel.textColor = [UIColor whiteColor];
        
        [self.cView addSubview:soundSwitcherLabel];
        self.soundSwitcherLabel = soundSwitcherLabel;
        
        UILabel *buttonSwitcherLabel = [[UILabel alloc]init];
        buttonSwitcherLabel.text = NAME_BUTTON_SWITCH;
        buttonSwitcherLabel.textAlignment = NSTextAlignmentCenter;
        buttonSwitcherLabel.adjustsFontSizeToFitWidth = YES;
        buttonSwitcherLabel.textColor = [UIColor whiteColor];
        [self.cView addSubview:buttonSwitcherLabel];
        self.buttonSwitcherLabel = buttonSwitcherLabel;
        
        UILabel *archiveSwitcherLabel = [[UILabel alloc]init];
        archiveSwitcherLabel.text = NAME_ARCHIVE_SWITCH;
        archiveSwitcherLabel.textAlignment = NSTextAlignmentCenter;
        archiveSwitcherLabel.adjustsFontSizeToFitWidth = YES;
        archiveSwitcherLabel.textColor = [UIColor whiteColor];
        [self.cView addSubview:archiveSwitcherLabel];
        self.archiveSwitcherLabel = archiveSwitcherLabel;
        
        UILabel *iCloudSwitcherName = [[UILabel alloc]init];
        iCloudSwitcherName.text = NAME_ICLOUD_SWITCH;
        iCloudSwitcherName.textAlignment = NSTextAlignmentCenter;
        iCloudSwitcherName.adjustsFontSizeToFitWidth = YES;
        iCloudSwitcherName.textColor = [UIColor whiteColor];
        [self.cView addSubview:iCloudSwitcherName];
        self.iCloudSwitcherName = iCloudSwitcherName;
        
        UILabel *clearHistoryButtonLabel = [[UILabel alloc]init];
        clearHistoryButtonLabel.text = TITLE_CLEAR_HISTORY_BUTTON;
        clearHistoryButtonLabel.textAlignment = NSTextAlignmentCenter;
        clearHistoryButtonLabel.adjustsFontSizeToFitWidth = YES;
        clearHistoryButtonLabel.textColor = [UIColor whiteColor];
        [self.cView addSubview:clearHistoryButtonLabel];
        self.clearHistoryButtonLabel = clearHistoryButtonLabel;
        
        if((self.wasPurshaised) || (self.isTrialPeriod)){
            UILabel *changeDesignButtonLabel = [[UILabel alloc]init];
            changeDesignButtonLabel.text = NAME_DESIGN_BUTTON;
            changeDesignButtonLabel.textAlignment = NSTextAlignmentCenter;
            changeDesignButtonLabel.adjustsFontSizeToFitWidth = YES;
            changeDesignButtonLabel.textColor = [UIColor whiteColor];
            [self.cView addSubview:changeDesignButtonLabel];
            self.changeDesignButtonLabel = changeDesignButtonLabel;
        }
    }*/
    
}



-(void) setLayOutOfSettingsView:(CGRect)rect
{
    if(IS_IPAD){
   
        //BUY ANDDEFAULT KEYBOARD BUTTONS
        if((self.wasPurshaised) || (self.isTrialPeriod)){
            
        }
        
        
    } else { //if iPhone
        
    }
    //need to set spinner
}


-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    
    [self setLayOutOfSettingsView:rect];
    
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
    if(self.processSpinner){
        
        [self.processSpinner setCenter:CGPointMake(self.buyAdditionsButton.bounds.size.width/2., self.buyAdditionsButton.bounds.size.height/2.)];
    }
    [self updateViewConstraints];
    if(DEBUG_MODE) NSLog(@"viewDidLayoutSubviews settings VC");
}


-(void)viewDidLoad{
    [super viewDidLoad];
    if(IS_X){
        self.topViewConstrain.constant = 84;
        self.bottomViewConstrain.constant = 64;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:SettingReciveChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(applicationDidEnterBackground:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(applicationWillEnterBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];
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


-(void) dismis
{
    
    [self.request cancel];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self.processSpinner stopAnimating];
    [self.processSpinner removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dismis];
    
    
}

-(void)applicationDidEnterBackground:(NSNotification *)note{
   // if([[self presentedViewController] isKindOfClass:[DesignViewController class]]){
        
    //} else {
       // [self dismisAnimated:NO];
    [self dismis];
    //}
   // NSLog(@"appWillGoToBackground");
}

-(void)applicationWillEnterBackground:(NSNotification *)note{
    // if([[self presentedViewController] isKindOfClass:[DesignViewController class]]){
    
    //} else {
    //[self dismis];
    //}
    // NSLog(@"appWillGoToBackground");
}

-(void)viewDidDisappear:(BOOL)animated{
    if(DEBUG_MODE) NSLog(@"setting view disapear");
    //[self dismis];
}

#pragma mark IN-APP PURSHASE
-(void) startSpinner
{
    
    
    UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc] init];
    [processSpinner setCenter:self.buyAdditionsButton.center];
    
    [self.cView addSubview:processSpinner];
    processSpinner.hidesWhenStopped = YES;
    self.processSpinner = processSpinner;
    [self.processSpinner startAnimating];
}

-(void) wasSuccesTransaction
{
    
    
    self.wasPurshaised = YES;
    NSNumber *message = self.wasPurshaised? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"wasPurshaised", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    [self setNeedViews];
    
    CGRect rect = self.view.bounds;
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [self setLayOutOfSettingsView:rect];
                         
                     } completion:^(BOOL finished) {
                         [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         
                         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                         [defaults setObject:[NSNumber numberWithBool:self.wasPurshaised] forKey:@"wasPurchaisedMark"];
                         [defaults synchronize];
                         
                         
                     }];
}


-(void) buyUnlockKeyboard
{
    
    SKPayment *payment = [SKPayment paymentWithProduct:self.product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

-(void) restorePurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


-(void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //1.
    
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            break;
        }
    }
    
    
}

#pragma mark _
#pragma mark SKProductsRequestDelegate

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if(products.count != 0) {
        
        
        self.product = products[0];
        self.buyAdditionsButton.enabled = YES;
        
    } else {
        // NSLog(@"Product not FUND");
    }
    
    if(self.processSpinner){
        //stop and remove process spinner
        [self.processSpinner stopAnimating];
        [self.processSpinner removeFromSuperview];
    }
    
}


-(void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //stop and remove process spinner
    [self.processSpinner stopAnimating];
    [self.processSpinner removeFromSuperview];
    [self.buyAdditionsButton setEnabled:NO];
    
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    //3.
    
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: [self wasSuccesTransaction];
                // NSLog(@"Succes payment");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //stop and remove process spinner
                [self.processSpinner stopAnimating];
                [self.processSpinner removeFromSuperview];
                
                break;
                
            case SKPaymentTransactionStateRestored: [self wasSuccesTransaction];
                //NSLog(@"Succes restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //stop and remove process spinner
                [self.processSpinner stopAnimating];
                [self.processSpinner removeFromSuperview];
                
                break;
                
            case SKPaymentTransactionStateDeferred:
                
                break;
                
            case SKPaymentTransactionStatePurchasing: //NSLog(@"Purchasing in process");
                
                break;
                
            case SKPaymentTransactionStateFailed: ;//NSLog(@"Purchasing faild");;
                
                
                //stop and remove process spinner
                [self.processSpinner stopAnimating];
                [self.processSpinner removeFromSuperview];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction failed"
                                                                message:@""//@"restore initial buttons settings"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"//@"Cancel"
                                                      otherButtonTitles: nil]; //@"Restore"
                
                [alert show];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
        }
    }
    
}


@end
