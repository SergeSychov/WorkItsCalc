//
//  ITSCalcViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 15.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//
@import UIKit;
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <CoreText/CTStringAttributes.h>
#import <MessageUI/MessageUI.h>

#import "ITSCalcViewController.h"

#import "ButtonsCollectionView.h"
#import "NewButtonsCollectionViewCell.h"
#import "HistroryTableViewCell.h"

#import "ACalcBrain.h"

#import "DisplayLabel.h"
#import "DisplayRam.h"
#import "History.h"
#import "History+Maker.h"
#import "Buttons.h"
#import "Buttons+Buttons_Maker.h"
#import "ButtonObject.h"
#import "HistoryTableSviper.h"
#import "HistoryTableView.h"

#import "HintView.h"

#import "recBut.h"
#import "SettingButton.h"

//dellete
#import "CloudView.h"
//dellete
#import "SoundView.h"
//dellete
#import "ArchiveSizeView.h"
//dellete
#import "ShareButton.h"
#import "NoticeButton.h"
#import "DelButton.h"
#import "DownButton.h"

#import "AppearedController.h"
#import "Transition.h"
#import "BackTransition.h"
//here its only test
//#import "SecondViewController.h"
#import "SettingsViewController.h"
#import "ShowedViewController.h"
//#import "ThirdController.h"

#import "AboutViewController.h"
#import "SettingViewController.h"
#import "ClearHistoryButton.h"
#import "DesignButton.h"


#define ANGLE_OFFSET (M_PI_4 * 0.1f)
#define X_OFFSET 2.0f
#define Y_OFFSET 2.0f
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define TIMES_TO_LIMIT_IAD_BANNER 3
//important
#define TIME_INTERVAL_FROM_LAST_ALERT 40.//86400.//for one day 43200. //need to be setted as 12 hours - 43 000;

//important
//think it isn't need
#define FREE_TRIAL_PERIOD 2592000. // for thirtee days trial period
#define DAYS_ALOWED_TRIAL_PERIOD 30. //not shure tha its needed

//important delete
#define kInAppPurchaseProductID @"ItsCalc.changekeyboard"
#define IS_BLACK_MODE NO
#define INDENT 20.0f


NSString *const MainControllerSendPayPossibilityNotification = @"MainControllerSendPayPossibilityNotification";
NSString *const MainControllerNotAvailableForBuingNotification = @"MainControllerNotAvailableForBuingNotification";
#pragma mark CHANGES FROM OTHER CONTROLLERS
NSString *const ReciveChangedNotification=@"SendChangedNotification";

@interface ITSCalcViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIApplicationDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, HistoryTableViewCellDelegate, UICollectionViewDelegateFlowLayout,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, DisplayRamDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, AppearedViewControllerProtocol, UIViewControllerTransitioningDelegate>


//outlets
//
//Main container view
#pragma mark TRANSITOPN PROPERTIES
@property (weak,nonatomic) Transition* transition;
@property (weak,nonatomic) SettingsViewController* settingsController;
@property (weak,nonatomic) ShowedViewController* showedController;
@property (nonatomic,strong) NSAttributedString *strAtrrForShow;
@property (nonatomic,strong) NSAttributedString *resStringForShow;
@property (nonatomic) BOOL callShowController;
@property (nonatomic) BOOL showControllerIsForward;



@property (weak, nonatomic) HintView *hintView;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (nonatomic) int wasRightShowed; //need for show Shoving view at rotation 0 - not on screen, 1- was in left rotation, 2 - was in right rotation
//important not shure its need
@property (nonatomic) UIDeviceOrientation wasRotatedNotificationAnotherController;
@property (nonatomic) BOOL willBePortraitRotated;
//necessary height of element for 3,5" screen
@property (nonatomic) CGFloat histroryTableViewHeight;
@property (nonatomic) CGFloat labelViewHeight;
@property (nonatomic) CGFloat lastRowHistoryTableHeight;

//Buttons collection
@property (weak, nonatomic) IBOutlet ButtonsCollectionView *buttonsCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
//recognizers
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *moveButtonsPanGestureRecognizer; //pan gesture recognizer

//Display view
@property (weak, nonatomic) IBOutlet UIView *displayContainer;
@property (weak, nonatomic) IBOutlet  DisplayLabel *display; //calc display
@property (nonatomic, strong) DisplayRam *displayRam; //outbut dta from dislplay /input to display
@property (weak, nonatomic) IBOutlet UIToolbar *backgroundToolBar; //background for display
//fix button to fix changes and settibgs
@property (weak, nonatomic) IBOutlet ShareButton *noticeButton;
@property (weak, nonatomic) IBOutlet NoticeButton *noticeRealButton;
@property (weak, nonatomic) IBOutlet recBut *recountButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet DelButton *deleteButton;
@property (weak,nonatomic) IBOutlet SettingButton *settingsButton;
@property (weak,nonatomic) IBOutlet DownButton *downButton;
@property (weak, nonatomic) IBOutlet SettingButton *settingsBottomButtn;

//History table view
@property (weak, nonatomic) IBOutlet HistoryTableView *historyTable;
@property (nonatomic) CGFloat isHistoryWholeShowed;
//property to show is one row from history table is selected
@property (weak,nonatomic) HistroryTableViewCell *selectedRow;
//attributes for historyTable
@property (nonatomic,strong) NSDictionary * attributes;

//items for dynamic draging

@property (weak, nonatomic) IBOutlet UIView *dynamicContainer;
@property (nonatomic) CGFloat wasDynamicOriginY;
@property (weak, nonatomic) IBOutlet HistoryTableSviper *historyTableSviper;
@property (nonatomic) CGPoint svipeGestureLocation;


//bool property for paid version
//important delete
@property (nonatomic, strong) SKProduct *product;

@property (nonatomic) BOOL wasPurshaised;

//important for trial period
//set in icloud user default by the big chenges verion or start. first value Yes
@property (nonatomic) BOOL isTrialPeriod;
//set in icloud user default by the big chenges verion or start
@property (nonatomic, strong) NSDate *startTrialDate;
//set in icloud user default, by the big chenges version or start, first value is 20 days,
@property (nonatomic) NSInteger nexNeedShovewTrialViewDay;// ask user 1, 5, 10, 20 to the end of trial period to buy whole version
//iAd banner
@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;

@property (nonatomic) BOOL isIAdBaneerAvailable;
@property (nonatomic) NSInteger bannerRequestCounter;// need to limitation of IAd banner request at pressing "equal"
@property (nonatomic) BOOL isIAdBannerOnScreen; //to find out if the banner on the screen
//set the origin Heigth according last row historyTable height
//@property (nonatomic) NSInteger iAdBannerOriginHeight;
//how many times were request to hide iAd banner
//@property (nonatomic) NSInteger timesRequestToHideIAdBanner;

//Settings View
@property (weak, nonatomic) IBOutlet UIView *SettingsView;
@property (weak, nonatomic) IBOutlet UIToolbar *settingsBackgroundToolBar;
@property (nonatomic) BOOL isSettingsViewOnScreen; //need to set in viewDidLoad
@property (nonatomic) BOOL isBottomSettingsViewOnScreen;//

@property (weak, nonatomic) IBOutlet UILabel *buttonSwitcherLabel;
@property (weak, nonatomic) IBOutlet UIView *smallButtonView;
@property (weak, nonatomic) IBOutlet UIView *bigbuttonView;
@property (weak, nonatomic) IBOutlet UISwitch *isBigSizeSwitcher;
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons


@property (weak, nonatomic) IBOutlet UILabel *soundSwitcherLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitcher;

@property (weak, nonatomic) IBOutlet SoundView *soundOff;
@property (weak, nonatomic) IBOutlet SoundView *soundOn;

@property (nonatomic) BOOL isSoundOn;


@property (weak, nonatomic) IBOutlet UILabel *archiveSwitcherLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isBigDataBaseSwitcher;
//@property (weak, nonatomic) IBOutlet UIImageView *smallDataBaseView;
@property (weak, nonatomic) IBOutlet ArchiveSizeView *archsizeViewSmall;
//@property (weak, nonatomic) IBOutlet UIImageView *bigDataBaseView;
@property (weak, nonatomic) IBOutlet ArchiveSizeView *archivesizeBigView;
@property (nonatomic) BOOL isBigDataBase; //size dataBase
@property (nonatomic) int limitInDataBase;


@property (weak, nonatomic) IBOutlet CloudView *cloudOnView;
@property (weak, nonatomic) IBOutlet CloudView *cloudOffView;
@property (weak, nonatomic) IBOutlet UILabel *iCloudSwitcherName;
@property (weak, nonatomic) IBOutlet UISwitch *isiCloudUseSwitcher;
@property (nonatomic) BOOL isiCloudInUse;
@property (nonatomic) BOOL fristLunchWithicloudAvailable;
//need to set iClouds images whole & empty


@property (weak, nonatomic) IBOutlet DesignButton *changeDesignButton;
@property (weak, nonatomic) IBOutlet ClearHistoryButton *clearHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *keyboardDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *buyAdditionsButton;
//add spin activity to show process of purchaising
@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;




//Showed View
@property (nonatomic, strong) UIDynamicAnimator *animator;

//Document
//@property (nonatomic, retain) UIDocumentInteractionController *docController;
@property (nonatomic, strong) UIManagedDocument *doc;

//Fetch controller
// Causes the fetchedResultsController to refetch the data.
// You almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
@property (nonatomic,strong) NSArray* lastRowDataArray;

//for set values of row hight in historyTableView
@property (nonatomic,strong) NSArray *heightsOfRows;
//need for manage at controller changes
//for adding new heights value at didChangeController
@property (nonatomic,strong) NSDictionary *heigthsOfNewRowsAccordingNewObjs;
//set for delleting indexis at didChangeController
@property (nonatomic,strong) NSIndexSet *deletedIndexesSet;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *buttonManagedObjectContext;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSURL * storeURL;
@property (nonatomic, strong) NSURL *localStoreUrl;
@property (nonatomic, strong) NSURL* iCloudURL;
//set managed obj context specially for buttons

//Buttons arrays
@property (nonatomic,strong) NSDictionary *mainButtonsStartWithPosition;
@property (nonatomic, weak) NSArray *startArray;
@property (nonatomic,weak) NSArray *mainButtonsStartArray;

@property (nonatomic,strong) NSArray* workButtonsNames; //nsStringNames

@property (nonatomic, strong) NSArray *changebleButtonObjs;
@property (nonatomic, strong) NSArray *delettedButtonObjs;
@property (nonatomic, strong) NSArray *mainButtonObjs;
@property (nonatomic,strong) NSArray *allButtonObj;//with obj



//Models
@property (nonatomic, strong) ACalcBrain *brain; //main brain


//necessary conditions for counting
@property (nonatomic) BOOL userIsInTheMidleOfEnteringNumber;
@property (nonatomic) BOOL isProgramInProcess;// for not clear stack at the entering new number: 2 + newNumber instead on 2 + 2 =, newNumber
@property (nonatomic) BOOL isStronglyArgu; //the argument is strongly setted by user
@property (nonatomic) BOOL isDecCounting;
@property (nonatomic) BOOL isResultFromMemory; //is result on screen is taked up from memory

//make int property only for test NSTimer
@property (nonatomic,strong) NSIndexPath * patch;
@property (nonatomic, strong) NSTimer *animationTimer;//for delet and set buttonsView animation
@property (nonatomic, strong) NSTimer *secondTimer; //for move button at pan gesture
@property (nonatomic,strong) NSMutableArray *buttonsToMoveArray;
@property (nonatomic) NSInteger itemOfNeedPosition;

//make this property to move button
@property (nonatomic,strong) newButtonView * buttonsAsSubView;
@property (nonatomic, strong) NewButtonsCollectionViewCell * subCell;
@property (nonatomic, strong) NewButtonsCollectionViewCell * findCell;
@property (nonatomic) BOOL isThreadInWork; //to check pan gesture thread
@property (nonatomic) BOOL wasInMoveOffsetSection; //to does not repeat moving offset
@property (nonatomic) BOOL isButtonsCollectionUnderChanging;
@property (nonatomic) BOOL isAllowedToDelete; // allow to delete buttons accroding amount of buttons in collection
@property (nonatomic) NSInteger counterForShowingAllertView; //set the counter of allert view Show allert every 100 counts, start at 50, at the YES - set counter -1
@property (nonatomic) NSString *currentProgrammVersion;

//sounds

@property (nonatomic, strong) NSURL *tapSoundFileURLRef;
@property (nonatomic) SystemSoundID   tapsoundFileObject;

@property (nonatomic) NSURL *errorSoundFileURLRef;
@property (nonatomic) SystemSoundID   errorSoundFileObject;

@property (nonatomic) NSURL *blankSoundFileURLRef;
@property (nonatomic) SystemSoundID   blankSoundFileObject;

@property (nonatomic) NSURL *shutterSoundFileURLRef;
@property (nonatomic) SystemSoundID   shutterSoundFileObject;

//hint vew

@property (nonatomic, strong) NSDate *lastShowAllertViewDate;

// Set to YES to get some debugging output in the console.
@property BOOL debug;
@end

@implementation ITSCalcViewController

//set this property to allow tap botton buttons in buttonsCollectionView
-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark LASY INITIALIZATION

-(ACalcBrain *) brain //main model
{
    if(!_brain){
        
        if(! _brain) _brain = [[ACalcBrain alloc] init];
    }
    
    return  _brain;
}

-(DisplayRam*) displayRam
{
    if(!_displayRam){
        _displayRam = [[DisplayRam alloc] init];
        _displayRam.delegate = self;
    }
    
    return _displayRam;
}
#pragma mark SET VARIABLES
-(void) setCallShowController:(BOOL)callShowController
{
    _callShowController = callShowController;
    if(_callShowController){
        [self showShowedView];
    }
}



#pragma mark TEXT ATTRIBUTES
//attributes for history table
-(NSDictionary*) attributes
{
    if(!_attributes){

        UIColor *textColor;
        if(IS_BLACK_MODE){
            textColor = [UIColor darkGrayColor]; //color of text
        } else {
            textColor = [UIColor grayColor]; //color of text
        }
        
        //change font size
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentRight;
        //style.
        
        
        //Change fontName to Helvetica Neue Light
        NSString *fontName = nil;
        NSArray *famalyNames  =[UIFont familyNames];
        if([famalyNames containsObject:@"Helvetica Neue"]){
            NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
            if([fontNames containsObject:@"HelveticaNeue-Light"]){
                fontName = @"HelveticaNeue-Light";
            }
        }
        CGFloat fontSize;// = 17.0;
        
        
        if(IS_IPAD){
            fontSize = 26.0;
            style.alignment = NSTextAlignmentRight;
        } else {
            fontSize = 17.0;
            style.alignment = NSTextAlignmentLeft;
        }
        UIFont *system = [UIFont systemFontOfSize:fontSize];
        UIFont *font; //if there is no needed font
        if(fontName){
            font = [UIFont fontWithName:system.fontName size:fontSize];
        }else {
            font =[UIFont boldSystemFontOfSize:fontSize];
        }

        _attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    }
    return _attributes;
}

-(NSDictionary*) heigthsOfNewRowsAccordingNewObjs
{
    if(!_heigthsOfNewRowsAccordingNewObjs){
        _heigthsOfNewRowsAccordingNewObjs = [[NSDictionary alloc] init];
    }
    return _heigthsOfNewRowsAccordingNewObjs;
}

-(NSIndexSet*) deletedIndexesSet
{
    if(!_deletedIndexesSet){
        _deletedIndexesSet = [[NSIndexSet alloc] init];
    }
    return _deletedIndexesSet;
}

#pragma mark COUNTING METHODS AND PROPERTIES
-(void) setIsDecCounting:(BOOL)isDecCounting
{
    _isDecCounting = isDecCounting;
    if(isDecCounting){
        [self.display.decRadLabel setText:@" DEG"];
    } else {
        [self.display.decRadLabel setText:@" RAD"];
    }
}

-(void) setIsStronglyArgu:(BOOL)isStronglyArgu
{
    _isStronglyArgu = isStronglyArgu;
    self.brain.isStronglyArgu = isStronglyArgu;
}

-(void) setIsResultFromMemory:(BOOL)isResultFromMemory
{
    _isResultFromMemory = isResultFromMemory;
    if(isResultFromMemory) {
        self.isStronglyArgu = YES;
        self.userIsInTheMidleOfEnteringNumber = NO;
    }
}

-(void) setUserIsInTheMidleOfEnteringNumber:(BOOL)userIsInTheMidleOfEnteringNumber
{
    _userIsInTheMidleOfEnteringNumber = userIsInTheMidleOfEnteringNumber;
    if(userIsInTheMidleOfEnteringNumber) self.isResultFromMemory = NO;
}


/*
 @"CHOOSE_STORAGE"
 message: @"SHOUD_STORAGE_BE_IN_ICLOUD"
 delegate:self
 cancelButtonTitle:@"LOCAL_ONLY"
 otherButtonTitles:@"USE_ICLOUD"
*/

#pragma mark NEW NAMES FOR TABlE VIEW
#define CHOOSE_STORAGE NSLocalizedStringFromTable(@"CHOOSE_STORAGE",@"ACalcTryViewControllerTableTwo", @"CHOOSE_STORAGE")
#define SHOUD_STORAGE_BE_IN_ICLOUD NSLocalizedStringFromTable(@"SHOUD_STORAGE_BE_IN_ICLOUD",@"ACalcTryViewControllerTableTwo", @"SHOUD_STORAGE_BE_IN_ICLOUD")
#define LOCAL_ONLY NSLocalizedStringFromTable(@"LOCAL_ONLY",@"ACalcTryViewControllerTableTwo", @"LOCAL_ONLY")
#define USE_ICLOUD NSLocalizedStringFromTable(@"USE_ICLOUD",@"ACalcTryViewControllerTableTwo", @"USE_ICLOUD")

#define NAME_BUTTON_SWITCH NSLocalizedStringFromTable(@"Buttons size",@"ACalcTryViewControllerTableTwo", @"Button size")
#define NAME_SOUND_SWITCH NSLocalizedStringFromTable(@"Sound",@"ACalcTryViewControllerTableTwo", @"Sound")
#define NAME_ARCHIVE_SWITCH NSLocalizedStringFromTable(@"History archive size",@"ACalcTryViewControllerTableTwo", @"Archive size")
#define NAME_ICLOUD_SWITCH NSLocalizedStringFromTable(@"iCloud",@"ACalcTryViewControllerTableTwo", @"iCloud")


#pragma mark SETTINGS VIEW

#define BUY_REQUEST_BUTTON NSLocalizedStringFromTable(@"BUY_REQUEST_BUTTON",@"ACalcTryViewControllerTable", @"buy button title")

#define TITLE_RESET_BUTTON NSLocalizedStringFromTable(@"TITLE_RESET_BUTTON",@"ACalcTryViewControllerTable", @"reset button title")
#define ALERT_MESAGE_RESET_BUTTONS NSLocalizedStringFromTable(@"ALERT_MESAGE_RESET_BUTTONS",@"ACalcTryViewControllerTable", @"reset button alert mesage")
#define ALERT_CANCEL_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_CANCEL_BUTTON_TITLE",@"ACalcTryViewControllerTable", @"alert cancel buton title")
#define ALERT_RESTORE_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_RESTORE_BUTTON_TITLE ",@"ACalcTryViewControllerTable", @"restore buton title")

#define TITLE_CLEAR_HISTORY_BUTTON NSLocalizedStringFromTable(@"TITLE_CLEAR_HISTORY_BUTTON",@"ACalcTryViewControllerTable", @"Clear history button title")


#define ALERT_MESSAGE_CLEAR_HOSTORY NSLocalizedStringFromTable(@"ALERT_MESSAGE_CLEAR_HOSTORY",@"ACalcTryViewControllerTable", @"delete history. all results will be lost")
#define ALERT_CLEAR_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_CLEAR_BUTTON_TITLE",@"ACalcTryViewControllerTable", @"clear")

#define ALERT_TITLE_ASSES NSLocalizedStringFromTable(@"ALLERT_TITLE_ASSES",@"ACalcTryViewControllerTable", @"YOUR OPINION IS IMPORTANT TO ME")
#define ALERT_MESSAGE_ASSES NSLocalizedStringFromTable(@"ALLERT_MESSAGE_ASSES",@"ACalcTryViewControllerTable", @"...should I stay or should I go?")
#define ALERT_ASSES_NO_BUTTON NSLocalizedStringFromTable(@"ALLERT_ASSES_NO_BUTTON",@"ACalcTryViewControllerTable", @"No, thanks")
#define ALERT_ASSES_ASSES_APLICATION_BUTTON NSLocalizedStringFromTable(@"ALERT_ASSES_ASSES_APLICATION_BUTTON",@"ACalcTryViewControllerTable", @"Аssess the application")
#define ALERT_ASSES_REMIND_LATER_BUTTON NSLocalizedStringFromTable(@"ALERT_ASSES_REMIND_LATER_BUTTON",@"ACalcTryViewControllerTable", @"Remind later")

#define ALLERT_TITLE_CHANGE_KEYBOARD NSLocalizedStringFromTable(@"ALLERT_TITLE_CHANGE_KEYBOARD",@"ACalcTryViewControllerTableAdditional", @"Change keyboard")
#define ALLERT_BUTTON_BUY NSLocalizedStringFromTable(@"ALLERT_BUTTON_BUY",@"ACalcTryViewControllerTableAdditional", @"Buy")
#define ALLERT_BUTTON_RESTORE NSLocalizedStringFromTable(@"ALLERT_BUTTON_RESTORE",@"ACalcTryViewControllerTableAdditional", @"Restore purshace")

//--important delete
- (IBAction)buyAdditionsButtonTapped:(UIButton *)sender
{
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:ALLERT_TITLE_CHANGE_KEYBOARD//@"Change keyboard"//TITLE_RESET_BUTTON
                                       message:@""
                                      delegate:self
                             cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                             otherButtonTitles: ALLERT_BUTTON_BUY,ALLERT_BUTTON_RESTORE, nil]; //@"Restore"
    
    [alert show];

}

- (IBAction)defaultKeyboardbuttonTapped:(id)sender
{
    //if(self.wasPurshaised /*|| self.isTrialPeriod*/){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:TITLE_RESET_BUTTON
                                           message:ALERT_MESAGE_RESET_BUTTONS//@"restore initial buttons settings"
                                          delegate:self
                                 cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                 otherButtonTitles:ALERT_RESTORE_BUTTON_TITLE, nil]; //@"Restore"
        
    [alert show];
   // }

}

- (IBAction)clearHistoryButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TITLE_CLEAR_HISTORY_BUTTON
                                                    message:ALERT_MESSAGE_CLEAR_HOSTORY//@"delete history. all results will be lost"
                                                   delegate:self
                                          cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                          otherButtonTitles:ALERT_CLEAR_BUTTON_TITLE, nil]; //@"Clear"
    [alert show];
}

//not settings view but allert to ask woth API
-(void) setCounterForShowingAllertView:(NSInteger)counterForShowingAllertView
{
    _counterForShowingAllertView = counterForShowingAllertView;
    NSTimeInterval intervalFromLastShowAllert = [self.lastShowAllertViewDate timeIntervalSinceNow];
    if((intervalFromLastShowAllert < (TIME_INTERVAL_FROM_LAST_ALERT * -1)) && (_counterForShowingAllertView > 30)){ //need 50
        //Important
        if((_counterForShowingAllertView) % 2 == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_ASSES//@"YOUR OPINION IS IMPORTANT TO ME"
                                                            message:ALERT_MESSAGE_ASSES//@"...should I stay or should I go?"
                                                           delegate:self
                                                  cancelButtonTitle:ALERT_ASSES_REMIND_LATER_BUTTON//ALERT_ASSES_NO_BUTTON //@"No, thanks"
                                                  otherButtonTitles: ALERT_ASSES_ASSES_APLICATION_BUTTON, nil];//, ALERT_ASSES_NO_BUTTON,nil]; //@"Аssess the application", @"Remind later"
            [alert show];
            self.lastShowAllertViewDate = [NSDate date];
        }
    }
}

-(void) showHintViewAccordingCounter
{
    switch (self.counterForShowingAllertView) {
        case 30:{
            HintView *hintView =
            [HintView newHintViewWithFrame:self.dynamicContainer.frame
                                 labelRect:self.displayContainer.frame
                                      type:self.counterForShowingAllertView];
            hintView.alpha = 0;
            [self.mainContainerView addSubview:hintView];
            self.hintView = hintView;
            [UIView animateWithDuration:0.4
                                  delay:0.4
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.hintView.alpha = 0.85;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
            break;
        case 33 : {
            if(!IS_IPAD){
                CGRect collectionVisibleRect = self.buttonsCollection.frame;
                collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
                collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
                HintView *hintView =
                [HintView newHintViewWithFrame:self.dynamicContainer.frame
                                     labelRect:collectionVisibleRect
                                          type:self.counterForShowingAllertView];
                hintView.alpha = 0;
                [self.mainContainerView addSubview:hintView];
                self.hintView = hintView;
                [UIView animateWithDuration:0.4
                                      delay:0.4
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.hintView.alpha = 0.85;
                                 } completion:^(BOOL finished) {
                                     
                                 }];
            }
        }
            break;
        case 36 :{
            
            CGRect collectionVisibleRect = self.buttonsCollection.frame;
            collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
            collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
            HintView *hintView =
            [HintView newHintViewWithFrame:self.dynamicContainer.frame
                                 labelRect:collectionVisibleRect
                                      type:self.counterForShowingAllertView];
            hintView.alpha = 0;
            [self.mainContainerView addSubview:hintView];
            self.hintView = hintView;
            [UIView animateWithDuration:0.4
                                  delay:0.4
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.hintView.alpha = 0.85;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
            break;
        default:
            break;
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:ALERT_RESTORE_BUTTON_TITLE]){
        [Buttons clearContext:self.buttonManagedObjectContext];
        
        [self setUpArrays];
        [self.doc updateChangeCount:UIDocumentChangeDone];
        
        [self.buttonsCollection reloadData];
        
    } else if ([title isEqualToString:ALERT_CLEAR_BUTTON_TITLE]){
        
        [History clearContext:self.managedObjectContext];
        NSArray *newHeightsOfRows = [[NSArray alloc] init];
        self.heightsOfRows = newHeightsOfRows;
        [self performFetch];
        
    } else if ([title isEqualToString:ALERT_ASSES_ASSES_APLICATION_BUTTON]){
        //NSString *iTunesLink = @"itms-apps://itunes.apple.com/us/app/its-calc/id873164530?l=ru&ls=1&mt=8";
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=873164530&type=Purple+Software";//&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALERT_ASSES_NO_BUTTON]){
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALLERT_BUTTON_RESTORE]){
        [self restorePurchase];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_BUY]){
        [self buyUnlockKeyboard];
        
    } else if ([title isEqualToString:USE_ICLOUD]){
        self.isiCloudInUse = YES;
    }
    
}

- (IBAction)switchIsBigDataBase:(UISwitch *)sender
{
    self.isBigDataBase = sender.on;
}

-(void) setIsBigDataBase:(BOOL)isBigDataBase
{
    _isBigDataBase = isBigDataBase;
    if(_isBigDataBase != self.isBigDataBaseSwitcher.on){
        self.isBigDataBaseSwitcher.on = _isBigDataBase;
    }
}

-(int) limitInDataBase{
    return self.isBigDataBase ? 200 : 500;
}

- (IBAction)isBigSizeButtonSwitch:(UISwitch *)sender
{
    if(sender.isOn){
        self.isBigSizeButtons = YES;
    } else {
        self.isBigSizeButtons = NO;
    }
}

-(void) setIsBigSizeButtons:(BOOL)isBigSizeButtons
{
    _isBigSizeButtons = isBigSizeButtons;
    //reset buttons size only when core data available
    //as exemple don't set in view didload
    if(self.buttonManagedObjectContext){
        [self setUpMainButtonsStartWithPosition];
        [self makeTwoArrays];
        [self.buttonsCollection reloadData];
    }
    

    if(_isBigSizeButtons != self.isBigSizeSwitcher.on){
        [self.isBigSizeSwitcher setOn:_isBigSizeButtons];
    }
    
}

- (IBAction)isSoundSwitch:(UISwitch *)sender
{
    if(sender.isOn){
        self.isSoundOn = YES;
    } else {
        self.isSoundOn = NO;
    }
}

-(void) setIsSoundOn:(BOOL)isSoundOn
{
    _isSoundOn = isSoundOn;
    if(_isSoundOn != self.soundSwitcher.on){
        [self.soundSwitcher setOn:_isSoundOn];
    }
}


//delegate method to allow read gestures (PAN AND SCROLL) toogether
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark BUTTONS ARRAYS
-(NSArray*) startArray
{
    NSArray* startArray = [[NSArray alloc] initWithObjects:
                           @"(",@")",@"rad",
                           @"¹/x",
                           @"%",
                           @"M+",
                           @"M-",
                           @"Mr",@"Mc",@"° ′″",@".00",
                           @"e",@"π",@"x²",@"x³",@"xʸ",
                           @"yˣ",@"2ˣ",@"10ˣ",@"eˣ",@"x!",
                           @"√x",@"³√x",@"ʸ√x",@"ˣ√y",@"√x²+y²",
                           @"lg",@"log₂",@"logʸ",@"ln",
                           @"sin",@"cos",@"tg",@"ctg",
                           @"asin",@"acos",@"atg",@"actg",
                           @"sinh",@"cosh",@"tgh",@"ctgh",
                           //@"X",@"A",@"Tab",@"Grph",@"+f(x)",
                           @"MIc",@"MIr",@"MI+",@"MI-",
                           nil];
    return startArray;
}


-(NSArray*) mainButtonsStartArray
{
    NSArray* mainArray = [[NSArray alloc] initWithObjects:@"∓",@"C",
                          @"7",@"8",@"9",@"÷",
                          @"4",@"5",@"6",@"×",
                          @"1",@"2",@"3",@"-",
                          @"0",@".",@"⌫",@"+",
                          @"=",
                          nil];
    return mainArray;
}

-(NSArray*) mainButtonsPositions
{
    NSInteger columsNumber = [self numberColumsInCollectionView];
    NSMutableArray* mutArray = [[NSMutableArray alloc] init];
    
    [mutArray addObject:[NSNumber numberWithInteger:(columsNumber - 1 - 1)]];//@"∓"
    [mutArray addObject:[NSNumber numberWithInteger:(columsNumber - 1)]];//@"C"
    
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 3)]];//@"7"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 2)]];//@"8"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 1)]];//@"9"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1)]];//@"÷"
    
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 3)]];//@"4"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 2)]];//@"5"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 1)]];//@"6"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1)]];//@"×"
    
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 3)]];//@"1"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 2)]];//@"2"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 1)]];//@"3"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1)]];//@"-"
    
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 3)]];//@"0"
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 2)]];//@"."
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 1)]];//@"⌫"
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1)]];//@"+"
    
    [mutArray addObject:[NSNumber numberWithInteger:(6*columsNumber - 1)]];//@"="

    return [mutArray copy];
}

-(void) setUpMainButtonsStartWithPosition
{
    NSArray *names = [[NSArray alloc] initWithObjects: @"∓",@"C",
                      @"7",@"8",@"9",@"÷",
                      @"4",@"5",@"6",@"×",
                      @"1",@"2",@"3",@"-",
                      @"0",@".",@"⌫",@"+",
                      @"=",
                      nil];
    _mainButtonsStartWithPosition = [[NSDictionary alloc] initWithObjects:[self mainButtonsPositions]forKeys:names];

}


//set start arrays work and main
-(NSDictionary*) mainButtonsStartWithPosition
{
    if(!_mainButtonsStartWithPosition){
        [self setUpMainButtonsStartWithPosition];
    }
    return _mainButtonsStartWithPosition;
}

-(void) setAllButtonObj:(NSArray *)allButtonObj
{
    _allButtonObj = allButtonObj;
    //[self resaveCoreButtons];
}

-(void) resaveCoreButtons
{
    NSManagedObjectContext *context = self.buttonManagedObjectContext;

        [Buttons reSaveKeyboardWithArray:self.allButtonObj inManageObjectContext:context];
       // NSError *error;
       // [context save:&error];

}

-(void) setUpArrays
{
    NSManagedObjectContext *context = self.buttonManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    
    NSError *error;
    NSArray *buttonsFromCoreData = [context executeFetchRequest:request error:&error];
    if(buttonsFromCoreData.count < 65){
        
        NSMutableArray *buttonsObjs = [[NSMutableArray alloc] init]; //array from obj not from core data
        for(NSInteger i = 0; i < self.startArray.count; i++){
            NSString *name = self.startArray[i];
            ButtonObject *btnObj = [[ButtonObject alloc] init];
            
            btnObj.enable = YES;
            btnObj.isMain = NO;
            btnObj.alowedTodelete = YES;
            btnObj.nameButton = name;
            btnObj.position = i;
            btnObj.dateOfDeletting = [NSDate distantFuture];
            
            [buttonsObjs addObject:btnObj];
            
        }
        self.changebleButtonObjs = [buttonsObjs copy];
        //clear deletted button objs
        //---
        self.delettedButtonObjs = [[NSArray alloc] init];
        //---
        //
        NSMutableArray *mainButtonObjs = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0; i < self.mainButtonsStartArray.count; i++){
            NSString *name = self.mainButtonsStartArray[i];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:name] integerValue];
            ButtonObject *btnObj = [[ButtonObject alloc] init];
            
            btnObj.nameButton =  name;
            btnObj.enable = YES;
            btnObj.isMain = YES;
            btnObj.alowedTodelete = NO;
            btnObj.position = index;
            btnObj.dateOfDeletting = [NSDate distantFuture];
            
            [mainButtonObjs addObject:btnObj];
        }

        self.mainButtonObjs = [mainButtonObjs copy];
        
        [self makeTwoArrays];
    }
    else {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
        //NSError *error;
        NSMutableArray *allButtons = [[NSMutableArray alloc] init];
        NSArray *buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = [button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [allButtons addObject:butObj];
        }
        self.changebleButtonObjs = [allButtons copy];
        
        
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@", [NSNumber numberWithBool:YES]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];

        NSMutableArray *mainButtons = [[NSMutableArray alloc] init];
        buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        //NSLog(@"Fetched Main objs %@", buttonsFromCoreData);
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:button.nameButton] integerValue];
            
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = index;//[button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [mainButtons addObject:butObj];
        }
        self.mainButtonObjs = [mainButtons copy];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateOfDeletting" ascending:NO]];
        //NSError *error;
        NSMutableArray *delettedButtonObjs = [[NSMutableArray alloc] init];
        buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = [button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [delettedButtonObjs addObject:butObj];
        }
        self.delettedButtonObjs = [delettedButtonObjs copy];
        
        [self makeTwoArrays];
    }
    //if main array from core dont equal main buttons obj from brog/ reload core
}

-(NSArray*) changebleButtonObjs
{
    if(!_changebleButtonObjs){
        _changebleButtonObjs = [[NSArray alloc] init];
        [self setUpArrays];
    }
    return _changebleButtonObjs;
}

-(NSArray*) delettedButtonObjs
{
    if(!_delettedButtonObjs){
        _delettedButtonObjs = [[NSArray alloc] init];
    }
    return _delettedButtonObjs;
}

-(NSArray*) mainButtonObjs
{
    if(!_mainButtonObjs){
        _mainButtonObjs = [[NSArray alloc] init];
        [self setUpArrays];
    }

    return _mainButtonObjs;
}

-(void) makeAllButtonObjsArray
{
    self.buttonsCollection.scrollEnabled = NO;
    NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
    
    //make initial array from enable changeble button objects
    for (int i = 0; i < self.changebleButtonObjs.count; i++){
        [allButtonsArray addObject:self.changebleButtonObjs[i]];
    }
    //insert main button objects att position according mainButtonWithStartPosition dictionary
    for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
        ButtonObject *buttonObj = self.mainButtonObjs[i];
        NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
        buttonObj.position = index;
        [allButtonsArray insertObject:self.mainButtonObjs[i] atIndex:index];
    }
    //add deleted buttons
    for (int i = 0; i < self.delettedButtonObjs.count; i++){
        [allButtonsArray addObject:self.delettedButtonObjs[i]];
    }
    
    self.allButtonObj = [allButtonsArray copy];
    self.buttonsCollection.scrollEnabled = YES;
}

-(void) makeWorkButoonNamesArray
{
    self.buttonsCollection.scrollEnabled = NO;
    
    NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
    
    //set up initial array from changeble buttons arrays names
    for(int i = 0; i < self.changebleButtonObjs.count; i++){
        ButtonObject *buttonObj = self.changebleButtonObjs[i];
        [workButtonNames addObject:buttonObj.nameButton];
    }
    //insert mainButtons as names
    for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
        ButtonObject *buttonObj = self.mainButtonObjs[i];
        NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
        
        [workButtonNames insertObject:buttonObj.nameButton atIndex:index];
    }
    
    self.workButtonsNames = [workButtonNames copy];
    
    self.buttonsCollection.scrollEnabled = YES;
}

//make workbuttons array and names array together
-(void) makeTwoArrays
{
    self.buttonsCollection.scrollEnabled = NO;
    NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
    NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
    
    //make initial array from enable changeble button objects
    for (int i = 0; i < self.changebleButtonObjs.count; i++){
        ButtonObject *buttonObj = self.changebleButtonObjs[i];
        [workButtonNames addObject:buttonObj.nameButton];
        [allButtonsArray addObject:self.changebleButtonObjs[i]];
        
    }
    //insert main button objects att position according mainButtonWithStartPosition dictionary
    for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
        ButtonObject *buttonObj = self.mainButtonObjs[i];
        NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
        
        [workButtonNames insertObject:buttonObj.nameButton atIndex:index];
        [allButtonsArray insertObject:self.mainButtonObjs[i] atIndex:index];
    }
    self.workButtonsNames = [workButtonNames copy];
    
    //add deleted buttons
    for (int i = 0; i < self.delettedButtonObjs.count; i++){
        [allButtonsArray addObject:self.delettedButtonObjs[i]];
    }
    
    self.allButtonObj = [allButtonsArray copy];
    self.buttonsCollection.scrollEnabled = YES;
}

-(NSArray*) workButtonsNames
{
    if(!_workButtonsNames){
        _workButtonsNames = [[NSArray alloc] init];
        [self makeWorkButoonNamesArray];
    }
    return _workButtonsNames;
}


#pragma mark MANAGED CONTEXT

-(void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = [self removeDuplicateRecordsFromHistoryContext:managedObjectContext];    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    //request.predicate = nil;
    //NSData *nullData = [NSKeyedArchiver archivedDataWithRootObject:[[NSArray alloc]init]];
    request.predicate = [NSPredicate predicateWithFormat:@"date != %@",[NSDate distantPast]];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.fetchLimit = self.limitInDataBase + 20;//!!!!set this value to allow use set it by settings
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

-(NSManagedObjectContext*)removeDuplicateRecordsFromHistoryContext:(NSManagedObjectContext*) internalContext
{
    //choose u uniq property for button - Name
    NSManagedObjectContext *context = internalContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //choose winner
    History *prevObject;
    for(History *duplicate in matches){
       // NSLog(@"Duplicate name %@ vs previosName %@", duplicate.date, prevObject.date);

        if([duplicate.date isEqualToDate:prevObject.date]){
            [context deleteObject:prevObject];
            prevObject = duplicate;
        } else {
            prevObject = duplicate;
        }
    }
    return context;
}

-(void) setButtonManagedObjectContext:(NSManagedObjectContext *)buttonManagedObjectContext
{
    _buttonManagedObjectContext =[self removeDuplicateRecordsFromContext:buttonManagedObjectContext];
    [self setUpArrays];
    [self.buttonsCollection reloadData];
}

-(NSManagedObjectContext*)removeDuplicateRecordsFromContext:(NSManagedObjectContext*) internalContext
{
    //choose u uniq property for button - Name
    NSManagedObjectContext *context = internalContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"nameButton" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //choose winner
    Buttons *prevObject;
    for(Buttons *duplicate in matches){
       // NSLog(@"Duplicate name %@ vs previosName %@", duplicate.nameButton, prevObject.nameButton);
        if([duplicate.nameButton isEqualToString:prevObject.nameButton]){
            [context deleteObject:prevObject];
            prevObject = duplicate;
        } else {
            prevObject = duplicate;
        }
    }
    matches = [context executeFetchRequest:request error:&error];
    return context;
}

//delete Flouous history
-(void) deleteSuperfluousValuesFromManagedDocuments
{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    if([fetchedObjects count] > self.limitInDataBase + 1){
        for(int i = 0; i < ([fetchedObjects count] - self.limitInDataBase -1); i++){
            History *story = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [self.managedObjectContext deleteObject:story];
        }
        
    }
}

//delete empty program from fetch
//IMPORTANT think its not necessary
-(void) deleteEmptyProgram
{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    for(NSInteger i = 0; i < ([fetchedObjects count]-1); i++){
        History *story = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSArray *programFromHistory = [NSKeyedUnarchiver unarchiveObjectWithData:story.program];
        if([programFromHistory count] == 0){
            [self.managedObjectContext deleteObject:story];
        }
    }
}





#pragma mark Button taped Action
-(void) errorAction
{
    if(self.isSoundOn){
        AudioServicesPlaySystemSound(_errorSoundFileObject);
    }
}

- (IBAction)tabButtonsCollection:(UITapGestureRecognizer *)sender
{
    if(!self.isButtonsCollectionUnderChanging){

        

        CGPoint tapLocation = [sender locationInView:self.buttonsCollection];
        NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:tapLocation];
        //find needed cell
        if(indexPath){
            if([[self.buttonsCollection cellForItemAtIndexPath:indexPath] isKindOfClass:[NewButtonsCollectionViewCell class]]){
                // add sound effect
                if(self.isSoundOn){
                    AudioServicesPlaySystemSound(_tapsoundFileObject);
                }
                
                //
                NewButtonsCollectionViewCell *cell =
                (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:indexPath];
                NSString *title = cell.name;
                
                NSArray * constants = [NSArray arrayWithObjects:@"π",@"e", nil];
                NSArray * trigonometrics = [NSArray arrayWithObjects:
                                            @"sin",@"cos",@"tg",@"ctg",
                                            @"asin",@"acos",@"atg",@"actg",
                                            nil];
                
                NSArray *operands = [NSArray arrayWithObjects:@"x!",
                                     @"x²",@"x³",@"2ˣ",@"√x",@"³√x",@"eˣ",
                                     @"lg",@"log₂",@"ln",@"10ˣ",
                                     @"sinh",@"cosh",@"tgh",@"ctgh",
                                     nil];
                NSArray * operandwithTwoArguments = [NSArray arrayWithObjects:   @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", nil];
                NSArray * operation = [NSArray arrayWithObjects:@"÷", @"×",@"-",@"+", nil];
                
                if((([title floatValue] != 0.0) || [title isEqualToString:@"0"]) && ![operands containsObject:title] ){
                    NSNumber *symbol = [NSNumber numberWithInt:[title intValue]];
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self.display showString:[self.displayRam addSymbol:symbol]];
                    }else {
                        [self.displayRam clearRam];
                        if(!self.isProgramInProcess){
                            [self setStoryInforamtion];
                            [self.brain clearOperation]; //if it's just new argument, not new counting
                        }
                        [self.display showString:[self.displayRam addSymbol:symbol]];
                        self.userIsInTheMidleOfEnteringNumber = YES;
                    }
                    
                } else if([title isEqualToString:[self point]]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        
                        [self.display showString:[self.displayRam addSymbol:@"."]];
                    } else {
                        [self.displayRam clearRam];
                        [self.display showString:[self.displayRam addSymbol:@0]];
                        if(!self.isProgramInProcess){
                            [self setStoryInforamtion];
                            [self.brain clearOperation];
                        }
                        [self.display showString:[self.displayRam addSymbol:@"."]];
                        self.userIsInTheMidleOfEnteringNumber = YES;
                    }
                    
                } else if([title isEqualToString:@"C"]){
                    //check if user jus delete las number
                    id curentresult = [self.displayRam getResult];
                    double curentValue = 1;
                    if( curentresult && [curentresult isKindOfClass:[NSNumber class]]){
                        curentValue = [curentresult doubleValue];
                    }
                    
                    [self.displayRam clearRam];
                    [self.display showString:[self.displayRam addSymbol:@0]];
                    
                    if((!self.userIsInTheMidleOfEnteringNumber) || (curentValue == 0)){
                        [self setStoryInforamtion];
                        [self.brain clearOperation];
                        
                    }
                    self.userIsInTheMidleOfEnteringNumber = YES;
                    self.isProgramInProcess = NO;
                    
                } else if([title isEqualToString:@"⌫"]){
                    if(!self.userIsInTheMidleOfEnteringNumber){
                        self.isStronglyArgu = [self.brain deleteLastElement];
                        self.isProgramInProcess = YES;
                        [self.displayRam clearRam];
                        [self.display showString:[self.displayRam addSymbol:@0]];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                        
                    } else {
                        
                        [self.display showString:[self.displayRam deleteLastSymbol]];//?? what about grad
                        if(self.displayRam.isGradMinutesSecons == 0){
                            id currentResult = [self.displayRam getResult]; // this function add grad symbol not needed here
                            if([currentResult isKindOfClass:[NSNumber class]] && ([currentResult doubleValue] == 0))
                            self.userIsInTheMidleOfEnteringNumber = NO;
                        }
                        
                    }
                    [self showStringThruManageDocument];
                    
                    
                } else if([constants containsObject:title]){ //if user pressed e, Pi or others constant buttons
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else {
                        [self.brain clearArgu];
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([operands containsObject:title]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([title isEqualToString:[[self point] stringByAppendingString:@"00"]]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:@".00"]]]];
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([trigonometrics containsObject:title]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    if(self.isDecCounting == YES){
                        title = [@"d" stringByAppendingString:title];
                    } else {
                        title = [@"r" stringByAppendingString:title];
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([title isEqualToString:@"%"]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.brain pushArguForPerCent];
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([operation containsObject:title]||[operandwithTwoArguments containsObject:title]){
                    
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                        self.isStronglyArgu = YES;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain perfomOperation:title]]]];
                    self.isStronglyArgu = NO;
                    self.isProgramInProcess = YES;
                    [self showStringThruManageDocument];
                    
                } else if ([title isEqualToString:@"="]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    } else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
                    self.isProgramInProcess = NO;
                    self.isStronglyArgu = YES;
                    
                    //check the brackets
                    [self showStringThrouhgmanagerAtEqualPress];
                    [self.brain insertBracket:NO];
                    //
                    //show what i can
                    //
                    if(self.counterForShowingAllertView > 26){
                        if(self.fristLunchWithicloudAvailable){
                            //Important set heere appeared view
                            [self askUserForiCloudStorage];
                        }
                    }
                    if((25 < self.counterForShowingAllertView) && (self.counterForShowingAllertView < 37)){
                        
                        [self showHintViewAccordingCounter];

                        //important
                    } //else {
                        //Important show about view
                        //1. Check if its a trilal period
                        if(self.isTrialPeriod){
                            //2. Calculate current value trila period in days(trialDays - (current - start trial time)). For its necessary setup start date and fix it in cloud storage
                            NSInteger intervalSinceStartInDays = (NSInteger)[self.startTrialDate timeIntervalSinceNow];
                            NSInteger daysToEndOfTrialPeriod = DAYS_ALOWED_TRIAL_PERIOD + intervalSinceStartInDays/20 ; //Important 86400;// (one day
                            NSLog(@"daysToEndOfTrialPeriod %ld", (long)daysToEndOfTrialPeriod);//Important - clear
                            
                            //important test
                            [self testShowAppController];
                            /*
                            //3. Copare days with @property NSInteger* nexNeedShovewTrialView.
                            if(daysToEndOfTrialPeriod < self.nexNeedShovewTrialViewDay){
                                if(daysToEndOfTrialPeriod < 4){
                                    self.nexNeedShovewTrialViewDay = 1;
                                } else if(daysToEndOfTrialPeriod < 9){
                                    self.nexNeedShovewTrialViewDay = 5;
                                } else if(daysToEndOfTrialPeriod < 20){
                                    self.nexNeedShovewTrialViewDay = 10;
                                }
                                //[set the app purcase reuest!!!
                                //and show about trila view
                                int64_t delayInSeconds = 0.05;
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    //Importan. If days lees then 0, need ask user Buy or continue without additions
                                    [self showAboutViewLeftDays:daysToEndOfTrialPeriod];
                                });
                                
                            }
                            */
                            
                            //4. If bigger - showAboutView and set days as argument
                      //  }
                        

                        
                        
                    }
                    
                }else if ([title isEqualToString:@"∓"]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        double number =[[self.displayRam getResult] doubleValue];
                        if([self.displayRam isGradValue]){
                            [self.display showString:[self.displayRam addSymbol:@"∓°"]];
                        } else if(number == 0){
                            [self.display showString:[self.displayRam addSymbol:@"-"]];
                        } else {
                            [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:number *(-1.0)]]];
                        }
                    } else {
                        [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain checkMinusOrDivideOperationOnDubble:title]]]];
                        self.isStronglyArgu = YES;
                        [self showStringThruManageDocument];
                    }
                } else if ([title isEqualToString:@"¹/x"]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self push];
                        self.userIsInTheMidleOfEnteringNumber = NO;
                    }  else if (self.isResultFromMemory){
                        [self push];
                        self.isResultFromMemory = NO;
                    }
                    [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain checkMinusOrDivideOperationOnDubble:title]]]];
                    
                    self.isStronglyArgu = YES;
                    [self showStringThruManageDocument];
                    
                } else  if ([title isEqualToString:@"("]){
                    
                    [self.brain insertBracket:YES];
                    [self.displayRam clearRam];
                    [self.display showString:[self.displayRam addSymbol:@0]];
                    [self showStringThruManageDocument];
                    self.userIsInTheMidleOfEnteringNumber = YES;
                    self.isStronglyArgu = NO;
                } else if ([title isEqualToString:@")"]){
                    if(self.brain.isOpenBracets){
                        if(self.userIsInTheMidleOfEnteringNumber){
                            [self push];
                        }  else if (self.isResultFromMemory){
                            [self push];
                            self.isResultFromMemory = NO;
                        }
                        
                        self.userIsInTheMidleOfEnteringNumber = NO;
                        self.isProgramInProcess = NO;
                        [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
                        [self.brain insertBracket:NO];
                        self.isStronglyArgu = YES;
                        [self showStringThruManageDocument];
                    }
                    
                } else if ([title isEqualToString:@"Mc"]){
                    self.display.firstMemoryLabel.text = @"";
                    [self.displayRam clearMemory:YES];
                    
                } else if ([title isEqualToString:@"Mr"]){
                    if([self.display.firstMemoryLabel.text isEqualToString:@"M"]){
                        self.isResultFromMemory = YES;
                        [self.display showString:[self.displayRam getResultFromMemory:YES]];
                    }
                    
                } else if ([title isEqualToString:@"M+"]){
                    self.display.firstMemoryLabel.text = @"M";
                    [self.displayRam addResToMemory:YES inRadians:!self.isDecCounting];
                    self.isResultFromMemory = YES;
                    
                } else if ([title isEqualToString:@"M-"]){
                    self.display.firstMemoryLabel.text = @"M";
                    [self.displayRam substractResFromMemory:YES inRadians:!self.isDecCounting];
                    self.isResultFromMemory = YES;
                    
                } else if ([title isEqualToString:@"MIc"]){
                    self.display.secondMemoryLabel.text = @"";
                    [self.displayRam clearMemory:NO];
                    
                } else if ([title isEqualToString:@"MIr"]){
                    if([self.display.secondMemoryLabel.text isEqualToString:@"MI"]){
                        self.isResultFromMemory = YES;
                        [self.display showString:[self.displayRam getResultFromMemory:NO]];
                    }
                    
                } else if ([title isEqualToString:@"MI+"]){
                    self.display.secondMemoryLabel.text = @"MI";
                    [self.displayRam addResToMemory:NO inRadians:!self.isDecCounting];
                    self.isResultFromMemory = YES;
                    
                } else if ([title isEqualToString:@"MI-"]){
                    self.display.secondMemoryLabel.text = @"MI";
                    [self.displayRam substractResFromMemory:NO inRadians:!self.isDecCounting];
                    self.isResultFromMemory = YES;
                    
                } else if ([title isEqualToString:@"X"]){
                    
                } else if ([title isEqualToString:@"A"]){
                    
                } else if ([title isEqualToString:@"Tab"]){
                    
                } else if ([title isEqualToString:@"Grph"]){
                    
                } else if ([title isEqualToString:@"+f(x)"]){
                    
                } else if ([title isEqualToString:@"rad"] || [title isEqualToString:@"deg"] ) {
                    if([title isEqualToString:@"rad"]){
                        cell.name = @"deg";
                        [self.display.decRadLabel setText:@" RAD"];
                        self.isDecCounting = NO;
                    } else if ([title isEqualToString:@"deg"]){
                        cell.name = @"rad";
                        [self.display.decRadLabel setText:@" DEG"];
                        self.isDecCounting = YES;
                    }
                    
                } else if ([title isEqualToString:@"° ′″"]){
                    if(self.userIsInTheMidleOfEnteringNumber){
                        [self.display showString:[self.displayRam addSymbol:@"° ′″"]];
                    } else {
                        [self.display showString:[self.displayRam setResult: self.isDecCounting? @"D" : @"R"]];
                    }
                    
                }
            }
            [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        
    }
}

-(void) showStringThrouhgmanagerAtEqualPress
{
  
    if(self.brain.isOpenBracets){
        [self showStringThruManageDocument];
    } else {

        NSArray *deepProgram = [self.brain.deepProgram copy];
        NSArray *deepArgu = [self.brain.deepArgu copy];
        
        NSArray *emptyArray = [[NSArray alloc] init];//to add empty array as no strongly argument and as result
        
        NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
        [muttableOutputArray addObject:deepProgram];
        if(self.brain.isStronglyArgu){
            [muttableOutputArray addObject:deepArgu];
        } else {
            //if no strongly argu add empty array
            [muttableOutputArray addObject:emptyArray];
        }
        //and @"=" string
        if(!self.brain.isOpenBracets){
            [muttableOutputArray addObject:@" ="];
        }
        self.lastRowDataArray = [muttableOutputArray copy];

    }
}

-(void) showStringThruManageDocument
{
   // NSDate *currDate = [NSDate date];
    NSArray *deepProgram = [self.brain.deepProgram copy];
    NSArray *deepArgu = [self.brain.deepArgu copy];
    
    NSArray *emptyArray = [[NSArray alloc] init];//to add empty array as no strongly argument and as result
    
    NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
    [muttableOutputArray addObject:deepProgram];
    if(self.brain.isStronglyArgu){
        [muttableOutputArray addObject:deepArgu];
    } else {
        //if no strongly argu add empty array
        [muttableOutputArray addObject:emptyArray];
    }
    //and the same for result
    [muttableOutputArray addObject:emptyArray];
    
    self.lastRowDataArray = [muttableOutputArray copy];
    
}

-(void) setStoryInforamtion
{
    //set last object from manageddocumnet
    NSDate *currDate = [NSDate date];
    //if no strongly argument first - delete last operation
    if(!self.isStronglyArgu){
        self.isStronglyArgu = [self.brain deleteLastElement];
    }
    
    while(self.brain.isOpenBracets){
        [self.brain count];
        [self.brain insertBracket:NO];
    }
    
    NSArray *deepProgram = [self.brain.deepProgram copy];
    NSArray *deepArgu = [self.brain.deepArgu copy];
    NSArray *testArray = [[deepProgram lastObject] copy];
    if(([testArray count]>0) || ([deepArgu count]>0)){
        
        NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
        [muttableOutputArray addObject:deepProgram];
        [muttableOutputArray addObject:deepArgu];
        [muttableOutputArray addObject:[NSNumber numberWithDouble:[self.brain count]]];
        
        //create new object in manageddoc with empty array
        [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
        
        //create new object in manageddoc with empty array

        NSArray *new = [[NSArray alloc] init];
        self.lastRowDataArray = new;
    }
    //set counter to show allert view
    if(self.counterForShowingAllertView != -1){
        self.counterForShowingAllertView ++;
    }
}

-(void) push
{
    if(self.displayRam.isGradValue){
        if([[self.displayRam getResult] isKindOfClass:[NSArray class]]){
            NSMutableArray *copyGradArray = [[self.displayRam getResult] mutableCopy];
            [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
            [self.brain pushOperand:[copyGradArray copy]];
        } else {
            
        }
    } else {
        [self.brain pushOperand:[self.displayRam getResult]];
    }
    
}


#pragma mark - BUTTONS COLLECTION
-(void)setIsButtonsCollectionUnderChanging:(BOOL)is
{
    
    _isButtonsCollectionUnderChanging = is;
    
    if(is){
        self.longPressRecognizer.minimumPressDuration = 0.1;
    } else {
        self.longPressRecognizer.minimumPressDuration = 0.5;
    }
    
   // [self.buttonsCollection reloadData];
  
}


#pragma mark - GESTURES and Tap Fix  and delete Button at changeble conditions buttonscollection


//long press at display
- (IBAction)displayLongPress:(UILongPressGestureRecognizer *)sender
{
   //if display is show number
    if(self.display.alpha == 1){
        if(sender.state == UIGestureRecognizerStateBegan){
        
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:self.display.attributedText.string];
        
        //may be add some signal
            UIView *signalView = [[UIView alloc] initWithFrame:self.display.frame];
            signalView.backgroundColor = [UIColor whiteColor];
            signalView.alpha = 1.0;
            [self.displayContainer addSubview:signalView];
            [UIView animateWithDuration:0.6
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 signalView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                             
                             }];
            if(self.isSoundOn){
                AudioServicesPlaySystemSound (_shutterSoundFileObject);
            }
        }
    }
}

- (IBAction)longPress:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];
        if(!self.isButtonsCollectionUnderChanging){
            //lock interaction
            self.buttonsCollection.userInteractionEnabled = NO;
            self.isButtonsCollectionUnderChanging = YES;
            
            CGRect newDynamicFrame = self.dynamicContainer.frame;
            newDynamicFrame.size.height = 2*self.mainContainerView.frame.size.height - self.labelViewHeight;
            
            //if self.isButtonsCollectionUnderChanging = YES;
            newDynamicFrame.origin.y = -self.mainContainerView.frame.size.height + self.labelViewHeight;

            
            CGRect buttonsCollectionViewBounds = self.buttonsCollection.frame;
            buttonsCollectionViewBounds.size.height = self.mainContainerView.frame.size.height;
            buttonsCollectionViewBounds.origin.y = self.mainContainerView.frame.size.height - self.labelViewHeight;

            //allow show settings button only in paid version
            if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.hidden = NO;
            self.downButton.hidden = NO;
            //[self.buttonsCollection reloadData];
            
            [UIView animateWithDuration:.35
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.dynamicContainer setFrame:newDynamicFrame];
                                 if(self.isIAdBaneerAvailable){
                                     NSInteger bannerHeight;
                                     if(IS_IPAD){
                                         bannerHeight = 66;
                                     } else {
                                         bannerHeight = 50;
                                     }
                                     [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, bannerHeight)];
                                     [self.iAdBanner setFrame:self.bannerContainerView.bounds];
                                 }
                                 [self.buttonsCollection setFrame: buttonsCollectionViewBounds];
                                 self.display.alpha = .0;
                                 
                                 //allow show settings button only in paid version
                                 if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.alpha = 1.;
                                 self.downButton.alpha = 1.;
                                 
                             } completion:^(BOOL finihed){
                                
                                 if(!self.wasPurshaised){

                                    //enable buttons to buy product
                                    self.buyAdditionsButton.enabled = NO;
                                    [self.buyAdditionsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                                    //start processSpiner
                                    [self startSpinner];
                                    //----------------------------
                                     
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
                                 if(!(self.wasPurshaised || self.isTrialPeriod)){

                                     //if no paid version show at moment only setting view
                                     //not allow user change buttons
                                    CGRect settingsViewNewframe = self.SettingsView.frame;
                                    settingsViewNewframe.origin.y = self.displayContainer.frame.origin.y + self.displayContainer.frame.size.height;
                                    [self.SettingsView setFrame:settingsViewNewframe];
                                    [self.settingsBackgroundToolBar setFrame:settingsViewNewframe];
                                     self.SettingsView.hidden = NO;
                                     self.settingsBackgroundToolBar.hidden = NO;
                                     
                                    settingsViewNewframe.origin.x = 0;
                                    [UIView animateWithDuration:0.5
                                                           delay:0.2
                                                         options:UIViewAnimationOptionCurveEaseOut
                                                      animations:^{
                                                          
                                                          [self.SettingsView setFrame:settingsViewNewframe];
                                                          [self.settingsBackgroundToolBar setFrame:settingsViewNewframe];
                                                      
                                                      } completion:^(BOOL finished) {
                                                          self.isSettingsViewOnScreen = YES;
                                                      }];
                                }
                                 
                                 [self.buttonsCollection reloadData];
                                 //ulock interaction
                                 self.buttonsCollection.userInteractionEnabled = YES;
                             }];
        } else {
            //1. fix button postion
            
            CGPoint tapLocation = [gesture locationInView:self.buttonsCollection];
            NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:tapLocation];
            //find needed cell
            if(indexPath){
                if([[self.buttonsCollection cellForItemAtIndexPath:indexPath] isKindOfClass:[NewButtonsCollectionViewCell class]]){
                    self.subCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:indexPath];
                    if((self.subCell.isChangeble) && (self.subCell.isEnable)){
                        CGRect subViewFrame;
                        subViewFrame = ((NewButtonsCollectionViewCell*)self.subCell).cellSubView.frame;
                        
                        
                        subViewFrame.origin = [self.subCell.cellSubView convertPoint:subViewFrame.origin toView:self.buttonsCollection];
                        
                        self.buttonsAsSubView = [[newButtonView alloc] initWithFrame:subViewFrame];
                        self.buttonsAsSubView.title = ((NewButtonsCollectionViewCell*)self.subCell).cellSubView.title;
                        self.buttonsAsSubView.buttonColor = ((NewButtonsCollectionViewCell*)self.subCell).cellSubView.buttonColor;
                        [self.buttonsCollection addSubview:self.buttonsAsSubView];
                        self.subCell.alpha = 0.0;
                        
                        self.buttonsAsSubView.isTaped = YES;
                        CGFloat subX = self.buttonsAsSubView.frame.origin.x + (1- 3.1)*self.subCell.frame.size.width /2.;
                        CGFloat subY = self.buttonsAsSubView.frame.origin.y + (1- 3.1)*self.subCell.frame.size.height /2.;
                        CGFloat subWidth = self.subCell.frame.size.width * 3.1;
                        CGFloat subHeight = self.subCell.frame.size.height * 3.1;
                        [UIView animateWithDuration:.2
                                              delay:0
                                            options:UIViewAnimationOptionBeginFromCurrentState
                                         animations:^{
                                             [self.buttonsAsSubView setFrame:CGRectMake(subX, subY, subWidth, subHeight)];
                                         } completion:^(BOOL finished) {
                                             
                                             CGFloat subX = self.subCell.frame.origin.x + (1- 2.1)*self.subCell.frame.size.width /2;
                                             CGFloat subY = self.subCell.frame.origin.y + (1- 2.1)*self.subCell.frame.size.height /2 - 20.;
                                             CGFloat subWidth = self.subCell.frame.size.width * 2.1;
                                             CGFloat subHeight = self.subCell.frame.size.height * 2.1;
                                             
                                             [UIView animateWithDuration:.2
                                                                   delay:0
                                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                                              animations:^{
                                                                  [self.buttonsAsSubView setFrame:CGRectMake(subX, subY, subWidth, subHeight)];
                                                                  self.buttonsAsSubView.title = ((NewButtonsCollectionViewCell*)self.subCell).cellSubView.title;
                                                                  
                                                              } completion:^(BOOL finished){
                                                                  self.buttonsAsSubView.isTaped = YES;
                                                              }];
                                             
                                         }];
                    }
                }
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        if(self.isButtonsCollectionUnderChanging){
            if(self.buttonsAsSubView){
                CGRect subFrame = self.subCell.frame;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     [self.buttonsAsSubView setFrame:subFrame];
                                     
                                 } completion:^(BOOL finished) {
                                     if(self.findCell){
                                     }
                                     self.subCell.alpha = 1.;
                                     [self.buttonsAsSubView removeFromSuperview];
                                     self.buttonsAsSubView = nil;
                                     NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:self.subCell]];
                                     [self.buttonsCollection reloadItemsAtIndexPaths:array];
                                 }];
                
            }
        } else {

        }
        
        
    } else if(gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed){
        if(self.isButtonsCollectionUnderChanging){
            if(self.buttonsAsSubView){
                CGRect subFrame = self.subCell.frame;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     [self.buttonsAsSubView setFrame:subFrame];
                                 } completion:^(BOOL finished) {
                                     if(self.findCell){
                                     }
                                     self.subCell.alpha = 1.;
                                     [self.buttonsAsSubView removeFromSuperview];
                                     self.buttonsAsSubView = nil;
                                     NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:self.subCell]];
                                     [self.buttonsCollection reloadItemsAtIndexPaths:array];
                                 }];
            }
        } else {

        }
    }
    
}

- (IBAction)tapSettingsBotomButton:(UIButton *)sender
{
    [self showSettingsViewcontroller];
    /*
    if(self.isBottomSettingsViewOnScreen){
        CGRect settingsViewframe = self.SettingsView.frame;
        settingsViewframe.origin.x = -self.mainContainerView.bounds.size.width;
        
        [UIView animateWithDuration:0.28f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.SettingsView setFrame:settingsViewframe];
                             [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                         } completion:^(BOOL finished) {
                             self.isBottomSettingsViewOnScreen = NO;
                             self.SettingsView.hidden = YES;
                             self.settingsBackgroundToolBar.hidden = YES;
                         }];
        
    } else {
        
        
        CGRect settingsViewframe = self.SettingsView.frame;
        
        settingsViewframe.origin.y = 0;
        self.SettingsView.hidden = NO;
        self.settingsBackgroundToolBar.hidden = NO;
        [self.SettingsView setFrame:settingsViewframe];
        [self.settingsBackgroundToolBar setFrame:settingsViewframe];
        
        if(!self.wasPurshaised){
            //enable buttons to buy product
            self.buyAdditionsButton.enabled = NO;
            [self.buyAdditionsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            //start processSpiner
            [self startSpinner];
            //----------------------------
            
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
        
        settingsViewframe.origin.x = 0;
        
        [UIView animateWithDuration:0.28
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.SettingsView setFrame:settingsViewframe];
                             [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                             
                         } completion:^(BOOL finished) {
                             self.isBottomSettingsViewOnScreen = YES;
                             
                         }];
    }
    */
}

- (IBAction)tapSettingsButton:(UIButton *)sender
{
    [self showSettingsViewcontroller];
    /*
    if(self.isSettingsViewOnScreen){
        
        CGRect settingsViewframe = self.SettingsView.frame;
        
        settingsViewframe.origin.x = -self.mainContainerView.bounds.size.width;
        
        
        [UIView animateWithDuration:0.28f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.SettingsView setFrame:settingsViewframe];
                             [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                         } completion:^(BOOL finished) {
                             self.isSettingsViewOnScreen = NO;
                             self.SettingsView.hidden = YES;
                             self.settingsBackgroundToolBar.hidden = YES;
                         }];
        
    } else {
        
        
        CGRect settingsViewframe = self.SettingsView.frame;
        settingsViewframe.origin.y = self.displayContainer.bounds.size.height + self.displayContainer.frame.origin.y;
       // NSLog(@"Initial frame origin y- %f", settingsViewframe.origin.y);
        self.SettingsView.hidden = NO;
        self.settingsBackgroundToolBar.hidden = NO;
        [self.SettingsView setFrame:settingsViewframe];
        [self.settingsBackgroundToolBar setFrame:settingsViewframe];
        
        settingsViewframe.origin.x = 0;
        
        [UIView animateWithDuration:0.28
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.SettingsView setFrame:settingsViewframe];
                             [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                             
                         } completion:^(BOOL finished) {
                             self.isSettingsViewOnScreen = YES;
                         }];
    }
    */
    
    
}

-(void) discardChanging
{
    //if there is process spiner - remove it from settings view
    if(self.processSpinner){
        [self.processSpinner stopAnimating];
        [self.processSpinner removeFromSuperview];
    }
    
    self.buttonsCollection.scrollEnabled = NO;
    //if there is buttonAsSubview in buttonCollection
    if(self.buttonsAsSubView){
        CGRect subFrame = self.subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(self.findCell){
                             }
                             self.subCell.alpha = 1.;
                             [self.buttonsAsSubView removeFromSuperview];
                             self.buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:self.subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                         }];
    }

    if(self.isButtonsCollectionUnderChanging){
        self.isButtonsCollectionUnderChanging = NO;
        for(UICollectionViewCell* cell in [self.buttonsCollection visibleCells]){
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
        }
        
        [self resaveCoreButtons];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];

    CGRect dynamicRect = self.dynamicContainer.frame;
    dynamicRect.size.height = 2*self.mainContainerView.bounds.size.height - self.histroryTableViewHeight - self.labelViewHeight;
    
    //initial origin
    dynamicRect.origin.y = self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.bounds.size.height;
    
    CGRect buttonsCollectionViewBounds = self.mainContainerView.bounds;
    buttonsCollectionViewBounds.size.height = self.mainContainerView.bounds.size.height - self.histroryTableViewHeight;
    buttonsCollectionViewBounds.origin.y = self.historyTable.bounds.size.height;

    CGRect settingsViewframe = self.SettingsView.frame;
    if(self.isBottomSettingsViewOnScreen){
        settingsViewframe.origin.y = self.displayContainer.frame.origin.y - settingsViewframe.size.height;
    } else {
        settingsViewframe.origin.y = self.displayContainer.frame.origin.y + self.displayContainer.frame.size.height;
    }
    settingsViewframe.origin.x = - settingsViewframe.size.width;

    
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

                         [self.dynamicContainer setFrame:dynamicRect];
                         
                         if(self.isIAdBannerOnScreen){
                             NSInteger bannerHeight;
                             if(IS_IPAD){
                                 bannerHeight = 66;
                             } else {
                                 bannerHeight = 50;
                             }

                             [self.bannerContainerView setFrame:CGRectMake(0, 0, self.mainContainerView.bounds.size.width, bannerHeight)];
                             [self.iAdBanner setFrame:self.bannerContainerView.bounds];

                         }
                         
                         [self.SettingsView setFrame:settingsViewframe];
                         [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                         
                         [self.buttonsCollection setFrame:buttonsCollectionViewBounds];
                         
                         self.settingsBottomButtn.alpha = 0.;
                         self.noticeButton.alpha = 0.;
                         if(IS_IPAD){
                             self.noticeRealButton.alpha = 0.;
                         }
                         self.recountButton.alpha = 0.;
                         self.upButton.alpha = 0.;
                         self.deleteButton.alpha = 0.;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.alpha = 0.;
                         self.downButton.alpha = 0.;
                         
                         self.display.alpha = 1.;
                         
                     } completion:^(BOOL finished){

                         self.settingsBottomButtn.hidden = YES;
                         self.noticeButton.hidden = YES;
                         if(IS_IPAD){
                             self.noticeRealButton.hidden = YES;
                         }
                         self.recountButton.hidden = YES;
                         self.upButton.hidden = YES;
                         self.deleteButton.hidden = YES;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.hidden = YES;
                         self.downButton.hidden = YES;
                         self.isSettingsViewOnScreen = NO;
                         self.isBottomSettingsViewOnScreen = NO;
                         self.SettingsView.hidden = YES;
                         self.settingsBackgroundToolBar.hidden = YES;
                         
                         //think about it
                         if(!self.wasPurshaised){
                             [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         }
                         if(self.isSoundOn){
                             AudioServicesPlaySystemSound (_blankSoundFileObject);
                         }
                         //
                         [self.buttonsCollection reloadData];
                         self.buttonsCollection.scrollEnabled = YES;
                         self.isHistoryWholeShowed = 0;
                         
                        [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
                         
                         
                     }];
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
        [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];
    } else {
    }
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }

}

- (IBAction)tapFixButton:(UIButton*)sender
{
    if(!self.animationTimer.isValid){
        [self discardChanging];
    }
}
#pragma mark sviper gesture recognizer
-(void)setIsHistoryWholeShowed:(CGFloat)isHistoryWholeShowed
{
    self.historyTableSviper.pattOfDown = isHistoryWholeShowed;
    _isHistoryWholeShowed = isHistoryWholeShowed;
}


- (IBAction)dragSviperGesturRecognizer:(UIPanGestureRecognizer *)sender
{
    if(!self.isButtonsCollectionUnderChanging){
    CGPoint currentSvipeGestureLocation = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        
        self.svipeGestureLocation = currentSvipeGestureLocation;
        self.wasDynamicOriginY = self.dynamicContainer.frame.origin.y;
        
        self.settingsBottomButtn.hidden = NO;
        self.noticeButton.hidden = NO;
        if(IS_IPAD){
            self.noticeRealButton.hidden = NO;
        }
        self.recountButton.hidden = NO;
        self.deleteButton.hidden = NO;
        
    } else if (sender.state == UIGestureRecognizerStateChanged){

        CGFloat hopeDynamicOriginY =self.wasDynamicOriginY + currentSvipeGestureLocation.y - self.svipeGestureLocation.y;
        
        if(hopeDynamicOriginY > -self.view.frame.size.height + self.histroryTableViewHeight + self.labelViewHeight
           && hopeDynamicOriginY < 0){
            CGFloat opacityMark = hopeDynamicOriginY/(self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.frame.size.height);
            
            self.display.alpha = opacityMark;
            self.settingsBottomButtn.alpha =1 - opacityMark;
            self.noticeButton.alpha = 1 - opacityMark;
            if(IS_IPAD){
                self.noticeRealButton.alpha = 1 - opacityMark;
            }
            self.recountButton.alpha = 1 - opacityMark;
            self.deleteButton.alpha = 1 - opacityMark;
            self.isHistoryWholeShowed = 1 - opacityMark;
            
            CGRect dynamicRect = self.dynamicContainer.frame;
            dynamicRect.origin.y = hopeDynamicOriginY;
            [self.dynamicContainer setFrame:dynamicRect];
            
            if(self.SettingsView.frame.origin.x > -self.SettingsView.frame.size.width){
                CGRect settingsViewframe = self.SettingsView.frame;
                settingsViewframe.origin.x = - settingsViewframe.size.width * opacityMark;
                [self.SettingsView setFrame:settingsViewframe];
                [self.settingsBackgroundToolBar setFrame:settingsViewframe];
            }

        }
        //if drag down
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
        CGFloat hopeDynamicOriginY =self.wasDynamicOriginY + currentSvipeGestureLocation.y - self.svipeGestureLocation.y;
        CGFloat opacityMark = hopeDynamicOriginY/(self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.frame.size.height);
        if(hopeDynamicOriginY >= -self.view.frame.size.height + self.histroryTableViewHeight + self.labelViewHeight
           && hopeDynamicOriginY < 0){
            
            self.display.alpha = opacityMark;
            self.settingsBottomButtn.alpha =1 - opacityMark;
            self.noticeButton.alpha = 1 - opacityMark;
            if(IS_IPAD){
                self.noticeRealButton.alpha = 1 - opacityMark;
            }
            self.recountButton.alpha = 1 - opacityMark;
            self.deleteButton.alpha = 1 - opacityMark;
            self.isHistoryWholeShowed = 1 - opacityMark;
            
            if(self.SettingsView.frame.origin.x > -self.SettingsView.frame.size.width){
                CGRect settingsViewframe = self.SettingsView.frame;
                settingsViewframe.origin.x = - settingsViewframe.size.width * opacityMark;
                [self.SettingsView setFrame:settingsViewframe];
                [self.settingsBackgroundToolBar setFrame:settingsViewframe];
            }

        }
        
        if(self.wasDynamicOriginY == -self.mainContainerView.frame.size.height + self.histroryTableViewHeight + self.labelViewHeight) {
            if(opacityMark < 0.9){
                [self finishDraggingDownWithVelocity:[sender velocityInView:self.view]];
            } else {
                
                [self finisDraggingUpWithVelocity:[sender velocityInView:self.view]];
            }
        } else {
            if(opacityMark < 0.1){
                [self finishDraggingDownWithVelocity:[sender velocityInView:self.view]];
            } else {
                
                [self finisDraggingUpWithVelocity:[sender velocityInView:self.view]];
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
       // NSLog(@"filed or canceled");
    }
    }
    
}

-(void) finisDraggingUpWithVelocity:(CGPoint)velocity
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.mainContainerView];
    
    velocity.x = 0;
    UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicContainer]];
    dynamicItem.allowsRotation = NO;
    [dynamicItem addLinearVelocity:velocity forItem:self.dynamicContainer];
    [animator addBehavior:dynamicItem];
    
    CGFloat centerY = self.mainContainerView.frame.size.height - self.dynamicContainer.frame.size.height/2;
    
    CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.mainContainerView.frame),
                                    centerY);
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.dynamicContainer snapToPoint:snapPoint];
    snap.damping = 0.3;
    
    __weak typeof (self) weakSelf = self;
    snap.action = ^{
        typeof(self) strongSelf = weakSelf;
        UIView *view = strongSelf.dynamicContainer;
        
        CGFloat opacityMark = strongSelf.dynamicContainer.frame.origin.y/(strongSelf.histroryTableViewHeight + strongSelf.labelViewHeight - strongSelf.mainContainerView.frame.size.height);
        
        strongSelf.display.alpha =  opacityMark;
        strongSelf.settingsBottomButtn.alpha =1- opacityMark;
        strongSelf.noticeButton.alpha = 1-opacityMark;
        if(IS_IPAD){
            strongSelf.noticeRealButton.alpha = 1 - opacityMark;
        }
        strongSelf.recountButton.alpha = 1-opacityMark;
        strongSelf.deleteButton.alpha = 1-opacityMark;
        strongSelf.isHistoryWholeShowed = 1-opacityMark;
        
        CGFloat needY = strongSelf.histroryTableViewHeight + strongSelf.labelViewHeight - strongSelf.mainContainerView.frame.size.height;
        
        if(strongSelf.SettingsView.frame.origin.x > -strongSelf.SettingsView.frame.size.width){
            CGRect settingsViewframe = strongSelf.SettingsView.frame;
            settingsViewframe.origin.x = - settingsViewframe.size.width * opacityMark;
            [strongSelf.SettingsView setFrame:settingsViewframe];
            [strongSelf.settingsBackgroundToolBar setFrame:settingsViewframe];
        }

        if(ABS(CGRectGetMidY(strongSelf.dynamicContainer.frame) - centerY) < 1 && [dynamicItem linearVelocityForItem:view].y < 0.01){
           [animator removeAllBehaviors];
            CGRect dynamicRect = view.frame;
            dynamicRect.origin.y = needY;
            [view setFrame:dynamicRect];

            //in any case hide settings view
            CGRect settingsViewframe = strongSelf.SettingsView.frame;
            settingsViewframe.origin.x = - settingsViewframe.size.width;
            [strongSelf.SettingsView setFrame:settingsViewframe];
            [strongSelf.settingsBackgroundToolBar setFrame:settingsViewframe];
            strongSelf.isSettingsViewOnScreen = NO;
            strongSelf.isBottomSettingsViewOnScreen = NO;
            self.SettingsView.hidden = YES;
            self.settingsBackgroundToolBar.hidden = YES;
            
            strongSelf.display.alpha =  1;
            strongSelf.settingsBottomButtn.alpha =0;
            strongSelf.noticeButton.alpha = 0;
            if(IS_IPAD){
                strongSelf.noticeRealButton.alpha = 0.;
            }
            strongSelf.recountButton.alpha = 0;
            strongSelf.deleteButton.alpha = 0;
            strongSelf.isHistoryWholeShowed = 0;
            
            [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
            
            if(strongSelf.historyTable.contentSize.height < strongSelf.historyTable.frame.size.height){


               [strongSelf.historyTable setContentInset:UIEdgeInsetsMake(strongSelf.historyTable.frame.size.height - strongSelf.historyTable.contentSize.height,0, 0, 0)];
            } else {

            }
            if([strongSelf.historyTable numberOfRowsInSection:0] > 1){
                NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[strongSelf.historyTable numberOfRowsInSection: 0]-1  inSection:0];
                
                [strongSelf.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
            }

        }
        
    };
    
    
    [animator addBehavior:snap];

    self.animator = animator;
}

-(void) finishDraggingDownWithVelocity:(CGPoint)velocity
{
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.mainContainerView];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicContainer]];
    gravity.gravityDirection = CGVectorMake(0.0, 4.0);
    [animator addBehavior:gravity];
    
    velocity.x = 0;
    UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicContainer]];
    dynamicItem.allowsRotation = NO;
    [dynamicItem addLinearVelocity:velocity forItem:self.dynamicContainer];
    [animator addBehavior:dynamicItem];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.dynamicContainer]];
    CGFloat stopY = 2* self.mainContainerView.frame.size.height - self.labelViewHeight - self.histroryTableViewHeight;
    [collision addBoundaryWithIdentifier:@"dynamic"
                                       fromPoint:CGPointMake(0, stopY)
                                         toPoint:CGPointMake(self.mainContainerView.frame.size.width, stopY)];
    
    __weak typeof (self) weakSelf = self;
    gravity.action = ^{
        
        typeof(self) strongSelf = weakSelf;
        
        CGFloat opacityMark = strongSelf.dynamicContainer.frame.origin.y/(strongSelf.histroryTableViewHeight + strongSelf.labelViewHeight - strongSelf.mainContainerView.frame.size.height);
        
        strongSelf.display.alpha = opacityMark;
        strongSelf.settingsBottomButtn.alpha =1- opacityMark;
        strongSelf.noticeButton.alpha = 1- opacityMark;
        if(IS_IPAD){
            strongSelf.noticeRealButton.alpha = 1 - opacityMark;
        }
        strongSelf.recountButton.alpha = 1- opacityMark;
        strongSelf.deleteButton.alpha = 1- opacityMark;
        self.isHistoryWholeShowed = 1- opacityMark;
        
        if(self.SettingsView.frame.origin.x > -self.SettingsView.frame.size.width){
            CGRect settingsViewframe = self.SettingsView.frame;
            settingsViewframe.origin.x = - settingsViewframe.size.width * opacityMark;
            [self.SettingsView setFrame:settingsViewframe];
            [self.settingsBackgroundToolBar setFrame:settingsViewframe];
        }
        //if self.isHistoryWholeShowed = 1.;
        CGFloat needY = 0;
        UIView *view = strongSelf.dynamicContainer;

        if(view.frame.origin.y > needY - 3 && ABS([dynamicItem linearVelocityForItem:view].y) < 0.01){
            [animator removeAllBehaviors];
            CGRect dynamicRect = view.frame;
            dynamicRect.origin.y = needY;
            [view setFrame:dynamicRect];
            
            strongSelf.display.alpha =  0;
            strongSelf.settingsBottomButtn.alpha =1.;
            strongSelf.noticeButton.alpha = 1.;
            if(IS_IPAD){
                strongSelf.noticeRealButton.alpha = 1.;
            }
            strongSelf.recountButton.alpha = 1.;
            strongSelf.deleteButton.alpha = 1.;
            strongSelf.isHistoryWholeShowed = 1.;
            
            if(strongSelf.SettingsView.frame.origin.x > -strongSelf.SettingsView.frame.size.width){
                CGRect settingsViewframe = strongSelf.SettingsView.frame;
                settingsViewframe.origin.x = 0;
                [strongSelf.SettingsView setFrame:settingsViewframe];
                [strongSelf.settingsBackgroundToolBar setFrame:settingsViewframe];
            }
            
            
        }

    };
    [animator addBehavior:collision];
    
    self.animator = animator;
}

//tap on history sviper
- (IBAction)tapSviper:(UITapGestureRecognizer *)sender
{
    if(!self.isButtonsCollectionUnderChanging){
        if(self.isHistoryWholeShowed == 1){
            [self finisDraggingUpWithVelocity:CGPointMake(0, 0)];
        } else {
            self.display.alpha =  0.99;
            self.settingsBottomButtn.hidden = NO;
            self.settingsBottomButtn.alpha =.01;
            
            self.noticeButton.hidden = NO;
            self.noticeButton.alpha = .01;
            if(IS_IPAD){
                self.noticeRealButton.hidden = NO;
                self.noticeRealButton.alpha = .01;
            }
            
            self.recountButton.hidden = NO;
            self.recountButton.alpha = .01;
            
            self.deleteButton.hidden = NO;
            self.deleteButton.alpha = .01;
            
            self.isHistoryWholeShowed = .01;
            [self finishDraggingDownWithVelocity:CGPointMake(0, 0)];
        }
    }
}

#pragma mark - MOVE BUTTONS Methods
//method change offset in pan gesture is included new Thread
-(CGFloat) moveButtonsCollectioViewByOffsetDown:(CGFloat) offset
{
    CGFloat retOffset = 0;
    if(!self.isThreadInWork){
        __block CGFloat blockOffset = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.isThreadInWork = YES;
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if((self.buttonsAsSubView.center.y > 0) && ((self.buttonsAsSubView.center.y - self.buttonsCollection.contentOffset.y) <  2.5 *self.subCell.bounds.size.height) && (self.buttonsCollection.contentOffset.y > 0)){
                    self.wasInMoveOffsetSection = YES;
                   
                    blockOffset = self.buttonsCollection.contentOffset.y;

                    CGPoint newOffset = self.buttonsCollection.contentOffset;
                    newOffset.y = self.buttonsCollection.contentOffset.y - blockOffset;
                    CGPoint newCenter = self.buttonsAsSubView.center;
                    newCenter.y = self.buttonsAsSubView.center.y - blockOffset;
                    
                    [UIView animateWithDuration: 1.5 * (blockOffset / self.buttonsCollection.frame.size.height)
                                     animations:^{
                                         [self.buttonsCollection setContentOffset:newOffset];
                                         [self.buttonsAsSubView setCenter:newCenter];
                                     }];
                }
                self.isThreadInWork = NO;
            });
        });
        retOffset = blockOffset;
    }
    return retOffset;
}

//method change offset UP in pan gesture
-(CGFloat) moveButtonsCollectioViewByOffsetUp:(CGFloat) offset
{
    CGFloat retOffset = 0;
    if(!self.isThreadInWork){
        __block CGFloat blockOffset = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.isThreadInWork = YES;
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if((self.buttonsAsSubView.center.y > 0) &&
                   ((self.buttonsCollection.contentOffset.y + self.buttonsCollection.frame.size.height - self.buttonsAsSubView.center.y) <  1.5*self.subCell.bounds.size.height) &&
                   ((self.buttonsCollection.contentOffset.y +self.buttonsCollection.frame.size.height) < self.buttonsCollection.contentSize.height)){
                    self.wasInMoveOffsetSection = YES;
                    if(offset > (self.subCell.frame.size.height*4)){
                        blockOffset = self.subCell.frame.size.height*4;
                    } else {
                        blockOffset = self.buttonsCollection.contentSize.height - self.buttonsCollection.contentOffset.y - self.buttonsCollection.frame.size.height;
                    }
                    CGPoint newOffset = self.buttonsCollection.contentOffset;
                    newOffset.y = self.buttonsCollection.contentOffset.y + blockOffset;
                    CGPoint newCenter = self.buttonsAsSubView.center;
                    newCenter.y = self.buttonsAsSubView.center.y + blockOffset;
                    
                    [UIView animateWithDuration:1.5 * (blockOffset / self.buttonsCollection.frame.size.height)
                                     animations:^{
                                         [self.buttonsCollection setContentOffset:newOffset];
                                         [self.buttonsAsSubView setCenter:newCenter];
                                     }];
                    
                }
                self.isThreadInWork = NO;
            });
        });
        retOffset = blockOffset;
    }
    return retOffset;
}

//main method to move buttonView from one position in buttonsCollection to another
-(void) moveCellFromPosition: (NSIndexPath*) patchFrom toPosition: (NSIndexPath*) patchTo withDuration: (CGFloat) duration
{
    UICollectionViewCell* cellTo = [self.buttonsCollection cellForItemAtIndexPath:patchTo];
    UICollectionViewCell* cellFrom = [self.buttonsCollection cellForItemAtIndexPath:patchFrom];
    
    newButtonView * subView = [[newButtonView alloc] init];
    if([cellFrom isKindOfClass:[NewButtonsCollectionViewCell class]] && [cellTo isKindOfClass:[NewButtonsCollectionViewCell class]]){
        CGRect subViewFrame;
        subViewFrame = ((NewButtonsCollectionViewCell*)cellFrom).cellSubView.frame;
        
        CGRect subViewFrameTo;
        
        //in case that suview's frame dos'nt equal view frame
        subViewFrame.origin.x =cellFrom.frame.origin.x;
        subViewFrame.origin.y =cellFrom.frame.origin.y;
        [subView setFrame:subViewFrame];
        subView.buttonColor = ((NewButtonsCollectionViewCell*)cellFrom).cellSubView.buttonColor;
        subView.title = ((NewButtonsCollectionViewCell*)cellFrom).cellSubView.title;
        
        [self.buttonsCollection addSubview:subView];
        cellTo.alpha = 0.;
        cellFrom.alpha = 0.;
        
        subViewFrameTo = ((NewButtonsCollectionViewCell*)cellTo).cellSubView.frame;
        //in case that suview's frame dos'nt equal view frame
        subViewFrameTo.origin.x =cellTo.frame.origin.x;
        subViewFrameTo.origin.y =cellTo.frame.origin.y;
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [subView setFrame:subViewFrameTo];
                         } completion:^(BOOL finished){
                             
                             //set to cellButtonTO properies of cellButtonFrom
                             ((NewButtonsCollectionViewCell*)cellTo).name = ((NewButtonsCollectionViewCell*)cellFrom).name;
                             ((NewButtonsCollectionViewCell*)cellTo).isUnderChanging = ((NewButtonsCollectionViewCell*)cellFrom).isUnderChanging;
                             ((NewButtonsCollectionViewCell*)cellTo).isEnable = ((NewButtonsCollectionViewCell*)cellFrom).isEnable;
                             ((NewButtonsCollectionViewCell*)cellTo).isChangeble = ((NewButtonsCollectionViewCell*)cellFrom).isChangeble;
                             ((NewButtonsCollectionViewCell*)cellTo).isAllovedToDelete = ((NewButtonsCollectionViewCell*)cellFrom).isAllovedToDelete;
                             [UIView animateWithDuration:.02
                                                   delay:0.
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  NSArray * pathesToReload = [NSArray arrayWithObjects:
                                                                              patchTo,
                                                                              nil];
                                                  [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
                                                  
                                                  [subView removeFromSuperview];
                                                  
                                              } completion:^(BOOL finished){
                                                  cellTo.alpha = 1.;
                                                  subView.alpha = 0.;
                                                  
                                              }
                              ];
                         }];
    }
    
}

//move array of buttonView inside NSTimer
-(void) moveButtonOfArray
{
    if(self.buttonsToMoveArray.count > 1){
        [self moveCellFromPosition:self.buttonsToMoveArray[1] toPosition:self.buttonsToMoveArray[0] withDuration:0.04];
        [self.buttonsToMoveArray removeObjectAtIndex:0];
    } else {
        
        [self.secondTimer invalidate];
    }
}


//move buttonView from global variable subCell and findCell
-(void) move
{
    //here is ok for all buttons
    NSIndexPath *findPatch = [self.buttonsCollection indexPathForCell:self.findCell];
    ButtonObject *findButtonObj = [self.allButtonObj objectAtIndex:findPatch.item];
    NSInteger findButtonObjPositionInCoreData = findButtonObj.position;
    //new position in changeble  array
    NSInteger indexFindButtonObjInChangebleArray = [self.changebleButtonObjs indexOfObject:findButtonObj];
    
    NSIndexPath *subPatch = [self.buttonsCollection indexPathForCell:self.subCell];
    ButtonObject *subButtonObj = [self.allButtonObj objectAtIndex:subPatch.item];
    NSInteger subButtonObjPositionInCoreData = subButtonObj.position;
   
    if(!self.secondTimer.isValid){
        
        NSMutableArray *mutableCahngebleArray = [self.changebleButtonObjs mutableCopy];
        [mutableCahngebleArray removeObject:subButtonObj];
        [mutableCahngebleArray insertObject:subButtonObj atIndex:indexFindButtonObjInChangebleArray];
        self.changebleButtonObjs = [mutableCahngebleArray copy];

        [self moveButtonObjFromPosition:subButtonObjPositionInCoreData toPosition:findButtonObjPositionInCoreData];
        
        [self moveCellsFromPatch:subPatch toPatch:findPatch];
    }
}

//move buttons view from global subCell to view according data model changeble position
-(void) moveButtonObjFromPosition:(NSInteger)subPuttonObjPosition toPosition:(NSInteger)finButtonObjPosition
{
    if(subPuttonObjPosition > finButtonObjPosition){
        for(ButtonObject *buttonObj in self.allButtonObj){
            if(!buttonObj.isMain){
                if((buttonObj.position < subPuttonObjPosition)&& (buttonObj.position >= finButtonObjPosition)){
                    buttonObj.position +=1;
                } else if (buttonObj.position == subPuttonObjPosition){
                    buttonObj.position = finButtonObjPosition;
                }
            }
        }
    }else if (subPuttonObjPosition < finButtonObjPosition){
        for(ButtonObject *buttonObj in self.allButtonObj){
            if(!buttonObj.isMain){
                if((buttonObj.position > subPuttonObjPosition)&& (buttonObj.position <= finButtonObjPosition)){
                    buttonObj.position -=1;
                } else if (buttonObj.position == subPuttonObjPosition){
                    buttonObj.position = finButtonObjPosition;
                }
            }
        }
    }
    [self makeTwoArrays];
}

-(void) moveCellsFromPatch:(NSIndexPath*)subPatch toPatch:(NSIndexPath*)findPatch
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSIndexPath *patch = [self.buttonsCollection indexPathForCell:self.findCell];
    
    if(subPatch.item > findPatch.item){
        for(NSInteger i = subPatch.item; i >= findPatch.item; i-- ){
            ButtonObject* changeObject = [self.allButtonObj objectAtIndex:i];
            if((!changeObject.isMain) && ([self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patch]]))
                
                [mutArray addObject:[NSIndexPath indexPathForItem:i inSection:subPatch.section]];
        }
        
    } else if(subPatch.item < findPatch.item){
        for(NSInteger i = subPatch.item; i <= findPatch.item; i++ ){
            ButtonObject * changeObject = [self.allButtonObj objectAtIndex:i];
            if((!changeObject.isMain)  && ([self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patch]]))
                [mutArray addObject:[NSIndexPath indexPathForItem:i inSection:subPatch.section]];
        }
        
    }
    
    self.subCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:patch];
    self.buttonsToMoveArray = [NSMutableArray arrayWithArray:mutArray];
    self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                        target:self
                                                      selector:@selector(moveButtonOfArray)
                                                      userInfo:nil
                                                       repeats:YES];
}


//pan gesture
//two methodes to delet and redelete buttons with animation
- (IBAction)moveButtonToNewPosition:(UIPanGestureRecognizer *)panGesture
{
    if(panGesture.state == UIGestureRecognizerStateBegan){
        
    }
    if (panGesture.state == UIGestureRecognizerStateCancelled ){
        
    }
    if (panGesture.state == UIGestureRecognizerStateChanged){
        if (!self.animationTimer.isValid){
            //0. change position of subview
            CGPoint translation =[panGesture translationInView:self.buttonsCollection];
            self.buttonsAsSubView.center = CGPointMake(self.buttonsAsSubView.center.x + translation.x, self.buttonsAsSubView.center.y + translation.y);
            [panGesture setTranslation:CGPointZero inView:self.buttonsCollection];
            
            //change offset of buttonscollection according move subView
            if((self.buttonsAsSubView.center.y > 0)
               && ((self.buttonsAsSubView.center.y - self.buttonsCollection.contentOffset.y) <  2.5 *self.subCell.bounds.size.height)
               && (self.buttonsCollection.contentOffset.y > 0)){
                if(!self.wasInMoveOffsetSection){
                    CGFloat offset = self.buttonsCollection.contentOffset.y;
                    
                    //remove the line before
                    [self moveButtonsCollectioViewByOffsetDown:offset];
                }
            } else if ((self.buttonsAsSubView.center.y > 0)
                       && ((self.buttonsCollection.contentOffset.y + self.buttonsCollection.frame.size.height - self.buttonsAsSubView.center.y) <  1.5 *self.subCell.bounds.size.height)
                       && ((self.buttonsCollection.contentOffset.y +self.buttonsCollection.frame.size.height) < self.buttonsCollection.contentSize.height)){
                if(!self.wasInMoveOffsetSection){
                    CGFloat offset = self.buttonsCollection.contentSize.height - self.buttonsCollection.contentOffset.y - self.buttonsCollection.frame.size.height;
                    //replace thre line above
                    [self moveButtonsCollectioViewByOffsetUp:offset];
                    
                }
            } else {
                self.wasInMoveOffsetSection = NO;
            }
            
            //set buttons to new position and change data
            NSIndexPath *patch = [self.buttonsCollection indexPathForItemAtPoint:self.buttonsAsSubView.center];
            if(patch){
                self.findCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:patch];
                
                while (YES){
                    if(([self.changebleButtonObjs containsObject:[self.allButtonObj objectAtIndex:[self.buttonsCollection indexPathForCell:self.findCell].item]])
                       && (self.findCell.isEnable)){
                        break;
                    } else {
                        self.findCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:patch.item -1 inSection:patch.section]];
                        if(!self.findCell){
                            self.findCell = self.subCell;
                            break;
                        }
                        patch = [self.buttonsCollection indexPathForCell:self.findCell];
                    }
                    
                }
                
                if(![self.findCell isEqual:self.subCell]){
                    [self move];
                }
            }
        }
    }
    //2. calculate nearest enable cell
    //3. change the model???? ( needed to change this function in model
    //4. move the cells buttons views
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        //1. change the model!!
        
        //[self.buttonsAsSubView removeFromSuperview];
        
    }
}

//DELET and SET BUTTONS
//ok
//if allowedToDelete condition changed set alowedToDelete condition for each buttons
-(void)setIsAllowedToDelete:(BOOL)isAllowedToDelete
{
    if(_isAllowedToDelete != isAllowedToDelete){
        if(!isAllowedToDelete){
            for(NSInteger i = 0; i < self.changebleButtonObjs.count; i++){
                ButtonObject *butObj = self.changebleButtonObjs[i];
                butObj.alowedTodelete = NO;
            }
            [self makeTwoArrays];
            //[self makeAllButtonObjsArray];
            for(int i = 0; i < ([self.changebleButtonObjs  count] + 19); i ++){
                NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewCell* cell =[self.buttonsCollection cellForItemAtIndexPath:index];
                ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = NO;
            }
            
        } else {
            for(NSInteger i = 0; i < self.changebleButtonObjs.count; i++){
                ButtonObject *butObj = self.changebleButtonObjs[i];
                butObj.alowedTodelete = YES;
            }
            [self makeTwoArrays];
            //[self makeAllButtonObjsArray];
            
            for(int i = 0; i <self.allButtonObj.count; i ++){
                NSIndexPath * indexToCheck = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewCell* cellToCheck = [self.buttonsCollection cellForItemAtIndexPath:indexToCheck];
                if (((NewButtonsCollectionViewCell*)cellToCheck).isChangeble) {
                    ((NewButtonsCollectionViewCell*)cellToCheck).isAllovedToDelete = YES;
                }
            }
        }
    }
    
    //[self.buttonsCollection reloadData];
    _isAllowedToDelete = isAllowedToDelete;
}

- (IBAction)tapCloseCheckButton:(UIButton *)sender
{
    //pasr here
    //don't allow user to tap this button if there are button as subview in buttoncollection
    
    if(!self.buttonsAsSubView && !self.animationTimer.isValid){
        self.buttonsCollection.scrollEnabled = NO;
        CGPoint necessaryPoint = CGPointMake(sender.bounds.origin.x, sender.bounds.size.height);
        CGPoint buttonsLocation = [sender convertPoint:necessaryPoint toView:self.buttonsCollection];
        NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:buttonsLocation];
        if(indexPath){
            UICollectionViewCell* cell =[self.buttonsCollection cellForItemAtIndexPath:indexPath];
            if([cell isKindOfClass:[NewButtonsCollectionViewCell class]]){
                
                ButtonObject* button = [self.allButtonObj objectAtIndex:indexPath.item];
                
                if(button.enable){
                    
                    NSMutableArray *mutableChangebleButtonObjs = [self.changebleButtonObjs mutableCopy];
                    NSMutableArray *mutableDeletedButtonObjs = [self.delettedButtonObjs mutableCopy];
                    
                    [mutableChangebleButtonObjs removeObject:button];
                    [mutableDeletedButtonObjs insertObject:button atIndex:0];
                    
                    self.changebleButtonObjs = [mutableChangebleButtonObjs copy];
                    self.delettedButtonObjs = [mutableDeletedButtonObjs copy];
                    
                    [self makeTwoArrays];
                    
                    button.enable = !button.enable;
                    button.dateOfDeletting = [NSDate date];
                    
                    ((NewButtonsCollectionViewCell*)cell).isEnable  = !((NewButtonsCollectionViewCell*)cell).isEnable;
                    self.patch = indexPath; //set the start patch for moveButtonDownSelector
                    self.animationTimer  = [NSTimer scheduledTimerWithTimeInterval: 0.07
                                                                            target: self
                                                                          selector:@selector(moveButtonsDown)  //find the selector moveButtonsDown early
                                                                          userInfo: nil repeats:YES];
                    /*
                     cjeck the quantity of buttons and if ti less then 11 not main
                     buttons set AllovedToDelete in NO condition for all not hiden
                     buttons, another - set YES
                     */
                    
                    if((self.changebleButtonObjs.count +19) < 31){
                        self.isAllowedToDelete = NO;
                    } else {
                        self.isAllowedToDelete = YES;
                    }
                    
                } else {
                    
                    NSMutableArray *mutableChangebleButtonObjs = [self.changebleButtonObjs mutableCopy];
                    NSMutableArray *mutableDeletedButtonObjs = [self.delettedButtonObjs mutableCopy];
                    
                    [mutableDeletedButtonObjs removeObject:button];
                    //find neede position in short array
                    NSInteger i = 0;
                    while (i  < mutableChangebleButtonObjs.count){
                        ButtonObject *butObj = mutableChangebleButtonObjs[i];
                        if(butObj.position > button.position) break;
                        i++;
                    }
                    
                    [mutableChangebleButtonObjs insertObject:button atIndex:i];
                    
                    self.changebleButtonObjs = [mutableChangebleButtonObjs copy];
                    self.delettedButtonObjs = [mutableDeletedButtonObjs copy];
                    
                    [self makeTwoArrays];

                    button.enable = !button.enable;
                    button.dateOfDeletting = [NSDate distantFuture];
                    
                    ((NewButtonsCollectionViewCell*)cell).isEnable  = !((NewButtonsCollectionViewCell*)cell).isEnable;
                    self.itemOfNeedPosition = [self.allButtonObj indexOfObject:button];
                    self.patch = indexPath; //set the start patch for moveButtonDownSelector
                    self.animationTimer  = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                                            target: self
                                                                          selector:@selector(moveButtonsUp)  //find the selector moveButtonsDown early
                                                                          userInfo: nil repeats:YES];
                    
                    if((self.changebleButtonObjs.count +19) < 31){
                        self.isAllowedToDelete = NO;
                    } else {
                        self.isAllowedToDelete = YES;
                    }
                }
            }
        }
        self.buttonsCollection.scrollEnabled = YES;
    }
}

-(void) moveButtonsDown
{
    NSIndexPath * patchFrom =[NSIndexPath indexPathForItem: self.patch.item+1 inSection:self.patch.section];
    
    if(self.patch.item == (self.changebleButtonObjs.count +19)){
        [self.animationTimer invalidate];
        
        NSArray * pathesToReload = [NSArray arrayWithObjects:
                                    self.patch,
                                    nil];
        [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
        
    } else {
        //find next chngeble position
        //while position is lees than quantity of work button and cell is visible
        while ((patchFrom.item < (self.changebleButtonObjs.count +19)) &&
               
               [self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patchFrom]] && (self.isButtonsCollectionUnderChanging)){
            
            ButtonObject *buttonObject = [self.allButtonObj objectAtIndex:patchFrom.item];
            
            if(!buttonObject.isMain) {
                break;
            } else {
                patchFrom = [NSIndexPath indexPathForItem:patchFrom.item +1 inSection:patchFrom.section];
            }
        }
        
        [self moveCellFromPosition:patchFrom toPosition:self.patch withDuration:0.02];
        self.patch = patchFrom;
        
        if((self.patch.item > ((self.changebleButtonObjs.count +19) - 1))||
           (![self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:self.patch]])){
            [self.animationTimer invalidate];
            NSArray * pathesToReload = [NSArray arrayWithObjects:
                                        [NSIndexPath indexPathForItem: self.patch.item -1 inSection:self.patch.section],
                                        self.patch,
                                        nil];
            [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
        }
    }
}

-(void) moveButtonsUp
{
    NSIndexPath * patchFrom =[NSIndexPath indexPathForItem: self.patch.item - 1 inSection:self.patch.section];
    
    if(self.patch.item == self.itemOfNeedPosition){
        [self.animationTimer invalidate];
        NSArray * pathesToReload = [NSArray arrayWithObjects:
                                    self.patch,
                                    nil];
        [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
        
    } else {
        //find next chngeble position
        //while position is lees than quantity of work button and cell is visible
        while ((patchFrom.item > self.itemOfNeedPosition) &&
               [self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patchFrom]] && (self.isButtonsCollectionUnderChanging)){
            ButtonObject *buttonObject = [self.allButtonObj objectAtIndex:patchFrom.item];
            if(!buttonObject.isMain) {
                break;
            } else {
                patchFrom = [NSIndexPath indexPathForItem:patchFrom.item - 1 inSection:patchFrom.section];
            }
        }
        
        [self moveCellFromPosition:patchFrom toPosition:self.patch withDuration:0.02];
        self.patch = patchFrom;
        
        if((self.patch.item == self.itemOfNeedPosition)||
           (![self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:self.patch]])){
            [self.animationTimer invalidate];
            
            NSArray * pathesToReload = [NSArray arrayWithObjects:
                                        [NSIndexPath indexPathForItem: self.patch.item +1 inSection:self.patch.section],
                                        self.patch,
                                        nil];
            [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
        }
    }
}

#pragma mark - UICOLLECTIONS VIEW DELEGATE
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger section = 0;
    
    if(self.buttonManagedObjectContext){
        section = 1;
    }
    return section;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isButtonsCollectionUnderChanging? [self.allButtonObj count] : [self.workButtonsNames count] ;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Button" forIndexPath:indexPath];
    ((NewButtonsCollectionViewCell *)cell).delegate = (ButtonsCollectionView*)collectionView;
    ((NewButtonsCollectionViewCell *)cell).isIpadPortraitView = self.willBePortraitRotated;
    
    if([cell isKindOfClass:[NewButtonsCollectionViewCell class]]){
        NSInteger item = indexPath.item;
        if(self.isButtonsCollectionUnderChanging){
            ButtonObject *button = [self.allButtonObj objectAtIndex:item];
            
            
            ((NewButtonsCollectionViewCell*)cell).isEnable = button.enable;
            ((NewButtonsCollectionViewCell*)cell).isChangeble = !button.isMain;
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = self.isButtonsCollectionUnderChanging;
            ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = button.alowedTodelete;
            
            if([button.nameButton isEqualToString:@"."]){
                ((NewButtonsCollectionViewCell *)cell).name = [self point];
            } else if([button.nameButton isEqualToString:@".00"]){
                ((NewButtonsCollectionViewCell *)cell).name = [[self point] stringByAppendingString:@"00"];
            } else if ([button.nameButton isEqualToString:@"rad"]){
                if(self.isDecCounting){
                    ((NewButtonsCollectionViewCell *)cell).name = @"rad";
                } else {
                    ((NewButtonsCollectionViewCell *)cell).name = @"deg";
                }
            } else {
                ((NewButtonsCollectionViewCell *)cell).name = button.nameButton;
            }
            
        } else {
            NSString* nameFromModel = [self.workButtonsNames objectAtIndex:item];

            
            if([nameFromModel isEqualToString:@"."]){
                ((NewButtonsCollectionViewCell *)cell).name = [self point];
            } else if([nameFromModel isEqualToString:@".00"]){
                ((NewButtonsCollectionViewCell *)cell).name = [[self point] stringByAppendingString:@"00"];
            } else if ([nameFromModel isEqualToString:@"rad"]){
                if(self.isDecCounting){
                    ((NewButtonsCollectionViewCell *)cell).name = @"rad";
                } else {
                    ((NewButtonsCollectionViewCell *)cell).name = @"deg";
                }
            } else {
                ((NewButtonsCollectionViewCell *)cell).name = nameFromModel;
            }
        }
        
    }
    return cell;
}



#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize result;
    if(IS_IPAD) {
                if(self.willBePortraitRotated){
            if(self.isBigSizeButtons){
                result = CGSizeMake(140, 83);
            } else {
                result = CGSizeMake(117, 72);
            }
            //result = CGSizeMake(140, 83);
        } else {
            if(self.isBigSizeButtons){
                result = CGSizeMake(133, 71);
            } else {
                result = CGSizeMake(118, 59);
            }
        }
        
    } else { //if it's iPhone ore iPod
        if(self.isBigSizeButtons){
            result = CGSizeMake(76, 46);
        } else {
            result = CGSizeMake(60, 40);
        }
    }
    return  result;
}

-(NSInteger) numberColumsInCollectionView
{
    CGFloat oneButtonWidth = [self collectionView:self.buttonsCollection
                                           layout:self.collectionViewFlowLayout
                           sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].width;
    CGFloat collectionWidth;
    if(IS_IPAD) {
        

        
        if(self.willBePortraitRotated){
            collectionWidth = 768;
        } else {
            collectionWidth = 1024;
        }
    } else { //if it's iPhone ore iPod
        collectionWidth = 320;
    }
    return ABS(collectionWidth/oneButtonWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets;
    insets.bottom = 0;
    insets.left = 0;
    insets.right = 0;

    if(IS_IPAD) {
        if(self.willBePortraitRotated){
            insets.top = 129;

        } else {
            insets.top = 119;
  
        }
    insets.right = 11;
        insets.left = 11;
        
    } else {
        if(IS_568_SCREEN){
            insets.top = 82;
        } else {
            insets.top = 75;
        }
    }
    
    return insets;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat linespasing;
    if(IS_IPAD) {
        linespasing = 9;
    } else {
        if(IS_568_SCREEN){
            linespasing = 4;
        } else {
            linespasing = 3;
        }
    }
    return linespasing;
}


#pragma mark - UITABLE VIEW DATA SOURSE DELEGATE
-(void) resetHeightOfFirstCell
{
    NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
    
    NSAttributedString* stringInCell = [self resizeStrforFirstCell:[self getAttributedStringFromArray:self.lastRowDataArray]];
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize;
    if(IS_IPAD){
        neededSize = CGSizeMake(700, 1000);
    } else {
        neededSize = CGSizeMake(280, 1000);
    }
    CGFloat height;
    
    CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:drawContext];
    
    //set heigth of first cell according ios screen
    if(IS_IPAD){ // if iPad
        height = 85.;
        if(neededRect.size.height*1.2 > 60.){
            height = neededRect.size.height * 1.2 + 25;
        }
    } else if(IS_568_SCREEN){
        height = 65.;
        if(neededRect.size.height*1.2 > 48.){
            height = neededRect.size.height * 1.2 + 17;
        }
    } else {
        height = 60.;
        if(neededRect.size.height*1.2 > 43.){
            height = neededRect.size.height *1.2 + 17;
        }
    }
    [mutArray removeLastObject];
    [mutArray addObject:[NSNumber numberWithFloat:height]];
    self.heightsOfRows = [mutArray copy];

}

-(NSArray*) makeHeightsOfRowsArray
{
    NSArray * fetchedObjects = self.fetchedResultsController.fetchedObjects;
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize;
    if(IS_IPAD){
        neededSize = CGSizeMake(700, 1000);
    } else {
        neededSize = CGSizeMake(280, 1000);
    }
    CGFloat height;
    
    
    if([fetchedObjects count] > 0){
        
        for(int i = 0; i < [fetchedObjects count]; i++){
            if(IS_IPAD){ // if iPad
                height = 75;
            } else {
                height = 55;
            }
            NSAttributedString* stringInCell = [self getAttributedStringFronFetchForIndexPatch:[NSIndexPath indexPathForItem:i inSection:0]];
            
            
            CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:drawContext];
            if(IS_IPAD){
                if(neededRect.size.height > 55.){
                    height = neededRect.size.height + 20;
                }
            } else {
                if(neededRect.size.height > 39.){
                    height = neededRect.size.height + 16;
                }
            }
            
            [mutArray addObject:[NSNumber numberWithFloat:height]];
            
        }
    } else {
        
    }
    //set height for first row not from coreData
    if(!self.lastRowDataArray) self.lastRowDataArray = [[NSArray alloc] init]; //if no array till now
    NSAttributedString* stringInCell = [self resizeStrforFirstCell:[self getAttributedStringFromArray:self.lastRowDataArray]];
    
    CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:drawContext];
    
    //set heigth of first cell according ios screen
    if(IS_IPAD){ // if iPad
        height = 85.;
        if(neededRect.size.height*1.2 > 60.){
            height = neededRect.size.height * 1.2 + 25;
        }
    } else if(IS_568_SCREEN){
        height = 65.;
        if(neededRect.size.height*1.2 > 48.){
            height = neededRect.size.height * 1.2 + 17;
        }
    } else {
        height = 60.;
        if(neededRect.size.height*1.2 > 43.){
            height = neededRect.size.height *1.2 + 17;
        }
    }
    
    [mutArray addObject:[NSNumber numberWithFloat:height]];

    
    return [mutArray copy];
    
}

-(NSArray*) heightsOfRows
{
    if(!_heightsOfRows){
        _heightsOfRows = [self makeHeightsOfRowsArray];

    }
    return _heightsOfRows;
}

-(void) resetHeightsofRows
{
    self.heightsOfRows = [self makeHeightsOfRowsArray];
}

-(NSMutableAttributedString*) getAttributedStringFronFetchForIndexPatch:(NSIndexPath*) indexPath
{
    return [self getAttributedStringFromStory:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}


-(NSMutableAttributedString*) getAttributedStringFromStory:(History*) story
{
    return [self getAttributedStringFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:story.program]];
}


-(NSMutableAttributedString*) getAttributedStringFromArray:(NSArray*) array
{
   // History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSMutableArray *programFromHistory = [array mutableCopy];
    NSString *resultString = @"";
    id result = [programFromHistory lastObject];
    if(result){
        [programFromHistory removeLastObject];
        
        if(result && [result isKindOfClass:[NSNumber class]]){
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setExponentSymbol:@"e"];
            [numberFormatter setZeroSymbol:@"0"];
            if (fabs([result doubleValue])>9e9 || fabs([result doubleValue])<9e-9) {
                [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
                [numberFormatter setMaximumFractionDigits:7];
            }
            else{
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                double intPartLenght = log10(fabs([result doubleValue]));
                double intPart;//fractPart,
                modf(intPartLenght, &intPart);// fractPart =
                if(intPart <0) intPart = 0;
                [numberFormatter setMaximumFractionDigits:(9 - (int)intPart)];
            }
            
            resultString = [numberFormatter stringFromNumber:result];
            resultString = [@" = " stringByAppendingString:resultString];
        } else if (result && [result isKindOfClass:[NSString class]]){
            resultString = result;
        }
    }
    NSMutableAttributedString * resultAtrStr = [[NSMutableAttributedString alloc] initWithString:resultString attributes:self.attributes];
    
    
    NSMutableArray *argArrayCopy = [[NSMutableArray alloc] init];
    NSMutableArray *wholeProgramCopy = [[NSMutableArray alloc] init];
    id top = [programFromHistory lastObject];
    if(top && [top isKindOfClass:[NSArray class]]){
        [programFromHistory removeLastObject];
        argArrayCopy = [ACalcBrain deepArrayCopy:top];
        top = [programFromHistory lastObject];
        if(top && [top isKindOfClass:[NSArray class]]){
            [programFromHistory removeLastObject];
            wholeProgramCopy = [ACalcBrain deepArrayCopy:top];
        }
    }
    id topOfArgArray = [argArrayCopy lastObject];
    //add arg as stack but not add argu as stack if it isn't strong argu
    if( topOfArgArray && [topOfArgArray isKindOfClass:[NSArray class]]){
        id topOfWhlPrgLastObj = [wholeProgramCopy lastObject];
        if([topOfWhlPrgLastObj lastObject]){
            [wholeProgramCopy.lastObject addObject:topOfArgArray];
        } else {
            for(id stc in topOfArgArray){
                [wholeProgramCopy.lastObject addObject:stc];
            }
        }
        
    } else if([argArrayCopy count] > 0){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
    } else if([argArrayCopy count] > 1){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
    }
    
    
    NSAttributedString *stringProgram = [ACalcBrain descriptionOfProgram:wholeProgramCopy withAttributes:self.attributes];
    [resultAtrStr insertAttributedString:stringProgram atIndex:0];
    
    return resultAtrStr;
    
}

-(NSAttributedString*) resizeStrforFirstCell:(NSAttributedString*) inputStr
{
    NSMutableAttributedString* resultString = [inputStr mutableCopy];
    
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        NSString *fontName = nil;
        NSArray *famalyNames  =[UIFont familyNames];
        if([famalyNames containsObject:@"Helvetica Neue"]){
            NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
            if([fontNames containsObject:@"HelveticaNeue"]){
                fontName = @"HelveticaNeue";
            }
            
        }
        
        UIFont *font; //if there is no needed font
        if(fontName){
            font = [UIFont fontWithName:[UIFont systemFontOfSize:17].fontName size:wasFont.pointSize*1.1];
        }else {
            font =[UIFont boldSystemFontOfSize:wasFont.pointSize*1.1];
        }
        UIColor *textColor;
        if(IS_BLACK_MODE){
            textColor = [UIColor lightTextColor];
        } else {
            textColor = [UIColor darkTextColor];
        }
        
        [symbolString beginEditing];
        NSRange wholeRange = NSMakeRange(0, [symbolString length]);
        [symbolString addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [symbolString addAttribute:NSFontAttributeName value:font range:wholeRange];
        [symbolString endEditing];
        
        [resultString replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:symbolString];
    }
    
    return [resultString copy];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.historyTable dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if([cell isKindOfClass:[HistroryTableViewCell class]]){

        
        
        ((HistroryTableViewCell*)cell).delegate = self;
        
        if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            ((HistroryTableViewCell*)cell).isCanDrag = NO;

            ((HistroryTableViewCell*)cell).historyDateString = @"";
            if(!self.lastRowDataArray) self.lastRowDataArray = [[NSArray alloc] init];//if no array till now
            NSAttributedString *resultAtrStr = [self getAttributedStringFromArray:self.lastRowDataArray];
            ((HistroryTableViewCell*)cell).historyProgramString = [self resizeStrforFirstCell:[resultAtrStr copy]];
            ((HistroryTableViewCell*)cell).programTextView.delegate = self;
            //if(![self.historyTable indexPathForSelectedRow]){
             //  [self.historyTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
           //}
        } else {
           // NSIndexPath *needPatch = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            NSIndexPath *needPatch = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            History *story = [self.fetchedResultsController objectAtIndexPath:needPatch];
            
            NSMutableAttributedString * resultAtrStr = [self getAttributedStringFronFetchForIndexPatch:indexPath];
            ((HistroryTableViewCell*)cell).isCanDrag = YES;
            ((HistroryTableViewCell*)cell).historyProgramString = [resultAtrStr copy];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
            ((HistroryTableViewCell*)cell).historyDateString = [dateFormatter stringFromDate:story.date];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60;
    if([self.heightsOfRows count] > 0){
            height = [[self.heightsOfRows objectAtIndex:indexPath.row] floatValue];
    }
    
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections;
    if([[self.fetchedResultsController sections] count] > 0){
        sections = [[self.fetchedResultsController sections] count];
    } else {
      sections = 1 ;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return one more rows than in fatched result controller
    NSInteger rows = 1;
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects]+1;
    }
    
    if(rows == 1){
        self.noticeButton.enabled = NO;
    } else {
        self.noticeButton.enabled = YES;
    }
    
    return rows;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    if(indexPath.row != [tableView numberOfRowsInSection: 0] - 1){
        return YES;
    } else {
        return NO;
    }
}
#pragma mark TEXT VIEW DELEGATE
//hide "past/copy menu
/*
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}



- (void)textViewDidChangeSelection:(UITextView *)textView
{

    if([textView becomeFirstResponder]){
        NSRange selectedRangee = textView.selectedRange;
        selectedRangee.length = selectedRangee.location;
        selectedRangee.location = 0;
       // NSLog(@"Selected range: %@",[textView.attributedText attributedSubstringFromRange:selectedRangee].string);
        
        UITextPosition *newCursorPosition = [textView positionFromPosition:textView.beginningOfDocument offset:selectedRangee.length - 3];
        UITextRange *newSelectedRange = [textView textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
        [textView setSelectedTextRange:newSelectedRange];
    }
    
}
*/


#pragma mark - HistoryCellDelegate Methods

- (IBAction)historyTableLeftSwipeGesturerecognizer:(UISwipeGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.historyTable];
    NSIndexPath *indexPath = [self.historyTable indexPathForRowAtPoint:tapLocation];
    if(indexPath){
        if([[self.historyTable  cellForRowAtIndexPath:indexPath] isKindOfClass:[HistroryTableViewCell class]]){
            if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
                HistroryTableViewCell *tableCell = (HistroryTableViewCell*)[self.historyTable cellForRowAtIndexPath:indexPath];
                [tableCell showButtons];
            }
            [self.historyTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
}

- (IBAction)historyTableRightSwipeGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    
    CGPoint tapLocation = [sender locationInView:self.historyTable];
    NSIndexPath *indexPath = [self.historyTable indexPathForRowAtPoint:tapLocation];
    if(indexPath && ([[self.historyTable  cellForRowAtIndexPath:indexPath] isKindOfClass:[HistroryTableViewCell class]])){
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];
        [self.historyTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (IBAction)pressedDeleteButton:(UIButton *)sender
{
    if(self.selectedRow){
        [self cellDidSelectDelete:self.selectedRow];
    }
}

-(void)cellDidSelectDelete:(HistroryTableViewCell *)cell
{
    //self.historyTable.isNeedToSetOffsetToButton = NO;
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    
    if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
        History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:story];
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        if(lastRowPatch){
            [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self setSelectedRow:nil];
        }
    }
}

- (IBAction)pressedSelectedButton:(UIButton *)sender
{
    if(self.selectedRow){
        [self cellDidSelectRecount:self.selectedRow];
    }
}

-(void)cellDidSelectRecount:(HistroryTableViewCell*) cell
{
    
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
        
        History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSMutableArray *programFromHistory = [[NSKeyedUnarchiver unarchiveObjectWithData:story.program] mutableCopy];
        //set the just maket story
        if([programFromHistory lastObject]) [programFromHistory removeLastObject];
        
        NSMutableArray *argArrayCopy = [[NSMutableArray alloc] init];
        id top = [programFromHistory lastObject];
        [programFromHistory removeLastObject];
        if(top) argArrayCopy = [ACalcBrain deepArrayCopy:top];
        
        NSMutableArray *programCopy = [[NSMutableArray alloc] init];
        top = [programFromHistory lastObject];
        if(top) programCopy = [ACalcBrain deepArrayCopy:top];
        ACalcBrain *newBrain = [ACalcBrain initWithProgram:[programCopy copy] withArgu:[argArrayCopy copy]];
        
        self.brain = newBrain;
        [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
        self.isProgramInProcess = NO;
        self.isStronglyArgu = YES;
        self.userIsInTheMidleOfEnteringNumber = NO;
        [self showStringThrouhgmanagerAtEqualPress];
        
        [self discardChanging];
    }
}

-(void) cellDidSelect:(HistroryTableViewCell *)cell
{
   
    self.selectedRow = cell;
    /*
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    
    NSIndexPath *previousSelectedIndexPatch = [self.historyTable indexPathForCell:_selectedRow];
    NSIndexPath *nowSelectedIndexPatch = [self.historyTable indexPathForSelectedRow];
    
    if(previousSelectedIndexPatch.row != nowSelectedIndexPatch.row){
        
        //self.selectedRow = cell;
        if(!indexPath){
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
        }else if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
            self.recountButton.enabled = YES;
            self.deleteButton.enabled = YES;
        } else {
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
            
        }
    }
    if(!self.isTestViewOnScreen){
        [self showCount];
    }

*/
}


-(void) setSelectedRow:(HistroryTableViewCell *)selectedRow
{
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:selectedRow];

    NSIndexPath *previousSelectedIndexPatch = [self.historyTable indexPathForCell:_selectedRow];
    NSIndexPath *nowSelectedIndexPatch = [self.historyTable indexPathForSelectedRow];
    
    if(previousSelectedIndexPatch.row != nowSelectedIndexPatch.row){
        
        _selectedRow = selectedRow;
        if(!indexPath){
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
        }else if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
            self.recountButton.enabled = YES;
            self.deleteButton.enabled = YES;
        } else {
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
            
        }
    }
    if(![self.presentedViewController isKindOfClass:[ThirdController class]] && ![self.presentedViewController isKindOfClass:[SecondViewController class]]){
        [self showCount];
    }
}

#pragma mark - FETCHING
- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
           // NSLog(@"Predicate %@", self.fetchedResultsController.fetchRequest.predicate);
        } else {
          //  NSLog(@"No predicate");
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];

    } else {

    }
    //[self deleteEmptyProgram];
    [self resetHeightsofRows];
    [self.historyTable reloadData];
    [self moveHistoryTableContentToRightPosition];

}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            [self performFetch];
        } else {
            [self.historyTable reloadData];
        }
    }
    
    /*
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){

        [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];
    } else {

    }
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    */
}

#pragma mark - WORK WITH LAST ROW
-(void) setLastRowDataArray:(NSArray *)lastRowDataArray
{
    [self.historyTable beginUpdates];
    _lastRowDataArray = lastRowDataArray;
    [self resetHeightOfFirstCell];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0]-1  inSection:0];
    [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastRow]
                             withRowAnimation:UITableViewRowAnimationFade];
    [self.historyTable endUpdates];
   // [self.historyTable selectRowAtIndexPath:lastRow animated:NO scrollPosition:UITableViewScrollPositionBottom];

    //--------------------------
    //INSERTED HERE
    //________________________
    /*
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    */
    [self moveHistoryTableContentToRightPosition];
}


#pragma mark - NSFetchedResultsControllerDelegate
//what I need to change array
//NSDictionary new heights according number of added row
//NSset Deleted obj


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.historyTable beginUpdates];
    //make dictionary heights according number of row
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.historyTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationBottom];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.historyTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationBottom];
            break;
            
        case NSFetchedResultsChangeMove:

            break;
            
        case NSFetchedResultsChangeUpdate:
            
            break;

    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    
   // NSLog(@"IndexPatch - %ld", (long)indexPath.row);
   // NSLog(@"NewIndexPatch - %ld", (long)newIndexPath.row);
    switch(type)
    {
        case NSFetchedResultsChangeInsert:{

            
           // NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
            NSMutableDictionary *mutDiction = [self.heigthsOfNewRowsAccordingNewObjs mutableCopy];
            
            //CGFloat height = 55;
            CGFloat height;
            if(IS_IPAD){ // if iPad
                height = 75;
            } else {
                height = 55;
            }

            NSAttributedString *insertProgramStr = [self getAttributedStringFronFetchForIndexPatch:newIndexPath];
            NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
            CGSize neededSize;
            
            if(IS_IPAD){
                neededSize = CGSizeMake(700, 1000);
            } else {
                neededSize = CGSizeMake(280, 1000);
            }
            CGRect neededRect = [insertProgramStr boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading
                                                           context:drawContext];
            if(IS_IPAD){
                if(neededRect.size.height > 55.){
                    height = neededRect.size.height + 20;
                }
            } else {
                if(neededRect.size.height > 39.){
                    height = neededRect.size.height + 16;
                }
            }
            
            [mutDiction setObject:[NSNumber numberWithFloat:height] forKey:newIndexPath];

            //exactly here the place to show banner with delay
            if(!self.wasPurshaised){
                //check banner show counter
                //if ok banner not on the screen  - show it, without count incrise
                //if no - incrise counter
                if(!self.isIAdBannerOnScreen && self.isIAdBaneerAvailable){
                    if((self.bannerRequestCounter % TIMES_TO_LIMIT_IAD_BANNER) == 0){
                        [self ShowIAdBanner];
                    }
                     self.bannerRequestCounter++;
                }
            }
            self.heigthsOfNewRowsAccordingNewObjs = [mutDiction copy];
            //replace row above
            
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
            
            break;
            
        case NSFetchedResultsChangeDelete: {
            self.historyTable.isNeedToSetOffsetToButton = NO;
            NSMutableIndexSet *mutSet = [self.deletedIndexesSet mutableCopy];
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [mutSet addIndex:indexPath.row];
            self.deletedIndexesSet = [mutSet copy];
            
        }
            break;
            
        case NSFetchedResultsChangeUpdate:{

        }
            break;
            
        case NSFetchedResultsChangeMove:
            self.historyTable.isNeedToSetOffsetToButton = NO;
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
   
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
    
    //if there are new objs insert heights of rows
    if(self.heigthsOfNewRowsAccordingNewObjs.count > 0){
        NSMutableDictionary *mutDiction = [self.heigthsOfNewRowsAccordingNewObjs mutableCopy];
        //in loop find smalest row and insert at that index
        while(mutDiction.count > 0){
            NSArray *allKeys = [mutDiction allKeys];
            NSIndexPath *keyForSmalestIndex = allKeys.firstObject;
            NSInteger smalestIndex = keyForSmalestIndex.row ;
            for(NSInteger i=1; i < allKeys.count; i++){
                NSIndexPath* currentPatch = [allKeys objectAtIndex:i];
                if(currentPatch.row < smalestIndex){
                    
                    keyForSmalestIndex = currentPatch;
                    smalestIndex = currentPatch.row;
                }
            }
            [mutArray insertObject:[mutDiction objectForKey:keyForSmalestIndex] atIndex:smalestIndex];
            [mutDiction removeObjectForKey:keyForSmalestIndex];
        }
        self.heigthsOfNewRowsAccordingNewObjs = [mutDiction copy];
    }
    
    //if there are deleted objs delete heights of rows
    if(self.deletedIndexesSet.count >0){
        if([mutArray objectsAtIndexes:self.deletedIndexesSet]){
            [mutArray removeObjectsAtIndexes:self.deletedIndexesSet];
            self.deletedIndexesSet = [[NSIndexSet alloc] init];
        }
    }
    
    self.heightsOfRows = [mutArray copy];
    
    [self.historyTable endUpdates];
    //[self.historyTable reloadData];
    
    //!! Set that at history class!!!
    //------------------------------------------------------------
    [self moveHistoryTableContentToRightPosition];
    /*
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
       // self.historyTable.isNeedToSetOffsetToButton = YES;

        [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];
    } else {
       // self.historyTable.isNeedToSetOffsetToButton = YES;
    }

    

    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
    */



    
    /*
    NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
    [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    */
}

-(void)moveHistoryTableContentToRightPosition
{
    
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
        // self.historyTable.isNeedToSetOffsetToButton = YES;
        
        [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];

    } else {
          [self.historyTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        // self.historyTable.isNeedToSetOffsetToButton = YES;
    }
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }

    
    
}

#pragma mark SHOW VIEW

- (IBAction)tappedRealNoticeButton:(UIButton *)sender
{
    self.callShowController = YES;
}

//tapped at share button in table condition
- (IBAction)tappedNoticeButton:(UIButton *)sender
{
    //sharing resulr of counting
    if([self.historyTable numberOfRowsInSection:0] > 0) {
    
        NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
        if(!indexPath) indexPath = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        NSMutableAttributedString *atrStrFromString;
        if(indexPath.row == ([self.historyTable numberOfRowsInSection:0]-1)){
            atrStrFromString =  [[self getAttributedStringFromArray:self.lastRowDataArray] mutableCopy];
        } else {
            atrStrFromString =  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        }
        NSString *strToShare = atrStrFromString.string;
        if(strToShare.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                NSString *lastSymbol = [strToShare substringWithRange:NSMakeRange(strToShare.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    NSAttributedString *result = [[NSAttributedString alloc] initWithString:self.display.attributedText.string attributes:self.attributes];
                    [atrStrFromString insertAttributedString:result atIndex:atrStrFromString.length];
                }
            }
            UIColor *textColor;
            textColor = [UIColor darkGrayColor]; //color of text
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentLeft;
            //Change fontName to Helvetica Neue Light
            NSString *fontName = nil;
            NSArray *famalyNames  =[UIFont familyNames];
            if([famalyNames containsObject:@"Helvetica Neue"]){
                NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
                if([fontNames containsObject:@"HelveticaNeue-Light"]){
                    fontName = @"HelveticaNeue-Light";
                }
            }
            CGFloat fontSize = 17.0;
            UIFont *system = [UIFont systemFontOfSize:fontSize];
            UIFont *font; //if there is no needed font
            if(fontName){
                font = [UIFont fontWithName:system.fontName size:fontSize];
            }else {
                font =[UIFont boldSystemFontOfSize:fontSize];
            }
            
            NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];


            NSMutableAttributedString *mutSTR = [[NSMutableAttributedString alloc] initWithString:strToShare attributes:attr];
        
            NSArray *activityItems = [[NSArray alloc] initWithObjects:mutSTR, nil];
        
            UIActivityViewController *activity = [[UIActivityViewController alloc]
                                                  initWithActivityItems:activityItems
                                                  applicationActivities:nil];
            activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
            activity.popoverPresentationController.sourceView = self.view;

            [self presentViewController:activity animated:YES completion:nil];
        }
        
    }
    
}


-(void) documentIsReady:(UIManagedDocument*) document
{
    if(document.documentState == UIDocumentStateNormal){
        self.managedObjectContext = document.managedObjectContext;
        NSManagedObjectContext *buttonContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [buttonContext setParentContext:self.managedObjectContext];
        self.buttonManagedObjectContext = buttonContext;

    }
}
#pragma mark ICLOUD SETUP

-(void) migrateDataToNewStorage:(NSURL*) newStorageURL
{
    NSLog(@"Need to migrate to URL %@", newStorageURL);
}



-(void) iCloudAccountChanged:(NSNotification*)notification
{
  //  NSLog(@"Storage did change");
}

-(void)cloudDidChange:(NSNotification*)notification
{
 //   NSLog(@"cloud Did Change %@", notification);// %@", [notification userInfo]);
}

-(void)cloudWillChange:(NSNotification*)notification
{
   // NSLog(@"cloud will Change");

    [self.managedObjectContext performBlock:^{
        if([self.doc.managedObjectContext hasChanges]){
            NSError *saveError;
            if(![self.doc.managedObjectContext save: &saveError]){
              //  NSLog(@"Save error: %@", saveError);
            }
        } else {
            [self.doc.managedObjectContext reset];
        }
        [self performSelectorOnMainThread:@selector(performFetch)
                              withObject:nil waitUntilDone:NO];
        [self.doc.managedObjectContext processPendingChanges];

    }];
    
}

-(void) performBlockContext
{
    [self.managedObjectContext performBlock:^{
        if([self.doc.managedObjectContext hasChanges]){
            NSError *saveError;
            if(![self.doc.managedObjectContext save: &saveError]){
               // NSLog(@"Save error: %@", saveError);
            }
        } else {
            [self.doc.managedObjectContext reset];
        }
        [self performSelectorOnMainThread:@selector(performFetch)
                               withObject:nil waitUntilDone:NO];
        [self.doc.managedObjectContext processPendingChanges];
        
    }];
}

-(void)cloudContentChange:(NSNotification*) notification
{
   // NSLog(@"content did chnage %@", notification);

    if([notification.description containsString:@"Buttons"]){
       // NSLog(@"Buttons was changed");
        [self.doc.managedObjectContext performBlock:^{
            [self.doc.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
            self.buttonManagedObjectContext = [self removeDuplicateRecordsFromContext:self.doc.managedObjectContext];
            [self setUpArrays];
            [self.buttonsCollection reloadData];
            
        }];
        
    } else {
      //  NSLog(@"Button didn't changed");
    }
                
    if ([notification.description containsString:@"History"]){
        [self.doc.managedObjectContext performBlock:^{
            [self.doc.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
            
        }];
    } else {
       // NSLog(@"History didn't change");
    }
    

    
}


-(void) setStoreNotifications
{
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(cloudDidChange:)
                                                   name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(cloudWillChange:)
                                                   name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(cloudContentChange:)
                                                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                 object:nil];
}

-(void) removeStoreNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:nil];

}

#pragma mark CHANGE_STORAGE

-(void) migrateToiCloudstorage:(BOOL)isiCloud
{
    if(self.doc){
        [self.doc updateChangeCount:UIDocumentChangeDone];
        NSPersistentStoreCoordinator *pcs =[self.doc.managedObjectContext persistentStoreCoordinator];
        UIManagedDocument *oldDoc = self.doc;
        
        NSPersistentStore *store = [pcs.persistentStores objectAtIndex:0];
        
        if(isiCloud){
            
            NSString* documentName = @"MyCloudDocument";
            NSDictionary *ubiquityOptions = @{NSPersistentStoreUbiquitousContentNameKey:documentName,
                                              NSPersistentStoreUbiquitousContentURLKey: self.iCloudURL,
                                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                                              NSInferMappingModelAutomaticallyOption:@YES};
            
            UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:self.storeURL];
            document.persistentStoreOptions = ubiquityOptions;

            if ([[NSFileManager defaultManager] fileExistsAtPath:[self.storeURL path]]) {
                [document openWithCompletionHandler:^(BOOL success) {
                    if (success) {
                        NSPersistentStoreCoordinator *newCoord = document.managedObjectContext.persistentStoreCoordinator;
                        NSPersistentStore *newStore= [newCoord.persistentStores objectAtIndex:0];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSError* error;
                            [pcs migratePersistentStore:store
                                                  toURL:newStore.URL
                                                options:ubiquityOptions
                                               withType:store.type
                                                  error:&error];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self documentIsReady:document];
                                self.doc = document;
                                [self setStoreNotifications];
                                        
                                [oldDoc closeWithCompletionHandler:^(BOOL success) {
                                    if(!success){
                                    //  NSLog(@"Close old document not sucesseful");
                                    } else {
                                        // NSLog(@"Close old sucesseful");
                                    }
                                    NSError *removeFileError;
                                    [[NSFileManager defaultManager] removeItemAtURL:self.localStoreUrl error:&removeFileError];
                                }];
                                        
                                        
                            });
                                    
                        });

                    }
                }];

            } else {
                [document saveToURL:self.storeURL forSaveOperation:UIDocumentSaveForCreating
                  completionHandler:^(BOOL success) {
                      if (success) {
                          NSPersistentStoreCoordinator *newCoord = document.managedObjectContext.persistentStoreCoordinator;
                          NSPersistentStore *newStore= [newCoord.persistentStores objectAtIndex:0];

                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                              NSError* error;
                              [pcs migratePersistentStore:store
                                                    toURL:newStore.URL
                                                  options:ubiquityOptions
                                                 withType:store.type
                                                    error:&error];
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self documentIsReady:document];
                                  self.doc = document;
                                  [self setStoreNotifications];
                                  
                                  [oldDoc closeWithCompletionHandler:^(BOOL success) {
                                      if(!success){
                                         // NSLog(@"Close old document not sucesseful");
                                      } else {
                                        //  NSLog(@"Close old sucesseful");
                                          NSError *removeFileError;
                                          [[NSFileManager defaultManager] removeItemAtURL:self.localStoreUrl error:&removeFileError];
                                      }
                                }];
                                  
                                  
                            });
                              
                        });

                      }
                  }];
            }
            
        } else {

            NSDictionary *localOptions = @{NSPersistentStoreRemoveUbiquitousMetadataOption:@YES,
                                           NSMigratePersistentStoresAutomaticallyOption:@YES,
                                           NSInferMappingModelAutomaticallyOption:@YES};
            
            NSString* documentName = @"MyCloudDocument";//@"MyDocument.sqlite"
            NSDictionary *ubiquityOptions = @{NSPersistentStoreUbiquitousContentNameKey:documentName,
                                              NSPersistentStoreUbiquitousContentURLKey: self.iCloudURL,
                                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                                              NSInferMappingModelAutomaticallyOption:@YES};
            
            // Remove any local file
            // We should check if a filename exists and then create a new filename using a counter...
            // because its possible to have more than one file with the same user filename in iCloud
            
            [[NSFileManager defaultManager] removeItemAtURL:self.localStoreUrl error:nil];
            
            
            UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:self.localStoreUrl];
            

            document.persistentStoreOptions = localOptions;
            
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self.localStoreUrl path]]) {
                [document openWithCompletionHandler:^(BOOL success) {
                    if (success) {
                        NSPersistentStoreCoordinator *newCoord = document.managedObjectContext.persistentStoreCoordinator;
                        NSPersistentStore *newStore= [newCoord.persistentStores objectAtIndex:0];
                        
                        // Now remove the existing store
                        NSError *removeStoreError;
                        if([newCoord removePersistentStore:newStore error:&removeStoreError]){
                            id sourceStore = [newCoord addPersistentStoreWithType:NSSQLiteStoreType
                                                                    configuration:nil
                                                                              URL:store.URL
                                                                          options:ubiquityOptions
                                                                            error:nil];
                            if (!sourceStore) {
                                
                             //   NSLog(@" failed to add old store");
                                
                            } else {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    NSError *error;
                                
                                    [newCoord migratePersistentStore:sourceStore
                                                               toURL:newStore.URL
                                                             options:localOptions
                                                            withType:NSSQLiteStoreType
                                                               error:&error];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self documentIsReady:document];
                                        self.doc = document;
                                        [oldDoc closeWithCompletionHandler:^(BOOL success) {
                                            if(!success){
                                             //   NSLog(@"Close old document not sucesseful");
                                            } else {
                                             //   NSLog(@"Close old sucesseful");
                                            }
                                        }];
                                    });
                                    
                                });
                                

                            }
                        }
                    
                    }
                }];
            } else {
                [document saveToURL:self.localStoreUrl forSaveOperation:UIDocumentSaveForCreating
                  completionHandler:^(BOOL success) {
                      if (success) {
                          if (success) {
                              NSPersistentStoreCoordinator *newCoord = document.managedObjectContext.persistentStoreCoordinator;
                              NSPersistentStore *newStore= [newCoord.persistentStores objectAtIndex:0];
                              
                              // Now remove the existing store
                              NSError *removeStoreError;
                              if([newCoord removePersistentStore:newStore error:&removeStoreError]){
                                  id sourceStore = [newCoord addPersistentStoreWithType:NSSQLiteStoreType
                                                                          configuration:nil
                                                                                    URL:store.URL
                                                                                options:ubiquityOptions
                                                                                  error:nil];
                                  if (!sourceStore) {
                                      
                                     // NSLog(@" failed to add old store");
                                      
                                  } else {
                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                          NSError *error;
                                          
                                         [newCoord migratePersistentStore:sourceStore
                                                                    toURL:newStore.URL
                                                                  options:localOptions
                                                                 withType:NSSQLiteStoreType
                                                                    error:&error];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self documentIsReady:document];
                                              self.doc = document;
                                              [oldDoc closeWithCompletionHandler:^(BOOL success) {
                                                  if(!success){
                                                     // NSLog(@"Close old document not sucesseful");
                                                  } else {
                                                    //  NSLog(@"Close old sucesseful");
                                                  }
                                              }];
                                          });
                                          
                                      });
                                      
                                      
                                  }
                              }
                          }
                      }
                  }];
            }
        }
    }
}


-(void) userDidChangeStorage:(BOOL)isiCloudInUse
{
    [self migrateToiCloudstorage:isiCloudInUse];
}

- (IBAction)isiCloudSwitch:(UISwitch *)sender
{
    if(sender.isOn){
        self.isiCloudInUse = YES;
    } else {
        self.isiCloudInUse = NO;
    }
}

-(void) setIsiCloudInUse:(BOOL)isiCloudInUse
{
    if(_isiCloudInUse != isiCloudInUse){
        [self userDidChangeStorage:isiCloudInUse];
    }
    
    _isiCloudInUse = isiCloudInUse;
    if(_isiCloudInUse != self.isiCloudUseSwitcher.on) {
        [self.isiCloudUseSwitcher setOn:_isiCloudInUse];
        
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isiCloudInUse]
                                             forKey:@"userUseiCloud"];
}



-(void) askUserForiCloudStorage
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
        NSOperationQueue *mainqeue = [NSOperationQueue mainQueue];
        [mainqeue addOperationWithBlock:^{
            if (currentiCloudToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: CHOOSE_STORAGE
                                                                message: nil //SHOUD_STORAGE_BE_IN_ICLOUD
                                                               delegate:self
                                                      cancelButtonTitle:USE_ICLOUD
                                                      otherButtonTitles:LOCAL_ONLY, nil];
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO]
                                                         forKey:@"firstLuanchValueStorage"];
                self.fristLunchWithicloudAvailable = NO;
                [alert show];
            }

        }];
        
    }];
    
}

#pragma mark SETUP_STORAGE

-(NSURL*) localStoreUrl
{
    if(!_localStoreUrl){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
        NSString* documentName = @"MyDocument";//@"MyDocument.sqlite"
        
        _localStoreUrl =  [documentsDirectory URLByAppendingPathComponent:documentName];
    }
    return _localStoreUrl;
}


-(NSURL*)storeURL
{
    if(!_storeURL){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
        NSString* documentName = @"MyCloudDocument";//@"MyDocument.sqlite"
    
        _storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    }
    return _storeURL;
}

-(NSURL*)iCloudURL
{
    if(!_iCloudURL){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString* documentName = @"MyCloudDocument";//@"MyDocument.sqlite"
        _iCloudURL = [[fileManager URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent: documentName];

    }
    return _iCloudURL;
}

-(void) setupLocalUIManagedDocument
{
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:self.localStoreUrl];
    
    NSDictionary *localOptions = @{
                                   NSPersistentStoreRemoveUbiquitousMetadataOption:@YES,
                                   NSMigratePersistentStoresAutomaticallyOption:@YES,
                                   NSInferMappingModelAutomaticallyOption:@YES};
    document.persistentStoreOptions = localOptions;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.localStoreUrl path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success){
                [self documentIsReady: document];
            } else {
              //  NSLog(@"Not succes with open");
            }
        }];
    } else {
        [document saveToURL:self.localStoreUrl forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  [self documentIsReady: document];
              } else {
               //   NSLog(@"Not succes with open");
              }
          }];
    }
    
    //try to save core data through update document
    self.doc = document;
    
}

-(void) setupiCloudUIManagedDocument
{
    //init managed document
    NSString* documentName = @"MyCloudDocument";//@"MyDocument.sqlite"
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:self.storeURL];
    
    NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey:documentName,
                              NSPersistentStoreUbiquitousContentURLKey: self.iCloudURL,
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption:@YES};
    document.persistentStoreOptions = options;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.storeURL path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
              [self documentIsReady: document];

            }
        }];
    } else {
        [document saveToURL:self.storeURL forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success){
                  [self documentIsReady: document];
              }
          }];
    }
    //try to save core data through update document
    self.doc = document;

    [self setStoreNotifications];
}


-(void) setupStorage
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iCloudAccountChanged:)
                                                 name:NSUbiquityIdentityDidChangeNotification
                                               object:nil];
    
    if(self.isiCloudInUse){
        [self setupiCloudUIManagedDocument];
    } else { //set up Local Storage
        [self setupLocalUIManagedDocument];
    }
}

-(void) checkForiCloud
{
    id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if(currentiCloudToken){
        NSData *newTokenData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
        [[NSUserDefaults standardUserDefaults]
         setObject:newTokenData
         forKey:@"com.apple.ItsCalc.UbiquityIdentyToken"];
        self.isiCloudUseSwitcher.enabled = YES;
        
    } else {
        [[NSUserDefaults standardUserDefaults]
         removeObjectForKey:@"com.apple.ItsCalc.UbiquityIdentyToken"];
        self.isiCloudInUse = NO;
        self.isiCloudUseSwitcher.enabled = NO;
    }
}

#pragma mark VIEW_DID_LOAD
- (void)viewDidLoad
{


    //[UIDevice currentDevice]
    //for testing delegate
    //set Hegths of ellement according screen height
    
    
    //check the first launch with available iCloud
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"firstLuanchValueStorage"]){
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES]
                                                 forKey:@"firstLuanchValueStorage"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO]
                                                 forKey:@"userUseiCloud"];

        self.fristLunchWithicloudAvailable = YES;
        self.isiCloudInUse = NO;
    } else {
        self.fristLunchWithicloudAvailable = [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLuanchValueStorage"] boolValue];
        self.isiCloudInUse = [[[NSUserDefaults standardUserDefaults]
                              objectForKey:@"userUseiCloud"] boolValue];
    }
    [self checkForiCloud]; //set enable iCloud switcher and possibility of iCloud
    if(self.isiCloudInUse){
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateKVStoreItems:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        
        //Important.What is this
        [store setString:@"Test" forKey:@"Test"];
        [store synchronize];
    }
    [self setupStorage];

    
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    UIGraphicsEndImageContext();

    
    self.settingsBottomButtn.hidden = YES;
    self.settingsBottomButtn.alpha = 0;
    
    self.noticeButton.hidden = YES;
    self.noticeButton.enabled = NO;
    self.noticeButton.alpha = 0;
    
    if(IS_IPAD){
        self.noticeRealButton.hidden = YES;
        //self.noticeRealButton.enabled = NO;
        self.noticeRealButton.alpha = 0.;
    }
    
    self.recountButton.hidden = YES;
    self.recountButton.enabled = NO;
    self.recountButton.alpha = 0;
    
    self.upButton.hidden = YES;
    self.upButton.alpha = 0;
    
    self.deleteButton.hidden = YES;
    self.deleteButton.enabled = NO;
    self.deleteButton.alpha = 0;
    
    self.settingsButton.hidden = YES;
    self.settingsButton.alpha = 0;
    
    self.downButton.hidden = YES;
    
    //set pan gesture delegate
    self.moveButtonsPanGestureRecognizer.delegate = self;
    self.isThreadInWork = NO;
    //key value iCloudStorage
    if([self extractKeyValuesFromStorage]){
        [self.display showString:[self.displayRam setResult:self.displayRam.resultNumber]];
        //[self showStringThruManageDocument];
    } else {
        [self.displayRam clearRam];//to key value
        [self.display showString:[self.displayRam addSymbol:@0]];//to key value
        
        self.display.firstMemoryLabel.text = @"";//to key value
        self.display.secondMemoryLabel.text = @"";//to key value
        self.display.decRadLabel.text = @"DEG";//to key value
        self.userIsInTheMidleOfEnteringNumber = YES;//to key value
        self.isProgramInProcess = NO;//to key value
        self.isStronglyArgu = NO;//to key value
        self.isResultFromMemory = NO;//to key value
        self.isDecCounting = YES;//to key value
        //Important WOKS With days trial
        self.isTrialPeriod = YES;
        
        //
        //
        self.nexNeedShovewTrialViewDay = 20;
        NSDate *date = [NSDate date];
        self.startTrialDate = date;
    }
    
    
    
    //USER DEFAULT
    id userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"wholeArray"];
    if(userDefault && [self extractFromUserDefault:userDefault]){

    } else {
        self.isBigDataBase = NO;
        self.isBigSizeButtons = YES;
        self.isSoundOn = YES;
        self.lastShowAllertViewDate = [NSDate date];
        self.counterForShowingAllertView = 26;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.currentProgrammVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    
    
    self.isSettingsViewOnScreen = NO;
    self.isBottomSettingsViewOnScreen = NO;
    self.SettingsView.hidden = YES;
    self.settingsBackgroundToolBar.hidden = YES;
    
    self.historyTable.allowsMultipleSelectionDuringEditing = NO;
    self.historyTable.allowsMultipleSelection = NO;
    if(IS_BLACK_MODE){
        [self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
        [self.buttonsCollection setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    } else {
        [self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appWillGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];

    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appDidEnterBackground)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appDidGoToForeground:)
                                                   name:UIApplicationDidBecomeActiveNotification
                                                 object:[UIApplication sharedApplication]];
    
  
    

    //set to 0 indication of previous rotation, also need at discard changing
    self.wasRightShowed = 0;
    
    //purchaising and banner
    id wasPurchaised = [[NSUserDefaults standardUserDefaults] objectForKey:@"wasPurchaisedMark"];
    if(wasPurchaised && [wasPurchaised isKindOfClass:[NSNumber class]]){
        self.wasPurshaised = [wasPurchaised boolValue];
    } else {
        self.wasPurshaised = NO;
    }
    if(!self.wasPurshaised){
        
        self.isIAdBaneerAvailable = NO;
        self.isIAdBannerOnScreen = NO;
        //set initial banners frame
        NSInteger bannerHeight;
        if(IS_IPAD){
            bannerHeight = 66;
        } else {
            bannerHeight = 50;
        }

        [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, bannerHeight)];
        [self.iAdBanner setFrame:self.bannerContainerView.bounds];
        self.bannerContainerView.hidden = YES;

        self.bannerRequestCounter = 2;
        
    } else {
        self.bannerContainerView.hidden = YES;
    }
    [self setHeightOfElementAccordingToScreenIPhone];
    //Important don't remember why i close it
    [self initialLayoutDynamiccontainer];
    //set the sounds properties
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"caf"];
    self.errorSoundFileURLRef =  [NSURL fileURLWithPath:soundPath];
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID  ((__bridge CFURLRef)self.errorSoundFileURLRef, &_errorSoundFileObject);
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"tap" ofType:@"caf"];
    self.tapSoundFileURLRef =  [NSURL fileURLWithPath:soundPath];
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID  ((__bridge CFURLRef)self.tapSoundFileURLRef, &_tapsoundFileObject);
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"shutter" ofType:@"caf"];
    self.shutterSoundFileURLRef =  [NSURL fileURLWithPath:soundPath];
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID  ((__bridge CFURLRef)self.shutterSoundFileURLRef, &_shutterSoundFileObject);
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"m4a"];
    self.blankSoundFileURLRef =  [NSURL fileURLWithPath:soundPath];
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID  ((__bridge CFURLRef)self.blankSoundFileURLRef, &_blankSoundFileObject);
    //replace from show count

    
    self.isHistoryWholeShowed = 0;
    //set other cursor color
    //transition to third controller
    self.callShowController = NO;
}



//this function need to send message about changing iPad rotation
/*
-(void) setWillBePortraitRotated:(BOOL)willBePortraitRotated
{
    _willBePortraitRotated = willBePortraitRotated;
    if(IS_IPAD){
        self.displayRam.isIpadPortraitView = willBePortraitRotated;
    } else {
       // if(willBePortraitRotated){
       //     [self rotateToPortraitViewIPhone];
      //  } else {
            if(self.hintView){
                 //if there ara hint view - remove it
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.hintView.alpha = 0;
                                 } completion:^(BOOL finished) {
                                     [self.hintView removeFromSuperview];
                                 }];
                
            }
            //[UIView setAnimationsEnabled:NO];
           // if(self.wasRotatedNotificationAnotherController == UIInterfaceOrientationLandscapeLeft || self.wasRotatedNotificationAnotherController == UIInterfaceOrientationLandscapeRight){
                
           //     [self orientationChangedToOrientation:self.wasRotatedNotificationAnotherController fromNotification:NO];
           //     self.wasRotatedNotificationAnotherController = 0;
           // }
       // }
    }
}
*/

#pragma mark VIEW LAYOUT

-(void) setLayOutOfSettingsView:(CGRect)rect
{
    CGFloat mainHeight = rect.size.height;
    CGFloat mainWidth = rect.size.width;
    self.cloudOnView.on = YES;
    self.cloudOffView.on = NO;
    
    self.soundOff.on = NO;
    self.soundOn.on = YES;
    
    self.archivesizeBigView.isBig=YES;
    self.archsizeViewSmall.isBig=NO;
    
    //self.clearHistoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.keyboardDefaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buyAdditionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //self.clearHistoryButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.keyboardDefaultButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.buyAdditionsButton.titleLabel.adjustsFontSizeToFitWidth = YES;


    
    
    if(IS_IPAD){
        // CGFloat measure = (mainHeight - self.displayContainer.frame.size.height )/ 4;
        CGFloat measure = (mainHeight)/5;
        CGFloat part = mainWidth /3; //
        CGFloat startSectionOne = part / 4;
        CGFloat startSectionTwo = startSectionOne + part + (part/2);
        
        CGFloat centerFirstLine =startSectionOne + (part / 2);
        CGFloat firstLinePicture = centerFirstLine - 85;
        CGFloat secondLinePicture = centerFirstLine + 85;
        
        CGFloat centerSecondLine = startSectionTwo + (part / 2);
        CGFloat thirstLinePicture = centerSecondLine - 85;
        CGFloat fourLinePicture = centerSecondLine + 85;
        
        
        //line one part one
        [self.smallButtonView setCenter:CGPointMake(firstLinePicture, measure)];
        [self.bigbuttonView setCenter:CGPointMake(secondLinePicture, measure)];
        [self.isBigSizeSwitcher setCenter:CGPointMake(centerFirstLine, measure)];
        self.buttonSwitcherLabel.text = NAME_BUTTON_SWITCH;
        [self.buttonSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.buttonSwitcherLabel setCenter:CGPointMake(centerFirstLine, measure - 60)];
        
        //line one part two
        [self.soundOff setCenter:CGPointMake(thirstLinePicture, measure)];
        //[self.soundOffView setCenter:CGPointMake(thirstLinePicture, measure)];
        [self.soundOn setCenter:CGPointMake(fourLinePicture, measure)];
        //[self.soundOnView setCenter:CGPointMake(fourLinePicture, measure)];
        [self.soundSwitcher setCenter:CGPointMake(centerSecondLine, measure)];
        
        self.soundSwitcherLabel.text = NAME_SOUND_SWITCH;
        [self.soundSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.soundSwitcherLabel setCenter:CGPointMake(centerSecondLine, measure - 60)];
        
        
        
        //line two part one
        //[self.smallDataBaseView setCenter:CGPointMake(firstLinePicture, 2*measure)];
        [self.archsizeViewSmall setCenter:CGPointMake(firstLinePicture, 2*measure)];
        //[self.bigDataBaseView setCenter:CGPointMake(secondLinePicture, 2*measure)];
        [self.archivesizeBigView setCenter:CGPointMake(secondLinePicture, 2*measure)];
        [self.isBigDataBaseSwitcher setCenter:CGPointMake(centerFirstLine, 2*measure)];
        self.archiveSwitcherLabel.text = NAME_ARCHIVE_SWITCH;
        [self.archiveSwitcherLabel setBounds:CGRectMake(0,0, 250, 20)];
        [self.archiveSwitcherLabel setCenter:CGPointMake(centerFirstLine, 2*measure - 60)];
        
        
        //line two part two
        [self.cloudOffView setCenter:CGPointMake(thirstLinePicture, 2*measure)];
        [self.cloudOnView setCenter:CGPointMake(fourLinePicture, 2*measure)];
        [self.isiCloudUseSwitcher setCenter:CGPointMake(centerSecondLine, 2*measure)];
        self.iCloudSwitcherName.text = NAME_ICLOUD_SWITCH;
        [self.iCloudSwitcherName setBounds:CGRectMake(0,0, 250, 20)];
        [self.iCloudSwitcherName setCenter:CGPointMake(centerSecondLine, 2*measure - 60)];
        
        //line three
        CGRect pictureButtonsRect = CGRectMake(0, 0, measure/1.5, measure/1.5);
        [self.clearHistoryButton setBounds:pictureButtonsRect];
        [self.clearHistoryButton setCenter:CGPointMake(centerFirstLine, 3*measure)];
        [self.changeDesignButton setBounds:pictureButtonsRect];
        [self.changeDesignButton setCenter:CGPointMake(centerSecondLine, 3*measure)];
        
        CGRect buttonsBounds = CGRectMake(0, 0, (rect.size.width - 4*INDENT)/3, measure-2*INDENT);
        //[self.clearHistoryButton setBounds:buttonsBounds];
        [self.keyboardDefaultButton setBounds:buttonsBounds];
        [self.buyAdditionsButton setBounds:buttonsBounds];
        
        if(self.isTrialPeriod){
            //[self.clearHistoryButton setCenter:CGPointMake(buttonsBounds.size.width/2+INDENT, 3*measure)];
            [self.keyboardDefaultButton setCenter:CGPointMake(firstLinePicture, 4*measure)];
            
            [self.processSpinner setCenter:CGPointMake(secondLinePicture, 4*measure - 40)];
            [self.buyAdditionsButton setCenter:CGPointMake(secondLinePicture, 4*measure)];
            
        } else if (self.wasPurshaised){
            //line three part one
            //[self.clearHistoryButton setCenter:CGPointMake(centerFirstLine, 3*measure)];
            
            //line three part two
            [self.keyboardDefaultButton setCenter:CGPointMake(rect.size.width/2, 3*measure)];
        } else {
            //line three part one
           // [self.clearHistoryButton setCenter:CGPointMake(centerFirstLine, 3*measure)];
            
            //line three part two
            [self.processSpinner setCenter:CGPointMake(rect.size.width/2, 4*measure - 40)];
            [self.buyAdditionsButton setCenter:CGPointMake(rect.size.width/2, 4*measure)];
        }
        
        
        
    } else {
        //CGFloat measure = (mainHeight- self.displayContainer.frame.size.height )/ 7;
        CGFloat measure = (mainHeight)/ 7;
        CGRect smallButtonFrame = self.smallButtonView.frame;
        smallButtonFrame.origin.y = measure - smallButtonFrame.size.height / 2;
        [self.smallButtonView setFrame:smallButtonFrame];
        
        CGRect bigButtonFrame = self.bigbuttonView.frame;
        bigButtonFrame.origin.y = measure - bigButtonFrame.size.height / 2;
        [self.bigbuttonView setFrame:bigButtonFrame];
        
        CGRect buttonsizeSwitcherFrame = self.isBigSizeSwitcher.frame;
        buttonsizeSwitcherFrame.origin.y = measure - buttonsizeSwitcherFrame.size.height / 2;
        [self.isBigSizeSwitcher setFrame:buttonsizeSwitcherFrame];
        
        CGRect sounSwitcherFrame = self.soundSwitcher.frame;
        sounSwitcherFrame.origin.y = 2 * measure - sounSwitcherFrame.size.height / 2;
        [self.soundSwitcher setFrame:sounSwitcherFrame];
        CGRect sounOffFrame = self.soundOff.frame;
        sounOffFrame.origin.y =2 * measure - sounOffFrame.size.height / 2;
        //[self.soundOffView setFrame:sounOffFrame];
        [self.soundOff setFrame:sounOffFrame];
        CGRect soundOnFrame = self.soundOn.frame;
        soundOnFrame.origin.y = 2 * measure - soundOnFrame.size.height / 2;
        //[self.soundOnView setFrame:soundOnFrame];
        [self.soundOn setFrame:soundOnFrame];
        
        CGRect bigDataSwitcher = self.isBigDataBaseSwitcher.frame;
        bigDataSwitcher.origin.y = 3 * measure - bigDataSwitcher.size.height / 2;
        [self.isBigDataBaseSwitcher setFrame:bigDataSwitcher];
        CGRect smallDataFrame = self.archsizeViewSmall.frame;
        smallDataFrame.origin.y =3 * measure - smallDataFrame.size.height / 2;
        [self.archsizeViewSmall setFrame:smallDataFrame];
        CGRect bigDataFrame = self.archivesizeBigView.frame;
        bigDataFrame.origin.y = 3 * measure - bigDataFrame.size.height / 2;
        [self.archivesizeBigView setFrame:bigDataFrame];
        
        CGRect iCloudSwitcherRect = self.isiCloudUseSwitcher.frame;
        iCloudSwitcherRect.origin.y = 4 * measure - iCloudSwitcherRect.size.height / 2;
        [self.isiCloudUseSwitcher setFrame:iCloudSwitcherRect];
        CGRect cloudOnFrame = self.cloudOnView.frame;
        cloudOnFrame.origin.y =4 * measure - cloudOnFrame.size.height / 2;
        [self.cloudOnView setFrame:cloudOnFrame];
        CGRect cloudOffFrame = self.cloudOffView.frame;
        cloudOffFrame.origin.y = 4 * measure - cloudOffFrame.size.height / 2;
        [self.cloudOffView setFrame:cloudOffFrame];
        
        /*
         CGRect smallDataFrame = self.smallDataBaseView.frame;
         smallDataFrame.origin.y =3 * measure - smallDataFrame.size.height / 2;
         [self.smallDataBaseView setFrame:smallDataFrame];
         CGRect bigDataFrame = self.bigDataBaseView.frame;
         bigDataFrame.origin.y = 3 * measure - bigDataFrame.size.height / 2;
         [self.bigDataBaseView setFrame:bigDataFrame];
         */
        
        CGRect clearHistoryButtonFrame = self.clearHistoryButton.frame;
        clearHistoryButtonFrame.origin.y = 5 * measure - clearHistoryButtonFrame.size.height / 2;
        [self.clearHistoryButton setFrame:clearHistoryButtonFrame];
        
        
        CGRect keyboarddefaultButtonFrame = self.keyboardDefaultButton.frame;
        keyboarddefaultButtonFrame.origin.y = 6 * measure - keyboarddefaultButtonFrame.size.height / 2;
        [self.keyboardDefaultButton setFrame:keyboarddefaultButtonFrame];
    }
    
    //self.clearHistoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[self.clearHistoryButton setTitle:TITLE_CLEAR_HISTORY_BUTTON forState:UIControlStateNormal];
    
    
    self.keyboardDefaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    // if(self.wasPurshaised || self.isTrialPeriod){
    [self.keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
    // } else {
    [self.buyAdditionsButton setTitle:BUY_REQUEST_BUTTON forState:UIControlStateNormal];
    //}
    
}

-(void) setHeightOfElementAccordingToScreenIPhone
{
    CGRect buttonsRect;
    if(IS_IPAD){
        buttonsRect = CGRectMake(0, 0, 60, 60);
        //for ipad try through autolayout
        //copy from here
        if(self.view.bounds.size.height > self.view.bounds.size.width){
            self.histroryTableViewHeight = 257.f;
            self.labelViewHeight = 118.f;
        } else {
            self.histroryTableViewHeight = 182.f;
            self.labelViewHeight = 108.f;
        }
        self.lastRowHistoryTableHeight = 85.f;

        //else if iPhone
    } else if(IS_568_SCREEN){
        buttonsRect = CGRectMake(0, 0, 60, 60);
        self.histroryTableViewHeight = 136.f;
        self.labelViewHeight = 72.f;
        self.lastRowHistoryTableHeight = 65.f;
    } else {
        self.histroryTableViewHeight = 112.f;
        self.labelViewHeight = 65;
        self.lastRowHistoryTableHeight = 60.f;
    }
    
}


-(void) initialLayoutDynamiccontainer
{
    [self initialLayoutDynamicContainerWithSize:self.view.bounds.size];

}

-(void) initialLayoutDynamicContainerWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self.mainContainerView setFrame:rect];
    if(IS_IPAD){
        if(size.height > size.width){

            self.histroryTableViewHeight = 257.f;
            self.labelViewHeight = 118.f;
            self.willBePortraitRotated = YES;
        } else {
            self.histroryTableViewHeight = 182.f;
            self.labelViewHeight = 108.f;
            self.willBePortraitRotated = NO;
        }
    }
    
    [self.dynamicContainer setFrame:CGRectMake(0,
                                                -self.mainContainerView.frame.size.height + self.histroryTableViewHeight + self.labelViewHeight,
                                                self.mainContainerView.frame.size.width,
                                                2*size.height - self.histroryTableViewHeight - self.labelViewHeight )];

    
    [self.historyTable setFrame:CGRectMake(0,
                                            0,
                                            self.mainContainerView.bounds.size.width,
                                            size.height - self.labelViewHeight)];
    CGRect displayViewFrame = CGRectMake(0,
                                        self.mainContainerView.frame.size.height - self.labelViewHeight,
                                        self.mainContainerView.bounds.size.width,
                                        self.labelViewHeight);//self.displayContainer.frame;
        
    [self.displayContainer setFrame:displayViewFrame];
    self.display.frame = self.displayContainer.bounds;
    self.backgroundToolBar.frame = self.displayContainer.frame;
    
    //if Ipad set Layout for display buttons
    if(IS_IPAD){
        CGSize displaySize = self.displayContainer.bounds.size;
        [self setDisplayButtonsLayout:displaySize];
    }
    
    [self.buttonsCollection setFrame:CGRectMake(0,
                                                self.mainContainerView.frame.size.height - self.labelViewHeight,
                                                self.mainContainerView.bounds.size.width,
                                                self.mainContainerView.bounds.size.height - self.histroryTableViewHeight)];


        
        
    CGRect sviperRect = self.historyTableSviper.frame;
    sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.bounds.size.width)/2;
    sviperRect.origin.y = self.displayContainer.frame.origin.y - self.historyTableSviper.bounds.size.height*2/3;
    [self.historyTableSviper setFrame:sviperRect];
    
    CGRect settingsViewRect = CGRectMake(-self.mainContainerView.bounds.size.width,
                                         0,
                                         self.mainContainerView.bounds.size.width,
                                         self.mainContainerView.bounds.size.height - self.displayContainer.bounds.size.height);
    
    //important think about background
    [self setLayOutOfSettingsView: settingsViewRect];
    [self.SettingsView setFrame:settingsViewRect];

}

-(void) changeLayoutDynamicContainerWithSize:(CGSize)size
{
    if(self.animator){
        self.animator = nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    [self.mainContainerView setFrame:rect];
    
    if(IS_IPAD){
        if(self.willBePortraitRotated){
            self.histroryTableViewHeight = 257.f;
            self.labelViewHeight = 118.f;
        } else {
            self.histroryTableViewHeight = 182.f;
            self.labelViewHeight = 108.f;
        }
    }
    
    //set origin.y for dynamicContainer
    CGFloat originYDynamicContainer;
    if(self.isButtonsCollectionUnderChanging){
       originYDynamicContainer = -self.mainContainerView.frame.size.height + self.labelViewHeight;
    } else if (self.isHistoryWholeShowed == 1){
        originYDynamicContainer = 0;
    } else {//initial setting
        originYDynamicContainer = self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.bounds.size.height;
    }
    
    [self.dynamicContainer setFrame:CGRectMake(0,
                                               originYDynamicContainer,
                                               size.width,
                                               2*size.height - self.histroryTableViewHeight - self.labelViewHeight )];
    
    
   
    CGRect displayViewFrame = CGRectMake(0,
                                         self.mainContainerView.frame.size.height - self.labelViewHeight,
                                         self.mainContainerView.bounds.size.width,
                                         self.labelViewHeight);//self.displayContainer.frame;
    
    [self.displayContainer setFrame:displayViewFrame];
    self.display.frame = self.displayContainer.bounds;
    self.backgroundToolBar.frame = self.displayContainer.frame;
    
    
    
    //if Ipad set Layout for display buttons
    if(IS_IPAD){
        CGSize displaySize = self.displayContainer.bounds.size;
        [self setDisplayButtonsLayout:displaySize];
    }
    
    
    CGRect sviperRect = self.historyTableSviper.frame;
    sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.bounds.size.width)/2;
    sviperRect.origin.y = self.displayContainer.frame.origin.y - self.historyTableSviper.bounds.size.height*2/3;
    [self.historyTableSviper setFrame:sviperRect];
    
    CGRect settingsViewRect = self.SettingsView.frame;

    
    if(self.isBottomSettingsViewOnScreen){
        settingsViewRect = CGRectMake(0,
                                      0,
                                      self.mainContainerView.bounds.size.width,
                                      self.mainContainerView.bounds.size.height - self.displayContainer.bounds.size.height);
    } else if (self.isSettingsViewOnScreen){
        settingsViewRect = CGRectMake(0,
                                      self.displayContainer.bounds.size.height + self.displayContainer.frame.origin.y,
                                      self.mainContainerView.bounds.size.width,
                                      self.mainContainerView.bounds.size.height - self.displayContainer.bounds.size.height);
    } else {
        settingsViewRect = CGRectMake(-self.mainContainerView.bounds.size.width,
                                         0,
                                         self.mainContainerView.bounds.size.width,
                                         self.mainContainerView.bounds.size.height - self.displayContainer.bounds.size.height);
    }
    
    [self.SettingsView setFrame:settingsViewRect];

    [self setLayOutOfSettingsView:settingsViewRect];
    
    
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
        
        [self.historyTable setContentInset:UIEdgeInsetsMake(size.height - self.labelViewHeight,0, 0, 0)];
    } else {
        [self.historyTable setContentInset:UIEdgeInsetsMake(size.height - self.labelViewHeight,0,0,0)];
    }
    
    [self.historyTable setFrame:CGRectMake(0,
                                           0,
                                           self.mainContainerView.bounds.size.width,
                                           size.height - self.labelViewHeight)];
    
    
    //impo
    for (UIView *subview in self.historyTable.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.frame = CGRectMake(0, 0, self.historyTable.bounds.size.width, self.historyTable.bounds.size.height);
        }
    }
    //IMOPRTANT TEST
    //self.historyTable.style=
    CGRect rc = self.historyTable.frame;
    NSLog(@"Rect:%f, %f, %f, %f", rc.origin.x,
          rc.origin.y,
          rc.size.width,
          rc.size.height);
    
    
    [self.buttonsCollection setFrame:CGRectMake(0,
                                                displayViewFrame.origin.y,
                                                size.width,
                                                self.dynamicContainer.bounds.size.height - self.historyTable.frame.size.height)];
    
    
    //Important may be Need to deleted it
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
    
}

-(void) setDisplayButtonsLayout:(CGSize)displaySize
{
    NSInteger numberOfButtons = 5;
    CGFloat partForOneButton = displaySize.width / numberOfButtons;
    CGFloat centerForOneButton = partForOneButton / 2;
    CGFloat displayHeightCenter = displaySize.height / 2;
    //1th button
    [self.settingsBottomButtn setCenter:CGPointMake(0 + centerForOneButton, displayHeightCenter)];
    //2nd button (share)
    [self.noticeButton setCenter:CGPointMake((1 * partForOneButton)+ centerForOneButton, displayHeightCenter)];
    //3d button
    [self.noticeRealButton setCenter:CGPointMake((2 * partForOneButton)+ centerForOneButton, displayHeightCenter)];
    //4th button (recount) - in 4 place!!!
    [self.recountButton setCenter:CGPointMake((3 * partForOneButton)+ centerForOneButton, displayHeightCenter)];
    //!!! iportant set Note button
    //self.upButton; //now it doesn't work
     //5th button - in 5 place!!!
    [self.deleteButton setCenter:CGPointMake((4 * partForOneButton)+ centerForOneButton, displayHeightCenter)];
    //self.settingsButton; // not necessary do it now
    //self.downButton; // not necessary do it now

}


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IPAD){
        //[self.mainContainerView setFrame:self.view.bounds];
    }
    
    self.backgroundToolBar.frame = self.displayContainer.frame;
    self.settingsBackgroundToolBar.frame = self.SettingsView.frame;
    
    //set size buttonsViews and frames
    struct Color clr;
    clr.r = 0.95;//0.26;
    clr.g = 0.95;//0.57;
    clr.b = 0.95;//0.70;
    clr.a = 1.0;
    
    self.smallButtonView.backgroundColor = [UIColor clearColor];
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
    
    CGFloat yDisplayCenter = self.displayContainer.frame.size.height/2;
    CGFloat widthdisplay = self.displayContainer.frame.size.width;

    if(self.wasPurshaised || self.isTrialPeriod){
        self.downButton.center = CGPointMake(widthdisplay*2/3, yDisplayCenter);
        
        self.settingsButton.center = CGPointMake(widthdisplay/3, yDisplayCenter);
    } else {
        
        self.downButton.center = CGPointMake(widthdisplay/2, yDisplayCenter);
    }
}

- (void)updateKVStoreItems:(NSNotification*)notification {

    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
}

//only at real enter in foregraund not at launch
-(void) appWillEnterForeground
{
    if(self.isiCloudInUse){
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateKVStoreItems:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        [store setString:@"Test" forKey:@"Test"];
        
        [store synchronize];
    }
    
    
    //[self extractKeyValuesFromStorage];
    if([self extractKeyValuesFromStorage]){
        [self.display showString:[self.displayRam setResult:self.displayRam.resultNumber]];
    } else {
        [self.displayRam clearRam];//to key value
        [self.display showString:[self.displayRam addSymbol:@0]];//to key value
        
        self.display.firstMemoryLabel.text = @"";//to key value
        self.display.secondMemoryLabel.text = @"";//to key value
        self.display.decRadLabel.text = @"DEG";//to key value
        self.userIsInTheMidleOfEnteringNumber = YES;//to key value
        self.isProgramInProcess = NO;//to key value
        self.isStronglyArgu = NO;//to key value
        self.isResultFromMemory = NO;//to key value
        self.isDecCounting = YES;//to key value
    }
    
    [self makeAllButtonObjsArray];
    
    NSInteger i = 0;
    
    while (i < self.mainButtonsStartArray.count) {
        NSString *name = self.mainButtonsStartArray[i];
        NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:name] integerValue];
        id fromWorkButtonNamesArray = [self.workButtonsNames objectAtIndex:index];
        if([fromWorkButtonNamesArray isKindOfClass:[NSString class]] && ![(NSString*)fromWorkButtonNamesArray isEqualToString:name]){
            
            self.workButtonsNames = nil; //nsStringNames
            
            self.changebleButtonObjs = nil;
            self.delettedButtonObjs = nil;
            self.mainButtonObjs = nil;
            self.allButtonObj = nil;//with obj
            [self setUpArrays];
            
            break;
        }
        i+=1;
    }

}

-(void) appDidGoToForeground: (NSNotification *)note
{
   
    if(self.isSoundOn){
        AudioServicesPlaySystemSound (_blankSoundFileObject);
    }
    /*
    if([self.historyTable numberOfRowsInSection: 0]>0){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable     numberOfRowsInSection: 0] -1 inSection:0];
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
     */

}

//possible enter to background, as example iTunes reques
-(void)appWillGoToBackground:(NSNotification *)note
{
    //if there is byttonAssubview - delete it
    if(self.buttonsAsSubView){
        CGRect subFrame = self.subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(self.findCell){
                             }
                             self.subCell.alpha = 1.;
                             [self.buttonsAsSubView removeFromSuperview];
                             self.buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:self.subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                         }];
    }
    
    //save managed object context
     [self.doc updateChangeCount:UIDocumentChangeDone];

}

//really enter to background
-(void) appDidEnterBackground
{
    //if there is process spiner - remove it from settings view
    if(self.processSpinner){
        [self.processSpinner stopAnimating];
        [self.processSpinner removeFromSuperview];
    }
    
   
    //if there is byttonAssubview - delete it
    if(self.buttonsAsSubView){
        CGRect subFrame = self.subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(self.findCell){
                             }
                             self.subCell.alpha = 1.;
                             [self.buttonsAsSubView removeFromSuperview];
                             self.buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:self.subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                         }];
    }
    
    if(self.isButtonsCollectionUnderChanging){
        self.isButtonsCollectionUnderChanging = NO;
        
        for(UICollectionViewCell* cell in [self.buttonsCollection visibleCells]){
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
        }

        [self resaveCoreButtons];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];
    
    //importand why i've made it
    //[self discardChanging];

    
    [self deleteSuperfluousValuesFromManagedDocuments];
    
    [self.buttonsCollection reloadData];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //[defaults setObject:self.workButtonsNames forKey:@"preWorkButtonsNames"];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [self setKeyValuesFromStorage];
    [defaults synchronize];
}

-(void) appWillTerminate
{
    [self.doc updateChangeCount:UIDocumentChangeDone];


    [self setKeyValuesFromStorage];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [defaults synchronize];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


-(void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"MainView Will appear");
    if(self.isSoundOn){
        AudioServicesPlaySystemSound (_blankSoundFileObject);
    }
    self.callShowController = NO;
    [self.buttonsCollection reloadData];
    [super viewWillAppear:animated];
    
}
#pragma mark TRANSITION DELEGATE
-(id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    Transition* trans = [[Transition alloc] init];
    self.transition = trans;
    
    if(self.callShowController){
        self.transition.isGravity = YES;
    } else {
        self.transition.isGravity = NO;
        if(self.showControllerIsForward){
            self.transition.isForward = YES;
        } else {
            self.transition.isForward = NO;
        }
        
    }
    return self.transition;
}

#pragma mark SHOW OTHER CONTROLLERS

#pragma mark SETTINGS VIEW CONTROLLER

//recived notification from settingsViewcontroller
#pragma mark NOTIFICATION
-(void) recivedNotification:(NSNotification*)notification
{
    NSArray *keys = notification.userInfo.allKeys;
    if(keys.count && (keys.count < 2) && [keys[0] isKindOfClass:[NSString class]]){
        //NSLog(@"Ok recived notification %@ for key %@", [notification.userInfo objectForKey:keys[0]], keys[0]);
        NSString *key = keys[0];
        if([key isEqualToString:@"isBigSizeButtons"]){
            
            self.isBigSizeButtons = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if([key isEqualToString:@"isSoundOn"]){
            
            self.isSoundOn = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if([key isEqualToString:@"isBigDataBase"]){
            
            self.isBigDataBase = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if([key isEqualToString:@"isiCloudInUse"]){
            
            self.isiCloudInUse = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if([key isEqualToString:@"wasPurshaised"]){
            
            self.wasPurshaised = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if ([key isEqualToString:@"setKeyboardDefaultAction"]){
            if([[notification.userInfo objectForKey:keys[0]] boolValue]){
                
                [Buttons clearContext:self.buttonManagedObjectContext];
                [self setUpArrays];
                [self.doc updateChangeCount:UIDocumentChangeDone];
                [self.buttonsCollection reloadData];
            }
            
        } else if ([key isEqualToString:@"cleanHistoryArchive"]){
            if([[notification.userInfo objectForKey:keys[0]] boolValue]){
                
                [History clearContext:self.managedObjectContext];
                NSArray *newHeightsOfRows = [[NSArray alloc] init];
                self.heightsOfRows = newHeightsOfRows;
                [self performFetch];
            }
            
        }else {
            NSLog(@"Not find right key");
        }
    } else {
        NSLog(@"recived wrong notification");
    }
    
}
-(void) showSettingsViewcontroller
{
    self.showControllerIsForward = NO;
    self.callShowController = NO;
    
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    //set all properties
    settingsController.isiCloudInUse = self.isiCloudInUse;;
    settingsController.isBigDataBase = self.isBigDataBase; //size dataBase
    settingsController.isSoundOn = self.isSoundOn;
    settingsController.isBigSizeButtons = self.isBigSizeButtons;

    settingsController.isTrialPeriod = self.isTrialPeriod;
    settingsController.wasPurshaised = self.wasPurshaised;

    self.settingsController = settingsController;
    self.settingsController.transitioningDelegate = self;
    //recive notification from other controllers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:ReciveChangedNotification object:nil];
    [self presentViewController:self.settingsController animated:YES completion:nil];
    
}

#pragma mark SHOW VIEW CONTROLLER

-(void) showShowedView
{
    //NSLog(@"ATTR str fro show: %@", self.strAtrrForShow.string);
    ShowedViewController *show = [[ShowedViewController alloc] init];
    [show setNeedStringsForShow:self.strAtrrForShow andRes:self.resStringForShow];
    if(IS_IPAD){
        UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
        if(orient == UIDeviceOrientationPortrait || orient == UIDeviceOrientationPortraitUpsideDown){
            
            CGFloat angle = 0;
            CGFloat width = self.view.bounds.size.height;
            CGFloat height = self.view.bounds.size.width;

            switch (orient) {
                case UIDeviceOrientationPortrait:
                    angle = 0;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    angle = 0;
                    
                default:
                    break;
            }
            
            [show.cView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
            [show.cView setFrame:CGRectMake(0,0, height, width)];
        }
    }
    
    self.showedController = show;
    self.showedController.transitioningDelegate = self;
   // self.showedController.attrStrForLabel = self.strAtrrForShow;
    
    [self presentViewController:self.showedController animated:YES completion:nil];
}
#pragma mark PREAPERE STRINGS
-(void) showCount
{
    //important AT START ITS CALL 4 times IMPOSIBLE //end every time ITS CALLED TWICE, at = CALL THREE TIMES
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSAttributedString * count;
    NSAttributedString *result;
   // NSLog(@"Number of rowInhistory table %ld",(long)[self.historyTable numberOfRowsInSection:0]);
    
    if([self.historyTable numberOfRowsInSection: 0] >0){
        NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        if(!indexPath){
            indexPath = lastRowPatch;
        }
        NSMutableAttributedString *atrStrFromString;
        if(indexPath.row == lastRowPatch.row){
            if(!self.lastRowDataArray) self.lastRowDataArray = [[NSArray alloc] init];//if no array till now
            atrStrFromString = [self getAttributedStringFromArray:self.lastRowDataArray];
        } else {
            atrStrFromString=  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        }
        if(atrStrFromString.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                
                NSString *lastSymbol = [atrStrFromString.string substringWithRange:NSMakeRange(atrStrFromString.string.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    [atrStrFromString insertAttributedString:self.display.attributedText atIndex:atrStrFromString.length];
                }
            }
            
        }
        
       // if(![atrStrFromString.string isEqualToString:[self.viewToPDF stringOnScreen]]){
            NSRange equalRange = [atrStrFromString.string rangeOfString:@"="];
            if(equalRange.location == NSNotFound){
                count = [atrStrFromString copy];
                result = [[NSAttributedString alloc] initWithString:@""];
            } else {
                count = [atrStrFromString attributedSubstringFromRange:NSMakeRange(0, equalRange.location +1)];
                result = [atrStrFromString attributedSubstringFromRange:NSMakeRange(equalRange.location +1, atrStrFromString.length - equalRange.location -1)];
            }
        
    }

        [self prepareStringsForshowedViewControllerCountStr:[count copy] andResStr:[result copy]];
}

//call its func only if ShowedController is presented of begining appears
//make it in background
#define RES_RECT_HEIGHT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 196.f : 96.f)
#define RES_STRING_HEIGHT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 176.f : 72.f)
#define COUNT_STRING_HEIGHT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 88.f : 48.f)
#define STRING_INDENT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 150.f : 90.f)
-(void) prepareStringsForshowedViewControllerCountStr:(NSAttributedString*)countStr andResStr:(NSAttributedString*)resStr
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //first works with result string
        NSMutableAttributedString * countAtrStr = [countStr mutableCopy];
        
        UIFont *font; //72;
        UIColor *textColor = [UIColor darkTextColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentLeft;
        style.lineHeightMultiple = 0;
        
        [countAtrStr beginEditing];
        NSRange wholeRange = NSMakeRange(0, [countAtrStr length]);
        [countAtrStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [countAtrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
        [countAtrStr addAttribute:NSParagraphStyleAttributeName value:style range:wholeRange];
        [countAtrStr endEditing];
        
        //set maximum heigth of count string
        UIFont *mainAttributefont = [self.attributes valueForKey:NSFontAttributeName];
        
        countAtrStr = [[self resizeAttrString:[countAtrStr copy] withKoeff:COUNT_STRING_HEIGHT/mainAttributefont.pointSize] mutableCopy];
        
        //find the need height of multiline string
        NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
        //calculate width and height of DEVICE
        CGFloat width;
        CGFloat height;
        if(self.view.bounds.size.width > self.view.bounds.size.height){
            width = self.view.bounds.size.width;
            height = self.view.bounds.size.height;
        } else {
            width = self.view.bounds.size.height;
            height = self.view.bounds.size.width;
        }
        
        CGSize neededSize = CGSizeMake(width - STRING_INDENT - 20,1000);
        CGRect neededRect = [countAtrStr boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:drawContext];
        //CGFloat needPointsize = COUNT_STRING_HEIGHT;
        CGFloat maxHightOfMultiLineString = height - 20- RES_RECT_HEIGHT;
        
        while (neededRect.size.height > maxHightOfMultiLineString) {
            CGFloat koeff = sqrtf(maxHightOfMultiLineString/neededRect.size.height);
            countAtrStr = [[self resizeAttrString:[countAtrStr copy] withKoeff:koeff] mutableCopy];
            neededRect = [countAtrStr boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:drawContext];
            /*
            NSLog(@"in Loop needRect: %f,%f,%f,%f",
                  neededRect.origin.x,
                  neededRect.origin.y,
                  neededRect.size.width,
                  neededRect.size.height);
            */
        }
        
        //set result string
        NSMutableAttributedString * resulAttrStr = [resStr mutableCopy];
        font = [self setFontWithSize:RES_STRING_HEIGHT]; //72
        style.alignment = NSTextAlignmentRight;
        style.lineHeightMultiple = 1.;
        [resulAttrStr beginEditing];
        wholeRange = NSMakeRange(0, [resulAttrStr length]);
        [resulAttrStr addAttribute:NSFontAttributeName value:font range:wholeRange];
        [resulAttrStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [resulAttrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
        [resulAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:wholeRange];
        [resulAttrStr endEditing];
        
        // NSInteger resultStringSize = RES_STRING_HEIGHT;//176;//72;
        
        CGRect resRect = CGRectMake(STRING_INDENT,
                                    height - RES_RECT_HEIGHT - 20,
                                    width - STRING_INDENT - 20,
                                    RES_RECT_HEIGHT);
        
        CGRect neededResultRect = [resulAttrStr boundingRectWithSize:resRect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                             context:drawContext];
        while(neededResultRect.size.width > (resRect.size.width -10)){
            CGFloat koeff = sqrtf((resRect.size.width -10)/neededResultRect.size.width);
            
            resulAttrStr = [[self resizeAttrString:[resulAttrStr copy] withKoeff:koeff] mutableCopy];
            neededResultRect = [resulAttrStr boundingRectWithSize:resRect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                          context:drawContext];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _strAtrrForShow = [countAtrStr copy];
            _resStringForShow = [resulAttrStr copy];
            if([self.presentedViewController isKindOfClass:[ShowedViewController class]]){
                [(ShowedViewController*)self.presentedViewController setNeedStringsForShow:[countAtrStr copy] andRes:[resulAttrStr copy]];
                
            }
        });
        
    });
    

}

//helped function for set need font
-(UIFont*) setFontWithSize:(CGFloat) size
{
    UIFont *font; //if there is no needed font
    
    NSString *fontName = nil;
    NSArray *famalyNames  =[UIFont familyNames];
    if([famalyNames containsObject:@"Helvetica Neue"]){
        NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
        if([fontNames containsObject:@"HelveticaNeue"]){
            fontName = @"HelveticaNeue";
        }
    }
    
    if(fontName){
        font = [UIFont fontWithName:fontName size:size];
    }else {
        font =[UIFont boldSystemFontOfSize:size];
    }
    return  font;
}


-(NSAttributedString*) resizeAttrString:(NSAttributedString*)inputStr withKoeff:(CGFloat)k;
{
    NSMutableAttributedString* resultString = [inputStr mutableCopy];
    
    //set the new value for all of symbols according new k
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        NSNumber *wasOffset = [attributes valueForKey:NSBaselineOffsetAttributeName];
        UIFont *font = [UIFont fontWithName:wasFont.familyName size:wasFont.pointSize * k]; //if there is no needed font
        UIColor *textColor = [UIColor darkTextColor];
        
        [symbolString beginEditing];
        NSRange wholeRange = NSMakeRange(0, [symbolString length]);
        [symbolString addAttribute:NSFontAttributeName value:font range:wholeRange];
        [symbolString addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [symbolString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:[wasOffset floatValue]* k] range:wholeRange];
        [symbolString endEditing];
        [resultString replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:symbolString];
    }
    
    return [resultString copy];
}


#pragma mark MORE CONTROLLERS
//Important test
-(void) testShowAppController
{
    AppearedController *second = [[AppearedController alloc] init];
    second.view.backgroundColor = [UIColor colorWithRed:0.25
                                                  green:0.61
                                                   blue:.80
                                                  alpha:1.];
    second.transitioningDelegate = self;
    
    
    [self presentViewController:second animated:YES completion:nil];
}


#pragma mark ABOUT VIEW

-(void) showAboutViewLeftDays:(NSInteger)days
{
    
    AboutViewController *aboutController = [[AboutViewController alloc] initWithController:self daysLeft:days];
    aboutController.delegate = self;
    aboutController.direction = YES;
    aboutController.mainViewBackGroundColor = [UIColor colorWithRed:0.25
                                                              green:0.61
                                                               blue:.80
                                                              alpha:1.];
    
    [self presentViewController:aboutController animated:NO completion:^{
        nil;
    }];
    //make product request
    if([SKPaymentQueue canMakePayments]) {
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kInAppPurchaseProductID]];
        request.delegate = self;
        
        [request start];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: MainControllerNotAvailableForBuingNotification object:nil];

    }

}

#pragma mark APPEARED CONTROLLER DELEGATE
-(void) appearedControllerDidCloseWithString:(NSString *)returnString
{
    if([returnString isEqualToString:@"BUY"]){
        NSLog(@"Buy command from about view");
        //show buy allert
        [self buyAdditionsButtonTapped:nil];
        
    } else if ([returnString isEqualToString:@"CONTINUE"]){ //if continue trial period
        NSLog(@"Jus continue fronm about view");
    } else if ([returnString isEqualToString:@"CLOSE"]){ //if work without addition after trial period is finished
        [self endsOfTrialPeriod];
    }
    
}

-(void) endsOfTrialPeriod
{
    NSLog(@"Finish trial period from about view");
    self.isTrialPeriod = NO;
    //set settings view for change button
    CGRect settingsViewRect = CGRectMake(-self.mainContainerView.bounds.size.width,
                                  0,
                                  self.mainContainerView.bounds.size.width,
                                  self.mainContainerView.bounds.size.height - self.displayContainer.bounds.size.height);
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.keyboardDefaultButton.alpha = 0;
                          } completion:^(BOOL finished) {
                              [UIView animateWithDuration:0.4
                                               animations:^{
                                                   self.keyboardDefaultButton.hidden = YES;
                                                   [self setLayOutOfSettingsView:settingsViewRect];
                                               }];
    }];
    //Important:
    //1. need to reset buttons array
    //2. need to reset all views
}

#pragma mark KEY VALUE STORAGE
-(void) setKeyValuesFromStorage
{
    NSMutableArray *wholeArray = [[NSMutableArray alloc] init];
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    
    [controllerArray addObject:self.lastRowDataArray];//to key value last row
    [controllerArray addObject:[NSNumber numberWithBool:self.userIsInTheMidleOfEnteringNumber]];//to key value
    [controllerArray addObject:[NSNumber numberWithBool:self.isProgramInProcess]];//to key value
    [controllerArray addObject:[NSNumber numberWithBool:self.isStronglyArgu]];//to key value
    [controllerArray addObject:[NSNumber numberWithBool:self.isDecCounting]];//to key value
    [controllerArray addObject:[NSNumber numberWithBool:self.isResultFromMemory]];//to key value
    [controllerArray addObject:[NSNumber numberWithBool:self.isTrialPeriod]];//to kay value
    [controllerArray addObject:[NSNumber numberWithInteger:self.nexNeedShovewTrialViewDay]];
    [controllerArray addObject:self.startTrialDate];
    
    
    [wholeArray addObject:[controllerArray copy]];
    
    [wholeArray addObject:[self.brain arrayToSaveBrain]]; //to key value
    
    NSMutableArray *displayRamArray = [[NSMutableArray alloc] init]; //to key value
    [displayRamArray addObject:self.displayRam.firstMemoryStack];//to key value
    [displayRamArray addObject:self.displayRam.secondMemoryStack];//to key value
    [displayRamArray addObject:self.displayRam.gradArray];//to key value
    [displayRamArray addObject:self.displayRam.resultNumber];//to key value
    [wholeArray addObject:[displayRamArray copy]];//to key value
    if(self.isiCloudInUse){
        NSUbiquitousKeyValueStore *kvStore = [NSUbiquitousKeyValueStore defaultStore];
        [kvStore setObject:[wholeArray copy] forKey:@"keyValuesArray"];
        [kvStore synchronize];
        
    }
    
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        //[defaults setObject:self.workButtonsNames forKey:@"preWorkButtonsNames"];
        [defaults setObject:[wholeArray copy] forKey:@"keyValuesArray"];
        [defaults synchronize];
    
}

-(BOOL) extractKeyValuesFromStorage
{
    BOOL sucsess = YES;
    id userDefault;

    userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyValuesArray"];

    
    if(userDefault && [userDefault isKindOfClass:[NSArray class]]){
        NSMutableArray *wholeArray = [userDefault mutableCopy];
    
        //extract disaply
        id displayRamArray = [[wholeArray lastObject] mutableCopy];
        
        DisplayRam *newDisplayRam;
        if(!self.displayRam){
            newDisplayRam = [[DisplayRam alloc] init];
            newDisplayRam.delegate = self;
        }else {
            newDisplayRam = self.displayRam;
        }
        
        if(displayRamArray && [displayRamArray isKindOfClass:[NSArray class]]){
            id top = [displayRamArray lastObject];
            if(top && [top isKindOfClass:[NSNumber class]]){
                newDisplayRam.resultNumber = top;
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSArray class]]){
                newDisplayRam.gradArray = top;
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSArray class]]){
                newDisplayRam.secondMemoryStack = top;
                //set the memory mark
                NSArray* test = [top copy];
                if([test count] > 0) {
                    self.display.secondMemoryLabel.text = @"MI";
                } else {
                    self.display.secondMemoryLabel.text = @"";
                }
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSArray class]]){
                newDisplayRam.firstMemoryStack = top;
                //set the memory mark
                NSArray* test = [top copy];
                if([test count] > 0) {
                    self.display.firstMemoryLabel.text = @"M";
                } else {
                    self.display.firstMemoryLabel.text = @"";
                }
            
            } else {
                return  NO;
            }
            self.displayRam = newDisplayRam;
        
            [wholeArray removeLastObject];
        
        } else {
            return  NO;
        }
    
        //set brain
        id brainArray = [wholeArray lastObject];
        if(brainArray && [brainArray isKindOfClass:[NSArray class]]){
            self.brain = [ACalcBrain brainFromSavedArray:brainArray];
            [wholeArray removeLastObject];
        } else {
            return  NO;
        }
    
    //set controller
        id controllerArray = [[wholeArray lastObject] mutableCopy];
        if(controllerArray && [controllerArray isKindOfClass:[NSMutableArray class]]){
        
            id top = [controllerArray lastObject];
            //-----Trial Period
            if(top && [top isKindOfClass:[NSDate class]]){
                self.startTrialDate = top;
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.nexNeedShovewTrialViewDay = [top integerValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.isTrialPeriod = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
        //-----------------------------------------
        
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.isResultFromMemory = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.isDecCounting = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.isStronglyArgu = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.isProgramInProcess = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            } else {
                return  NO;
            }
        
            if(top && [top isKindOfClass:[NSNumber class]]){
                self.userIsInTheMidleOfEnteringNumber = [top boolValue];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];

            } else {
                return  NO;
            }
            
            if(top && [top isKindOfClass:[NSArray class]]){
                self.lastRowDataArray = top;
                
            } else {
                return  NO;
            }

        
        } else {
            return  NO;
        }
    } else {
        return NO;
    }

    return sucsess;
}

#pragma mark FOR USER DEFAULT
-(NSArray*) arrayToUserDefault
{
    NSMutableArray *wholeArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    [controllerArray addObject:self.lastShowAllertViewDate];
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigDataBase]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigSizeButtons]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isSoundOn]];
    [controllerArray addObject: self.currentProgrammVersion];
    [controllerArray addObject:[NSNumber numberWithInteger:self.counterForShowingAllertView]];
    
    
    [wholeArray addObject:[controllerArray copy]];
    
    return [wholeArray copy];
}

-(BOOL) extractFromUserDefault:(NSArray*) array
{
    BOOL sucsess = YES;
    NSMutableArray *wholeArray = [array mutableCopy];
        //set controller
    id controllerArray = [[wholeArray lastObject] mutableCopy];
    if(controllerArray && [controllerArray isKindOfClass:[NSMutableArray class]]){
        
        id top = [controllerArray lastObject];
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.counterForShowingAllertView= [top integerValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            return NO;
        }
        
        if(top && [top isKindOfClass:[NSString class]]){
            self.currentProgrammVersion= top;
            //check is the equal to current version
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *realVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if(![self.currentProgrammVersion isEqualToString:realVersion]){
               self.counterForShowingAllertView= 37;
                //important
                //set here show aboutView with new functions and trial additions
                //if the changes are so big and i whon show it to user
                //set it manualy every time
                //Important WOKS With days trial
                self.isTrialPeriod = YES;
                self.nexNeedShovewTrialViewDay = 20;
                self.startTrialDate = [NSDate date];

                self.currentProgrammVersion = realVersion;
            }
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            return NO;
        }

        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isSoundOn = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            return NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isBigSizeButtons = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            return NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isBigDataBase = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            return NO;
        }
       
        if(top && [top isKindOfClass:[NSDate class]]){
            // self.self.lastShowAllertViewDate = top;
            self.lastShowAllertViewDate = top;
        } else {
            return NO;
        }
        
    } else {
        return NO;
    }
    
    return sucsess;
}

- (void)didReceiveMemoryWarning
{

    [self.doc updateChangeCount:UIDocumentChangeDone];

    
    [self setKeyValuesFromStorage];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [defaults synchronize];
    
    [super didReceiveMemoryWarning];
}


#pragma mark ROTATION

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    if(self.hintView){
        [self.hintView removeFromSuperview];
        [self showHintViewAccordingCounter];
    }
    
    NSInteger bannerHeight;
    
    if(IS_IPAD){
        [self IPadTransitionToSize:size withTransitionCoordinator:coordinator];

    } else {
        bannerHeight = 50;
        [self iPhoneTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    if(!self.wasPurshaised){
        /*
        CGRect bannerFrame = self.bannerContainerView.frame;
        bannerFrame.size.width = size.width;
        bannerFrame.size.height = bannerHeight;
        
        [self.bannerContainerView setFrame:bannerFrame];
        [self.iAdBanner setFrame:self.bannerContainerView.bounds];
         */
    }
    //[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void) IPadTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    
    //!!!
    //If presented second controller
    //
    //steel don't ready for IPad
    NSInteger bannerHeight = 66;
    BOOL wasWillBePortraitRotated = self.willBePortraitRotated;
    if(size.height > size.width){
        self.willBePortraitRotated = YES;
    } else {
        self.willBePortraitRotated = NO;
    }
    
    
    
    [self.display showString:[self.displayRam setResult:self.displayRam.resultNumber]];//ipad
    [self setUpMainButtonsStartWithPosition];//ipad
    [self makeTwoArrays];//ipad
    [self.buttonsCollection reloadData];//ipad
    [self changeLayoutDynamicContainerWithSize:size];//ipad
    
    if([self.presentedViewController isKindOfClass:[SecondViewController class]]){
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

        
    }
    //!!!!
    //if presented third controller
    //
    else if ([self.presentedViewController isKindOfClass:[ThirdController class]]){
       
            if(wasWillBePortraitRotated != self.willBePortraitRotated){
                //if(self.willBePortraitRotated){
                [UIView setAnimationsEnabled:NO];
                if(!self.willBePortraitRotated){
                    [self.showedController.testView setTransform:CGAffineTransformMakeRotation(0)];
                    CGRect initialFrame = self.showedController.testView.frame;
                    initialFrame.origin.x =  (size.width - initialFrame.size.width)/2;
                    initialFrame.origin.y = (size.height - initialFrame.size.height)/2;
                    [self.showedController.testView setFrame:initialFrame];
                } else {
                    [self.showedController.testView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
                    CGRect initialFrame = self.showedController.testView.frame;
                    initialFrame.origin.x =  (size.width - initialFrame.size.width)/2;
                    initialFrame.origin.y = (size.height - initialFrame.size.height)/2;
                    [self.showedController.testView setFrame:initialFrame];
                    
                }
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView setAnimationsEnabled:YES];
                    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

                });
                
            } else {
                [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
            }
    }
    //!!!!
    //if presented current controller
    //
    else {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

        NSLog(@"Main viewWillTransitionToSize");
        
        if(!self.wasPurshaised){
            
            CGRect bannerFrame = self.bannerContainerView.frame;
            bannerFrame.size.width = size.width;
            bannerFrame.size.height = bannerHeight;
            
            [self.bannerContainerView setFrame:bannerFrame];
            [self.iAdBanner setFrame:self.bannerContainerView.bounds];
        }
    }


}

-(void) iPhoneTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
        UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
        //!!!
        //If presented second controller
        //
        if([self.presentedViewController isKindOfClass:[SecondViewController class]]){

            CGFloat angle = 0;
            CGFloat width = size.height;
            CGFloat height = size.width;
            
            BOOL rotate = NO;
            CGRect rctWasCView = self.settingsController.cView.frame;
            CGRect newCViewFrame = self.settingsController.cView.frame;
            
            UIDeviceOrientation wasOrient = self.settingsController.wasOrient;
            
            if(size.width > size.height){
                
                width = size.height;
                height = size.width;
                switch (orient) {
                    case UIDeviceOrientationLandscapeLeft:
                        if(orient == wasOrient){
                            angle = -M_PI/2;
                            rotate = NO;
                        } else if(wasOrient == UIDeviceOrientationLandscapeRight){
                            angle = -M_PI/2;
                            rotate = NO;
                        } else {
                            angle = -M_PI/2;
                            rotate = YES;
                        }
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        if(orient == wasOrient){
                            angle = M_PI/2;
                            rotate = NO;
                        } else if(wasOrient == UIDeviceOrientationLandscapeLeft){

                            angle = M_PI/2;
                            rotate = NO;
                        } else {
                            angle = M_PI/2;
                            rotate = YES;
                        }
                        break;
                    default:
                        break;
                }

                if(rotate){
                    newCViewFrame = CGRectMake(rctWasCView.origin.y,
                                               rctWasCView.origin.x,
                                               rctWasCView.size.height,
                                               rctWasCView.size.width);
                }else {
                    newCViewFrame = CGRectMake(rctWasCView.origin.x,
                                               rctWasCView.origin.y,
                                               rctWasCView.size.width,
                                               rctWasCView.size.height);
                }
            } else {
                if(wasOrient == UIDeviceOrientationLandscapeLeft || wasOrient == UIDeviceOrientationLandscapeRight){
                    newCViewFrame = CGRectMake(rctWasCView.origin.y,
                                               rctWasCView.origin.x,
                                               rctWasCView.size.height,
                                               rctWasCView.size.width);
                }
                
            }
            
            self.settingsController.wasOrient = orient;


            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angle)];
            [self.mainContainerView setFrame:CGRectMake(0,0, height, width)];
            
            [self.settingsController.cView setTransform:CGAffineTransformMakeRotation(angle)];
            [self.settingsController.cView setFrame:newCViewFrame];
            
            [self.view setTransform:CGAffineTransformMakeRotation(0)];
            
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [UIView setAnimationsEnabled:YES];
                
                [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

            });
            
        }
        //!!!!
        //if presented third controller
        //
        else if ([self.presentedViewController isKindOfClass:[ThirdController class]]){
            CGFloat angle = 0;
            CGFloat width = size.height;
            CGFloat height = size.width;
            BOOL needDissmisThirdController = NO;
            
            if(size.height > size.width){
                width = size.height;
                height = size.width;
                switch (self.showedController.wasOrient) {
                    case UIDeviceOrientationLandscapeLeft:
                        angle = M_PI/2;
                        needDissmisThirdController = YES;
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        angle = -M_PI/2;
                        needDissmisThirdController = YES;
                        
                    default:
                        break;
                }
                self.showedController.wasOrient = orient;
            }
            if(needDissmisThirdController) {
                [UIView setAnimationsEnabled:NO];
                [self.mainContainerView setTransform:CGAffineTransformMakeRotation(0)];
                [self.mainContainerView setFrame:CGRectMake(0,0, height, width)];
                
                [self.showedController.cView setTransform:CGAffineTransformMakeRotation(angle)];
                [self.showedController.cView setFrame:CGRectMake(0,0, height, width)];
                
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView setAnimationsEnabled:YES];
                    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                    [self.showedController dismis];
                });
            }
            
        }
        //!!!!
        //if presented current controller
        //
        else {
            
            CGFloat angle = 0;
            CGFloat width = size.height;
            CGFloat height = size.width;
            
            BOOL needCallcontroller = NO;
            
            if(size.width > size.height){
                width = size.height;
                height = size.width;
                switch (orient) {
                    case UIDeviceOrientationLandscapeLeft:
                        angle = -M_PI/2;
                        needCallcontroller = YES;
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        angle = M_PI/2;
                        needCallcontroller = YES;
                        break;
                    default:
                        break;
                }
            }
            
            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angle)];
            [self.mainContainerView setFrame:CGRectMake(0,0, height, width)];
            
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [UIView setAnimationsEnabled:YES];
                
                [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                self.callShowController = needCallcontroller;

            });
        }
}



#pragma mark SHOWING IAd BANNER
//but exactly here need to show banner
//1. delay banner appearence
//2. show banner with dynamic gravity and collission
-(void) ShowIAdBanner
{
    if(!self.wasPurshaised){
    int64_t delayInSeconds = 4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.bannerContainerView.hidden = NO;
        self.bannerContainerView.alpha = 1.;
        
        [UIView animateWithDuration:.8
                         animations:^{
                             NSInteger bannerHeight;
                             if(IS_IPAD){
                                 bannerHeight = 66;
                             } else {
                                 bannerHeight = 50;
                             }

                             [self.bannerContainerView setFrame:CGRectMake(0,0, self.mainContainerView.bounds.size.width, bannerHeight)];
                             [self.iAdBanner setFrame:self.bannerContainerView.bounds];

                         } completion:^(BOOL finished) {
                             self.isIAdBannerOnScreen =  YES;
                         }];
    });
    }
}
//3. hide banner with alpha animation and set to needed hight
-(void) hideIAdBanner
{
    
    [UIView animateWithDuration:2.8
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.bannerContainerView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         NSInteger bannerHeight;
                         if(IS_IPAD){
                             bannerHeight = 66;
                         } else {
                             bannerHeight = 50;
                         }

                         [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, bannerHeight)];
                         [self.iAdBanner setFrame:self.bannerContainerView.bounds];

                         self.isIAdBannerOnScreen = NO;
                         self.bannerContainerView.hidden = YES;
                     }];
    
}

#pragma mark iAD BANNER DELEGATE


-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{

    if(!self.wasPurshaised){
        if(self.isIAdBaneerAvailable && self.isIAdBannerOnScreen){
            [self hideIAdBanner];
            //self.isIAdBaneerAvailable = NO;
        } else {
            if([self.historyTable numberOfRowsInSection:0] > 2){
            
                self.isIAdBaneerAvailable = YES;
            }
        }
    }
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.isIAdBaneerAvailable = NO;
    if(self.isIAdBannerOnScreen){
        [self hideIAdBanner];
    }
    
    
}

//----------------------------------------------------------
//-----IMPORTANT DELETE-------------------------------------
//----------------------------------------------------------

#pragma mark IN-APP PURSHASE
-(void) startSpinner
{
    CGRect spinnerFrame = CGRectMake((self.SettingsView.bounds.size.width -40)/2,
                                     self.buyAdditionsButton.frame.origin.y - 40,
                                     40.,
                                     40.);

    UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc] initWithFrame:spinnerFrame];
    [processSpinner setCenter:self.buyAdditionsButton.center];

    [self.SettingsView addSubview:processSpinner];
    processSpinner.hidesWhenStopped = YES;
    self.processSpinner = processSpinner;
    [self.processSpinner startAnimating];
}

-(void) wasSuccesTransaction
{
    //3.
    
    
    self.settingsButton.alpha = 0.;
    self.settingsButton.hidden = self.downButton.hidden;

    CGFloat yDisplayCenter = self.displayContainer.frame.size.height/2;
    CGFloat widthdisplay = self.displayContainer.frame.size.width;
    
    
    self.settingsButton.center = CGPointMake(widthdisplay/3, yDisplayCenter);
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        self.downButton.center = CGPointMake(widthdisplay*2/3, yDisplayCenter);
                        self.buyAdditionsButton.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         self.wasPurshaised = YES;
                         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                         [defaults setObject:[NSNumber numberWithBool:self.wasPurshaised] forKey:@"wasPurchaisedMark"];
                         [defaults synchronize];
                         
                         self.buyAdditionsButton.enabled = NO;
                         self.buyAdditionsButton.hidden = YES;
                        
                         [self hideIAdBanner];
                         self.isIAdBaneerAvailable = NO;
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              self.keyboardDefaultButton.alpha = 1;
                                              self.settingsButton.alpha = self.downButton.alpha;
                                          }];
                     }];
}

-(void) setWasPurshaised:(BOOL)wasPurshaised
{
    /*
    if(wasPurshaised){
        self.keyboardDefaultButton.enabled = YES;
        self.keyboardDefaultButton.hidden = NO;
        
        self.buyAdditionsButton.enabled = NO;
        self.buyAdditionsButton.hidden = YES;
        
    } else {
        self.buyAdditionsButton.enabled = YES;
        self.buyAdditionsButton.hidden = NO;
        if(self.isTrialPeriod){
            self.keyboardDefaultButton.enabled = YES;
            self.keyboardDefaultButton.hidden = NO;
        } else {
            self.keyboardDefaultButton.enabled = NO;
            self.keyboardDefaultButton.hidden = YES;
        }
    }
    */
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
    [[NSNotificationCenter defaultCenter] postNotificationName: MainControllerSendPayPossibilityNotification object:nil];
    
}


-(void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //stop and remove process spinner
    [self.processSpinner stopAnimating];
    [self.processSpinner removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName: MainControllerNotAvailableForBuingNotification object:nil];
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
//----------------------------------------------------------
//-----IMPORTANT DELETE-------------------------------------
//----------------------------------------------------------


#pragma mark HELPED FUNCTIONS______________________
//return point according localisation
-(NSString *) point
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}



@end



