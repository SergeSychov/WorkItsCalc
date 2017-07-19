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

#import "TestButtonBackGroundView.h"
#import "designButtonView.h"
#import "PlusButton.h"
#import "CLr.h"
#import "RoundedGroundView.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)
#define INDENT 20.0f


#define kInAppPurchaseProductID @"ItsCalc.changekeyboard"
NSString *const SettingReciveChangedNotification=@"SendChangedNotification";

@interface SettingsViewController() <SKPaymentTransactionObserver, SKProductsRequestDelegate, DesignViewControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design>

@property (nonatomic, strong) SKProduct *product;
@property (nonatomic,strong) SKProductsRequest *request;
@property (nonatomic,weak) CalcButton *calcButton;

//transition
@property (weak,nonatomic) Transition* rightTransition;
@property (weak,nonatomic) DesignViewController *designViewController;

//copied from main controller
@property (weak, nonatomic) UILabel *buttonSwitcherLabel;
@property (weak, nonatomic) UIView *smallButtonView;
@property (weak,nonatomic) newButtonView *smalButtonLook;
@property (weak, nonatomic) UIView *bigbuttonView;
@property (weak,nonatomic) newButtonView *bigButtonLook;
@property (weak, nonatomic) UISwitch *isBigSizeSwitcher;

@property (weak, nonatomic) UILabel *soundSwitcherLabel;
@property (weak, nonatomic) UISwitch *soundSwitcher;
@property (weak, nonatomic) SoundView *soundOff;
@property (weak, nonatomic) SoundView *soundOn;

@property (weak, nonatomic) UILabel *archiveSwitcherLabel;
@property (weak, nonatomic) UISwitch *isBigDataBaseSwitcher;
@property (weak, nonatomic) ArchiveSizeView *archsizeViewSmall;
@property (weak, nonatomic) ArchiveSizeView *archivesizeBigView;

@property (weak, nonatomic) CloudView *cloudOnView;
@property (weak, nonatomic) CloudView *cloudOffView;
@property (weak, nonatomic) UILabel *iCloudSwitcherName;
@property (weak, nonatomic) UISwitch *isiCloudUseSwitcher;

@property (nonatomic) BOOL fristLunchWithicloudAvailable;
//need to set iClouds images whole & empty

@property (weak,nonatomic) UILabel *changeDesignButtonLabel;
@property (weak, nonatomic) DesignButton *changeDesignButton;
@property (weak,nonatomic) DesignViewFromButton *designViewFromButton;

@property (weak,nonatomic) UILabel* clearHistoryButtonLabel;
@property (weak, nonatomic) ClearHistoryButton *clearHistoryButton;

@property (weak, nonatomic) UIButton *keyboardDefaultButton;


@property (weak, nonatomic) UIButton *buyAdditionsButton;
//add spin activity to show process of purchaising
@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;
//end copied from main controller

//FOR IAPD SET DESIGN CHOOSING
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
#define ALERT_MESSAGE_CHOOSE_NEW_PHOTO NSLocalizedStringFromTable(@"ALERT_MESSAGE_CHOOSE_NEW_PHOTO",@"ACalcTryViewControllerTableNew", @"Выберите фотографию из Вашего фотоархива")
#define TITLE_BUTTON_CHOOSE_NEW_PHOTO_OK NSLocalizedStringFromTable(@"TITLE_BUTTON_CHOOSE_NEW_PHOTO_OK",@"ACalcTryViewControllerTableNew", @"Ok")
#pragma mark SET NEW DESIGN

-(void)sendNoteChangeDesign:(NSInteger)design
{
    //self.design = design;
    NSNumber *message = [NSNumber numberWithInteger:design];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"ChangedDesign",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingReciveChangedNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)trySetDesign:(NSInteger)design
{
    if(self.designObj.designNumber != design){
        if(design == DESIGN_PHOTO){
            //check is there user photo in store
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString* documentName = @"PhotoPicture";//@"MyDocument.sqlite"
            NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
            NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
            
            if ([fileManager fileExistsAtPath:[storeURL path]]) {
                
                [self sendNoteChangeDesign:design];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:ALERT_MESSAGE_CHOOSE_NEW_PHOTO
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {[self choosePhoto];}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            //if send user to photo library throug message
        } else {
            if (design == DESIGN_COLOR_BLUE){
                [self setNewBackgroundImageForColor:[Clr blueGround]];
            }else if (design == DESIGN_COLOR_GRAY){
                [self setNewBackgroundImageForColor:[Clr grayGround]];
            }else if (design == DESIGN_COLOR_GREEN){
                [self setNewBackgroundImageForColor:[Clr greenGround]];
            }else if (design == DESIGN_COLOR_PINK){
                [self setNewBackgroundImageForColor:[Clr pinkGround]];
            }else if (design == DESIGN_COLOR_YELOW){
                [self setNewBackgroundImageForColor:[Clr yellowGround]];
            }
            [self sendNoteChangeDesign:design];
        }
    }
}

-(void) setNewBackgroundImageForColor:(UIColor*)color
{
    UIImage *createdImage = [RoundedGroundView getImageForRect:CGRectInset(self.view.bounds, -40, -40) withColor:color];
    NSData *newImageData = UIImagePNGRepresentation(createdImage);
    
    //save image
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documentName = @"PaintedPicture";//@"MyDocument.sqlite"
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        if([fileManager isDeletableFileAtPath:[storeURL path]]){
            NSError *error;
            BOOL delSucces = [fileManager removeItemAtPath:[storeURL path] error:&error];
            if(delSucces){
                NSLog(@"File exist and deleted");
                if([newImageData writeToURL:storeURL atomically:YES]){
                    NSLog(@"File replace succesefuly");
                } else {
                    NSLog(@"But not replace");
                }
            } else {
                NSLog(@"File exist but not deleted");
            }
        }
    } else {
        NSLog(@"File not finded");
        if([newImageData writeToURL:storeURL atomically:YES]){
            NSLog(@"File created succesefuly");
        } else {
            NSLog(@"But not created");
        }
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
    [self showDesignViewcontroller];
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

NSString *const SettingSendChangedNotification=@"SendChangedNotification";

- (void)isBigSizeButtonSwitch:(UISwitch *)sender
{
    self.isBigSizeButtons = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isBigSizeButtons",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)isSoundSwitch:(UISwitch *)sender
{
    self.isSoundOn = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"isSoundOn",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)switchIsBigDataBase:(UISwitch *)sender
{
    self.isBigDataBase = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isBigDataBase", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)isiCloudSwitch:(UISwitch *)sender
{
    self.isiCloudInUse = sender.on;
    NSNumber *message = sender.on? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"isiCloudInUse", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SettingSendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.photo setImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
    UIImage *imageFromLibrary = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *newImageData = UIImagePNGRepresentation(imageFromLibrary);
    
    //save image
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documentName = @"PhotoPicture";//@"MyDocument.sqlite"
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    
    BOOL succes = NO;
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        if([fileManager isDeletableFileAtPath:[storeURL path]]){
            NSError *error;
            BOOL delSucces = [fileManager removeItemAtPath:[storeURL path] error:&error];
            if(delSucces){
                NSLog(@"File exist and deleted");
                if([newImageData writeToURL:storeURL atomically:YES]){
                    NSLog(@"File replace succesefuly");
                    succes = YES;
                } else {
                    NSLog(@"But not replace");
                }
            } else {
                NSLog(@"File exist but not deleted");
            }
        }
    } else {
        NSLog(@"File not finded");
        if([newImageData writeToURL:storeURL atomically:YES]){
            NSLog(@"File created succesefuly");
            succes = YES;
        } else {
            NSLog(@"But not created");
        }
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if(succes) [self sendNoteChangeDesign:DESIGN_PHOTO];
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{ }];
}


-(void) choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)chooseNewPhoto:(id)sender
{
    [self choosePhoto];
}

#pragma mark CHOSE NEW DESIGN
-(void) chooseButtonTapped:(id)sender
{
    NSInteger design = 0;
    id senderView = nil;
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        senderView = ((UITapGestureRecognizer*)sender).view;
    }
    
    if(senderView){
        if([senderView isKindOfClass:[TestButtonBackGroundView class]]){
            design = ((TestButtonBackGroundView*)senderView).designIndex;
        } else if ([senderView isKindOfClass:[designButtonView class]]){
            design = ((designButtonView*)senderView).designIndex;
        } else if([senderView isKindOfClass:[UIView class]]){
            design = ((UIView*)senderView).tag;
        }
    }
    
    
    [self trySetDesign:design];
    
    
    
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
    struct Color clr;
    clr.r = 0.95;//0.26;
    clr.g = 0.95;//0.57;
    clr.b = 0.95;//0.70;
    clr.a = 1.0;
    
    UISwitch *isBigSizeSwitcher = [[UISwitch alloc] init];
    [isBigSizeSwitcher setOn:self.isBigSizeButtons];
    [isBigSizeSwitcher addTarget:self action:@selector(isBigSizeButtonSwitch:) forControlEvents:UIControlEventValueChanged];
    isBigSizeSwitcher.onTintColor = [UIColor whiteColor];
    [self.cView addSubview:isBigSizeSwitcher];
    self.isBigSizeSwitcher = isBigSizeSwitcher;
    
    UIView *smallButtonView = [[UIView alloc] init];
    
    [self.cView addSubview:smallButtonView];
    self.smallButtonView = smallButtonView;
    
    newButtonView *smalButtonLook = [[newButtonView alloc] init];
    smalButtonLook.title = @"=";
    smalButtonLook.buttonColor = [UIColor whiteColor];
    [self.smallButtonView addSubview:smalButtonLook];
    self.smalButtonLook = smalButtonLook;
    
    UIView *bigbuttonView = [[UIView alloc] init];
    [self.cView addSubview:bigbuttonView];
    self.bigbuttonView = bigbuttonView;
    
    newButtonView *bigButtonLook = [[newButtonView alloc] init];
    bigButtonLook.title = @"=";
    bigButtonLook.buttonColor = [UIColor whiteColor];
    [self.bigbuttonView addSubview:bigButtonLook];
    self.bigButtonLook = bigButtonLook;
    
    
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
    isiCloudUseSwitcher.enabled = self.isiCloudUseSwitcherEnabled;
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
        if(!IS_IPAD){
            DesignButton *changeDesignButton = [[DesignButton alloc]init];
            //fro iPad its only pictures
            [changeDesignButton addTarget:self action:@selector(pressedDesignButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.cView addSubview:changeDesignButton];
            self.changeDesignButton = changeDesignButton;
        } else {
            DesignViewFromButton *designViewFromButton = [[DesignViewFromButton alloc]init];
            designViewFromButton.backgroundColor = [UIColor clearColor];
            //fro iPad its only pictures
            [self.cView addSubview:designViewFromButton];
            self.designViewFromButton = designViewFromButton;
        }
        
        //set KEYBOARD DEFAULT BUTTON
        UIButton *keyboardDefaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [keyboardDefaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        keyboardDefaultButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.];
        keyboardDefaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        keyboardDefaultButton.titleLabel.numberOfLines = 0;
        keyboardDefaultButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        keyboardDefaultButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
        [keyboardDefaultButton addTarget:self action:@selector(pressedKeyboardDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.cView addSubview:keyboardDefaultButton];
        self.keyboardDefaultButton = keyboardDefaultButton;
        
        if(IS_IPAD){
            UILabel *chooseDesignLabel = [[UILabel alloc] init];
            chooseDesignLabel.text = @"Выберите подходящий дизайн";
            chooseDesignLabel.textAlignment = NSTextAlignmentCenter;
            chooseDesignLabel.numberOfLines = 0;
            chooseDesignLabel.textColor = [UIColor whiteColor];
            
            chooseDesignLabel.font = [UIFont systemFontOfSize:18];
            
            chooseDesignLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            chooseDesignLabel.adjustsFontSizeToFitWidth = YES;
            [self.cView addSubview:chooseDesignLabel];
            self.chooseDesignLabel = chooseDesignLabel;
            
            
            UIView *classicPartView = [[UIView alloc] init];
            classicPartView.backgroundColor = [UIColor blackColor];
            //classicPartView.layer.masksToBounds = YES;
            
            [self.cView addSubview:classicPartView];
            self.classicPartView = classicPartView;
            //need to set button classic button
            designButtonView *classicButtonView= [[designButtonView alloc] init];
            classicButtonView.backgroundColor = [UIColor clearColor];
            
            [self.classicPartView addSubview:classicButtonView];
            self.classicButtonView = classicButtonView;
            
            TestButtonBackGroundView *classicButton = [[TestButtonBackGroundView alloc]init];
            classicButton.designIndex = DESIGN_CLASSIC;
            classicButton.isChoosed = NO;
            [self.classicPartView addSubview:classicButton];
            self.classicButton = classicButton;
            
            
            UIView *paperPartView = [[UIView alloc] init];
            paperPartView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            //paperPartView.layer.masksToBounds = YES;
            [self.cView addSubview:paperPartView];
            self.paperPartView = paperPartView;
            designButtonView *paperButtonView= [[designButtonView alloc] init];
            paperButtonView.backgroundColor = [UIColor clearColor];
            [self.paperPartView addSubview:paperButtonView];
            self.paperButtonView = paperButtonView;
            
            TestButtonBackGroundView *paperButton = [[TestButtonBackGroundView alloc]init];
            paperButton.designIndex = DESIGN_PAPER;
            paperButton.isChoosed = NO;
            [self.paperPartView addSubview:paperButton];
            self.paperButton = paperButton;
            
            
            //need to set button classic button
            designButtonView *colorButtonView= [[designButtonView alloc] init];
            
            //IMPORTANT need to be according design
            colorButtonView.designIndex = DESIGN_COLOR_BLUE;
            colorButtonView.backgroundColor = [UIColor clearColor];
            [self.cView addSubview:colorButtonView];
            self.colorButtonView = colorButtonView;
            
            //blue
            TestButtonBackGroundView *clolorBlueButton = [[TestButtonBackGroundView alloc]init];
            clolorBlueButton.designIndex = DESIGN_COLOR_BLUE;
            clolorBlueButton.isChoosed = NO;
            [self.cView addSubview:clolorBlueButton];
            self.clolorBlueButton = clolorBlueButton;
            
            //pink
            TestButtonBackGroundView *colorPinkButton = [[TestButtonBackGroundView alloc]init];
            colorPinkButton.designIndex = DESIGN_COLOR_PINK;
            colorPinkButton.isChoosed = NO;
            [self.cView addSubview:colorPinkButton];
            self.colorPinkButton = colorPinkButton;
            
            //green
            TestButtonBackGroundView *colorGreenButton = [[TestButtonBackGroundView alloc]init];
            colorGreenButton.designIndex = DESIGN_COLOR_GREEN;
            colorGreenButton.isChoosed = NO;
            [self.cView addSubview:colorGreenButton];
            self.colorGreenButton = colorGreenButton;
            
            //yelow
            TestButtonBackGroundView *colorYelowButton = [[TestButtonBackGroundView alloc]init];
            
            
            colorYelowButton.designIndex = DESIGN_COLOR_YELOW;
            colorYelowButton.isChoosed = NO;
            [self.cView addSubview:colorYelowButton];
            self.colorYelowButton = colorYelowButton;
            
            //black
            TestButtonBackGroundView *colorBlackButton = [[TestButtonBackGroundView alloc]init];
            
            
            colorBlackButton.designIndex = DESIGN_COLOR_GRAY;
            colorBlackButton.isChoosed = NO;
            [self.cView addSubview:colorBlackButton];
            self.colorBlackButton = colorBlackButton;
            
            UIView *photoPartView = [[UIView alloc] init];
            
            photoPartView.clipsToBounds = YES;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString* documentName = @"PhotoPicture";//@"MyDocument.sqlite"
            NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
            NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
            UIImage *imageForPhotoPart;
            
            if ([fileManager fileExistsAtPath:[storeURL path]]) {
                if([fileManager isDeletableFileAtPath:[storeURL path]]){
                    imageForPhotoPart = [UIImage imageWithData:[NSData dataWithContentsOfURL:storeURL]];
                } else {
                    imageForPhotoPart =[UIImage imageNamed:/*@"handmadepaper.png"*/@"photoGround.png"];
                }
            } else {
                imageForPhotoPart =[UIImage imageNamed:/*@"handmadepaper.png"*/@"photoGround.png"];
                
            }
            
            UIImageView *photo = [[UIImageView alloc] initWithImage:imageForPhotoPart];
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.backgroundColor = self.cView.backgroundColor;
            photo.clipsToBounds = YES;
            self.photo = photo;
            
            [photoPartView addSubview:photo];
            
            [self.cView addSubview:photoPartView];
            self.photoPartView = photoPartView;
            
            TestButtonBackGroundView *photButton = [[TestButtonBackGroundView alloc]init];
            photButton.designIndex = DESIGN_PHOTO;
            photButton.isChoosed = NO;
            [self.photoPartView addSubview:photButton];
            self.photButton = photButton;
            
            //need to set button classic button
            designButtonView *photoButtonView= [[designButtonView alloc] init];
            photoButtonView.backgroundColor = [UIColor clearColor];
            [self.photoPartView addSubview:photoButtonView];
            self.photoButtonView = photoButtonView;
            
            PlusButton *addNewPhotoButton = [[PlusButton alloc] init];
            [addNewPhotoButton addTarget:self action:@selector(chooseNewPhoto:) forControlEvents:UIControlEventTouchUpInside];
            self.addNewPhotoButton = addNewPhotoButton;
            [self.cView addSubview:addNewPhotoButton];
            
            switch (self.designObj.designNumber) {
                case DESIGN_CLASSIC:
                    self.classicButton.isChoosed = YES;
                    break;
                case DESIGN_PAPER:
                    self.paperButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_BLUE:
                    self.clolorBlueButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_GREEN:
                    self.colorGreenButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_PINK:
                    self.colorPinkButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_YELOW:
                    self.colorYelowButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_GRAY:
                    self.colorBlackButton.isChoosed = YES;
                    break;
                case DESIGN_PHOTO:
                    self.photButton.isChoosed = YES;
                    break;
                default:
                    break;
            }
            
            UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            UITapGestureRecognizer *tapOnView13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
            
            [self.classicPartView addGestureRecognizer:tapOnView];
            [self.classicButton addGestureRecognizer:tapOnView1];
            [self.classicButtonView addGestureRecognizer:tapOnView2];
            
            [self.paperPartView addGestureRecognizer:tapOnView3];
            [self.paperButtonView addGestureRecognizer:tapOnView4];
            [self.paperButton addGestureRecognizer:tapOnView5];
            
            [self.clolorBlueButton addGestureRecognizer:tapOnView6];
            [self.colorPinkButton addGestureRecognizer:tapOnView7];
            [self.colorGreenButton addGestureRecognizer:tapOnView8];
            [self.colorYelowButton addGestureRecognizer:tapOnView9];
            [self.colorBlackButton addGestureRecognizer:tapOnView10];
            
            [self.photoPartView addGestureRecognizer:tapOnView11];
            [self.photoButtonView addGestureRecognizer:tapOnView12];
            [self.photButton addGestureRecognizer:tapOnView13];
        }
    }
    
    
    
    //set BUY ADDITIONS BUTTON
    if(!self.wasPurshaised){
        
        UIButton *buyAdditionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [buyAdditionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyAdditionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.];
        buyAdditionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        buyAdditionsButton.titleLabel.numberOfLines = 0;
        buyAdditionsButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
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
        //devide height on ten parts
        //one part is
        CGFloat measure = mainHeight/9;
        //determine center of seetings line accordindg condition
        CGFloat centeSettingsLine;//center settings line
        CGFloat centerDesignLine;//set center for design views
        if((self.wasPurshaised) || (self.isTrialPeriod)){
            centeSettingsLine =x+mainWidth/4;
            centerDesignLine = x + 3*mainWidth/4;//center of design line
        } else {
            centeSettingsLine =x+mainWidth/2;
            centerDesignLine =x+mainWidth/2;
        }
        
        //icons size
        CGFloat viewSide =rect.size.height/13 ;
        CGRect rectForView = CGRectMake(0, 0, viewSide, viewSide);
        //determine center layout for each settings property
        //switcher; one picture; second picture; label
        //y center switcher; one picture; second picture;
        CGFloat yCenter = y + measure/2; //+quantity measures
        CGFloat yCenterDesignView = yCenter - measure/10;
        CGFloat yLabelCenter = y+(measure/2 - viewSide/2.5)/2; //+quantity measures
        
        //determine x centers for one and second pictures
        CGFloat part = (mainWidth-2*INDENT) /3; //whole line size
        
        CGFloat firstLinePicture = centeSettingsLine - part/3;
        CGFloat secondLinePicture = centeSettingsLine + part/3;
        
        
        //SIZE BUTTON SWITCHER LINE
        [self.smallButtonView setBounds:CGRectMake(0, 0, viewSide/1.4, (viewSide/1.4)*0.7)];
        [self.smallButtonView setCenter:CGPointMake(firstLinePicture,yCenter+ measure)];
        
        [self.bigbuttonView setBounds:CGRectMake(0, 0, viewSide/1.1, (viewSide/1.1)*0.7)];
        [self.bigbuttonView setCenter:CGPointMake(secondLinePicture,yCenter+ measure)];
        
        [self.isBigSizeSwitcher setCenter:CGPointMake(centeSettingsLine,yCenter+ measure)];
        
        [self.buttonSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.buttonSwitcherLabel setCenter:CGPointMake(centeSettingsLine, yLabelCenter+measure)];
        
        
        //SOUND SWITCHER LINE
        [self.soundOff setBounds:rectForView];
        [self.soundOff setCenter:CGPointMake(firstLinePicture,yCenter+ 2*measure)];
        
        [self.soundOn setBounds:rectForView];
        [self.soundOn setCenter:CGPointMake(secondLinePicture,yCenter+ 2*measure)];
        
        [self.soundSwitcher setCenter:CGPointMake(centeSettingsLine, yCenter+ 2*measure)];
        
        [self.soundSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.soundSwitcherLabel setCenter:CGPointMake(centeSettingsLine,yLabelCenter+ 2*measure)];
        
        
        
        //ARCHIVE SIZE SWITHER
        [self.archsizeViewSmall setBounds:rectForView];
        [self.archsizeViewSmall setCenter:CGPointMake(firstLinePicture,yCenter+ 3*measure)];
        
        [self.archivesizeBigView setBounds:rectForView];
        [self.archivesizeBigView setCenter:CGPointMake(secondLinePicture,yCenter+ 3*measure)];
        [self.isBigDataBaseSwitcher setCenter:CGPointMake(centeSettingsLine,yCenter+ 3*measure)];
        
        [self.archiveSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.archiveSwitcherLabel setCenter:CGPointMake(centeSettingsLine,yLabelCenter+ 3*measure)];
        
        
        //iCLOUD USE SWITCHER
        [self.cloudOffView setBounds:rectForView];
        [self.cloudOffView setCenter:CGPointMake(firstLinePicture,yCenter+ 4*measure)];
        
        [self.cloudOnView setBounds:rectForView];
        [self.cloudOnView setCenter:CGPointMake(secondLinePicture,yCenter+ 4*measure)];
        [self.isiCloudUseSwitcher setCenter:CGPointMake(centeSettingsLine,yCenter+ 4*measure)];
        
        [self.iCloudSwitcherName setBounds:CGRectMake(0,0, 250, 20)];
        [self.iCloudSwitcherName setCenter:CGPointMake(centeSettingsLine,yLabelCenter+ 4*measure)];
        
        
        //CLEAR HISTROY BUTTON
        [self.clearHistoryButton setBounds:CGRectMake(0, 0, rectForView.size.width/1.2, rectForView.size.height/1.2)];
        [self.clearHistoryButton setCenter:CGPointMake(centeSettingsLine,yCenter+ 5*measure)];
        [self.clearHistoryButtonLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.clearHistoryButtonLabel setCenter:CGPointMake(centeSettingsLine,yLabelCenter+5*measure)];
        
        
        CGRect buttonsBounds = CGRectMake(0, 0, (rect.size.width - 4*INDENT)/3, measure-2*INDENT);
        
        //BUY ANDDEFAULT KEYBOARD BUTTONS
        if((self.wasPurshaised) || (self.isTrialPeriod)){
            [self.keyboardDefaultButton setBounds:buttonsBounds];
            [self.keyboardDefaultButton setCenter:CGPointMake(centeSettingsLine,yCenter+ 6*measure)];
            
            if(!self.wasPurshaised){
                [self.buyAdditionsButton setBounds:buttonsBounds];
                [self.buyAdditionsButton setCenter:CGPointMake(centeSettingsLine,yCenter+ 7*measure)];
                
                [self.processSpinner setCenter:CGPointMake(centeSettingsLine,yCenter+ 7*measure)];
            }
            
            CGFloat onePart;
            CGFloat origHeight;
            //nex two parts need be in setLayout in case of redrawing views
            self.classicButton.designIndex = DESIGN_CLASSIC;
            self.classicButtonView.designIndex = DESIGN_CLASSIC;
            self.classicPartView.tag = DESIGN_CLASSIC;
            
            self.paperButton.designIndex = DESIGN_PAPER;
            self.paperButtonView.designIndex = DESIGN_PAPER;
            self.paperPartView.tag = DESIGN_PAPER;
            
            self.colorButtonView.designIndex = DESIGN_COLOR_BLUE;
            self.clolorBlueButton.designIndex = DESIGN_COLOR_BLUE;
            self.colorPinkButton.designIndex = DESIGN_COLOR_PINK;
            self.colorGreenButton.designIndex = DESIGN_COLOR_GREEN;
            self.colorYelowButton.designIndex = DESIGN_COLOR_YELOW;
            self.colorBlackButton.designIndex = DESIGN_COLOR_GRAY;
            
            self.photoPartView.tag = DESIGN_PHOTO;
            self.photoButtonView.designIndex = DESIGN_PHOTO;
            self.photButton.designIndex = DESIGN_PHOTO;
            
            switch (self.designObj.designNumber) {
                case DESIGN_CLASSIC:
                    self.classicButton.isChoosed = YES;
                    break;
                case DESIGN_PAPER:
                    self.paperButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_BLUE:
                    self.clolorBlueButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_GREEN:
                    self.colorGreenButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_PINK:
                    self.colorPinkButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_YELOW:
                    self.colorYelowButton.isChoosed = YES;
                    break;
                case DESIGN_COLOR_GRAY:
                    self.colorBlackButton.isChoosed = YES;
                case DESIGN_PHOTO:
                    self.photButton.isChoosed = YES;
                    break;
                default:
                    break;
            }
            
            
            CGRect rctForDesignView = CGRectMake(0, 0, (mainWidth/3)*1.3, measure*0.8);
            
            CGFloat markSide =rect.size.width > rect.size.height? rect.size.height/13: rect.size.width/13 ;
            
            CGRect rctForMark = CGRectMake(0, 0, markSide, markSide);
            
            CGRect rctForButtonView = CGRectMake(0,0, rctForDesignView.size.width/2, markSide*1.2);
            
            [self.designViewFromButton setFrame:rctForMark];
            [self.designViewFromButton setCenter:CGPointMake(centerDesignLine - rctForDesignView.size.width/2 + rctForButtonView.size.width/3.5, yCenterDesignView+measure)];
            
            [self.chooseDesignLabel setFrame:CGRectMake(0, 0, rctForDesignView.size.width/2+rctForButtonView.size.width/2, rctForButtonView.size.height) ];
            CGFloat deltaCenter = (rctForDesignView.size.width/2+rctForButtonView.size.width/2)/2- rctForButtonView.size.width/2;
            [self.chooseDesignLabel setCenter:CGPointMake(centerDesignLine + deltaCenter,
                                                          yCenterDesignView+measure)];
            
            
            [self.classicPartView setFrame:rctForDesignView];
            [self.classicPartView setCenter:CGPointMake(centerDesignLine, yCenterDesignView + 2*measure)];
            self.classicPartView.layer.cornerRadius = rctForDesignView.size.height/6;
            self.classicPartView.layer.masksToBounds = YES;
            
            [self.classicButton setFrame:rctForMark];
            [self.classicButton setCenter:CGPointMake(rctForButtonView.size.width/3.5, rctForDesignView.size.height/2)];
            [self.classicButtonView setFrame:rctForButtonView];
            [self.classicButtonView setCenter:CGPointMake(rctForDesignView.size.width/2, rctForDesignView.size.height/2)];
            
            
            [self.paperPartView setFrame:rctForDesignView];
            [self.paperPartView setCenter:CGPointMake(centerDesignLine, yCenterDesignView + 3*measure)];
            self.paperPartView.layer.cornerRadius = rctForDesignView.size.height/6;
            self.paperPartView.layer.masksToBounds = YES;
            
            [self.paperButton setFrame:rctForMark];
            [self.paperButton setCenter:CGPointMake(rctForButtonView.size.width/3.5, rctForDesignView.size.height/2)];
            [self.paperButtonView setFrame:rctForButtonView];
            [self.paperButtonView setCenter:CGPointMake(self.paperPartView.bounds.size.width/2,self.paperPartView.bounds.size.height/2) ];
            
            [self.colorButtonView setFrame:rctForButtonView];
            [self.colorButtonView setCenter:CGPointMake(centerDesignLine, yCenterDesignView + 4*measure)];
            
            
            [self.clolorBlueButton setFrame:rctForMark];
            [self.clolorBlueButton setCenter:CGPointMake(centerDesignLine - rctForDesignView.size.width/2 + rctForButtonView.size.width/3.5, yCenterDesignView+5*measure)];
            
            CGFloat midleBetwinBlueAndGreen =  (rctForDesignView.size.width/2 - rctForButtonView.size.width/3.5)/2;
            [self.colorPinkButton setFrame:rctForMark];
            [self.colorPinkButton setCenter:CGPointMake(centerDesignLine - midleBetwinBlueAndGreen, yCenterDesignView+5*measure)];
            [self.colorGreenButton setFrame:rctForMark];
            [self.colorGreenButton setCenter:CGPointMake(centerDesignLine, yCenterDesignView+5*measure)];
            [self.colorYelowButton setFrame:rctForMark];
            [self.colorYelowButton setCenter:CGPointMake(centerDesignLine + midleBetwinBlueAndGreen, yCenterDesignView+5*measure)];
            [self.colorBlackButton setFrame:rctForMark];
            [self.colorBlackButton setCenter:CGPointMake(centerDesignLine + rctForDesignView.size.width/2 - rctForButtonView.size.width/3.5,
                                                         yCenterDesignView+5*measure)];
            
            
            [self.photoPartView setFrame:CGRectMake(0,origHeight+5*onePart, self.cView.bounds.size.width, onePart)];
            [self.photoPartView setFrame:rctForDesignView];
            [self.photoPartView setCenter:CGPointMake(centerDesignLine, yCenterDesignView + 6*measure)];
            self.photoPartView.layer.cornerRadius = rctForDesignView.size.height/6;
            self.photoPartView.layer.masksToBounds = YES;
            
            [self.photo setFrame:self.photoPartView.bounds];
            [self.photButton setFrame:rctForMark];
            [self.photButton setCenter:CGPointMake(rctForButtonView.size.width/3.5, rctForDesignView.size.height/2)];
            
            [self.photoButtonView setFrame:rctForButtonView];
            [self.photoButtonView setCenter:CGPointMake(self.photoPartView.bounds.size.width/2,self.photoPartView.bounds.size.height/2) ];
            
            
            [self.addNewPhotoButton setFrame:rctForMark];
            [self.addNewPhotoButton setCenter:CGPointMake(centerDesignLine + rctForDesignView.size.width/2 - rctForButtonView.size.width/3.5,
                                                          yCenterDesignView+6*measure)];
            
            
        } else {
            
            [self.buyAdditionsButton setBounds:buttonsBounds];
            [self.buyAdditionsButton setCenter:CGPointMake(centeSettingsLine,yCenter+ 6*measure)];
            
            [self.processSpinner setCenter:CGPointMake(centeSettingsLine,yCenter+ 6*measure)];
        }
        
        //line five
        [self.calcButton setBounds:rectForView];
        [self.calcButton setCenter:CGPointMake(x +INDENT+viewSide/2, y+mainHeight-INDENT-viewSide/2)];
        
        
    } else { //if iPhone
        
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
    [self.smalButtonLook setFrame:self.smallButtonView.bounds];
    
    self.bigbuttonView.backgroundColor = [UIColor clearColor];
    CGRect bigLook = self.bigbuttonView.bounds;
    bigLook.size.width =-4;
    bigLook.size.height =-4;
    [self.bigButtonLook setFrame:self.bigbuttonView.bounds];
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


-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:SettingReciveChangedNotification object:nil];
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


-(void)appWillGoToBackground:(NSNotification *)note{
    if([[self presentedViewController] isKindOfClass:[DesignViewController class]]){
        
    } else {
        [self dismis];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"setting view disapear");
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
