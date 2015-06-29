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
#import "newButtonView.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)
#define INDENT 20.0f

#define kInAppPurchaseProductID @"ItsCalc.changekeyboard"

@interface SettingsViewController() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) SKProduct *product;

@property (nonatomic,weak) CalcButton *calcButton;

//copied from main controller
@property (weak, nonatomic) UILabel *buttonSwitcherLabel;
@property (weak, nonatomic) UIView *smallButtonView;
@property (weak, nonatomic) UIView *bigbuttonView;
@property (weak, nonatomic) UISwitch *isBigSizeSwitcher;

@property (weak, nonatomic) UILabel *soundSwitcherLabel;
@property (weak, nonatomic) UISwitch *soundSwitcher;
@property (weak, nonatomic) SoundView *soundOff;
@property (weak, nonatomic) SoundView *soundOn;

@property (weak, nonatomic) UILabel *archiveSwitcherLabel;
@property (weak, nonatomic) UISwitch *isBigDataBaseSwitcher;
@property (weak, nonatomic) ArchiveSizeView *archsizeViewSmall;
@property (weak, nonatomic) ArchiveSizeView *archivesizeBigView;
//@property (nonatomic) int limitInDataBase;


@property (weak, nonatomic) CloudView *cloudOnView;
@property (weak, nonatomic) CloudView *cloudOffView;
@property (weak, nonatomic) UILabel *iCloudSwitcherName;
@property (weak, nonatomic) UISwitch *isiCloudUseSwitcher;

@property (nonatomic) BOOL fristLunchWithicloudAvailable;
//need to set iClouds images whole & empty

@property (weak,nonatomic) UILabel *changeDesignButtonLabel;
@property (weak, nonatomic) DesignButton *changeDesignButton;

@property (weak,nonatomic) UILabel* clearHistoryButtonLabel;
@property (weak, nonatomic) ClearHistoryButton *clearHistoryButton;
@property (weak, nonatomic) UIButton *keyboardDefaultButton;
@property (weak, nonatomic) UIButton *buyAdditionsButton;
//add spin activity to show process of purchaising
@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;
//end copied from main controller





@end

@implementation SettingsViewController


-(BOOL) prefersStatusBarHidden
{
    return YES;
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

-(void) calcButtonTapped:(id)sender

{
    [self dismis];
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
    [self setCViewAccordingFrameRect:rct];
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
        NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];

        
    }  else if ([title isEqualToString:ALERT_CLEAR_BUTTON_TITLE]){
        
        NSNumber *message = [NSNumber numberWithBool:YES];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"cleanHistoryArchive",nil];
        NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_RESTORE]){
        [self restorePurchase];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_BUY]){
        [self buyUnlockKeyboard];
        
    }
}


#pragma mark BUTTON ACTION


-(void)pressedClearHistoryButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TITLE_CLEAR_HISTORY_BUTTON
                                                    message:ALERT_MESSAGE_CLEAR_HOSTORY//@"delete history. all results will be lost"
                                                   delegate:self
                                          cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                          otherButtonTitles:ALERT_CLEAR_BUTTON_TITLE, nil]; //@"Clear"
    [alert show];
}

-(void)pressedDesignButton:(id)sender
{
    NSLog(@"pressedDesignButton");
}

-(void) pressedKeyboardDefaultButton:(id)sender
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:TITLE_RESET_BUTTON
                                       message:ALERT_MESAGE_RESET_BUTTONS//@"restore initial buttons settings"
                                      delegate:self
                             cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                             otherButtonTitles:ALERT_RESTORE_BUTTON_TITLE, nil]; //@"Restore"
    
    [alert show];
}
-(void) pressedBuyAdditionsButton:(id)sender
{
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:ALLERT_TITLE_CHANGE_KEYBOARD//@"Change keyboard"//TITLE_RESET_BUTTON
                                       message:@""
                                      delegate:self
                             cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                             otherButtonTitles: ALLERT_BUTTON_BUY,ALLERT_BUTTON_RESTORE, nil]; //@"Restore"
    
    [alert show];
}


#pragma mark SWITCHER ACTIONS

NSString *const SendChangedNotification=@"SendChangedNotification";

- (void)isBigSizeButtonSwitch:(UISwitch *)sender
{
    self.isBigSizeButtons = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isBigSizeButtons",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)isSoundSwitch:(UISwitch *)sender
{
    self.isSoundOn = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isSoundOn",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)switchIsBigDataBase:(UISwitch *)sender
{
    self.isBigDataBase = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isBigDataBase", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)isiCloudSwitch:(UISwitch *)sender
{
    self.isiCloudInUse = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isiCloudInUse", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
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
    CalcButton *calcButton = [CalcButton buttonWithType:UIButtonTypeSystem];
    [calcButton addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [calcButton setTintColor:[UIColor whiteColor]];
    
    [self.cView addSubview:calcButton];
    self.calcButton = calcButton;

    //SIZE BUTTON
    UISwitch *isBigSizeSwitcher = [[UISwitch alloc] init];
    [isBigSizeSwitcher setOn:self.isBigSizeButtons];
    [isBigSizeSwitcher addTarget:self action:@selector(isBigSizeButtonSwitch:) forControlEvents:UIControlEventValueChanged];
    isBigSizeSwitcher.onTintColor = [UIColor whiteColor];
    [self.cView addSubview:isBigSizeSwitcher];
    self.isBigSizeSwitcher = isBigSizeSwitcher;

    UIView *smallButtonView = [[UIView alloc] init];
    [self.cView addSubview:smallButtonView];
    self.smallButtonView = smallButtonView;
    
    UIView *bigbuttonView = [[UIView alloc] init];
    [self.cView addSubview:bigbuttonView];
    self.bigbuttonView = bigbuttonView;

    
    //SOUND SWITCH
    UISwitch *soundSwitcher = [[UISwitch alloc] init];
    [soundSwitcher setOn:self.isSoundOn];
    [soundSwitcher addTarget:self action:@selector(isSoundSwitch:) forControlEvents:UIControlEventValueChanged];
    soundSwitcher.onTintColor = [UIColor whiteColor];

    [self.cView addSubview:soundSwitcher];
    self.soundSwitcher = soundSwitcher;
    
    SoundView *soundOff = [[SoundView alloc] init];
    soundOff.on = NO;
    soundOff.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:soundOff];
    self.soundOff = soundOff;
    
    SoundView *soundOn = [[SoundView alloc] init];
    soundOn.on = YES;
    soundOn.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:soundOn];
    self.soundOn = soundOn;
    
    
    //ARCHIVE SIZE
    UISwitch *isBigDataBaseSwitcher = [[UISwitch alloc] init];
    [isBigDataBaseSwitcher setOn:self.isBigDataBase];
    [isBigDataBaseSwitcher addTarget:self action:@selector(switchIsBigDataBase:) forControlEvents:UIControlEventValueChanged];
    isBigDataBaseSwitcher.onTintColor = [UIColor whiteColor];

    [self.cView addSubview:isBigDataBaseSwitcher];
    self.isBigDataBaseSwitcher = isBigDataBaseSwitcher;
    
    ArchiveSizeView *archsizeViewSmall = [[ArchiveSizeView alloc] init];
    archsizeViewSmall.isBig=NO;
    archsizeViewSmall.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:archsizeViewSmall];
    self.archsizeViewSmall = archsizeViewSmall;
    
    ArchiveSizeView *archivesizeBigView = [[ArchiveSizeView alloc] init];
    archivesizeBigView.isBig=YES;
    archivesizeBigView.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:archivesizeBigView];
    self.archivesizeBigView = archivesizeBigView;
    
    //iCloud use
    UISwitch *isiCloudUseSwitcher = [[UISwitch alloc] init];
    [isiCloudUseSwitcher setOn:self.isiCloudInUse];
    [isiCloudUseSwitcher addTarget:self action:@selector(isiCloudSwitch:) forControlEvents:UIControlEventValueChanged];
    isiCloudUseSwitcher.onTintColor = [UIColor whiteColor];

    [self.cView addSubview:isiCloudUseSwitcher];
    self.isiCloudUseSwitcher = isiCloudUseSwitcher;
    
    CloudView *cloudOnView = [[CloudView alloc]init];
    cloudOnView.on = YES;
    cloudOnView.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:cloudOnView];
    self.cloudOnView = cloudOnView;
    
    CloudView *cloudOffView = [[CloudView alloc]init];
    cloudOffView.on = NO;
    cloudOffView.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:cloudOffView];
    self.cloudOffView = cloudOffView;
    
    //CLEAR HISTORY
    ClearHistoryButton *clearHistoryButton = [[ClearHistoryButton alloc]init];
    [clearHistoryButton addTarget:self action:@selector(pressedClearHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cView addSubview:clearHistoryButton];
    self.clearHistoryButton = clearHistoryButton;
    
    //CHANGE DESIGN BUTTON
    if((self.wasPurshaised) || (self.isTrialPeriod)){
        DesignButton *changeDesignButton = [[DesignButton alloc]init];
        [changeDesignButton addTarget:self action:@selector(pressedDesignButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.cView addSubview:changeDesignButton];
        self.changeDesignButton = changeDesignButton;
        
        //set KEYBOARD DEFAULT BUTTON
        UIButton *keyboardDefaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [keyboardDefaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        keyboardDefaultButton.titleLabel.font = [UIFont systemFontOfSize:18.];
        keyboardDefaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        keyboardDefaultButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
        [keyboardDefaultButton addTarget:self action:@selector(pressedKeyboardDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.cView addSubview:keyboardDefaultButton];
        self.keyboardDefaultButton = keyboardDefaultButton;
    }
    
    
    
    //set BUY ADDITIONS BUTTON
        if(!self.wasPurshaised){
            UIButton *buyAdditionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [buyAdditionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buyAdditionsButton.titleLabel.font = [UIFont systemFontOfSize:18.];
            buyAdditionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            buyAdditionsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            [buyAdditionsButton setTitle:BUY_REQUEST_BUTTON forState:UIControlStateNormal];
            [buyAdditionsButton addTarget:self action:@selector(pressedBuyAdditionsButton:) forControlEvents:UIControlEventTouchUpInside];
            
            buyAdditionsButton.enabled = NO;
            [buyAdditionsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            
            [self.cView addSubview:buyAdditionsButton];
            self.buyAdditionsButton = buyAdditionsButton;
            
            
            //setProcessSpiner
            
             UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc]init];
            [processSpinner startAnimating];
            [self.cView addSubview:processSpinner];
             self.processSpinner = processSpinner;
            
            
            
            
            //make product request
            if([SKPaymentQueue canMakePayments]) {
                
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kInAppPurchaseProductID]];
                request.delegate = self;
                
                [request start];
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            } else {
                //if cant make purchaising stop and remove spinner
                [self.processSpinner stopAnimating];
                [self.processSpinner removeFromSuperview];
                self.buyAdditionsButton.titleLabel.textColor = [UIColor grayColor];
            }
    
           
        }
    
    if(IS_IPAD){
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
    }
    
}



-(void) setLayOutOfSettingsView:(CGRect)rect
{

    CGFloat mainHeight = rect.size.height;
    CGFloat mainWidth = rect.size.width;
    
    CGFloat x = INDENT+rect.origin.x;
    CGFloat y = rect.origin.y;
    
    
    if(IS_IPAD){
        CGFloat measure = (mainHeight)/6;
        CGFloat part = (mainWidth-2*INDENT) /3; //
        CGFloat startSectionOne = part / 4;
        CGFloat startSectionTwo = startSectionOne + part + (part/2);
        
        CGFloat centerFirstLine =x+startSectionOne + (part / 2);
        CGFloat firstLinePicture = centerFirstLine - 85;
        CGFloat secondLinePicture = centerFirstLine + 85;
        
        CGFloat centerSecondLine = x+startSectionTwo + (part / 2);
        CGFloat thirstLinePicture = centerSecondLine - 85;
        CGFloat fourLinePicture = centerSecondLine + 85;
        
        CGFloat viewSide = (self.view.bounds.size.width>self.view.bounds.size.height)? self.view.bounds.size.height/10 : self.view.bounds.size.width/10;
        CGRect rectForView = CGRectMake(0, 0, viewSide, viewSide);
        
        
        //line one part one
        [self.smallButtonView setBounds:CGRectMake(0, 0, viewSide/1.1, (viewSide/1.1)*0.7)];
        [self.smallButtonView setCenter:CGPointMake(firstLinePicture,y+ measure)];
        
        [self.bigbuttonView setBounds:CGRectMake(0, 0, viewSide*1.2, (viewSide*1.2)*0.7)];
        [self.bigbuttonView setCenter:CGPointMake(secondLinePicture,y+ measure)];
        
        [self.isBigSizeSwitcher setCenter:CGPointMake(centerFirstLine,y+ measure)];

        [self.buttonSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.buttonSwitcherLabel setCenter:CGPointMake(centerFirstLine, y+measure - 60)];
        
        
        //line one part two
        [self.soundOff setBounds:rectForView];
        [self.soundOff setCenter:CGPointMake(thirstLinePicture,y+ measure)];
        
        [self.soundOn setBounds:rectForView];
        [self.soundOn setCenter:CGPointMake(fourLinePicture,y+ measure)];

        [self.soundSwitcher setCenter:CGPointMake(centerSecondLine, y+measure)];
        
        
        [self.soundSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.soundSwitcherLabel setCenter:CGPointMake(centerSecondLine,y+ measure - 60)];
        
        
        
        //line two part one
        [self.archsizeViewSmall setBounds:rectForView];
        [self.archsizeViewSmall setCenter:CGPointMake(firstLinePicture,y+ 2*measure)];
        
        [self.archivesizeBigView setBounds:rectForView];
        [self.archivesizeBigView setCenter:CGPointMake(secondLinePicture,y+ 2*measure)];
        [self.isBigDataBaseSwitcher setCenter:CGPointMake(centerFirstLine,y+ 2*measure)];

        [self.archiveSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.archiveSwitcherLabel setCenter:CGPointMake(centerFirstLine,y+ 2*measure - 60)];
        
        
        //line two part two
        [self.cloudOffView setBounds:rectForView];
        [self.cloudOffView setCenter:CGPointMake(thirstLinePicture,y+ 2*measure)];
        
        [self.cloudOnView setBounds:rectForView];
        [self.cloudOnView setCenter:CGPointMake(fourLinePicture,y+ 2*measure)];
        [self.isiCloudUseSwitcher setCenter:CGPointMake(centerSecondLine,y+ 2*measure)];

        [self.iCloudSwitcherName setBounds:CGRectMake(0,0, 250, 20)];
        [self.iCloudSwitcherName setCenter:CGPointMake(centerSecondLine,y+ 2*measure - 60)];
        
        //line three
        if((!self.wasPurshaised) && (!self.isTrialPeriod)){
            [self.clearHistoryButton setBounds:rectForView];
            [self.clearHistoryButton setCenter:CGPointMake(rect.origin.x+rect.size.width/2,y+ 3*measure)];
            [self.clearHistoryButtonLabel setBounds:CGRectMake(0,0, 250, 20)];
            [self.clearHistoryButtonLabel setCenter:CGPointMake(rect.origin.x+rect.size.width/2,y+ 3*measure - 60)];
        } else {
        
            [self.clearHistoryButton setBounds:rectForView];
            [self.clearHistoryButton setCenter:CGPointMake(centerFirstLine,y+ 3*measure)];
            [self.clearHistoryButtonLabel setBounds:CGRectMake(0,0, 250, 20)];
            [self.clearHistoryButtonLabel setCenter:CGPointMake(centerFirstLine,y+ 3*measure - 60)];
        
            [self.changeDesignButton setBounds:rectForView];
            [self.changeDesignButton setCenter:CGPointMake(centerSecondLine,y+ 3*measure)];
            [self.changeDesignButtonLabel setBounds:CGRectMake(0,0, 250, 20)];
            [self.changeDesignButtonLabel setCenter:CGPointMake(centerSecondLine,y+ 3*measure - 60)];
        }

        
        CGRect buttonsBounds = CGRectMake(0, 0, (rect.size.width - 4*INDENT)/3, measure-2*INDENT);
        [self.keyboardDefaultButton setBounds:buttonsBounds];
        if(!self.wasPurshaised){
            [self.buyAdditionsButton setBounds:buttonsBounds];
        }
        
        if(self.isTrialPeriod && (!self.wasPurshaised)){
            [self.keyboardDefaultButton setCenter:CGPointMake(centerFirstLine,y+ 4*measure)];
            
            [self.processSpinner setCenter:CGPointMake(centerSecondLine,y+ 4*measure)];
            [self.buyAdditionsButton setCenter:CGPointMake(centerSecondLine,y+ 4*measure)];
            
        } else if (self.wasPurshaised){
            
            //line three part two
            [self.keyboardDefaultButton setCenter:CGPointMake(rect.origin.x+rect.size.width/2,y+ 4*measure)];
        } else {
            
            //line three part two
            [self.processSpinner setCenter:CGPointMake(rect.origin.x+rect.size.width/2,y+ 4*measure - 40)];
            [self.buyAdditionsButton setCenter:CGPointMake(rect.origin.x+rect.size.width/2,y+ 4*measure)];
        }
        
        //line five
        [self.calcButton setBounds:rectForView];
        [self.calcButton setCenter:CGPointMake(rect.origin.x+rect.size.width/2, y+5*measure)];
        
        
        
    } else {
        NSInteger parts = 9;
        if(self.wasPurshaised || (!self.isTrialPeriod)){
            parts = 8;
        }
        CGFloat measure = (mainHeight)/ parts;
        CGFloat xCenterLineOne = x+(mainWidth-2*INDENT)/4;
        CGFloat xCenterLineTwo = x+(mainWidth-2*INDENT)/2;
        CGFloat xCenterLineThree = x+3*(mainWidth-2*INDENT)/4;
        
        CGFloat viewSide = (self.view.bounds.size.height>self.view.bounds.size.width)? self.view.bounds.size.height/10 : self.view.bounds.size.width/10;
        CGRect rectForView = CGRectMake(0, 0, viewSide, viewSide);
        
        //first line
        [self.smallButtonView setBounds:CGRectMake(0, 0, viewSide/1.1, (viewSide/1.1)*0.7)];
        [self.smallButtonView setCenter:CGPointMake(xCenterLineOne, y+measure)];
        
        [self.isBigSizeSwitcher setCenter:CGPointMake(xCenterLineTwo, y+measure)];
        
        [self.bigbuttonView setBounds:CGRectMake(0, 0, viewSide*1.2, (viewSide*1.2)*0.7)];
        [self.bigbuttonView setCenter:CGPointMake(xCenterLineThree, y+measure)];

        
       //second line
        [self.soundOff setBounds:rectForView];
        [self.soundOff setCenter:CGPointMake(xCenterLineOne, y+2*measure)];
        
        [self.soundSwitcher setCenter:CGPointMake(xCenterLineTwo, y+2*measure)];
        
        [self.soundOn setBounds:rectForView];
        [self.soundOn setCenter:CGPointMake(xCenterLineThree, y+2*measure)];
        
        //line three
        [self.archsizeViewSmall setBounds:rectForView];
        [self.archsizeViewSmall setCenter:CGPointMake(xCenterLineOne, y+3*measure)];
        
        [self.isBigDataBaseSwitcher setCenter:CGPointMake(xCenterLineTwo, y+3*measure)];
        
        [self.archivesizeBigView setBounds:rectForView];
        [self.archivesizeBigView setCenter:CGPointMake(xCenterLineThree, y+3*measure)];
        
        //line four
        [self.cloudOffView setBounds:rectForView];
        [self.cloudOffView setCenter:CGPointMake(xCenterLineOne, y+4*measure)];
        
        [self.isiCloudUseSwitcher setCenter:CGPointMake(xCenterLineTwo, y+4*measure)];
        
        [self.cloudOnView setBounds:rectForView];
        [self.cloudOnView setCenter:CGPointMake(xCenterLineThree, y+4*measure)];
        
        //line five
        if((!self.wasPurshaised) && (!self.isTrialPeriod)){
            [self.clearHistoryButton setBounds:rectForView];
            [self.clearHistoryButton setCenter:CGPointMake(xCenterLineTwo, y+5*measure)];
        } else {
        
            [self.clearHistoryButton setBounds:rectForView];
            [self.clearHistoryButton setCenter:CGPointMake(xCenterLineOne, y+5*measure)];
            
            [self.changeDesignButton setBounds:rectForView];
            [self.changeDesignButton setCenter:CGPointMake(xCenterLineThree, y+5*measure)];
        }

        
        //line six
        CGRect buttonsBounds = CGRectMake(0, 0, (rect.size.width - 2*INDENT), measure-1.5*INDENT);
        if(!self.wasPurshaised){
            [self.buyAdditionsButton setBounds:buttonsBounds];
            [self.buyAdditionsButton setCenter:CGPointMake(xCenterLineTwo, y+6*measure)];
            [self.processSpinner setCenter:self.buyAdditionsButton.center];
        }
        
        
        //line seven
        if((self.wasPurshaised) || (self.isTrialPeriod)){
            [self.keyboardDefaultButton setBounds:buttonsBounds];
            [self.keyboardDefaultButton setCenter:CGPointMake(xCenterLineTwo, y+(parts-2)*measure)];
        }
        
        
        //line eight
        [self.calcButton setBounds:rectForView];
        [self.calcButton setCenter:CGPointMake(xCenterLineTwo, y+(parts-1)*measure)];

    }
    struct Color clr;
    clr.r = 0.95;//0.26;
    clr.g = 0.95;//0.57;
    clr.b = 0.95;//0.70;
    clr.a = 1.0;
    
    CGRect smalLook = self.smallButtonView.bounds;
    smalLook.size.width = smalLook.size.width -4;
    smalLook.size.height =smalLook.size.height-4;
    newButtonView *smalButtonLook = [[newButtonView alloc] initWithFrame:smalLook];
    smalButtonLook.title = @"=";
    smalButtonLook.buttonColor = clr;
    [self.smallButtonView addSubview:smalButtonLook];
    
    self.bigbuttonView.backgroundColor = [UIColor clearColor];
    CGRect bigLook = self.bigbuttonView.bounds;
    bigLook.size.width =-4;
    bigLook.size.height =-4;
    newButtonView *bigButtonLook = [[newButtonView alloc] initWithFrame:self.bigbuttonView.bounds];
    bigButtonLook.title = @"=";
    bigButtonLook.buttonColor = clr;
    [self.bigbuttonView addSubview:bigButtonLook];
    
}


-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{

    [self setLayOutOfSettingsView:rect];

}

-(void) setCViewAccordingFrameRect:(CGRect)rctIn
{
    CGRect rct;
    rct.size.width = rctIn.size.width/0.8;
    rct.size.height = rctIn.size.height/0.8;
    rct.origin.x = (rctIn.size.width - rct.size.width)/2;
    rct.origin.y = (rctIn.size.height - rct.size.height)/2;
    
    
    CGRect rect = rctIn;
    rect.origin.x = -rct.origin.x;
    rect.origin.y = -rct.origin.y;
    
    CGFloat angle = 0;
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    self.wasOrient = orient;
    
    if(!IS_IPAD){
        CGFloat width = rct.size.width;
        CGFloat height = rct.size.height;
        
        if(width > height){
            
            switch (orient) {
                case UIDeviceOrientationLandscapeLeft:
                    angle = -M_PI/2;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    angle = M_PI/2;
                    
                default:
                    break;
            }
            rect.size.width = self.view.bounds.size.height;
            rect.size.height = self.view.bounds.size.width;
            rect.origin.x = -rct.origin.y;
            rect.origin.y = -rct.origin.x;
        }
        
        self.cView.center = self.view.center;
        [self.cView setTransform:CGAffineTransformMakeRotation(angle)];
    }
    [self.cView setFrame:rct];
    
    [self viewDidLayoutSubviewsWithRect:rect];

}




-(void)viewWillAppear:(BOOL)animated
{
    
    CGRect rct = self.view.bounds;
    [self setCViewAccordingFrameRect:rct];
    

    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appWillGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];
    
}

-(void)appWillGoToBackground:(NSNotification *)note{
    [self dismis];
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
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    [self setNeedViews];
    
    CGRect rect = self.view.bounds;
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

                         [self setCViewAccordingFrameRect:rect];
                         
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
