//
//  ITSCalcViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 15.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//
//#import <UIKit/UIKit.h>;
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <CoreText/CTStringAttributes.h>
#import <MessageUI/MessageUI.h>

#import "ITSCalcViewController.h"


#import "NewButtonsCollectionViewCell.h"
#import "HistroryTableViewCell.h"

#import "ACalcBrain.h"

//#import "DisplayLabel.h"
#import "DisplayScreenLabel.h"
#import "DisplayRam.h"
#import "History.h"
#import "History+Maker.h"

#import "ButtonsStore.h"
#import "Buttons.h"
#import "Buttons+Buttons_Maker.h"
//#import "ButtonObject.h"

#import "HistoryTableSviper.h"
#import "HistoryTableView.h"

#import "HintView.h"

#import "recBut.h"
#import "SettingButton.h"

#import "ShareButton.h"
#import "NoticeButton.h"
#import "PlusButton.h"
#import "DelButton.h"
#import "DownButton.h"

#import "AppearedController.h"
#import "Transition.h"
#import "BackTransition.h"
//here its only test
#import "SettingsViewController.h"
#import "ShowedViewController.h"

#import "AboutViewController.h"
//#import "SettingViewController.h"
#import "ClearHistoryButton.h"
#import "DesignButton.h"

#import "Clr.h"
#import "DesignObject.h"
#import "AtrStrStore.h"

#import "CreateNewButtonViewController.h"

#define DEBUG_MODE NO

#define ANGLE_OFFSET (M_PI_4 * 0.1f)
#define X_OFFSET 2.0f
#define Y_OFFSET 2.0f
#define IS_568_SCREEN ([[UIScreen mainScreen]bounds].size.height == 568. || [[UIScreen mainScreen]bounds].size.width == 568.)

//#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
//#define IS_X ([[UIScreen mainScreen]bounds].size.height == 812. || [[UIScreen mainScreen]bounds].size.width == 812.)
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

//define design numbers
//#define DESIGN_CLASSIC 1
//#define DESIGN_PAPER 2
//#define DESIGN_COLOR_BLUE 30
//#define DESIGN_COLOR_GREEN 31
//#define DESIGN_COLOR_PINK 32
//#define DESIGN_COLOR_YELOW 33
//#define DESIGN_COLOR_GRAY 34
//#define DESIGN_PHOTO 4

//types of calculator buttons
//#define MAIN_BUTTON 1
//#define CHANGE_BUTTON 2
//#define CHANGE_BUTTON_NOT_DELETABLE 3
//#define DELETED_BUTTON 4
//#define DELETED_USER_BUTTON 5


//for constrain layout
#define IPHONE_RATIO_BUTTONS_VIEW 1.33
#define IPHONE_X_RATIO_BUTTONS_VIEW 1.54
#define IPAD_RAIO_BUTTONS_VIEW 1.3
#define IPHONE_SCREEN_VS_WIDTH_RATIO 0.25
#define IPAD_SCREEN_VS_WIDTH_RATIO 0.14

//NSString *const MainControllerSendPayPossibilityNotification = @"MainControllerSendPayPossibilityNotification";
//NSString *const MainControllerNotAvailableForBuingNotification = @"MainControllerNotAvailableForBuingNotification";
#pragma mark CHANGES FROM OTHER CONTROLLERS
NSString *const ReciveChangedNotification=@"SendChangedNotification";

@interface ITSCalcViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIApplicationDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, HistoryTableViewCellDelegate, UICollectionViewDelegateFlowLayout,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, DisplayRamDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, /* not shure its needed*/AppearedViewControllerProtocol, UIViewControllerTransitioningDelegate,ButtonsStoreProtocol, CellButtonActionDelegate, DesignStrDelegate, UIContentContainer,NSFilePresenter,AtrStrStoreSourse>


//outlets
//
//Main container view

#pragma mark INSERTED PROPERTIES
//need thees properties for right calc layout
@property (nonatomic) BOOL isCalcShowed;
@property (nonatomic) BOOL isHistoryShowed;


//it depend opasity of buutons and screen label, and view of histroydrager


#pragma mark TRANSITOPN PROPERTIES
@property (weak,nonatomic) Transition* transition;
@property (weak,nonatomic) SettingsViewController* settingsController;
@property (weak,nonatomic) ShowedViewController* showedController;
@property (nonatomic,strong) NSAttributedString *strAtrrForShow;
@property (nonatomic,strong) NSAttributedString *resStringForShow;
@property (nonatomic) BOOL callShowController;
@property (nonatomic) BOOL showControllerIsForward;

#pragma mark DESIGN OBJECT
@property (nonatomic, strong) DesignObject* designObj;
@property (nonatomic,strong) AtrStrStore* atrStore;
@property (weak, nonatomic) HintView *hintView;
@property (weak,nonatomic) UIImageView *imageBackgroundView;
//@property (nonatomic) int wasRightShowed; //need for show Shoving view at rotation 0 - not on screen, 1- was in left rotation, 2 - was in right rotation
//important not shure its need
//@property (nonatomic) UIDeviceOrientation wasRotatedNotificationAnotherController;
@property (nonatomic) BOOL willBePortraitRotated;
//necessary height of element for 3,5" screen
//@property (nonatomic) CGFloat histroryTableViewHeight;
//@property (nonatomic) CGFloat labelViewHeight;
//@property (nonatomic) CGFloat lastRowHistoryTableHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
//recognizers
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *moveButtonsPanGestureRecognizer; //pan gesture recognizer

//@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
//Display view
@property (weak, nonatomic) IBOutlet UIView *displayContainer;

@property (weak, nonatomic) IBOutlet UIView *labelsDisplayContainer;

@property (weak, nonatomic) IBOutlet DisplayScreenLabel *mainLabel;
//@property (weak, nonatomic) IBOutlet DisplayLabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *decLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoryOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoryTwoLabel;




@property (nonatomic, strong) DisplayRam *displayRam; //outbut dta from dislplay /input to display

@property (weak, nonatomic) UIView*blackViewforPhotoBackground;
//@property (weak, nonatomic) IBOutlet UIToolbar *backgroundToolBar; //background for display
//fix button to fix changes and settibgs

@property (weak, nonatomic) IBOutlet NoticeButton *noticeButton;

@property (weak, nonatomic) IBOutlet PlusButton *plusButton;

@property (weak, nonatomic) IBOutlet recBut *recountButton;

@property (weak, nonatomic) IBOutlet DelButton *deleteButton;
@property (weak, nonatomic) IBOutlet ShareButton *shareButton;

@property (weak, nonatomic) IBOutlet SettingButton *settingsButton;

//History table view

@property (weak, nonatomic) IBOutlet UITableView *historyTable;
//property to show is one row from history table is selected
@property (strong, nonatomic) HistroryTableViewCell *selectedRow;
//attributes for historyTable
//@property (nonatomic,strong) NSDictionary * attributes;

//items for dynamic draging


//@property (nonatomic) CGFloat wasDynamicOriginY;
@property (weak, nonatomic) IBOutlet HistoryTableSviper *historyTableSviper;
//@property (nonatomic) CGPoint svipeGestureLocation;


//bool property for paid version
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAdTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAdHeightConstrain;

@property (nonatomic) BOOL canShowBanner; //set to YES after first operation = if WasPurchaised allways NO
@property (nonatomic) BOOL isIAdBannerOnScreen; //to find out if the banner on the screen
//@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;

//@property (nonatomic) BOOL isIAdBaneerAvailable;
@property (nonatomic) NSInteger bannerRequestCounter;// need to limitation of IAd banner request at pressing "equal"


//Settings
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons
@property (nonatomic) BOOL isSoundOn;
@property (nonatomic) BOOL isBigDataBase; //size dataBase
@property (nonatomic) int limitInDataBase;
//@property (nonatomic) NSInteger design;
@property (nonatomic) BOOL isNeedToBeReloadedAfterDesignChanged;

//@property (nonatomic) BOOL isiCloudInUse;
//@property (nonatomic) BOOL isiCloudUseSwitcherEnabled;
//@property (nonatomic) BOOL fristLunchWithicloudAvailable;
//need to set iClouds images whole & empty
//arrays to quick start scrollViews (buttonsCollection & historyTable)
//@property (nonatomic) NSArray* buttonsNames;
@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *infoAttributedStrings;
@property (nonatomic) NSArray *mainAttributedStrings;
//Showed View
//@property (nonatomic, strong) UIDynamicAnimator *animator;

//Document
//@property (nonatomic, retain) UIDocumentInteractionController *docController;
//@property (nonatomic, strong) UIManagedDocument *doc;

//Fetch controller
// Causes the fetchedResultsController to refetch the data.
// You almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
@property (nonatomic,strong) NSArray* lastRowDataArray;

//IMPORTANT NEED TO DELETE THIS PROPERTY
@property (nonatomic,strong) NSAttributedString *lastRowsString;

//for set values of row hight in historyTableView
//@property (nonatomic,strong) NSArray *heightsOfRows;
//need for manage at controller changes
//for adding new heights value at didChangeController
//@property (nonatomic,strong) NSDictionary *heigthsOfNewRowsAccordingNewObjs;
//set for delleting indexis at didChangeController
//@property (nonatomic,strong) NSIndexSet *deletedIndexesSet;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *buttonManagedObjectContext;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (nonatomic,strong) NSURL * storeURL;
//@property (nonatomic, strong) NSURL *localStoreUrl;
//@property (nonatomic, strong) NSURL* iCloudURL;
//set managed obj context specially for buttons

//Buttons arrays
@property (nonatomic,strong) ButtonsStore *buttonsStore;




//necessary conditions for counting
@property (nonatomic, assign) BOOL userIsInTheMidleOfEnteringNumber;
@property (nonatomic, assign) BOOL isProgramInProcess;// for not clear stack at the entering new number: 2 + newNumber instead on 2 + 2 =, newNumber
@property (nonatomic, assign) BOOL isStronglyArgu; //the argument is strongly setted by user
@property (nonatomic,assign) BOOL isDecCounting;
@property (nonatomic,assign) BOOL isResultFromMemory; //is result on screen is taked up from memory

//make int property only for test NSTimer
//@property (nonatomic,strong) NSIndexPath * patch;
@property (nonatomic, strong) NSTimer *animationTimer;//for delet and set buttonsView animation
@property (nonatomic, strong) NSTimer *secondTimer; //for move button at pan gesture
@property (nonatomic,strong) NSMutableArray *buttonsToMoveArray;
@property (nonatomic, assign) NSInteger itemOfNeedPosition;

//make this property to move button
//@property (nonatomic,strong) newButtonView * buttonsAsSubView; //strong
//@property (nonatomic, strong) NewButtonsCollectionViewCell * subCell;
//@property (nonatomic, strong) NewButtonsCollectionViewCell * findCell;
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
//@property BOOL debug;
@end

@implementation ITSCalcViewController

//set this property to allow tap botton buttons in buttonsCollectionView

#pragma mark INITIALIZATION

-(BOOL) prefersStatusBarHidden
{
    return YES;
    //self.buttonsCollection.frame
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
-(ButtonsStore*) buttonsStore{
    if(!_buttonsStore){
        _buttonsStore = [[ButtonsStore alloc] init];
        _buttonsStore.delegate = self;
    }
    return _buttonsStore;
}
#pragma mark SET VARIABLES
-(void) setCallShowController:(BOOL)callShowController
{
    _callShowController = callShowController;
    /*if(_callShowController){
        [self showShowedView];
    }*/
}
-(void) setPhotoBackGround:(BOOL)isPhoto
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documentName;
    if(isPhoto){
        documentName = @"PhotoPicture";//@"MyDocument.sqlite"
    } else {
        documentName = @"PaintedPicture";//@"MyDocument.sqlite"
    }
    
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    UIImage *imageForPhotoPart;
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        if([fileManager isDeletableFileAtPath:[storeURL path]]){
            imageForPhotoPart = [UIImage imageWithData:[NSData dataWithContentsOfURL:storeURL]];
        } else {
           // [UIImage imageNamed:/*@"handmadepaper.png"*/@"photoGround.png"];
        }
    } else {
       // [UIImage imageNamed:/*@"handmadepaper.png"*/@"photoGround.png"];
        
    }
    if(!self.imageBackgroundView){
        id minValue;
        id maxValue;
        if(IS_IPAD){
            minValue = @(60);
            maxValue = @(-60);
        } else {
            minValue = @(40);
            maxValue = @(-40);
        }
        UIImageView *imageBackgroundView = [[UIImageView alloc] initWithImage:imageForPhotoPart];
        imageBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
        //imageBackgroundView.contentMode = UIViewContentModeScaleAspectFit;
        [self.mainContainerView insertSubview:imageBackgroundView atIndex:0];
        self.imageBackgroundView = imageBackgroundView;
        
        // Do any additional setup after loading the view, typically from a nib.
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = minValue;
        verticalMotionEffect.maximumRelativeValue = maxValue;
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = minValue;
        horizontalMotionEffect.maximumRelativeValue = maxValue;
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self.imageBackgroundView addMotionEffect:group];
    } else {
        [self.imageBackgroundView setImage:imageForPhotoPart];
    }
    if(isPhoto){
        if(!self.blackViewforPhotoBackground){
            UIView* blackViewforPhotoBackground = [[UIView alloc] init];
            blackViewforPhotoBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            [self.imageBackgroundView addSubview:blackViewforPhotoBackground];
            self.blackViewforPhotoBackground = blackViewforPhotoBackground;
        }
    } else {
        if(self.blackViewforPhotoBackground){
            [self.blackViewforPhotoBackground removeFromSuperview];
        }
    }
}

-(void)setDesignObj:(DesignObject *)designObj{
    _designObj = designObj;
    self.view.backgroundColor = self.designObj.mainViewBackgroundColor;
    self.historyTable.backgroundColor = self.designObj.historyTableColor;
    self.historyTableSviper.designObj = self.designObj;
    
   // self.displayContainer.backgroundColor = self.designObj.displayContainerColor;
    //self.displayBackground.hidden = self.designObj.isScreenBlurHiden;
    //self.displayBackground.effect = self.designObj.screenBlurEffect;
    
    
    self.mainLabel.designObj = self.designObj;
    
    
    
    //self.mainLabel.textColor = self.designObj.screenTextColor;
    self.decLabel.textColor = self.designObj.screenTextColor;
    self.memoryOneLabel.textColor = self.designObj.screenTextColor;
    self.memoryTwoLabel.textColor = self.designObj.screenTextColor;
    
    //display's buttons
    self.settingsButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.settingsButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.settingsButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    self.shareButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.shareButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.shareButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    self.noticeButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.noticeButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.noticeButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    self.plusButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.plusButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.plusButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    self.recountButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.recountButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.recountButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    self.deleteButton.shadowColor = self.designObj.screenButtonShadowColor;
    self.deleteButton.shadowBlur = self.designObj.screenButtonShadowBlur;
    self.deleteButton.shadowSize = self.designObj.screenButtonShadowSize;
    
    
    //may be this not need  - let check
    self.isNeedToBeReloadedAfterDesignChanged = YES;
    
    
}

/*
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
 */

#pragma mark COUNTING METHODS AND PROPERTIES
//used
-(void) setIsDecCounting:(BOOL)isDecCounting
{
    _isDecCounting = isDecCounting;
    if(isDecCounting){
        [self.decLabel setText:@" DEG"];
    } else {
        [self.decLabel setText:@" RAD"];
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


#define ALERT_TITLE_ASSES NSLocalizedStringFromTable(@"ALLERT_TITLE_ASSES",@"ACalcTryViewControllerTable", @"YOUR OPINION IS IMPORTANT TO ME")
#define ALERT_MESSAGE_ASSES NSLocalizedStringFromTable(@"ALLERT_MESSAGE_ASSES",@"ACalcTryViewControllerTable", @"...should I stay or should I go?")
#define ALERT_ASSES_NO_BUTTON NSLocalizedStringFromTable(@"ALLERT_ASSES_NO_BUTTON",@"ACalcTryViewControllerTable", @"No, thanks")
#define ALERT_ASSES_ASSES_APLICATION_BUTTON NSLocalizedStringFromTable(@"ALERT_ASSES_ASSES_APLICATION_BUTTON",@"ACalcTryViewControllerTable", @"Аssess the application")
#define ALERT_ASSES_REMIND_LATER_BUTTON NSLocalizedStringFromTable(@"ALERT_ASSES_REMIND_LATER_BUTTON",@"ACalcTryViewControllerTable", @"Remind later")


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
            [HintView newHintViewWithFrame:self.mainContainerView.frame
                                 labelRect:self.mainContainerView.frame
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
                CGRect collectionVisibleRect = self.viewforCurrencyRecognizer.frame;
                collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
                collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
                HintView *hintView =
                [HintView newHintViewWithFrame:self.mainContainerView.frame
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
            
            CGRect collectionVisibleRect = self.viewforCurrencyRecognizer.frame;
            collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
            collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
            HintView *hintView =
            [HintView newHintViewWithFrame:self.mainContainerView.frame
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
    if ([title isEqualToString:ALERT_ASSES_ASSES_APLICATION_BUTTON]){
        //NSString *iTunesLink = @"itms-apps://itunes.apple.com/us/app/its-calc/id873164530?l=ru&ls=1&mt=8";
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=873164530&type=Purple+Software";//&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALERT_ASSES_NO_BUTTON]){
        self.counterForShowingAllertView = -1;
        
    } /*else if ([title isEqualToString:USE_ICLOUD]){
        self.isiCloudInUse = YES;
    }*/
    
}

-(void) setIsBigDataBase:(BOOL)isBigDataBase
{
    _isBigDataBase = isBigDataBase;
}

-(int) limitInDataBase{
    return self.isBigDataBase ? 200 : 500;
}





//delegate method to allow read gestures (PAN AND SCROLL) toogether
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark ACTIONS
- (IBAction)plusButtonTapped:(UIButton *)sender {
    NSArray *programm;
    NSString *programmDescription = @"";
    if(self.selectedRow){ //if there is not first row
            NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
            if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
                NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
                History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSMutableArray *programFromHistory = [[NSKeyedUnarchiver unarchiveObjectWithData:story.program] mutableCopy];

                //remover result
                if([programFromHistory lastObject]) [programFromHistory removeLastObject];

                
                if([programFromHistory lastObject]){
                    programm = [self arrayForNewButtonFromArgu:[programFromHistory lastObject]]; //set attributes as program

                    //check if constant add value as description
                    if([[programm firstObject] isKindOfClass:[NSNumber class]]){
                        programmDescription = [(NSNumber*)[programm firstObject] stringValue];
                    } else {
                        programmDescription = [ACalcBrain descriptionOfProgram:[[programFromHistory lastObject] mutableCopy] withAttributes:self.atrStore.mainAttributes].string;
                    }
                }
                
            
            } else {//if its first row
                programm = [self arrayForNewButtonFromArgu:[self.brain argu]];//set argu
                //check if constant add value as description
                if([[programm firstObject] isKindOfClass:[NSNumber class]]){

                    if([[self.displayRam getResult]isKindOfClass:[NSNumber class]]){
                        programm = [self.displayRam getResult];
                        programmDescription =[[self.displayRam getResult] stringValue];
                    } else if([[self.displayRam getResult] isKindOfClass:[NSArray class]]){
                        programm = [[NSArray alloc] initWithArray:[self.displayRam getResult]];
                        
                        
                        NSMutableArray *copyGradArray = [[self.displayRam getResult] mutableCopy];
                        [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
                        programmDescription = [ACalcBrain descriptionOfProgram:copyGradArray withAttributes:self.atrStore.mainAttributes].string;
                        //programmDescription =[[self.displayRam getResult] stringValue];
                    } else {//if for eaxample it is grad value
                        programmDescription = [(NSNumber*)[programm firstObject] stringValue];
                    }
                } else {
                      programmDescription = [ACalcBrain descriptionOfProgram:[self.brain argu] withAttributes:self.atrStore.mainAttributes].string;
                }

              
        }
        
    } else { //if not selected ctach programm from first row
        programm = [self arrayForNewButtonFromArgu:[self.brain argu]];//set argu
        //check if constant add value as description
        if([[programm firstObject] isKindOfClass:[NSNumber class]]){
            programmDescription = [(NSNumber*)[programm firstObject] stringValue];
        } else {
            programmDescription = [ACalcBrain descriptionOfProgram:[self.brain argu] withAttributes:self.atrStore.mainAttributes].string;
        }
  
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateNewButtonViewController *createNewButtonViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CreateNewButtonViewController"];
    createNewButtonViewController.program = programm;
    createNewButtonViewController.programDescription = programmDescription;
    createNewButtonViewController.delegate = self.buttonsStore;
    [self presentViewController:createNewButtonViewController animated:YES completion:^{
        nil;
    }];
}

-(NSArray*)arrayForNewButtonFromArgu:(NSArray*)argu{
    NSMutableArray* outputButtonProgram = [[NSMutableArray alloc] init];
    NSMutableArray* signArray = [NSMutableArray arrayWithObjects:@"", @"",@"",@"", nil];

    //check argu array
    //if argu contains $, X of Y
    
    //  make first obj - @"f"
    //  then create array of three objects: @"",@"",@"" - if there are set 1 - $, 2 - x, 3 - y
    //  if 1 == $, next array set as currensies exchange pairs
    NSArray* currencies = [ACalcBrain chekForCurrensiesProgramm:argu];
    if(currencies){

        signArray[0] = @"f";//this is a function
        signArray[1] = @"$";//this is currensies pair in function
    }
    
    NSSet *variables = [ACalcBrain chekForVariablesInProgramm:argu];
    if([variables count]){

        signArray[0] = @"f"; //this is a function
        if([variables containsObject:@"x"]){
            signArray[2] = @"x";
        }
        if([variables containsObject:@"y"]){
            signArray[3] = @"y";
        }
    }
    
    //else if program equal constant - set just number value
    if(![signArray[0] isEqualToString:@"f"]){

        NSNumber *constantFromProgramm = [NSNumber numberWithDouble:[ACalcBrain runProgram:argu]];
        [outputButtonProgram addObject:constantFromProgramm];
    }else {
        [outputButtonProgram addObject:signArray];
        if(currencies){
            [outputButtonProgram addObject:currencies];
        }
        [outputButtonProgram addObject:argu];
    }
    
    return [outputButtonProgram copy];
    
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
                
                
                //check if the button has a program
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
                request.predicate = [NSPredicate predicateWithFormat:@"nameButton = %@", title];
                
                NSError *error;
                NSArray *matches = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
                
                if(!matches || error ){
                  //  NSLog(@"Button not fetched");
                } else {
                    Buttons *obj = [matches firstObject];
                    if(obj.program == nil){
                        [self tappedButtonWithTitle: title];
                    } else {
                        id prog = [NSKeyedUnarchiver unarchiveObjectWithData:obj.program];
                        //NSLog(@"obj.program: %@", prog);
                        if([prog isKindOfClass:[NSNumber class]]){
                            NSDictionary *buttonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:prog, title, nil];
                            [self tappedButtonWithTitle: buttonDictionary];
                        } else if ([prog isKindOfClass:[NSArray class]]){
                            NSDictionary *buttonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:prog, title, nil];
                            [self tappedButtonWithTitle: buttonDictionary];
                        }
                      //  NSLog(@"Button has a program");
                    }
                }
 

                //[self tappedButtonWithTitle: title];
                if ([title isEqualToString:@"rad"] || [title isEqualToString:@"deg"] ) {
                    if([title isEqualToString:@"rad"]){
                        cell.name = @"deg";
                    } else if ([title isEqualToString:@"deg"]){
                        cell.name = @"rad";
                    }
                    
                }
                
            }
            [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        
    }
}

/*
-(NSString*)currencyStringFromCurrencyArray:(NSArray*)currArr
{
    NSString *retStr = nil;
    if([currArr[1] isKindOfClass:[NSString class]] && [currArr[2] isKindOfClass:[NSString class]] && [currArr[3] isKindOfClass:[NSNumber class]]){
        
        retStr = [(NSString*)currArr[1] stringByAppendingString:@"/"];
        retStr = [retStr stringByAppendingString:currArr[2]];
        retStr = [retStr stringByAppendingString:@" = "];
        retStr = [retStr stringByAppendingString:[(NSNumber*)currArr[3] stringValue]];
    }
    
    return retStr;
}
*/

-(void)tappedButtonWithTitle:(id)title
{
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
    
    if([title isKindOfClass:[NSArray class]]){
        if([(NSArray*)title count]==4 && [(NSString*)title[0] isEqualToString:@"$"]){
            if(self.userIsInTheMidleOfEnteringNumber){
                //ok for that
                [self push];
                //ok for that
                self.userIsInTheMidleOfEnteringNumber = NO;
            } /*else {
                //ok for that
                [self.brain clearArgu];
            }*/
            else if (self.isResultFromMemory){
                [self push];
                self.isResultFromMemory = NO;
            }
           // NSString *resStr = [NSString stringWithFormat:@"%.2f",[self.brain performOperationInArgu:title]]; //formated string from double
            //resStr = [resStr stringByAppendingString:(NSString*)title[2]];
            //[self.display showString:[self.displayRam setResult:resStr]];
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
            
            
            
        }
    }else if ([title isKindOfClass:[NSDictionary class]]){
        //if there is constant or function
        //add
        NSString *keyTitle = [[title allKeys]firstObject];
        id valueProg = [title objectForKey:keyTitle];
        if([valueProg isKindOfClass:[NSNumber class]]){
            if(self.userIsInTheMidleOfEnteringNumber){
            //[self push];
                self.userIsInTheMidleOfEnteringNumber = NO;
            } else {
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                } else {
                    [self.brain clearArgu];
                }
            }
            [self.mainLabel showString:[self.displayRam addSymbol:title]];
            //[self.brain performOperationInArgu:title];
            self.isResultFromMemory = YES;
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
        } else if([valueProg isKindOfClass:[NSArray class]]){
            if([valueProg containsObject:@"°"]){
               // NSLog(@"OK it was graduses");
                if(self.userIsInTheMidleOfEnteringNumber){
                    //[self push];
                    self.userIsInTheMidleOfEnteringNumber = NO;
                } else {
                    [self.displayRam clearRam];
                    if(!self.isProgramInProcess){
                        [self setStoryInforamtion];
                        [self.brain clearOperation]; //if it's just new argument, not new counting
                    } else {
                        [self.brain clearArgu];
                    }
                }
                [self.mainLabel showString:[self.displayRam addSymbol:title]];
                //[self.brain performOperationInArgu:title];
                self.isResultFromMemory = YES;
                self.isStronglyArgu = YES;
                [self showStringThruManageDocument];
            } else {
                if(DEBUG_MODE){
                    NSLog(@"There no graduses");
                }
            }
        }
        
    }else if([title isKindOfClass:[NSString class]]){
        if((([title floatValue] != 0.0) || [title isEqualToString:@"0"]) && ![operands containsObject:title] ){
            NSNumber *symbol = [NSNumber numberWithInt:[title intValue]];
            if(self.userIsInTheMidleOfEnteringNumber){
                [self.mainLabel showString:[self.displayRam addSymbol:symbol]];
            }else {
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                }
                [self.mainLabel showString:[self.displayRam addSymbol:symbol]];
                self.userIsInTheMidleOfEnteringNumber = YES;
            }
            
            //for update string for show view
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:[self.cellHeights count]  inSection:0];
            [self getStringsForShowedControllerForCell:lastRow];

            
        } else if([title isEqualToString:[self point]]){
            if(self.userIsInTheMidleOfEnteringNumber){
                
                [self.mainLabel showString:[self.displayRam addSymbol:@"."]];
            } else {
                [self.displayRam clearRam];
                [self.mainLabel showString:[self.displayRam addSymbol:@0]];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation];
                }
                [self.mainLabel showString:[self.displayRam addSymbol:@"."]];
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
            [self.mainLabel showString:[self.displayRam addSymbol:@0]];
            
            if((!self.userIsInTheMidleOfEnteringNumber) || (curentValue == 0)){
                [self setStoryInforamtion];
                [self.brain clearOperation];
                
                //show Ad banner
                if(self.canShowBanner && (!self.isIAdBannerOnScreen)){
                    [self appearAdBanner];
                }
            }
            self.userIsInTheMidleOfEnteringNumber = NO;

            self.isProgramInProcess = NO;
            
        } else if([title isEqualToString:@"⌫"]){
            if(!self.userIsInTheMidleOfEnteringNumber){
                self.isStronglyArgu = [self.brain deleteLastElement];
                self.isProgramInProcess = YES;
                [self.displayRam clearRam];
                [self.mainLabel showString:[self.displayRam addSymbol:@0]];
                self.userIsInTheMidleOfEnteringNumber = NO;
                
            } else {
                
                [self.mainLabel showString:[self.displayRam deleteLastSymbol]];//?? what about grad
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
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                } else {
                    [self.brain clearArgu];
                }
            }
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:@".00"]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain perfomOperation:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
            self.isProgramInProcess = NO;
            self.isStronglyArgu = YES;
            
            //check the brackets
            [self showStringThrouhgmanagerAtEqualPress];
            [self.brain insertBracket:NO];
            //
            //show what i can
            //
            /*
            if(self.counterForShowingAllertView > 26){
                if(self.fristLunchWithicloudAvailable){
                    //Important set heere appeared view
                    //[self askUserForiCloudStorage];
                }
            }
            */
            if((25 < self.counterForShowingAllertView) && (self.counterForShowingAllertView < 37)){
                
                [self showHintViewAccordingCounter];
                
                //important
            } //else {
            //Important show about view
            //1. Check if its a trilal period
            if(self.isTrialPeriod){
                //2. Calculate current value trila period in days(trialDays - (current - start trial time)). For its necessary setup start date and fix it in cloud storage
               // NSInteger intervalSinceStartInDays = (NSInteger)[self.startTrialDate timeIntervalSinceNow];
               // NSInteger daysToEndOfTrialPeriod = DAYS_ALOWED_TRIAL_PERIOD + intervalSinceStartInDays/20 ; //Important 86400;// (one day
               // NSLog(@"daysToEndOfTrialPeriod %ld", (long)daysToEndOfTrialPeriod);//Important - clear
                
                //important test!!!
                
                //!!!!![self testShowAppController];
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
                    [self.mainLabel showString:[self.displayRam addSymbol:@"∓°"]];
                } else if(number == 0){
                    [self.mainLabel showString:[self.displayRam addSymbol:@"-"]];
                } else {
                    [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:number *(-1.0)]]];
                }
            } else {
                [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain checkMinusOrDivideOperationOnDubble:title]]]];
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
            [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain checkMinusOrDivideOperationOnDubble:title]]]];
            
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
            
        } else  if ([title isEqualToString:@"("]){
            
            [self.brain insertBracket:YES];
            [self.displayRam clearRam];
            [self.mainLabel showString:[self.displayRam addSymbol:@0]];
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
                [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
                [self.brain insertBracket:NO];
                self.isStronglyArgu = YES;
                [self showStringThruManageDocument];
            }
            
        } else if ([title isEqualToString:@"Mc"]){
            self.memoryOneLabel.text = @"";
            [self.displayRam clearMemory:YES];
            
        } else if ([title isEqualToString:@"Mr"]){
            if([self.memoryOneLabel.text isEqualToString:@"M"]){
                self.isResultFromMemory = YES;
                [self.mainLabel showString:[self.displayRam getResultFromMemory:YES]];
            }
            
        } else if ([title isEqualToString:@"M+"]){
            self.memoryOneLabel.text = @"M";
            [self.displayRam addResToMemory:YES inRadians:!self.isDecCounting];
            self.isResultFromMemory = YES;
            
        } else if ([title isEqualToString:@"M-"]){
            self.memoryOneLabel.text = @"M";
            [self.displayRam substractResFromMemory:YES inRadians:!self.isDecCounting];
            self.isResultFromMemory = YES;
            
        } else if ([title isEqualToString:@"MIc"]){
            self.memoryTwoLabel.text = @"";
            [self.displayRam clearMemory:NO];
            
        } else if ([title isEqualToString:@"MIr"]){
            if([self.memoryTwoLabel.text isEqualToString:@"MI"]){
                self.isResultFromMemory = YES;
                [self.mainLabel showString:[self.displayRam getResultFromMemory:NO]];
            }
            
        } else if ([title isEqualToString:@"MI+"]){
            self.memoryTwoLabel.text = @"MI";
            [self.displayRam addResToMemory:NO inRadians:!self.isDecCounting];
            self.isResultFromMemory = YES;
            
        } else if ([title isEqualToString:@"MI-"]){
            self.memoryTwoLabel.text = @"MI";
            [self.displayRam substractResFromMemory:NO inRadians:!self.isDecCounting];
            self.isResultFromMemory = YES;
            
        } else if ([title isEqualToString:@"X"] || [title isEqualToString:@"Y"]){
            
            //add
            
            if(self.userIsInTheMidleOfEnteringNumber){
                [self push];
                self.userIsInTheMidleOfEnteringNumber = NO;
            } else {
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                } else {
                    [self.brain clearArgu];
                }
            }
            [self.mainLabel showString:[self.displayRam addSymbol:[title lowercaseString]]];
            [self.brain performOperationInArgu:[title lowercaseString]];

            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
            
            
        } else if ([title isEqualToString:@"Z"]){
            
        } else if ([title isEqualToString:@"Tab"]){
            
        } else if ([title isEqualToString:@"Grph"]){
            
        } else if ([title isEqualToString:@"+f(x)"]){
            
        } else if ([title isEqualToString:@"rad"] || [title isEqualToString:@"deg"] ) {
            if([title isEqualToString:@"rad"]){
                //cell.name = @"deg";
                [self.decLabel setText:@" RAD"];
                self.isDecCounting = NO;
            } else if ([title isEqualToString:@"deg"]){
                //cell.name = @"rad";
                [self.decLabel setText:@" DEG"];
                self.isDecCounting = YES;
            }
            
        } else if ([title isEqualToString:@"° ′″"]){
            if(self.userIsInTheMidleOfEnteringNumber){
                [self.mainLabel showString:[self.displayRam addSymbol:@"° ′″"]];
            } else {
                [self.mainLabel showString:[self.displayRam setResult: self.isDecCounting? @"D" : @"R"]];
            }
            
        }

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
        //[self lastRowUpdate];

    }
    
    if(!self.wasPurshaised){
        self.canShowBanner = YES;
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
    //[self lastRowUpdate];
    
}

-(NSArray*) currentBrainProgramm{
    NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
    
    NSArray *deepProgram = [self.brain.deepProgram copy];
    NSArray *deepArgu = [self.brain.deepArgu copy];
    NSArray *testArray = [[deepProgram lastObject] copy];
    if(([testArray count]>0) || ([deepArgu count]>0)){
        
        //NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
        [muttableOutputArray addObject:deepProgram];
        [muttableOutputArray addObject:deepArgu];
    }
    
    return [muttableOutputArray copy];
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
        
        //if programm has currensies, get currencies array
        //NSArray* currensies = [ACalcBrain chekForCurrensiesProgramm:[muttableOutputArray copy]];
        
        //add result to array
        [muttableOutputArray addObject:[NSNumber numberWithDouble:[self.brain count]]];
        //NSMutableArray * currentBrainProgramm = [[self currentBrainProgramm] mutableCopy];
    
        //add result to array
        //[muttableOutputArray addObject:[NSNumber numberWithDouble:[self.brain count]]];
        
        /*
         //if programm has currensies, get currencies array
         NSArray* currensies = [ACalcBrain chekForCurrensiesProgramm:[muttableOutputArray copy]];
        //if currensies was, make string from each pair in array and add to currString
        if(currensies){
            NSString *currStr = @"";
            for(NSArray* currPair in currensies){
                currStr = [currStr stringByAppendingString:currPair[1]];
                currStr = [currStr stringByAppendingString:@"/"];
                currStr = [currStr stringByAppendingString:currPair[2]];
                currStr = [currStr stringByAppendingString:@"="];
                currStr = [currStr stringByAppendingString:[currPair[3] stringValue]];
                currStr = [currStr stringByAppendingString:@" "];
            }
            
            NSAttributedString *curAtrStr = [ACalcBrain stringCurrensiesInProgram:[muttableOutputArray copy] withAtrtributes:self.atrStore.mainAttributes];
            currStr = [curAtrStr string];
            
            
            
        }
        else {
            [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
        }
        */
        [History storyWithProgram:[muttableOutputArray copy]
                           atDate:currDate
                     currensyRate:[ACalcBrain stringCurrensiesInProgram:[muttableOutputArray copy] withAtrtributes:self.atrStore.mainAttributes].string
              variabledescription:nil
            inManageObjectContext:self.managedObjectContext];
        //create new object in manageddoc with empty array
        
        
        NSArray *new = [[NSArray alloc] init];
        self.lastRowDataArray = new;
        //[self lastRowUpdate];
    } else {
        [self selectLastRowInHistory];
    }


    //set counter to show allert view
    if(self.counterForShowingAllertView != -1){
        self.counterForShowingAllertView ++;
    }
}

-(void) push
{
    [self pushWithBrain:self.brain];
    /*
    id result = [self.displayRam getResult];
    
    if([result isKindOfClass:[NSDictionary class]]){
        NSString *key = [[result allKeys]firstObject];
        id prog = [result objectForKey:key];
        if([prog isKindOfClass:[NSNumber class]]){
            
        } else if([prog isKindOfClass:[NSArray class]]){
            if([prog containsObject:@"°"]){
                NSMutableArray *copyGradArray = [prog mutableCopy];
                [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
                result = [[NSDictionary alloc] initWithObjectsAndKeys:[copyGradArray copy], key, nil];
            }
        }
        [self.brain pushOperand:result];

    } else if(self.displayRam.isGradValue){
        if([result isKindOfClass:[NSArray class]]){
            NSMutableArray *copyGradArray = [result mutableCopy];
            [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
            [self.brain pushOperand:[copyGradArray copy]];
        } else {
            
        }
    } else {
        [self.brain pushOperand:result];
    }
    */
}

-(void)pushWithBrain:(ACalcBrain*)brain{
    id result = [self.displayRam getResult];
    
    if([result isKindOfClass:[NSDictionary class]]){
        NSString *key = [[result allKeys]firstObject];
        id prog = [result objectForKey:key];
        if([prog isKindOfClass:[NSNumber class]]){
            
        } else if([prog isKindOfClass:[NSArray class]]){
            if([prog containsObject:@"°"]){
                NSMutableArray *copyGradArray = [prog mutableCopy];
                [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
                result = [[NSDictionary alloc] initWithObjectsAndKeys:[copyGradArray copy], key, nil];
            }
        }
        [brain pushOperand:result];
        
    } else if(self.displayRam.isGradValue){
        if([result isKindOfClass:[NSArray class]]){
            NSMutableArray *copyGradArray = [result mutableCopy];
            [copyGradArray addObject: self.isDecCounting? @"D" : @"R" ];
            [brain pushOperand:[copyGradArray copy]];
        } else {
            
        }
    } else {
        [brain pushOperand:result];
        
    }
}

#pragma mark - BUTTONS COLLECTION
static BOOL wasisIAdBannerOnScreen;
-(void)setIsButtonsCollectionUnderChanging:(BOOL)is
{
    _isButtonsCollectionUnderChanging = is;
    //lock interaction
    self.buttonsCollection.userInteractionEnabled = NO;
    
    if(is){
        if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
            self.isAllowedToDelete = NO;
        } else {
            self.isAllowedToDelete = YES;
        }

        self.displayTopConstrain.constant = 0;
        self.sviperBottomConstrain.constant = -((self.calcScreenHeightConstrain.constant -self.historyTableSviper.frame.size.height)/2-self.calcScreenHeightConstrain.constant/10);
        
        wasisIAdBannerOnScreen = self.isIAdBannerOnScreen;
        if(self.isIAdBannerOnScreen){
            self.isIAdBannerOnScreen = NO;
            self.bannerAdTopConstrain.constant = -(self.bannerAdHeightConstrain.constant+10.);
        }
        
        [UIView animateWithDuration:.6
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:velocitySviperUnderChangin.y
                            options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                [self.view layoutIfNeeded];
                                self.labelsDisplayContainer.alpha = 0;
                            } completion:^(BOOL finished) {
                                [self.buttonsCollection reloadData];
                                //ulock interaction
                                self.buttonsCollection.userInteractionEnabled = YES;
                                self.longPressRecognizer.minimumPressDuration = 0.1;
                            }];
    } else {

       
        self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
        self.sviperBottomConstrain.constant = -self.calcScreenHeightConstrain.constant*14./20.;
        [self.buttonsCollection reloadData];
        
        self.isIAdBannerOnScreen = wasisIAdBannerOnScreen;
        if(self.isIAdBannerOnScreen){
            self.bannerAdTopConstrain.constant =bannerYOrigin;
        }
        
        [UIView animateWithDuration:.6
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:velocitySviperUnderChangin.y
                            options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                [self.view layoutIfNeeded];
                                self.labelsDisplayContainer.alpha = 1;
                                [self.buttonsCollection setContentOffset:CGPointMake(0, 0)];
                            } completion:^(BOOL finished) {
                                //ulock interaction
                                self.buttonsCollection.userInteractionEnabled = YES;
                                self.longPressRecognizer.minimumPressDuration = 0.5;
                            }];
    }
}


#pragma mark - GESTURES and Tap Fix  and delete Button at changeble conditions buttonscollection

//long press at display
- (IBAction)displayLongPress:(UILongPressGestureRecognizer *)sender
{
   //if display is show number
    if(self.mainLabel.alpha == 1){
        if(sender.state == UIGestureRecognizerStateBegan){
        
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:self.mainLabel.attributedText.string];
        
        //may be add some signal
            UIView *signalView = [[UIView alloc] initWithFrame:self.displayContainer.bounds];
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
        /*[[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];*/
        if(!self.isButtonsCollectionUnderChanging){
            velocitySviperUnderChangin = CGPointZero;
            self.isButtonsCollectionUnderChanging = YES;//launch changes constrains with animation
        } else {
            //1. fix button postion
            
            CGPoint tapLocation = [gesture locationInView:self.buttonsCollection];
            NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:tapLocation];
            //find needed cell
            if(indexPath){
                if([[self.buttonsCollection cellForItemAtIndexPath:indexPath] isKindOfClass:[NewButtonsCollectionViewCell class]]){
                    subCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:indexPath];
                    if((subCell.typeOfButton == CHANGE_BUTTON) || (subCell.typeOfButton == CHANGE_BUTTON_NOT_DELETABLE)){
                        CGRect subViewFrame;
                        subViewFrame = ((NewButtonsCollectionViewCell*)subCell).cellSubView.frame;
                        
                        
                        subViewFrame.origin = [subCell.cellSubView convertPoint:subViewFrame.origin toView:self.buttonsCollection];
                        
                        buttonsAsSubView = [[newButtonView alloc] initWithFrame:subViewFrame];
                        buttonsAsSubView.title = ((NewButtonsCollectionViewCell*)subCell).cellSubView.title;
                        buttonsAsSubView.buttonColor = ((NewButtonsCollectionViewCell*)subCell).cellSubView.buttonColor;
                        buttonsAsSubView.designObj = self.designObj;
                        buttonsAsSubView.alpha = 0.8;
                        [self.buttonsCollection addSubview:buttonsAsSubView];
                        subCell.hidden = YES;
                        
                        buttonsAsSubView.isTaped = YES;
                        CGFloat subX = buttonsAsSubView.frame.origin.x + (1- 3.1)*subCell.frame.size.width /2.;
                        CGFloat subY = buttonsAsSubView.frame.origin.y + (1- 3.1)*subCell.frame.size.height /2.;
                        CGFloat subWidth = subCell.frame.size.width * 3.1;
                        CGFloat subHeight = subCell.frame.size.height * 3.1;
                        [UIView animateWithDuration:.2
                                              delay:0
                                            options:UIViewAnimationOptionBeginFromCurrentState
                                         animations:^{
                                             [buttonsAsSubView setFrame:CGRectMake(subX, subY, subWidth, subHeight)];
                                         } completion:^(BOOL finished) {
                                             
                                             CGFloat subX = subCell.frame.origin.x + (1- 2.1)*subCell.frame.size.width /2;
                                             CGFloat subY = subCell.frame.origin.y + (1- 2.1)*subCell.frame.size.height /2 - 20.;
                                             CGFloat subWidth = subCell.frame.size.width * 2.1;
                                             CGFloat subHeight = subCell.frame.size.height * 2.1;
                                             
                                             [UIView animateWithDuration:.2
                                                                   delay:0
                                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                                              animations:^{
                                                                  [buttonsAsSubView setFrame:CGRectMake(subX, subY, subWidth, subHeight)];
                                                                  buttonsAsSubView.title = ((NewButtonsCollectionViewCell*)subCell).cellSubView.title;
                                                                  
                                                              } completion:^(BOOL finished){
                                                                  buttonsAsSubView.isTaped = YES;
                                                              }];
                                             
                                         }];
                    }
                }
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        
        if(self.isButtonsCollectionUnderChanging){
            if(buttonsAsSubView){
                CGRect subFrame = subCell.frame;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     [buttonsAsSubView setFrame:subFrame];
                                     
                                 } completion:^(BOOL finished) {
                                     subCell.hidden = NO;
                                     [buttonsAsSubView removeFromSuperview];
                                     buttonsAsSubView = nil;
                                 }];
                
            }
        }
    } else if(gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed){
        if(self.isButtonsCollectionUnderChanging){
            if(buttonsAsSubView){
                CGRect subFrame = subCell.frame;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     [buttonsAsSubView setFrame:subFrame];
                                 } completion:^(BOOL finished) {
                                     if(findCell){
                                     }
                                     subCell.alpha = 1.;
                                     [buttonsAsSubView removeFromSuperview];
                                     buttonsAsSubView = nil;
                                     NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:subCell]];
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
}

/*
- (IBAction)tapSettingsButton:(UIButton *)sender
{
    [self showSettingsViewcontroller];

}
*/

-(void) discardChanging
{
    
    //self.buttonsCollection.scrollEnabled = NO;
    //if there is buttonAsSubview in buttonCollection
    if(buttonsAsSubView){
        self.buttonsCollection.scrollEnabled = NO;
        CGRect subFrame = subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(findCell){
                             }
                             subCell.alpha = 1.;
                             [buttonsAsSubView removeFromSuperview];
                             buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                             self.buttonsCollection.scrollEnabled = YES;
                         }];
    }

    if(self.isButtonsCollectionUnderChanging){
        
        for(UICollectionViewCell* cell in [self.buttonsCollection visibleCells]){
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
        }
        

       // [self.doc updateChangeCount:UIDocumentChangeDone];
        NSError *error;
        //[self.managedObjectContext save:&error];
        [self.buttonManagedObjectContext save: &error];


    }
    
    /*[[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];*/

    //CGRect dynamicRect = self.dynamicContainer.frame;
    //dynamicRect.size.height = 2*self.mainContainerView.bounds.size.height - self.histroryTableViewHeight - self.labelViewHeight;
    
    //initial origin
    //dynamicRect.origin.y = self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.bounds.size.height;
    /*
    CGRect buttonsCollectionViewBounds = self.mainContainerView.bounds;
    buttonsCollectionViewBounds.size.height = self.mainContainerView.bounds.size.height - self.histroryTableViewHeight;
    buttonsCollectionViewBounds.origin.y = self.historyTable.bounds.size.height;

    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
//IMPORTANT
                         //delete here
                        // [self.dynamicContainer setFrame:dynamicRect];
     
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
     
                        //[self.viewforCurrencyRecognizer setFrame:buttonsCollectionViewBounds];
                         //[self.buttonsCollection setFrame:self.viewforCurrencyRecognizer.bounds];


                         
                         self.settingsButton.alpha = 0.;
                         if(IS_IPAD){
                             self.noticeButton.alpha = 0.;
                         }
                         
                         self.recountButton.alpha = 0.;
                         self.shareButton.alpha = 0.;
                         self.deleteButton.alpha = 0.;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.alpha = 0.;
                         self.plusButton.alpha = 0.;
                         
                         self.labelsDisplayContainer.alpha = 1.;
                         
                     } completion:^(BOOL finished){
                         self.isButtonsCollectionUnderChanging = NO;

                         self.settingsButton.hidden = YES;
                         if(IS_IPAD){
                             self.noticeButton.hidden = YES;
                         }
                         self.recountButton.hidden = YES;
                         self.shareButton.hidden = YES;
                         self.deleteButton.hidden = YES;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.hidden = YES;
                         self.plusButton.hidden = YES;

                         //think about it
                         if(!self.wasPurshaised){
                             //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         }
                         if(self.isSoundOn){
                             AudioServicesPlaySystemSound (_blankSoundFileObject);
                         }
                         //
                         [self.buttonsCollection reloadData];
                         self.buttonsCollection.scrollEnabled = YES;
                         
                        [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
                         
                         
                     }]; */
    //[self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];
    self.isHistoryShowed = NO;
    [self finisDraggingUpWithVelocity:CGPointZero];
    [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:YES];
    /*
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
        [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];
    } else {
    }*/
    
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }

}

/*
- (IBAction)tapFixButton:(UIButton*)sender
{
    if(!self.animationTimer.isValid){
        [self discardChanging];
    }
}
*/
#pragma mark DRAGGER HISTORY
//IMPORTANT
//    [self moveHistoryTableContentToRightPosition];
//IMPORTANT



CGPoint startDragerLocation;
CGFloat screenYOrigin;
CGFloat howHistoryWasShowedBeforeDrag;
CGPoint velocitySviperUnderChangin;//COPIED
CGFloat historyTableBottomOffset;

-(void)setIsCalcShowed:(BOOL)isCalcShowed{
    _isCalcShowed = isCalcShowed;
    if(isCalcShowed){
       
        self.settingsButton.hidden = YES;
        self.shareButton.hidden = YES;
        self.noticeButton.hidden = YES;
        self.plusButton.hidden = YES;
        self.recountButton.hidden = YES;
        self.deleteButton.hidden = YES;
    } else {
        self.settingsButton.hidden = NO;
        self.shareButton.hidden = NO;
        self.noticeButton.hidden = NO;
        self.plusButton.hidden = NO;
        self.recountButton.hidden = NO;
        self.deleteButton.hidden = NO;
        if(IS_IPAD && self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
            self.noticeButton.hidden = NO;
        }
    }
}

-(void) setIsHistoryShowed:(BOOL)isHistoryShowed{
    _isHistoryShowed = isHistoryShowed;
    if(isHistoryShowed){
        self.labelsDisplayContainer.hidden = YES;

    } else {
        self.labelsDisplayContainer.hidden = NO;
    }
}

-(void) changeHowHistoryShowed:(CGFloat)howHistoryShowed{
    self.historyTableSviper.pathOfDown = howHistoryShowed;
    
    self.labelsDisplayContainer.alpha = powf((1-howHistoryShowed),3.);
    self.settingsButton.alpha = powf(howHistoryShowed,3.);//COOL
    self.shareButton.alpha = powf(howHistoryShowed,3.);
    self.plusButton.alpha = powf(howHistoryShowed,3.);
    self.recountButton.alpha = powf(howHistoryShowed,3.);
    self.deleteButton.alpha = powf(howHistoryShowed,3.);
    if(IS_IPAD && self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
        self.noticeButton.alpha = powf(howHistoryShowed,3.);
    }
    
    //IMPORTANT
    //[self moveHistoryTableContentToRightPosition];
}

- (IBAction)tapHistoryDragger:(UITapGestureRecognizer *)sender {
    lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
    //selectedRowPatch = [self.historyTable indexPathForSelectedRow];

     historyTableBottomOffset = self.historyTable.contentOffset.y + self.historyTable.bounds.size.height;
    
    if(self.isButtonsCollectionUnderChanging == YES){
        velocitySviperUnderChangin = CGPointZero;
        self.isButtonsCollectionUnderChanging = NO;
    } else if(self.isHistoryShowed){
        self.isHistoryShowed = NO;
        [self finisDraggingUpWithVelocity:CGPointZero];
    } else if(self.isCalcShowed){
        self.isCalcShowed  = NO;
        [self finishDraggingDownWithVelocity:CGPointZero];
    } else {
       [self finishDraggingDownWithVelocity:CGPointZero];
    }
}



- (IBAction)dragSviperGesturRecognizer:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan){
        
        lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
        //selectedRowPatch = [self.historyTable indexPathForSelectedRow];
        historyTableBottomOffset = self.historyTable.contentOffset.y + self.historyTable.bounds.size.height;

        startDragerLocation = [sender locationInView:self.mainContainerView];
        screenYOrigin = self.displayTopConstrain.constant;
        
        if(!self.isButtonsCollectionUnderChanging){
            if(self.isCalcShowed){
                howHistoryWasShowedBeforeDrag = 0;
            } else if (self.isHistoryShowed){
                howHistoryWasShowedBeforeDrag = 1;
            } else {
                howHistoryWasShowedBeforeDrag = 0.5;
            }
            //start draggin - no calc and no history showed
            self.isCalcShowed = NO;
            self.isHistoryShowed = NO;
        }
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        CGFloat deltaHeight;
        if(self.isButtonsCollectionUnderChanging){
            deltaHeight = [sender locationInView:self.mainContainerView].y - startDragerLocation.y;
            CGFloat normalScreenTop=self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
            if(deltaHeight>= normalScreenTop){
                self.displayTopConstrain.constant = normalScreenTop;
            } else if(deltaHeight > 0){
                self.displayTopConstrain.constant = deltaHeight;
            }
            //[self.view layoutIfNeeded];
            
        } else {
            deltaHeight = [sender locationInView:self.mainContainerView].y - startDragerLocation.y;
            //startDragerLocation = [sender locationInView:self.mainContainerView];
            CGFloat newScreenTop = screenYOrigin + deltaHeight;
            CGFloat howHistoryShowed = ((newScreenTop+self.displayContainer.frame.size.height)-(self.mainContainerHeight.constant-maxButtonsCollectionHeight))/maxButtonsCollectionHeight;
            if(howHistoryShowed >= 1){
                self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant;
                howHistoryShowed = 1;
            } else if (howHistoryShowed <= 0){
                self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
                howHistoryShowed = 0;
            } else {
                self.displayTopConstrain.constant = newScreenTop;
            }

            [self changeHowHistoryShowed:howHistoryShowed];

            [self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];

            //[self.view layoutIfNeeded];
        }

        /*if(DEBUG_MODE){
            NSLog(@"sviperBottomConstrain: %f", self.sviperBottomConstrain.constant);
            NSLog(@"calcScreenHeight: %f", self.displayContainer.bounds.size.height);
        }*/

        
    } else {

        CGFloat deltaHeight;
        if(self.isButtonsCollectionUnderChanging){
            deltaHeight = [sender locationInView:self.mainContainerView].y - startDragerLocation.y;
            CGFloat normalScreenTop=self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
            velocitySviperUnderChangin = CGPointZero;//[sender velocityInView:self.mainContainerView];
            if(deltaHeight>= normalScreenTop/3){
                self.isButtonsCollectionUnderChanging = NO;
            } else {
                self.isButtonsCollectionUnderChanging = YES;
            }
        } else {
            
            deltaHeight = [sender locationInView:self.mainContainerView].y - startDragerLocation.y;
            //startDragerLocation = [sender locationInView:self.mainContainerView];
            self.displayTopConstrain.constant = screenYOrigin+deltaHeight;
            CGPoint velosity = [sender velocityInView:self.mainContainerView];

            
            //[self.view layoutIfNeeded];
            
            CGFloat howHistoryShowed = ((self.displayTopConstrain.constant+self.displayContainer.frame.size.height)-(self.mainContainerHeight.constant-maxButtonsCollectionHeight))/maxButtonsCollectionHeight;
            //[self changeHowHistoryShowed:howHistoryShowed];
            
            if(howHistoryWasShowedBeforeDrag == 1.) {//think it'll be need to drag up
                if(howHistoryShowed == 1){
                    self.isCalcShowed = NO;
                    self.isHistoryShowed = YES;
                }else if(howHistoryShowed == 0){
                    self.isCalcShowed = YES;
                    self.isHistoryShowed = NO;
                }else if(howHistoryShowed < 0.7){
                    //exactly drag up
                    [self finisDraggingUpWithVelocity:velosity];
                } else {
                    //return back
                    [self finishDraggingDownWithVelocity:velosity];
                }
            } else if(howHistoryWasShowedBeforeDrag ==0.){ //think it'll be need to drag down to show history
                if(howHistoryShowed == 1){
                    self.isCalcShowed = NO;
                    self.isHistoryShowed = YES;
                }else if(howHistoryShowed == 0){
                    self.isCalcShowed = YES;
                    self.isHistoryShowed = NO;
                } else if(howHistoryShowed > 0.3){
                    //exactly drag down
                    [self finishDraggingDownWithVelocity:velosity];
                } else {
                    //return back
                    [self finisDraggingUpWithVelocity:velosity];
                }
            } else {
                //if(DEBUG_MODE) NSLog(@"Error can't show finaly history tab not 1 and not 0");
                if(howHistoryShowed == 1){
                    self.isCalcShowed = NO;
                    self.isHistoryShowed = YES;
                }else if(howHistoryShowed == 0){
                    self.isCalcShowed = YES;
                    self.isHistoryShowed = NO;
                }else if(howHistoryShowed > 0.5){
                    //exactly drag down
                    [self finishDraggingDownWithVelocity:CGPointZero];
                } else {
                    //return back
                    [self finisDraggingUpWithVelocity:CGPointZero];
                }
            }
            [self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];
        }
    }

}

#pragma mark DYNAMIC ANIMATION
NSString *finishDrugDirection;// = @"CloseHistroy";

-(void) finisDraggingUpWithVelocity:(CGPoint)velocity
{

    self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
    self.historyTableSviper.pathOfDown = 0;
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity: -velocity.y/100 //velocitySviperUnderChangin.y
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [self.view layoutIfNeeded];
                            [self.buttonsCollection reloadData];
                            [self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];
                            //[self moveHistoryTableContentToRightPosition];
                            
                            self.labelsDisplayContainer.alpha = 1.;
                            
                            self.settingsButton.alpha = 0.;
                            self.shareButton.alpha = 0.;
                            self.plusButton.alpha = 0.;
                            self.recountButton.alpha = 0.;
                            self.deleteButton.alpha = 0.;
                            if(IS_IPAD && self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
                                self.noticeButton.alpha = 0.;
                            }

                        } completion:^(BOOL finished) {
                            self.isCalcShowed = YES;
                            //[self.buttonsCollection reloadData];
                            //NSLog(@"buttoncollection offset: %f", self.buttonsCollection.contentOffset.y);
                            //[self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:NO];
                            
                            //[self.historyTable reloadData];
                            //[self.historyTable selectRowAtIndexPath:selectedRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
                            
                        }];
}

-(void) finishDraggingDownWithVelocity:(CGPoint)velocity

{
    self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant;
    self.historyTableSviper.pathOfDown = 1;
    [UIView animateWithDuration:.8
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:velocity.y/100 //velocitySviperUnderChangin.y //
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [self.view layoutIfNeeded];
                            [self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];
                            //[self moveHistoryTableContentToRightPosition];
                            
                            self.labelsDisplayContainer.alpha = 0.;
                            
                            self.settingsButton.alpha = 1.;
                            self.shareButton.alpha = 1.;
                            self.plusButton.alpha = 1.;
                            self.recountButton.alpha = 1.;
                            self.deleteButton.alpha = 1.;
                            if(IS_IPAD && self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
                                self.noticeButton.alpha = 1.;
                            }
                            
                        } completion:^(BOOL finished) {
                            
                            self.isHistoryShowed = YES;
                             [self.buttonsCollection setContentOffset:CGPointMake(0, 0) animated:NO];
                            //[self.historyTable reloadData];
                            //[self.historyTable selectRowAtIndexPath:selectedRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
                        }];
}


#pragma mark - MOVE BUTTONS Methods

//method change offset in pan gesture is included new Thread
-(CGFloat) moveButtonsCollectioViewByOffsetDown:(CGFloat) offset
{
    /*if(DEBUG_MODE){
        NSLog(@"moveButtonsCollectioViewByOffsetDown");
    }*/
    CGFloat retOffset = 0;
    if(!self.isThreadInWork){
        __block CGFloat blockOffset = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.isThreadInWork = YES;
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if((buttonsAsSubView.center.y > 0) && ((buttonsAsSubView.center.y - self.buttonsCollection.contentOffset.y) <  2.5 *subCell.bounds.size.height) && (self.buttonsCollection.contentOffset.y > 0)){
                    self.wasInMoveOffsetSection = YES;
                   
                    blockOffset = self.buttonsCollection.contentOffset.y;

                    CGPoint newOffset = self.buttonsCollection.contentOffset;
                    newOffset.y = self.buttonsCollection.contentOffset.y - blockOffset;
                    CGPoint newCenter = buttonsAsSubView.center;
                    newCenter.y = buttonsAsSubView.center.y - blockOffset;
                    
                    [UIView animateWithDuration: 1.5 * (blockOffset / self.viewforCurrencyRecognizer.frame.size.height)
                                     animations:^{
                                         [self.buttonsCollection setContentOffset:newOffset];
                                         [buttonsAsSubView setCenter:newCenter];
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
    /*if(DEBUG_MODE){
        NSLog(@"moveButtonsCollectioViewByOffsetUp");
    }*/

    CGFloat retOffset = 0;
    if(!self.isThreadInWork){
        __block CGFloat blockOffset = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.isThreadInWork = YES;
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if((buttonsAsSubView.center.y > 0) &&
                   ((self.buttonsCollection.contentOffset.y + self.viewforCurrencyRecognizer.frame.size.height - buttonsAsSubView.center.y) <  1.5*subCell.bounds.size.height) &&
                   ((self.buttonsCollection.contentOffset.y +self.viewforCurrencyRecognizer.frame.size.height) < self.buttonsCollection.contentSize.height)){
                    self.wasInMoveOffsetSection = YES;
                    if(offset > (subCell.frame.size.height*4)){
                        blockOffset = subCell.frame.size.height*4;
                    } else {
                        blockOffset = self.buttonsCollection.contentSize.height - self.buttonsCollection.contentOffset.y - self.viewforCurrencyRecognizer.frame.size.height;
                    }
                    CGPoint newOffset = self.buttonsCollection.contentOffset;
                    newOffset.y = self.buttonsCollection.contentOffset.y + blockOffset;
                    CGPoint newCenter = buttonsAsSubView.center;
                    newCenter.y = buttonsAsSubView.center.y + blockOffset;
                    
                    [UIView animateWithDuration:1.5 * (blockOffset / self.viewforCurrencyRecognizer.frame.size.height)
                                     animations:^{
                                         [self.buttonsCollection setContentOffset:newOffset];
                                         [buttonsAsSubView setCenter:newCenter];
                                     }];
                    
                }
                self.isThreadInWork = NO;
            });
        });
        retOffset = blockOffset;
    }
    return retOffset;
}


- (IBAction)moveButtonToNewPosition:(UIPanGestureRecognizer *)panGesture
{
    /*
     if(DEBUG_MODE){
        NSLog(@"moveButtonToNewPosition");
    }*/

    if(panGesture.state == UIGestureRecognizerStateBegan){
        moveIsAvailable = YES;
        
    }
    if (panGesture.state == UIGestureRecognizerStateCancelled ){
        
    }
    if (panGesture.state == UIGestureRecognizerStateChanged){
        if (!self.animationTimer.isValid){
            //0. change position of subview
            CGPoint translation =[panGesture translationInView:self.buttonsCollection];
            buttonsAsSubView.center = CGPointMake(buttonsAsSubView.center.x + translation.x, buttonsAsSubView.center.y + translation.y);
            [panGesture setTranslation:CGPointZero inView:self.buttonsCollection];
            
            //change offset of buttonscollection according move subView
            if((buttonsAsSubView.center.y > 0)
               && ((buttonsAsSubView.center.y - self.buttonsCollection.contentOffset.y) <  2.5 *subCell.bounds.size.height)
               && (self.buttonsCollection.contentOffset.y > 0)){
                if(!self.wasInMoveOffsetSection){
                    CGFloat offset = self.buttonsCollection.contentOffset.y;
                    
                    //remove the line before
                    [self moveButtonsCollectioViewByOffsetDown:offset];
                }
            } else if ((buttonsAsSubView.center.y > 0)
                       && ((self.buttonsCollection.contentOffset.y + self.viewforCurrencyRecognizer.frame.size.height - buttonsAsSubView.center.y) <  1.5 *subCell.bounds.size.height)
                       && ((self.buttonsCollection.contentOffset.y +self.viewforCurrencyRecognizer.frame.size.height) < self.buttonsCollection.contentSize.height)){
                if(!self.wasInMoveOffsetSection){
                    CGFloat offset = self.buttonsCollection.contentSize.height - self.buttonsCollection.contentOffset.y - self.viewforCurrencyRecognizer.frame.size.height;
                    //replace thre line above
                    [self moveButtonsCollectioViewByOffsetUp:offset];
                    
                }
            } else {
                self.wasInMoveOffsetSection = NO;
            }
            
            //set buttons to new position and change data
            NSIndexPath *patch = [self.buttonsCollection indexPathForItemAtPoint:buttonsAsSubView.center];
            if(patch){
                findCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:patch];
                
                while (YES){
                    //if(DEBUG_MODE) NSLog(@"moveButtonToNewPosition while YES");
                    if(([self.buttonsStore.changebleButtonObjs containsObject:[self.buttonsStore.allButtonObj objectAtIndex:[self.buttonsCollection indexPathForCell:findCell].item]])
                       && ((findCell.typeOfButton == CHANGE_BUTTON)||(findCell.typeOfButton == CHANGE_BUTTON_NOT_DELETABLE))){
                        break;
                    } else {
                        patch = [NSIndexPath indexPathForItem:patch.item -1 inSection:patch.section];
                        findCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:patch];
                        if(!findCell){
                            findCell = subCell;
                            break;
                        }
                        patchForUse = [self.buttonsCollection indexPathForCell:findCell];
                    }
                    
                }
                
                if(![findCell isEqual:subCell]){
                    if (moveIsAvailable){
                        [self move];
                        moveIsAvailable = NO;
                    }
                }
            }
        }
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
    }
}
//move buttonView from global variable subCell and findCell
-(void) move
{

    //here is ok for all buttons
    NSIndexPath *findPatch = [self.buttonsCollection indexPathForCell:findCell];
    Buttons *findButtonObj = [self.buttonsStore.allButtonObj objectAtIndex:findPatch.item];
    NSNumber* findButtonObjPositionInCoreData = findButtonObj.position;
    //new position in changeble  array
    NSInteger indexFindButtonObjInChangebleArray = [self.buttonsStore.changebleButtonObjs indexOfObject:findButtonObj];
    
    NSIndexPath *subPatch = [self.buttonsCollection indexPathForCell:subCell];
    Buttons *subButtonObj = [self.buttonsStore.allButtonObj objectAtIndex:subPatch.item];
    NSNumber *subButtonObjPositionInCoreData = subButtonObj.position;
   
    if(!self.secondTimer.isValid){
        
        NSMutableArray *mutableCahngebleArray = [self.buttonsStore.changebleButtonObjs mutableCopy];
        [mutableCahngebleArray removeObject:subButtonObj];
        /*if(DEBUG_MODE){
            NSLog(@"move removeObject");
        }*/

        [mutableCahngebleArray insertObject:subButtonObj atIndex:indexFindButtonObjInChangebleArray];
        /*if(DEBUG_MODE){
            NSLog(@"move insertObject");
        }*/

        self.buttonsStore.changebleButtonObjs = [mutableCahngebleArray copy];
        //findButtonObjPositionInCoreData
        //subButtonObjPositionInCoreData
        movedCells = [self findMovedCellsForReplacePatch:subPatch toPatch:findPatch];

        [self.buttonsStore moveButton:subButtonObj fromPosition:subButtonObjPositionInCoreData toPosition:findButtonObjPositionInCoreData];

    }
}

-(NSArray*)findMovedCellsForReplacePatch:(NSIndexPath*)subPatch toPatch:(NSIndexPath*)findPatch{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];

    //add cell wich be moved
    [returnArray addObject:subPatch];
    
    //add finded cell - cell in wich need set new cell
    [returnArray addObject:findPatch];
    
    if(findPatch.item > subPatch.item){//if move done
        NSIndexPath* tempPatch = findPatch;
        NSIndexPath* nextPatch = [NSIndexPath indexPathForItem:tempPatch.item-1 inSection:tempPatch.section];//+
        
        
        while (tempPatch.item>subPatch.item) {
            NewButtonsCollectionViewCell *nextCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:nextPatch];
            if(nextCell.typeOfButton == MAIN_BUTTON){//if its not changeble//main button
                [returnArray addObject:tempPatch];//add to array patch that need be replaced
                nextPatch =[NSIndexPath indexPathForItem:nextPatch.item-1 inSection:nextPatch.section];
                
                while (true && (nextPatch.item>=subPatch.item)) {
                    nextCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:nextPatch];

                    if(nextCell.typeOfButton != MAIN_BUTTON){//find first changeble cells patch and add to array
                        [returnArray addObject:nextPatch];
                        tempPatch = nextPatch;
                         nextPatch =[NSIndexPath indexPathForItem:nextPatch.item-1 inSection:nextPatch.section];

                        break;
                    } else {
                        nextPatch =[NSIndexPath indexPathForItem:nextPatch.item-1 inSection:nextPatch.section];
                    }
                    
                }
            } else {
                tempPatch = [NSIndexPath indexPathForItem:tempPatch.item-1 inSection:tempPatch.section];
                nextPatch = [NSIndexPath indexPathForItem:tempPatch.item-1 inSection:tempPatch.section];
            }
        }
    } else if (findPatch.item < subPatch.item){
        NSIndexPath* tempPatch = findPatch;
        NSIndexPath* nextPatch = [NSIndexPath indexPathForItem:tempPatch.item+1 inSection:tempPatch.section];//+
        

        while (tempPatch.item<subPatch.item) {
            NewButtonsCollectionViewCell *nextCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:nextPatch];

            if(nextCell.typeOfButton == MAIN_BUTTON){//if its not changeble//main button
                [returnArray addObject:tempPatch];//add to array patch that need be replaced

                nextPatch =[NSIndexPath indexPathForItem:nextPatch.item+1 inSection:nextPatch.section];

                while (true && (nextPatch.item<=subPatch.item)) {
                    nextCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:nextPatch];

                    if(nextCell.typeOfButton != MAIN_BUTTON){//find first changeble cells patch and add to array
                        [returnArray addObject:nextPatch];

                        tempPatch = nextPatch;
                        nextPatch =[NSIndexPath indexPathForItem:nextPatch.item+1 inSection:nextPatch.section];

                        break;
                    } else {
                        nextPatch =[NSIndexPath indexPathForItem:nextPatch.item+1 inSection:nextPatch.section];
                    }
                    
                }
            } else {
                tempPatch = [NSIndexPath indexPathForItem:tempPatch.item+1 inSection:tempPatch.section];
                nextPatch = [NSIndexPath indexPathForItem:tempPatch.item+1 inSection:tempPatch.section];
            }
        }
    }
    return [returnArray copy];
}

//pan gesture
//two methodes to delet and redelete buttons with animation


//DELET and SET BUTTONS
#define DELETE_BUTTON_REQUEST NSLocalizedStringFromTable(@"DELETE_BUTTON_REQUEST",@"ACalcTryViewControllerTableNew", @"DELETE_BUTTON_REQUEST")
#define CANCEL NSLocalizedStringFromTable(@"CANCEL",@"ACalcTryViewControllerTableNew", @"CANCEL")
#define CONFIRM NSLocalizedStringFromTable(@"CONFIRM",@"ACalcTryViewControllerTableNew", @"CONFIRM")
- (void)tapRemoveItsButton:(UIButton *)sender {
    //call buttonsStore to remove users button
    CGPoint necessaryPoint = CGPointMake(sender.bounds.origin.x, sender.bounds.size.height);
    CGPoint buttonsLocation = [sender convertPoint:necessaryPoint toView:self.buttonsCollection];
    NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:buttonsLocation];
    Buttons* button = [self.buttonsStore.allButtonObj objectAtIndex:indexPath.item];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:DELETE_BUTTON_REQUEST
                                                                   message:button.nameButton
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {;
                                                              
                                                          }];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:CONFIRM style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {;

                                                              [self removeFromCollectionViewUsersButton:button forIndexPatch:indexPath];
                                                          }];
    
    [alert addAction:defaultAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)removeFromCollectionViewUsersButton:(Buttons*)button forIndexPatch:(NSIndexPath*)patch{
    NewButtonsCollectionViewCell *delCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:patch];
    CGRect subViewFrame;
    subViewFrame = ((NewButtonsCollectionViewCell*)delCell).cellSubView.frame;
    subViewFrame.origin = [delCell convertPoint:subViewFrame.origin toView:self.buttonsCollection];

    buttonsAsSubView = [[newButtonView alloc] initWithFrame:subViewFrame];
    buttonsAsSubView.title = ((NewButtonsCollectionViewCell*)delCell).cellSubView.title;
    buttonsAsSubView.buttonColor = ((NewButtonsCollectionViewCell*)delCell).cellSubView.buttonColor;
    buttonsAsSubView.designObj = self.designObj;
    [self.buttonsCollection addSubview:buttonsAsSubView];
    delCell.alpha = 0.0;

    CGRect newRect = CGRectInset(subViewFrame,-subViewFrame.size.width*0.1, -subViewFrame.size.height*0.1);
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [buttonsAsSubView setFrame:newRect];
                     } completion:^(BOOL finished) {
                         CGPoint center = buttonsAsSubView.center;
                         CGRect zeroRect = CGRectMake(center.x, center.y, 0., 0.);
                         
                         [UIView animateWithDuration:.4
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              [buttonsAsSubView setFrame:zeroRect];
                                              
                                          } completion:^(BOOL finished){
                                              [buttonsAsSubView removeFromSuperview ];
                                              buttonsAsSubView = nil;
                                              [self.buttonsStore removeUsersButton:button];
                                              patchForUse = patch;
                                          }];
                     }];
}

- (void)tapCloseCheckButton:(UIButton *)sender
{
        CGPoint necessaryPoint = CGPointMake(sender.bounds.origin.x, sender.bounds.size.height);
        CGPoint buttonsLocation = [sender convertPoint:necessaryPoint toView:self.buttonsCollection];
        NSIndexPath *indexPath = [self.buttonsCollection indexPathForItemAtPoint:buttonsLocation];
        if(indexPath){
            
            subCell =(NewButtonsCollectionViewCell*)[self.buttonsCollection cellForItemAtIndexPath:indexPath];
            //subCell.isEnable  = !subCell.isEnable;
                
                Buttons* button = [self.buttonsStore.allButtonObj objectAtIndex:indexPath.item];
                
                if([button.enable boolValue]){
                    //find the total quantity of deleted button
                    NSInteger lenghtDeletedArray = [self.buttonsStore.delettedButtonObjs count];
                    //find the last not deleted ellement in all array
                    NSInteger numberOfLastEnabledElement = [self.buttonsStore.allButtonObj count]-lenghtDeletedArray-1;
                    //indexPatch next after last enabled
                    NSIndexPath *findPatch = [NSIndexPath indexPathForItem:numberOfLastEnabledElement inSection:indexPath.section];
                    
                    //make array for muving cellc
                    movedCells = [self findMovedCellsForReplacePatch:indexPath toPatch:findPatch];
                    if(button.program){
                        subCell.typeOfButton = DELETED_USER_BUTTON;
                    } else {
                        subCell.typeOfButton = DELETED_BUTTON;
                    }
                    //call buttonsStore function to setEnable button
                    [self.buttonsStore setDisablingForButton:button];

                } else {
                    //1 find the ordering number from button data
                    NSInteger numerOfOrdering = [button.position integerValue];
                    Buttons* nextOrderingButton = nil;
                    //2 in changebleButtons find button with next position
                    for(Buttons* btn in self.buttonsStore.changebleButtonObjs){
                        NSInteger btnPosition = [btn.position integerValue];
                        if(btnPosition>numerOfOrdering){
                            nextOrderingButton = btn;
                            break;
                        }
                    }

                    //3 find position in allButtonsarray
                    NSInteger findPosition;//if there no needed button
                    if(nextOrderingButton){
                        findPosition = [self.buttonsStore.allButtonObj indexOfObject:nextOrderingButton];
                    } else {
                        findPosition = [self.buttonsStore.allButtonObj indexOfObject:[self.buttonsStore.changebleButtonObjs lastObject]]+1;
                    }
                    //4 make necessary indexPatch
                    NSIndexPath *findPatch = [NSIndexPath indexPathForItem:findPosition inSection:indexPath.section];
                    
                    //make array for muving cellc
                    movedCells = [self findMovedCellsForReplacePatch:indexPath toPatch:findPatch];

                    subCell.typeOfButton = CHANGE_BUTTON;
                    //call buttonsStore function to setEnable button
                    [self.buttonsStore setEnablingForButton:button];
                    

                }
            }
}

#pragma mark BUTTONS
UICollectionViewFlowLayout *buttonsFlowLayout;
CGFloat buttonsCollectionWidth;
CGFloat screenHeight;
CGFloat buttonsWidth;
CGFloat buttonsHeight;
CGFloat buttonsIntens;
NSIndexPath* patchForUse;//COPIED
//BOOL isBigSizeButtons;

#pragma mark MOVE BUTTON STATIC PROPERTIES //COPIED
static newButtonView* buttonsAsSubView;//COPIED
static NewButtonsCollectionViewCell* findCell;//COPIED
static NewButtonsCollectionViewCell* subCell;//COPIED
static NSArray *movedCells;//COPIED
static BOOL moveIsAvailable;//COPIED



//define properties of each button
#define INSERT_BUTTON 1
#define DELETE_BUTTON 2
#define CHANGE_BUTTON_POISTION 3
#define MOVE_TO_ENABLE 4
#define MOVE_TO_DISABLE 5
#define RELOAD 0

#pragma mark - MOVE BUTTONS Methods

#pragma mark BUTTONS DELEGATE

-(NSInteger) numberColumsInCollectionView
{
    return ABS(buttonsCollectionWidth/buttonsWidth);
}

-(void)buttonsArrayDidChangedWithReloadOperation:(NSInteger)operation
{
    //don't know why but switch not works
    
    if(operation == RELOAD){
        if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
            self.isAllowedToDelete = NO;
        } else {
            self.isAllowedToDelete = YES;
        }
        [self.buttonsCollection reloadData];
    } else if(operation == INSERT_BUTTON){
        [self.buttonsCollection performBatchUpdates:^{
            NSIndexPath *newIndex = [NSIndexPath indexPathForItem:[self.buttonsStore.workButtonsNames count]-1 inSection:0];
            NSArray *indexPatchs = [[NSArray alloc]initWithObjects:newIndex, nil];
            [self.buttonsCollection insertItemsAtIndexPaths:indexPatchs];
        } completion:^(BOOL finished) {
            nil;
        }];
        if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
            self.isAllowedToDelete = NO;
        } else {
            self.isAllowedToDelete = YES;
        }
    } else if(operation == DELETE_BUTTON){
        [self.buttonsCollection performBatchUpdates:^{
            NSArray *indexPatchs = [[NSArray alloc]initWithObjects:patchForUse, nil];
            [self.buttonsCollection deleteItemsAtIndexPaths:indexPatchs];
        } completion:^(BOOL finished) {
            nil;
        }];
    } else if(operation == CHANGE_BUTTON_POISTION){
        [self.buttonsCollection performBatchUpdates:^{
            NSMutableArray* mutPatchsArray = [movedCells mutableCopy];
            while ([mutPatchsArray firstObject]) {
                NSIndexPath *subPatch = [mutPatchsArray firstObject];
                [mutPatchsArray removeObjectAtIndex:0];
                if([mutPatchsArray firstObject]){
                    NSIndexPath *findPatch = [mutPatchsArray firstObject];
                    [mutPatchsArray removeObjectAtIndex:0];
                    [self.buttonsCollection moveItemAtIndexPath:subPatch toIndexPath:findPatch];
                }
            }
            
            
        } completion:^(BOOL finished) {
            //subCell.hidden = NO;
            moveIsAvailable = YES;
            movedCells = nil;
        }];
        
    } else if(operation == MOVE_TO_ENABLE){
        [self.buttonsCollection performBatchUpdates:^{
            if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
                self.isAllowedToDelete = NO;
            } else {
                self.isAllowedToDelete = YES;
            }
            
            NSMutableArray* mutPatchsArray = [movedCells mutableCopy];
            while ([mutPatchsArray firstObject]) {
                NSIndexPath *subPatch = [mutPatchsArray firstObject];
                [mutPatchsArray removeObjectAtIndex:0];
                if([mutPatchsArray firstObject]){
                    NSIndexPath *findPatch = [mutPatchsArray firstObject];
                    [mutPatchsArray removeObjectAtIndex:0];
                    [self.buttonsCollection moveItemAtIndexPath:subPatch toIndexPath:findPatch];
                }
            }
            
        } completion:^(BOOL finished) {
            movedCells = nil;

        }];
    }else if(operation == MOVE_TO_DISABLE){
        [self.buttonsCollection performBatchUpdates:^{
            if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
                self.isAllowedToDelete = NO;
            } else {
                self.isAllowedToDelete = YES;
            }
            NSMutableArray* mutPatchsArray = [movedCells mutableCopy];
            while ([mutPatchsArray firstObject]) {
                NSIndexPath *subPatch = [mutPatchsArray firstObject];
                [mutPatchsArray removeObjectAtIndex:0];
                if([mutPatchsArray firstObject]){
                    NSIndexPath *findPatch = [mutPatchsArray firstObject];
                    [mutPatchsArray removeObjectAtIndex:0];
                    [self.buttonsCollection moveItemAtIndexPath:subPatch toIndexPath:findPatch];
                }
            }
            
        } completion:^(BOOL finished) {
            
            movedCells = nil;
        }];
        
    }else{
        //default
    }
}

-(void)buttonsArrayDidChangedWithReload:(BOOL)isNeedReload
{
    if(isNeedReload){
        if(self.isButtonsCollectionUnderChanging){
            /*
            if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
                self.isAllowedToDelete = NO;
            } else {
                self.isAllowedToDelete = YES;
            }
            */
            NSError *error;
            [self.buttonManagedObjectContext save: &error];
        }
        [self.buttonsCollection reloadData];
    } else {

    }
    //MAYBE IT WILL BE USEFUL BUT NOT NOW
    /*
    if(self.counterForShowingAllertView == 37 && self.buttonsStore.allButtonObj){
        [self.buttonsStore checkButtonsArray];
    }*/
}


//ok
//if allowedToDelete condition changed set alowedToDelete condition for each buttons
-(void)setIsAllowedToDelete:(BOOL)isAllowedToDelete
{
    if(_isAllowedToDelete != isAllowedToDelete){
        _isAllowedToDelete = isAllowedToDelete;
        if(!isAllowedToDelete){
            for(NewButtonsCollectionViewCell* cell in self.buttonsCollection.visibleCells){
                if(cell.typeOfButton == CHANGE_BUTTON){
                    cell.typeOfButton = CHANGE_BUTTON_NOT_DELETABLE;
                }
            }
        } else {
            for(NewButtonsCollectionViewCell* cell in self.buttonsCollection.visibleCells){
                if(cell.typeOfButton == CHANGE_BUTTON_NOT_DELETABLE){
                    cell.typeOfButton = CHANGE_BUTTON;
                }
            }
        }
    }
}


#pragma mark - UICOLLECTIONS VIEW DELEGATE

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger section = 1;
    
    if(self.buttonManagedObjectContext){
        section = 1;
    }
    return section;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isButtonsCollectionUnderChanging? [self.buttonsStore.allButtonObj count] : [self.buttonsStore.workButtonsNames count] ;
}


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Button" forIndexPath:indexPath];
    ((NewButtonsCollectionViewCell *)cell).delegate = (ButtonsCollectionView*)collectionView;
    ((NewButtonsCollectionViewCell *)cell).isIpadPortraitView = self.willBePortraitRotated;
    ((NewButtonsCollectionViewCell *)cell).designObj = self.designObj;
    //WHAT IS THIS??? BELOW
    //[((NewButtonsCollectionViewCell *)cell)removeFromSuperview];
    //[collectionView insertSubview:((NewButtonsCollectionViewCell *)cell) atIndex:indexPath.item];
    
    if([cell isKindOfClass:[NewButtonsCollectionViewCell class]]){
        NSInteger item = indexPath.item;
        ((NewButtonsCollectionViewCell*)cell).designObj = self.designObj;
        if(self.isButtonsCollectionUnderChanging){
           
             Buttons *button = [self.buttonsStore.allButtonObj objectAtIndex:item];
            ((NewButtonsCollectionViewCell*)cell).actionDelegate = self;
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = YES;
            
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

            //if its main button
            if([button.isMain boolValue]){
                ((NewButtonsCollectionViewCell*)cell).typeOfButton = MAIN_BUTTON;
            } else if ([button.enable boolValue] && self.isAllowedToDelete){
                //((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = self.isAllowedToDelete;
                //((NewButtonsCollectionViewCell*)cell).isEnable = YES;
                ((NewButtonsCollectionViewCell*)cell).typeOfButton = CHANGE_BUTTON;
               // [((NewButtonsCollectionViewCell*)cell).closeAndSetButton addTarget:self action:@selector(tapCloseCheckButton:) forControlEvents:UIControlEventTouchUpInside];
                //((NewButtonsCollectionViewCell*)cell).isUnderChanging = YES;
                
                /*
                if(button.program){
                    ((NewButtonsCollectionViewCell*)cell).typeOfButton = USER_BUTTON;
                } else {
                    ((NewButtonsCollectionViewCell*)cell).typeOfButton = CHANGE_BUTTON;
                }
            
                ((NewButtonsCollectionViewCell*)cell).isEnable = [button.enable boolValue];
                ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = self.isAllowedToDelete;
                ((NewButtonsCollectionViewCell*)cell).isUnderChanging = YES;
                */
            } else if([button.enable boolValue] && !self.isAllowedToDelete){
                ((NewButtonsCollectionViewCell*)cell).typeOfButton = CHANGE_BUTTON_NOT_DELETABLE;
            } else if(![button.enable boolValue] && button.program ){
                ((NewButtonsCollectionViewCell*)cell).typeOfButton = DELETED_USER_BUTTON;
                //[((NewButtonsCollectionViewCell*)cell).closeAndSetButton addTarget:self action:@selector(tapCloseCheckButton:) forControlEvents:UIControlEventTouchUpInside];
                
            } else if(![button.enable boolValue]){
                ((NewButtonsCollectionViewCell*)cell).typeOfButton = DELETED_BUTTON;
                //[((NewButtonsCollectionViewCell*)cell).closeAndSetButton addTarget:self action:@selector(tapCloseCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //}
            
            /*
            if([button.isMain boolValue]){
                ((NewButtonsCollectionViewCell*)cell).isChangeble = NO;
                ((NewButtonsCollectionViewCell*)cell).closeAndSetButton.hidden = YES;
                ((NewButtonsCollectionViewCell*)cell).removeButton.hidden = YES;
            } else {
                ((NewButtonsCollectionViewCell*)cell).isChangeble = YES;
                ((NewButtonsCollectionViewCell*)cell).isEnable = [button.enable boolValue];
                ((NewButtonsCollectionViewCell*)cell).closeAndSetButton.isClose = [button.enable boolValue];
                ((NewButtonsCollectionViewCell*)cell).closeAndSetButton.hidden = NO;
                //((NewButtonsCollectionViewCell*)cell).closeAndSetButton.isClose = [button.enable boolValue];
                 //if it 's users button
                if(button.program && ![button.enable boolValue]){
                    ((NewButtonsCollectionViewCell*)cell).isCanBeRemoved = YES;
                    ((NewButtonsCollectionViewCell*)cell).removeButton.hidden = NO;
                } else {
                    ((NewButtonsCollectionViewCell*)cell).removeButton.hidden = YES;
                }
                
                ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = [button.aloweToDelete boolValue];
                 ((NewButtonsCollectionViewCell*)cell).isUnderChanging = self.isButtonsCollectionUnderChanging;
            }
           
           
            if(button.program && ![button.enable boolValue]){
                ((NewButtonsCollectionViewCell*)cell).isCanBeRemoved = YES;
            }
            
            ((NewButtonsCollectionViewCell*)cell).isEnable = [button.enable boolValue];

            ((NewButtonsCollectionViewCell*)cell).isChangeble = ![button.isMain boolValue];
            
            ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = [button.aloweToDelete boolValue];
            */
            
        } else {
            NSString* nameFromModel = [self.buttonsStore.workButtonsNames objectAtIndex:item];
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
            ((NewButtonsCollectionViewCell*)cell).designObj = self.designObj;
            
            //((NewButtonsCollectionViewCell*)cell).removeButton.hidden = YES;
            //((NewButtonsCollectionViewCell*)cell).closeAndSetButton.hidden = YES;
            
            
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
    

    //NSLog(@"CellWidth - %f, CellHeight - %f", cell.bounds.size.width, cell.bounds.size.height);
    return cell;
}



#pragma mark - UICollectionViewDelegateFlowLayout
/*
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"buttonsWidth - %f, buttonsHeight - %f", buttonsWidth, buttonsHeight);

    //NSLog(@"buttonsCollectionWidth - %f, buttonsCollectionHeight - %f", self.buttonsCollection.bounds.size.width, self.buttonsCollection.bounds.size.height);
    
    //NSLog(@"displayWidth - %f, displayHeight - %f", self.displayContainer.bounds.size.width, self.displayContainer.bounds.size.height);
    
    //NSLog(@"main.width - %f, main.height - %f", self.mainContainerView.bounds.size.width, self.mainContainerView.bounds.size.height);
    

    
    //return  CGSizeMake(buttonsWidth, buttonsHeight);
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
*/

#pragma mark SET HISTORY TABLE TO RIGHT POSITION

NSIndexPath *lastVisibleCellPatch;//COPIED
//NSIndexPath* selectedRowPatch;
#define MIN_CELL_HEIGHT_COPACT 60.f
#define MIN_CELL_HEIGHT_REGULAR 90.f


-(void)moveHistoryTableContentToRightPosition
{
    //NSLog(@"FetchedController count: %lu", [self.fetchedResultsController.fetchedObjects count]);
    //NSLog(@"HistoryTable count: %lu", [self.historyTable numberOfRowsInSection:0]);
    /*if(DEBUG_MODE){
        NSLog(@"self.historyTable.frame.size.height: %f", self.historyTable.frame.size.height);
        NSLog(@"self.historyTable.contentSize.height: %f", self.historyTable.contentSize.height);
    }*/
    if(self.historyTable.contentSize.height < self.historyTable.frame.size.height){
        // self.historyTable.isNeedToSetOffsetToButton = YES;
        /*if(self.historyTable.contentSize.height == 0){
            CGFloat setedMinHeight = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact?MIN_CELL_HEIGHT_COPACT:MIN_CELL_HEIGHT_REGULAR;
            [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - setedMinHeight,0, 0, 0)];

        } else {*/
            [self.historyTable setContentInset:UIEdgeInsetsMake(self.historyTable.frame.size.height - self.historyTable.contentSize.height,0, 0, 0)];
       // }
        //[self.historyTable setContentOffset:]
 
    } else {
        [self.historyTable setContentInset:UIEdgeInsetsMake(0,0, 0, 0)];
        //[self.historyTable setContentOffset:CGPointMake(0, self.historyTable.contentSize.height-self.historyTable.frame.size.height)];
        
        [self.historyTable setContentOffset:CGPointMake(0, self.historyTable.contentSize.height-self.historyTable.frame.size.height) animated:YES];
    }
 /*
    if([self.cellHeights count] >=1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.cellHeights count]-1  inSection:0];
 
        //[self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
       // [self.historyTable scrollToRowAtIndexPath:lastRowPatch atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[self.historyTable scrollRectToVisible:[self.historyTable cellForRowAtIndexPath:lastRowPatch].frame animated:YES];
        
        //[self.historyTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    */

 
}

#pragma mark - WORK WITH LAST ROW
-(void) selectLastRowInHistory {

    
    /*if(DEBUG_MODE){
        NSLog(@"selectLastRowInHistory [self.cellHeights count] = %lun", (unsigned long)[self.cellHeights count] );
    }*/
    //if(self.historyTable && ([self.cellHeights count] >= 1)){
    if(self.historyTable && ([self.historyTable numberOfRowsInSection:0] >= 1)){

        
        //NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.cellHeights count]  inSection:0];
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0]-1 inSection:0];
        //NSLog(@"selectLastRowInHistory lastRowPatch: %lu", lastRowPatch.row);
        
        //lastVisibleCellPatch = lastRowPatch;
        //selectedRowPatch = lastRowPatch;
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];//animated:YES scrollPosition:UITableViewScrollPositionNone];
       // [self.historyTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //NSLog(@"FetchedController count: %lu", [self.fetchedResultsController.fetchedObjects count]);
    //NSLog(@"HistoryTable count: %lu", [self.historyTable numberOfRowsInSection:0]);
}


-(void) setLastRowDataArray:(NSArray *)lastRowDataArray
{
    
    if(!lastRowDataArray) {
        _lastRowDataArray = [[NSArray alloc] init];
    } else {
        _lastRowDataArray = lastRowDataArray;
    }
    
    //self.lastRowsString = [self getAttributedStringFromArray:_lastRowDataArray];
    [self lastRowUpdate];
}

-(void)lastRowUpdate{
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:[self.cellHeights count]  inSection:0];
    /*if(DEBUG_MODE){
        NSLog(@"lastRowUpdate Last row %ld", (long)lastRow.row);
    }*/

    [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastRow]
                             withRowAnimation:UITableViewRowAnimationFade];
    


    if(![self.historyTable.indexPathsForVisibleRows containsObject:lastRow]){
        [self moveHistoryTableContentToRightPosition];
    }
    
        [self selectLastRowInHistory];
    
    //NSLog(@"self.historyTable.rowHeight: %f", self.historyTable.rowHeight);
}


#pragma mark HISTORY TABLE VIEW DELEGATE

//ONLY FOR TEST
/*
-(NSArray*)buttonsNames{
    if(!_buttonsNames){
        _buttonsNames =[[NSArray alloc]init];
    }
    return _buttonsNames;
}
*/

-(NSArray*)cellHeights {
    if(!_cellHeights){
        _cellHeights = [[NSArray alloc] init];
    }
    return _cellHeights;
}
-(NSArray*)infoAttributedStrings{
    if(!_infoAttributedStrings){
        _infoAttributedStrings = [[NSArray alloc] init];
    }
    return _infoAttributedStrings;
}
-(NSArray*)mainAttributedStrings{
    if(!_mainAttributedStrings){
        _mainAttributedStrings = [[NSArray alloc] init];
    }
    return _mainAttributedStrings;

}


/*
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([cellHeights objectForKey:indexPath]){
        return [[cellHeights objectForKey:indexPath] floatValue];
    } else {
        return  60;
    }
}

*/



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"CEll height count: %lu",(unsigned long)[self.cellHeights count] );
    
    CGFloat retHeight;
    if(([self.cellHeights count]==0) || indexPath.row>([self.cellHeights count]-1)){
        NSAttributedString* mainLabel =  [self getAttributedStringFromArray:self.lastRowDataArray];
        NSAttributedString* infoLabel = [[NSAttributedString alloc] initWithString:@" "];

        retHeight = [self getCellHeightFromMain:mainLabel and:infoLabel forHorizontal:self.view.traitCollection.horizontalSizeClass];
        
        if(!self.wasPurshaised){
            [self setOriginHeightOfAdBannerWithLastRowHeight: retHeight];
        }
    } else {
        retHeight =  [[self.cellHeights objectAtIndex:indexPath.row] floatValue];
    }
    return retHeight;//MIN_CELL_HEIGHT;


}
/* was setted only for test -WILL DELETE IT
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"didSelectRowAtIndexPath %ld", (long)indexPath.row);
}
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSLog(@"willSelect %ld", (long)indexPath.row);
    return nil;
}
*/

#pragma mark - UITABLE VIEW DATA SOURSE DELEGATE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    
    if([[self.fetchedResultsController sections] count] > 0){
        sections = [[self.fetchedResultsController sections] count];
    }
    
    return sections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return one more rows than in fatched result controller
    NSInteger rows = 1;
    
    self.noticeButton.enabled = NO;
    
    if ([self.cellHeights count] > 0) {
        rows = [self.cellHeights count] +1;
        self.noticeButton.enabled = YES;
    }
    
    /*if(DEBUG_MODE){
        NSLog(@"numberOfRowsInSection rowsNumber:%ld", (long)rows);
    }*/

    return rows;
}

/* think it's not necessary
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    if(indexPath.row != [tableView numberOfRowsInSection: 0] - 1){
        return YES;
    } else {
        return NO;
    }
}
*/
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.historyTable dequeueReusableCellWithIdentifier:@"HistoryCell"];
    //NSLog(@"CALL cellForRowAtIndexPath");
    
    if([cell isKindOfClass:[HistroryTableViewCell class]]){
        ((HistroryTableViewCell*)cell).design = self.designObj;
        ((HistroryTableViewCell*)cell).delegate = self;

        if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            ((HistroryTableViewCell*)cell).mainProgrammLabel.attributedText = [self getAttributedStringFromArray:self.lastRowDataArray];
            ((HistroryTableViewCell*)cell).infoLabel.attributedText = [self getAttrInfStringFromProg:self.lastRowDataArray and:nil];
            
        } else {
            ((HistroryTableViewCell*)cell).mainProgrammLabel.attributedText =[self.mainAttributedStrings objectAtIndex:indexPath.row];
            ((HistroryTableViewCell*)cell).infoLabel.attributedText = [self.infoAttributedStrings objectAtIndex:indexPath.row];
        }

        
        /*
        ((HistroryTableViewCell*)cell).delegate = self;
        ((HistroryTableViewCell*)cell).design = self.designObj;
        
        ((HistroryTableViewCell*)cell).dateString = nil;
        ((HistroryTableViewCell*)cell).exchangeCurrencyString = nil;
        ((HistroryTableViewCell*)cell).funcDescriptAtrString = nil;
        ((HistroryTableViewCell*)cell).variableValuesString = nil;
        

        
        if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            ((HistroryTableViewCell*)cell).isCanDrag = NO;
            //NSArray* currProgram = [self currentBrainProgramm];
            NSArray* currProgram = self.lastRowDataArray;
            if(currProgram){

                ((HistroryTableViewCell*)cell).exchangeCurrencyString = [ACalcBrain stringCurrensiesInProgram:currProgram
                                                                                              withAtrtributes:self.designObj.atrForLabelHistoryTable];//IMPORTANT IF it is - need to set exchange rate
                ((HistroryTableViewCell*)cell).variableValuesString = [ACalcBrain stringVariableInProgram:currProgram
                                                                                              withAtrtributes:self.designObj.atrForLabelHistoryTable];
                ((HistroryTableViewCell*)cell).funcDescriptAtrString = [ACalcBrain stringFunctionInProgram:currProgram
                                                                                          withAtrtributes:self.designObj.atrForLabelHistoryTable];
                ((HistroryTableViewCell*)cell).programAtrString = [self getAttributedStringFromArray:currProgram];

            } else {
            
                //set least row program string
               // if(!self.lastRowDataArray) self.lastRowDataArray = [[NSArray alloc] init];//if no array till now
               // ((HistroryTableViewCell*)cell).programAtrString = self.lastRowsString;//IMPORTANT SET STR WITH MAIN ATTRIBUTES
            }

            
            if(![self.historyTable indexPathForSelectedRow]){
               // [self selectLastRowInHistory];

            }
            
        } else {
            
            ((HistroryTableViewCell*)cell).isCanDrag = YES;

            History *story = nil;
            if(self.fetchedResultsController && [self.fetchedResultsController objectAtIndexPath:indexPath]){
                story = [self.fetchedResultsController objectAtIndexPath:indexPath];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
            ((HistroryTableViewCell*)cell).dateString = [[NSAttributedString alloc]
                                                         initWithString:[[dateFormatter stringFromDate:story.date] stringByAppendingString:@"  "]
                                                         attributes:self.designObj.atrForLabelHistoryTable];
            ((HistroryTableViewCell*)cell).exchangeCurrencyString = [ACalcBrain stringCurrensiesInProgram:[NSKeyedUnarchiver unarchiveObjectWithData:story.program]
                                                                                          withAtrtributes:self.designObj.atrForLabelHistoryTable];//IMPORTANT IF it is - need to set exchange rate
            ((HistroryTableViewCell*)cell).variableValuesString = [ACalcBrain stringVariableInProgram:[NSKeyedUnarchiver unarchiveObjectWithData:story.program]
                                                                                      withAtrtributes:self.designObj.atrForLabelHistoryTable];
            ((HistroryTableViewCell*)cell).funcDescriptAtrString = [ACalcBrain stringFunctionInProgram:[NSKeyedUnarchiver unarchiveObjectWithData:story.program]
                                                                                       withAtrtributes:self.designObj.atrForLabelHistoryTable];
            ((HistroryTableViewCell*)cell).programAtrString = [self getAttributedStringFromStory:story];
            
        }
        [(HistroryTableViewCell*)cell setTextForLabels];
         */

    }
    //[cellHeights setObject:[NSNumber numberWithFloat:cell.bounds.size.height] forKey:indexPath];
    
    return cell;
}

#define EDIT ROW

#define NO_DEAL_CELL 0
#define DELETE_CELL 1
#define RECOUNT_CELL 2

NSInteger dealWithCell;

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   /* [self.historyTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0]-1  inSection:0]
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionBottom];*/
    if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
        return NO;
    } else {
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath ||(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1) ){
        self.recountButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }else {
        self.recountButton.enabled = YES;
        self.deleteButton.enabled = YES;
    }
    //}
    /*
     if(!self.isTestViewOnScreen){
     [self showCount];
     }
     if(![self.presentedViewController isKindOfClass:[ThirdController class]] && ![self.presentedViewController isKindOfClass:[SecondViewController class]]){
     [self showCount];
     }
     
     */
    
}
-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(dealWithCell == RECOUNT_CELL){
        [self.historyTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0]-1  inSection:0]
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionNone];
    } else if (dealWithCell == DELETE_CELL){
        NSIndexPath *newPatch = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [self.historyTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
          /*      [self.historyTable setContentOffset:CGPointMake(self.historyTable.contentOffset.x, historyTableBottomOffset - self.historyTable.bounds.size.height)];
        */
    }
    /*NSIndexPath *newPatch = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
     [self.historyTable selectRowAtIndexPath:newPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
     */
    dealWithCell = NO_DEAL_CELL;
    //NSLog(@"didEndEditingRowAtIndexPath");
}


-(UISwipeActionsConfiguration*)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    historyTableBottomOffset = self.historyTable.contentOffset.y + self.historyTable.bounds.size.height;
    [self.historyTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    UIContextualAction *delAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //IMPORTANT way to bug
        NSIndexPath *newPatch = [NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section];
        
        [self.historyTable selectRowAtIndexPath:newPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
        //--------------------------
        dealWithCell = DELETE_CELL;
        [self cellDidSelectDelete:indexPath];
        completionHandler(YES);
       
    }];

    delAction.image = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact? [UIImage imageNamed:@"DelPhone"]:[UIImage imageNamed:@"DelPad"] ;
    delAction.backgroundColor = self.designObj.deleteButtonBackgroundColor;
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        dealWithCell = RECOUNT_CELL;
        [self cellDidSelectRecount:indexPath];

        completionHandler(YES);
    }];

    editAction.image = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact? [UIImage imageNamed:@"RecPhone72"]:[UIImage imageNamed:@"RecPad"] ;

    editAction.backgroundColor = self.designObj.moreButtonBackgroundColor;

    UISwipeActionsConfiguration *swipeConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[delAction,editAction]];
    swipeConfiguration.performsFirstActionWithFullSwipe = YES;
    return swipeConfiguration;
}

//HERE
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60;
    if([self.heightsOfRows count] > 0){
        height = [[self.heightsOfRows objectAtIndex:indexPath.row] floatValue];
    }
    
    
    return height;
}

-(void) resetHeightOfFirstCell
{
    NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
    
    NSAttributedString* stringInCell = [self resizeStrforFirstCell:self.lastRowsString];
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
    //HERE
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

//HERE
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

*/

#pragma mark GET ATTRIBUTED STRINGS
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
    //NSLog(@"Get atrStr inputArray: %@", array);
    NSMutableArray *programFromHistory = [array mutableCopy];
    NSString *resultString = @"";
    id result = [programFromHistory lastObject];
    //NSLog(@"GetAttrStr result %@",result);
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
            
            //resultString = [numberFormatter stringFromNumber:result];
            resultString = [@" = " stringByAppendingString:[numberFormatter stringFromNumber:result]];
        } else if (result && [result isKindOfClass:[NSString class]]){
            resultString = result;
        }
    } else {
        resultString = @" ";
    }
    
    //IMPORTANT delete properties self.attributes
    
    NSMutableAttributedString * resultAtrStr = [[NSMutableAttributedString alloc] initWithString:resultString attributes:self.designObj.atrforHistoryTable];
    
    
    NSMutableArray *argArrayCopy = [[NSMutableArray alloc] init];
    NSMutableArray *wholeProgramCopy = [[NSMutableArray alloc] init];
    id top = [programFromHistory lastObject];
    if(top && [top isKindOfClass:[NSArray class]]){
        [programFromHistory removeLastObject];
        argArrayCopy = [ACalcBrain deepArrayCopy:top];//CHECK HEERE
        top = [programFromHistory lastObject];
        if(top && [top isKindOfClass:[NSArray class]]){
            [programFromHistory removeLastObject];
            wholeProgramCopy = [ACalcBrain deepArrayCopy:top];
        }
    }
    id topOfArgArray = [argArrayCopy lastObject];
    //add arg as stack but not add argu as stack if it isn't strong argu
    if(topOfArgArray && [topOfArgArray isKindOfClass:[NSArray class]]){
        if([(NSArray*)topOfArgArray count]==4 && [topOfArgArray[0] isKindOfClass:[NSString class]]){
            if([(NSString*)topOfArgArray[0] isEqualToString:@"$"]){
                [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
            } else {
                id topOfWhlPrgLastObj = [wholeProgramCopy lastObject];
                if([topOfWhlPrgLastObj lastObject]){
                    [wholeProgramCopy.lastObject addObject:topOfArgArray];
                } else {
                    for(id stc in topOfArgArray){
                        [wholeProgramCopy.lastObject addObject:stc];
                    }
                }
            }
        } else {
            id topOfWhlPrgLastObj = [wholeProgramCopy lastObject];
            if([topOfWhlPrgLastObj lastObject]){
                [wholeProgramCopy.lastObject addObject:topOfArgArray];
            } else {
                for(id stc in topOfArgArray){
                    [wholeProgramCopy.lastObject addObject:stc];
                }
            }
        }

    } else if([argArrayCopy count] > 0){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
    } else if([argArrayCopy count] > 1){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
    }

    
    NSAttributedString *stringProgram = [ACalcBrain descriptionOfProgram:wholeProgramCopy withAttributes:self.designObj.atrforHistoryTable];
    [resultAtrStr insertAttributedString:stringProgram atIndex:0];
    
    return resultAtrStr;
    
}

-(NSAttributedString*)getAttrInfStringFromStory:(History*)story{
    
    
    return [self getAttrInfStringFromProg:[NSKeyedUnarchiver unarchiveObjectWithData:story.program] and:story.date];
}

-(NSAttributedString*)getAttrInfStringFromProg:(NSArray*)prog and:(NSDate*)date{
    
    NSMutableAttributedString *wholeInfo = [[NSMutableAttributedString alloc] initWithString:@"" attributes:self.designObj.atrForLabelHistoryTable];
    NSAttributedString* spaceMark = [[NSAttributedString alloc] initWithString:@" "];//IMPORTANT Check if it need to set attributes
    
    //get date
    if(date){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    
    NSAttributedString *dateString = [[NSAttributedString alloc]
                                      initWithString:[[dateFormatter stringFromDate:date] stringByAppendingString:@"  "]
                                      attributes:self.designObj.atrForLabelHistoryTable];
        [wholeInfo insertAttributedString:dateString atIndex:0];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    } /*else {
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }*/
    
    //get currensies part
    NSAttributedString* exchangeCurrencyString = [ACalcBrain stringCurrensiesInProgram:prog
                                                                       withAtrtributes:self.designObj.atrForLabelHistoryTable];
    if(exchangeCurrencyString){
        [wholeInfo insertAttributedString:exchangeCurrencyString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    
    //get variables part
    NSAttributedString* variableValuesString = [ACalcBrain stringVariableInProgram:prog
                                                                   withAtrtributes:self.designObj.atrForLabelHistoryTable];
    if(variableValuesString){
        [wholeInfo insertAttributedString:variableValuesString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    
    //get functions part
    NSAttributedString* funcDescriptAtrString = [ACalcBrain stringFunctionInProgram:prog
                                                                    withAtrtributes:self.designObj.atrForLabelHistoryTable];
    if(funcDescriptAtrString){
        [wholeInfo insertAttributedString:funcDescriptAtrString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    
    return [wholeInfo copy];
    
}

#pragma mark HEIGHT OF CELL
-(CGFloat)getCellHeightFromMain:(NSAttributedString*)mainStr and:(NSAttributedString*)infStr forHorizontal:(UIUserInterfaceSizeClass)size{
    CGFloat needHeight;
    
    //here -40
    CGFloat needWidth = self.mainContainerWidth.constant - 40;
    CGSize needSize = CGSizeMake(needWidth, 1000);
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    
    CGRect needInfoRect = [infStr boundingRectWithSize:needSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:drawContext];
    CGRect needMainRect = [mainStr boundingRectWithSize:needSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:drawContext];
    needHeight = needInfoRect.size.height+needMainRect.size.height+20.;
    CGFloat setedMinHeight = size == UIUserInterfaceSizeClassCompact?MIN_CELL_HEIGHT_COPACT:MIN_CELL_HEIGHT_REGULAR;
    if(needHeight < setedMinHeight){
        return setedMinHeight;
    } else {
        return needHeight;
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
/*
- (IBAction)historyTableLeftSwipeGesturerecognizer:(UIPanGestureRecognizer *)sender
{
    
    CGPoint tapLocation = [sender locationInView:self.historyTable];
    NSIndexPath *indexPath = [self.historyTable indexPathForRowAtPoint:tapLocation];
    if(indexPath){
        if([[self.historyTable  cellForRowAtIndexPath:indexPath] isKindOfClass:[HistroryTableViewCell class]]){
            if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
                HistroryTableViewCell *tableCell = (HistroryTableViewCell*)[self.historyTable cellForRowAtIndexPath:indexPath];
                [tableCell showButtons:sender];
            }
            [self.historyTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateEnded ||
       sender.state == UIGestureRecognizerStateFailed){

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
*/


- (IBAction)pressedSelectedButton:(UIButton *)sender
{
    if([self.historyTable indexPathForSelectedRow]){
        [self cellDidSelectRecount:[self.historyTable indexPathForSelectedRow]];
    }
}

-(void)cellDidSelectRecount:(NSIndexPath*)selectedCellIndex
{
    
   // NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    if(selectedCellIndex.row != [self.historyTable numberOfRowsInSection: 0] - 1){
        
        History *story = [self.fetchedResultsController objectAtIndexPath:selectedCellIndex];
        NSMutableArray *programFromHistory = [[NSKeyedUnarchiver unarchiveObjectWithData:story.program] mutableCopy];
        
        if([programFromHistory lastObject])[programFromHistory removeLastObject];
        
        
        //if there are currencies in count - asck  currencies controller to make request for particukar currencies pair
        NSArray* copyProgrammFroCurrensiesCheck = [programFromHistory copy];
        
        
        id top = [programFromHistory lastObject];
        //remove result from pprogramm array!
        [programFromHistory removeLastObject];
        NSMutableArray *argArrayCopy;
        if(top){
            argArrayCopy = [[ACalcBrain deepArrayCopy:top] mutableCopy];
        }
        
       // if(DEBUG_MODE) NSLog(@"cellDidSelectRecount Argu %@", argArrayCopy);
        
        
        NSMutableArray *programCopy = [[NSMutableArray alloc] init];
        top = [programFromHistory lastObject];
        if(top) programCopy = [ACalcBrain deepArrayCopy:top];
        //if(DEBUG_MODE) NSLog(@"cellDidSelectRecount program %@", programCopy);
        
        ACalcBrain *newBrain = [ACalcBrain initWithProgram:[programCopy copy] withArgu:[argArrayCopy copy]];
        
        self.brain = newBrain;
        [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
        self.isProgramInProcess = NO;
        self.isStronglyArgu = YES;
        self.userIsInTheMidleOfEnteringNumber = NO;
        [self showStringThrouhgmanagerAtEqualPress];
        [self discardChanging];
        
        
        if([ACalcBrain chekForCurrensiesProgramm:copyProgrammFroCurrensiesCheck]){
            //if there are currencies in count - asck  currencies controller to make request for particukar currencies pair
            [self.currensies askResultForCurrensiesArray:[ACalcBrain chekForCurrensiesProgramm:copyProgrammFroCurrensiesCheck]];
        }
    }
}

-(void) resetProgrammAfterCurrensiesChecked:(NSArray*)currencies{
    //if(DEBUG_MODE) NSLog(@"resetProgrammAfterCurrensiesChecked Curr array after request: %@", currencies);
    NSArray *deepProgram = [self.brain.deepProgram copy];
    NSArray *deepArgu = [self.brain.deepArgu copy];
    NSArray *testArray = [[deepProgram lastObject] copy];
    if(([testArray count]>0) || ([deepArgu count]>0)){
        
        NSMutableArray * muttableOutputArray = [[NSMutableArray alloc] init];
        [muttableOutputArray addObject:deepProgram];
        [muttableOutputArray addObject:deepArgu];
        
        if([ACalcBrain chekForCurrensiesProgramm:[muttableOutputArray copy]]){
            
            muttableOutputArray =  [[ACalcBrain programm:[muttableOutputArray copy] withReplaceWithCurrencies:currencies
                                     ] mutableCopy];
        }
        
        
        id top = [muttableOutputArray lastObject];
        //remove result from pprogramm array!
        [muttableOutputArray removeLastObject];
        NSMutableArray *argArrayCopy;
        if(top){
            argArrayCopy = [[ACalcBrain deepArrayCopy:top] mutableCopy];
        }
        
        
        NSMutableArray *programCopy = [[NSMutableArray alloc] init];
        top = [muttableOutputArray lastObject];
        if(top) programCopy = [ACalcBrain deepArrayCopy:top];
        //if(DEBUG_MODE) NSLog(@"resetProgrammAfterCurrensiesChecked after programCopy %@:",programCopy );
        ACalcBrain *newBrain = [ACalcBrain initWithProgram:[programCopy copy] withArgu:[argArrayCopy copy]];
        
        self.brain = newBrain;
        
        
        [self.mainLabel showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
        self.isProgramInProcess = NO;
        self.isStronglyArgu = YES;
        self.userIsInTheMidleOfEnteringNumber = NO;
        [self showStringThrouhgmanagerAtEqualPress];
        
        
    }
}

- (IBAction)pressedDeleteButton:(UIButton *)sender
{
    if([self.historyTable indexPathForSelectedRow]){
        [self cellDidSelectDelete:[self.historyTable indexPathForSelectedRow]];
    }
}

-(void)cellDidSelectDelete:(NSIndexPath*)cellIndexPatch
{
    //self.historyTable.isNeedToSetOffsetToButton = NO;
   // NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    
    if(cellIndexPatch.row != [self.historyTable numberOfRowsInSection: 0] - 1){
        History *story = [self.fetchedResultsController objectAtIndexPath:cellIndexPatch];
        [self.managedObjectContext deleteObject:story];
        
        /*
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        if(lastRowPatch){
            [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self setSelectedRow:nil];
        }*/
    }
}


-(void) cellDidSelect:(HistroryTableViewCell *)cell
{
   
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    //if(DEBUG_MODE) NSLog(@"cellDidSelectsetSelectedRow %ld, %ld", (long)indexPath.row, indexPath.section);
    //self.selectedRow = cell;
    
    
    //NSIndexPath *indexPath = [self.historyTable indexPathForCell:cell];
    
    //NSIndexPath *previousSelectedIndexPatch = [self.historyTable indexPathForCell:_selectedRow];
   // NSIndexPath *nowSelectedIndexPatch = [self.historyTable indexPathForSelectedRow];
    
    //if(previousSelectedIndexPatch.row != nowSelectedIndexPatch.row){
        
        //self.selectedRow = cell;
        if(!indexPath ||(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1) ){
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
        }else {
            self.recountButton.enabled = YES;
            self.deleteButton.enabled = YES;
        }
    
    [self getStringsForShowedControllerForCell: indexPath];
            //}
    /*
    if(!self.isTestViewOnScreen){
        [self showCount];
    }
     if(![self.presentedViewController isKindOfClass:[ThirdController class]] && ![self.presentedViewController isKindOfClass:[SecondViewController class]]){
     [self showCount];
     }

     */
}

/*
-(void) setSelectedRow:(HistroryTableViewCell *)selectedRow
{
    NSIndexPath *indexPath = [self.historyTable indexPathForCell:selectedRow];

    

    //NSIndexPath *previousSelectedIndexPatch = [self.historyTable indexPathForSelectedRow];
    //NSIndexPath *nowSelectedIndexPatch = indexPath;//[self.historyTable indexPathForSelectedRow];
    
    NSLog(@"setSelectedRow indexPath %ld", (long)indexPath.row);
    //NSLog(@"setSelectedRow previousSelectedIndexPatch %ld", (long)previousSelectedIndexPatch.row);
    //NSLog(@"setSelectedRow willSelectedIndexPatch %ld", (long)nowSelectedIndexPatch.row);

    
    //if(previousSelectedIndexPatch.row != nowSelectedIndexPatch.row){
        
        _selectedRow = selectedRow;
       //NSIndexPath *nowSelectPatch = [self.historyTable indexPathForCell:_selectedRow];
   // NSIndexPath *nowSelectPatch = [self.historyTable indexPathForCell:self.historyTable];
         //NSLog(@"nowSelectedIndexPatch %ld", (long)nowSelectPatch.row);
        if(!indexPath){
            self.plusButton.enabled = YES;
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
        }else if(indexPath.row != [self.historyTable numberOfRowsInSection: 0] - 1){
            self.plusButton.enabled = YES;
            self.recountButton.enabled = YES;
            self.deleteButton.enabled = YES;
        } else {
            self.plusButton.enabled = YES;
            self.recountButton.enabled = NO;
            self.deleteButton.enabled = NO;
            
        }
    //}
    if(![self.presentedViewController isKindOfClass:[ThirdController class]] && ![self.presentedViewController isKindOfClass:[SecondViewController class]]){
        [self showCount];
    }
}
*/

#pragma mark MANAGED CONTEXT
/*
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
*/

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
/*
-(void) setButtonManagedObjectContext:(NSManagedObjectContext *)buttonManagedObjectContext
{
    _buttonManagedObjectContext =[self removeDuplicateRecordsFromContext:buttonManagedObjectContext];
    self.buttonsStore.buttonManagedObjectContext = buttonManagedObjectContext;
    //init button store with context
    //ask inside initialization makes all needed arrays
   // ButtonsStore* buttons = [[ButtonsStore alloc] initWithContext:buttonManagedObjectContext];
    //buttons.delegate = self;
    //all setup inside buttons store
    //self.buttonsStore = buttons;
    //[self.buttonsStore setUpArrays];
    
    //[self setUpArrays];
    //all buttons reload in delegate methods buttonsArrayDidChanged
    //[self.buttonsCollection reloadData];
}
*/

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



#pragma mark SET HISTORY ARRAYS

-(void) updateHistoryTableArraysAndGoBottom:(BOOL) toBottom{
    
    UIUserInterfaceSizeClass horisontalSize = self.view.traitCollection.horizontalSizeClass;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * fetchedObjects = self.fetchedResultsController.fetchedObjects;
        
        NSMutableArray* mainHistoryAttributedStrings = [[NSMutableArray alloc] init];
        NSMutableArray* infoHistoryAttributedStrings = [[NSMutableArray alloc] init];
        NSMutableArray* heightsHistoryCells = [[NSMutableArray alloc]init];
        
        if([fetchedObjects count]>0){
            for(History* story in fetchedObjects){
                NSAttributedString *mainStr;
                NSAttributedString *infStr;
                CGFloat cellHeight;
                
                //1. get main string
                mainStr = [self getAttributedStringFromStory:story];
                //2. get inf str
                infStr = [self getAttrInfStringFromStory:story];
                //3. calculate need cell Heigh
                cellHeight = [self getCellHeightFromMain:mainStr and:infStr forHorizontal:horisontalSize];
                
                //add to arrays
                [mainHistoryAttributedStrings addObject:mainStr];
                [infoHistoryAttributedStrings addObject:infStr];
                [heightsHistoryCells addObject:[NSNumber numberWithFloat:cellHeight]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.historyTable  beginUpdates];
            self.mainAttributedStrings = [mainHistoryAttributedStrings copy];
            self.infoAttributedStrings = [infoHistoryAttributedStrings copy];
            self.cellHeights = [heightsHistoryCells copy];
            // [self.historyTable endUpdates];
            
            [self.historyTable reloadData];

            
             if(toBottom){
                 
                 [self.historyTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.cellHeights count]  inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
                 [self moveHistoryTableContentToRightPosition];
             }
        });
    });
}

#pragma mark - FETCHING
- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
           //if(DEBUG_MODE) NSLog(@"performFetch Predicate %@", self.fetchedResultsController.fetchRequest.predicate);
        } else {
            //if(DEBUG_MODE) NSLog(@"performFetch No predicate");
        }
        NSError *error;
        if([self.fetchedResultsController performFetch:&error]){
            //if(DEBUG_MODE) NSLog(@"performFetch SUCCES PERFORM FETCH");
        }

    } else {

    }
    //if(DEBUG_MODE) NSLog(@"performFetch fetchedObjs count %lu",[self.fetchedResultsController.fetchedObjects count]);
    
    
    [self updateHistoryTableArraysAndGoBottom:YES];
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
            [self updateHistoryTableArraysAndGoBottom:YES];
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
    

#pragma mark - NSFetchedResultsControllerDelegate
//what I need to change array
//NSDictionary new heights according number of added row
//NSset Deleted obj

BOOL isNewTableRow;
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
    isNewTableRow = NO;
    switch(type)
    {
        case NSFetchedResultsChangeInsert:{

            /*
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

            
            self.heigthsOfNewRowsAccordingNewObjs = [mutDiction copy];
            //replace row above
            */
            //exactly here the place to show banner with delay
            if(!self.wasPurshaised){
                //check banner show counter
                //if ok banner not on the screen  - show it, without count incrise
                //if no - incrise counter
                /*
                 if(!self.isIAdBannerOnScreen && self.isIAdBaneerAvailable){
                 if((self.bannerRequestCounter % TIMES_TO_LIMIT_IAD_BANNER) == 0){
                 [self ShowIAdBanner];
                 }
                 self.bannerRequestCounter++;
                 }*/
            }
            /*HERE IS THE PROBLEM
            History* newStory = [self.fetchedResultsController.fetchedObjects objectAtIndex:newIndexPath.row];
            NSMutableArray *mainAttrArrMut = [self.mainAttributedStrings mutableCopy];
            [mainAttrArrMut insertObject:<#(nonnull id)#> atIndex:<#(NSUInteger)#>]
            */
            
            //for history arrays changes
            NSMutableArray* mainHistoryAttributedStrings = [self.mainAttributedStrings mutableCopy];
            NSMutableArray* infoHistoryAttributedStrings = [self.infoAttributedStrings mutableCopy];
            NSMutableArray* heightsHistoryCells = [self.cellHeights mutableCopy];
            
            History* storyObj = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            
            //1. get main string
            NSAttributedString* mainStr = [self getAttributedStringFromStory:storyObj];
            //2. get inf str
            NSAttributedString* infStr = [self getAttrInfStringFromStory:storyObj];
            //3. calculate need cell Heigh
            CGFloat cellHeight = [self getCellHeightFromMain:mainStr and:infStr forHorizontal:self.view.traitCollection.horizontalSizeClass];
            
            //add to arrays
            [mainHistoryAttributedStrings addObject:mainStr];
            [infoHistoryAttributedStrings addObject:infStr];
            [heightsHistoryCells addObject:[NSNumber numberWithFloat:cellHeight]];
            
            self.mainAttributedStrings = [mainHistoryAttributedStrings copy];
            self.infoAttributedStrings = [infoHistoryAttributedStrings copy];
            self.cellHeights = [heightsHistoryCells copy];
            
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            isNewTableRow = YES;
            
        }
            
            break;
            
        case NSFetchedResultsChangeDelete: {
            //self.historyTable.isNeedToSetOffsetToButton = NO;
            //NSMutableIndexSet *mutSet = [self.deletedIndexesSet mutableCopy];
            
            //for history arrays changes
            NSMutableArray* mainHistoryAttributedStrings = [self.mainAttributedStrings mutableCopy];
            NSMutableArray* infoHistoryAttributedStrings = [self.infoAttributedStrings mutableCopy];
            NSMutableArray* heightsHistoryCells = [self.cellHeights mutableCopy];
            

            
            //add to arrays
            [mainHistoryAttributedStrings removeObjectAtIndex:indexPath.row];
            [infoHistoryAttributedStrings removeObjectAtIndex:indexPath.row];
            [heightsHistoryCells removeObjectAtIndex:indexPath.row];
            
            self.mainAttributedStrings = [mainHistoryAttributedStrings copy];
            self.infoAttributedStrings = [infoHistoryAttributedStrings copy];
            self.cellHeights = [heightsHistoryCells copy];
            
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //IMPORTANT way to bug
            NSIndexPath *newPatch = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            [self.historyTable selectRowAtIndexPath:newPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
            //--------------------------
            
            //[self moveHistoryTableContentToRightPosition];
            
            //[mutSet addIndex:indexPath.row];
            //self.deletedIndexesSet = [mutSet copy];
            
        }
            break;
            
        case NSFetchedResultsChangeUpdate:{

        }
            break;
            
        case NSFetchedResultsChangeMove:
            //self.historyTable.isNeedToSetOffsetToButton = NO;
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
   
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    /*
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
    */
    
    
    [self.historyTable endUpdates];
   
    
    //NSLog(@"FetchedController count: %lu", [self.fetchedResultsController.fetchedObjects count]);
    //NSLog(@"HistoryTable count: %lu", [self.historyTable numberOfRowsInSection:0]);
    
    if([self.historyTable numberOfRowsInSection:0]>1){
        NSIndexPath *preLastRow = [NSIndexPath
                                   indexPathForRow:[self.historyTable numberOfRowsInSection:0]-2
                                   inSection:0];
        [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:
                                                   preLastRow, nil]
                                 withRowAnimation:UITableViewRowAnimationFade];
    }
    /*
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if(isNewTableRow) {
        NSLog(@"controllerDidChangeContent %lu", [self.historyTable numberOfRowsInSection:0]-1);
            [self moveHistoryTableContentToRightPosition];
        }
    }];
     if([self.historyTable numberOfRowsInSection:0]>1){
         NSIndexPath *preLastRow = [NSIndexPath
                                    indexPathForRow:[self.historyTable numberOfRowsInSection:0]-2
                                    inSection:0];
         [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:
                                                    preLastRow, nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
     }

    
    [CATransaction commit];
*/
   
    if(isNewTableRow) {
        //NSLog(@"controllerDidChangeContent %lu", [self.historyTable numberOfRowsInSection:0]-1);
        [self.historyTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0]-1  inSection:0]
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionBottom];
       // [self moveHistoryTableContentToRightPosition];

    }
    
    NSError *error;
    if (self.managedObjectContext != nil) {
        if (self.managedObjectContext.hasChanges && ![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
   
 
    
    //[self selectLastRowInHistory];
    //[self moveHistoryTableContentToRightPosition];
    //[self selectLastRowInHistory];
    //[self.historyTable reloadData];
    
    //!! Set that at history class!!!
    //------------------------------------------------------------
    //[self moveHistoryTableContentToRightPosition];
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

//REPLASED
//-----------------------------------------------------------------------------------------
/*
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
*/
//-----------------------------------------------------------------------------------------

#pragma mark SHOW VIEW

- (IBAction)tappedRealNoticeButton:(UIButton *)sender
{
    self.callShowController = YES;
    [self showSowedViewController];
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
            atrStrFromString = [self.lastRowsString mutableCopy];//IMPORTANT not shure it needed. lastRowsString apears only here
           // atrStrFromString =  [[self getAttributedStringFromArray:self.lastRowDataArray] mutableCopy];
        } else {
            atrStrFromString =  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        }
        NSString *strToShare = atrStrFromString.string;
        if(strToShare.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                NSString *lastSymbol = [strToShare substringWithRange:NSMakeRange(strToShare.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    NSAttributedString *result = [[NSAttributedString alloc] initWithString:self.mainLabel.attributedText.string attributes:self.atrStore.mainAttributes];
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

#pragma mark ICLOUD SETUP

/*
- (IBAction)isiCloudSwitch:(UISwitch *)sender
{
    if(sender.isOn){
        self.isiCloudInUse = YES;
    } else {
        self.isiCloudInUse = NO;
    }
}
*/

/*
-(void) setIsiCloudInUse:(BOOL)isiCloudInUse
{
    if(_isiCloudInUse != isiCloudInUse){
        [self userDidChangeStorage:isiCloudInUse];
    }
    
    _isiCloudInUse = isiCloudInUse;
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
*/

#pragma mark SETUP_STORAGE
/**
 Returns the URL to the application's documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
   // return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
     return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

#pragma mark DOCUMENT
-(void) documentIsReady:(UIManagedDocument*) document
{
    if(document.documentState == UIDocumentStateNormal){

        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
       // request.predicate = [NSPredicate predicateWithFormat:@"date != %@",[NSDate distantPast]];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
        request.fetchLimit = self.limitInDataBase + 20;//!!!!set this value to allow use set it by settings
        NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        NSError *error;
        [fetchedResultsController performFetch:&error];
        NSArray* fetchedObjs = [fetchedResultsController fetchedObjects] ;
        if(DEBUG_MODE) NSLog(@"documentIsReady Fetched objects: %lu",[fetchedObjs count]);
        
        if(fetchedObjs && (fetchedObjs.count >0)){
            for (History *hist in fetchedObjs){
                [History storyWithProgram:[NSKeyedUnarchiver unarchiveObjectWithData:hist.program] atDate:hist.date inManageObjectContext:self.managedObjectContext];
            }
        }
        
        [document closeWithCompletionHandler:^(BOOL success) {
            if(!success){
                //  NSLog(@"Close old document not sucesseful");
            } else {
                // NSLog(@"Close old sucesseful");
            }
            NSError *removeFileError;
            if([[NSFileManager defaultManager] removeItemAtURL:[document fileURL] error:&removeFileError]){
                if(DEBUG_MODE) NSLog(@"removeItemAtURL SUCCES");
            }else {
                if(DEBUG_MODE) NSLog(@"removeItemAtURL  NOT success");
            }
        }];
        
        [self performFetch];

        [self.managedObjectContext save:&error];
    }
}

-(void) checkICloudWith:(NSString*)fileName cloud:(NSString*)cloudName andKey:(NSString*)keyName
{
    
    if(DEBUG_MODE) NSLog(@"checkICloudWith file:%@, cloudName:%@ and keyName:%@", fileName, cloudName, keyName);//check iCloud store
    NSURL *documentsStoreURL =
    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:documentsStoreURL];
    NSURL *iCloudURL = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent: cloudName];
    
    if(iCloudURL){
        NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey:keyName,
                                  NSPersistentStoreUbiquitousContentURLKey: iCloudURL,
                                  NSMigratePersistentStoresAutomaticallyOption:@YES,
                                  NSInferMappingModelAutomaticallyOption:@YES};
        document.persistentStoreOptions = options;
    
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsStoreURL.path]) {
            //[self setStoreNotifications];
            if(DEBUG_MODE) NSLog(@"Exist file");
            [document openWithCompletionHandler:^(BOOL success) {
                if (success){
                    [self documentIsReady:document];
                } else {
                    if(DEBUG_MODE) NSLog(@"NOT SUCCESS TO OPEN MyCloudDocument");
                }
            }];
    }
    }
}
-(void) checkPreviousStorage
{
    
    //Check MyDocument
    NSURL *documentsStoreURL =
    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyDocument"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:documentsStoreURL];
    NSDictionary *options = @{
                              NSPersistentStoreRemoveUbiquitousMetadataOption:@YES,
                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES};

    document.persistentStoreOptions = options;

    if ([[NSFileManager defaultManager] fileExistsAtPath:documentsStoreURL.path]) {
        if(DEBUG_MODE) NSLog(@"Exist file MyDocument");
        [document openWithCompletionHandler:^(BOOL success) {
            if (success){
                [self documentIsReady:document];
            } else {
                if(DEBUG_MODE) NSLog(@"NOT SUCCESS TO OPEN MyDocument");
            }
        }];
    }
    [self checkICloudWith:@"MyCloudDocument" cloud:@"MyCloudDocument"  andKey:@"MyCloudDocument" ];//
}

-(void) setupStorage
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *documentsStorePath =
        [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"ItsCalcSQL"];

        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsStorePath]) {
            [[NSFileManager defaultManager] createFileAtPath:documentsStorePath contents:nil attributes:nil];
        }
        _persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        // Add the default store to our coordinator.
        NSError *error;
        NSURL *defaultStoreURL = [NSURL fileURLWithPath:documentsStorePath];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:defaultStoreURL
                                                             options:nil
                                                               error:&error]) {

            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        } else {
            _buttonManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _buttonManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
            
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonsStore.buttonManagedObjectContext  = self.buttonManagedObjectContext;
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
            //request.predicate = nil;
            //NSData *nullData = [NSKeyedArchiver archivedDataWithRootObject:[[NSArray alloc]init]];
            request.predicate = [NSPredicate predicateWithFormat:@"date != %@",[NSDate distantPast]];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
            request.fetchLimit = self.limitInDataBase + 20;//!!!!set this value to allow use set it by settings
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:self.managedObjectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
            [self checkPreviousStorage];
        });
    });
    
    
    
    
    //if(self.isiCloudInUse){
    //    [self setupiCloudUIManagedDocument];
    //} else { //set up Local Storage
     //   [self setupLocalUIManagedDocument];
   // }
}
/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

#pragma mark VIEW_DID_LOAD
- (void)viewDidLoad
{
    ITSCalcAppDelegate* appClass = (ITSCalcAppDelegate*)[[UIApplication sharedApplication] delegate];//((AppDelegate *)
    NSDate* launchTime = appClass.launchDate;
    /*if(DEBUG_MODE){
        //NSDate* appearDate = [NSDate date];
        NSLog(@"start view did time %f",[[NSDate date] timeIntervalSinceDate:launchTime]);
    } */
    //IMPORTANT SET ATR STORE FOR BUTTONS
    self.atrStore = [[AtrStrStore alloc]init];
    self.atrStore.delegate = self;
    self.atrStore.design = self.designObj;
    
    //USER DEFAULT
    //set KV Store selector
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateKVStoreItems:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:store];
    //Important.What is this
    //[store setString:@"Test" forKey:@"Test"];
    [store synchronize];
    
    [self setMainProperties]; // set main properties from user default or initial defaults
    [self setupStorage]; //setup icloud storage

    [super viewDidLoad];
    
    //for work with AD banner
    self.canShowBanner = NO;
    self.isIAdBannerOnScreen = NO;
    if(self.wasPurshaised){
        self.bannerContainerView.hidden = YES;
    } else {
        [self hideAdBannerAnimate:NO];
    }
    
    //set pan gesture delegate
    self.moveButtonsPanGestureRecognizer.delegate = self;
    self.isThreadInWork = NO;
    
    /*
    if(IS_BLACK_MODE){
        [self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
        [self.buttonsCollection setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    } else {
        //[self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    */
    
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
    //self.wasRightShowed = 0;

    //Important don't remember why i close it
    //IMPORTANT DELETE HERE
    /*
    [self initialLayoutDynamiccontainer];
    */
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

    
    //self.isHistoryWholeShowed = 0;
    //set other cursor color
    //transition to third controller
    self.callShowController = NO;

    self.isNeedToBeReloadedAfterDesignChanged = NO;
    isNeedReloadAfterOtherController = NO;
    
    //
    [self.buttonsCollection addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    [self.displayContainer addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    //INSERTED
    self.isCalcShowed = YES;
    self.isHistoryShowed = NO;
    /*if(DEBUG_MODE){
        NSLog(@"end view did time %f",[[NSDate date] timeIntervalSinceDate:launchTime]);
    }*/
    
    
    /*
    // Set vertical effect

    id motionOffsetValue = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular ? [NSNumber numberWithFloat: MOTION_IPAD]:[NSNumber numberWithFloat: MOTION_IPHONE];
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = motionOffsetValue;
    verticalMotionEffect.maximumRelativeValue = [NSNumber numberWithFloat:-[motionOffsetValue floatValue]];
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = motionOffsetValue;
    horizontalMotionEffect.maximumRelativeValue = [NSNumber numberWithFloat:-[motionOffsetValue floatValue]];
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    
    // Add both effects to your view
    //[self.buttonsCollection addMotionEffect:group];
    [self.historyTable addMotionEffect:group];
     */

}


#pragma mark ROTATION
-(void)rotateIPhoneAsNonRotateWithSize:(CGSize)size{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    CGFloat angleShowedViewController = 0;
    CGFloat angleMainTransform;
    BOOL needStopAnimation = YES;
    if([self.presentedViewController isKindOfClass:[SecondViewController class]]){
        
        
        switch (orient) {
            case UIDeviceOrientationPortraitUpsideDown:
                angleMainTransform = M_PI/2;
                break;
            case UIDeviceOrientationPortrait:
                angleMainTransform = 0;
                break;
            case UIDeviceOrientationLandscapeLeft:
                angleMainTransform = -M_PI/2;
                break;
            case UIDeviceOrientationLandscapeRight:
                angleMainTransform = M_PI/2;
                break;
            default:
                angleMainTransform = 0;
                break;
        }
        
        if(needStopAnimation){
            [UIView setAnimationsEnabled:NO]; //turn off animation on time
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
            [self.settingsController.cView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
            
            
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView setAnimationsEnabled:YES];
            });
        } else {
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
            [self.settingsController.cView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
        }
        
    }
    //!!!!
    //if presented third controller
    //
    else if([self.presentedViewController isKindOfClass:[ShowedViewController class]]){
            BOOL needToDissmisShowedViewcontroller = NO;
        if(size.height > size.width) {
            needToDissmisShowedViewcontroller = YES;
            
            switch (self.showedController.wasOrient) {
                case UIDeviceOrientationLandscapeLeft:
                    angleShowedViewController = M_PI/2;
                    needStopAnimation = YES;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    angleShowedViewController = -M_PI/2;
                    needStopAnimation = YES;
                    break;
                    
                default:
                    angleShowedViewController = 0;
                    needStopAnimation = NO;
                    break;
            }
        } else {
            switch (self.showedController.wasOrient) {
                case UIDeviceOrientationPortrait:
                    angleShowedViewController = 0;
                    needStopAnimation = YES;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    angleShowedViewController = 0;
                    needStopAnimation = YES;
                    break;
                    
                default:
                    angleShowedViewController = 0;
                    needStopAnimation = NO;
                    break;
            }
        }
       // [self callChanginShowedViewFrom:@"rotateIPhoneAsNonRotateWithSize"];
        switch (orient) {
            case UIDeviceOrientationPortraitUpsideDown:
                angleMainTransform = M_PI/2;
                break;
            case UIDeviceOrientationPortrait:
                angleMainTransform = 0;
                break;
            case UIDeviceOrientationLandscapeLeft:
                angleMainTransform = -M_PI/2;
                break;
            case UIDeviceOrientationLandscapeRight:
                angleMainTransform = M_PI/2;
                break;
            default:
                angleMainTransform = 0;
                break;
        }
        if(needStopAnimation){
            [UIView setAnimationsEnabled:NO]; //turn off animation on time
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
                [self.showedController.containerView setTransform:CGAffineTransformMakeRotation(angleShowedViewController)];
            
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.showedController.wasOrient = orient;
                [self.view setFrame:[UIScreen mainScreen].bounds];
                if(needToDissmisShowedViewcontroller){
                    [self.showedController dismis];
                    self.callShowController = NO;
                }
                [UIView setAnimationsEnabled:YES];
            });
        } else {
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
            [self.showedController.containerView setTransform:CGAffineTransformMakeRotation(angleShowedViewController)];
            self.showedController.wasOrient = orient;
        }

        
        
    } else {
        
        BOOL needToShowShowedController = NO;

    
        switch (orient) {
            case UIDeviceOrientationPortraitUpsideDown:
                angleMainTransform = M_PI/2;
                break;
            case UIDeviceOrientationPortrait:
                angleMainTransform = 0;
                break;
            case UIDeviceOrientationLandscapeLeft:
                angleMainTransform = -M_PI/2;
                needToShowShowedController = YES;
                break;
            case UIDeviceOrientationLandscapeRight:
                angleMainTransform = M_PI/2;
                needToShowShowedController = YES;
                break;
            default:
                angleMainTransform = 0;
                break;
        }
    
        if(needStopAnimation){
            [UIView setAnimationsEnabled:NO]; //turn off animation on time
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
        
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if(needToShowShowedController){
                    self.callShowController = YES;
                    [self showSowedViewController];
                }
                [UIView setAnimationsEnabled:YES];
            });
        } else {
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(angleMainTransform)];
        }
    }
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
    if(!IS_IPAD){
        [self rotateIPhoneAsNonRotateWithSize:size];
    } else {
        if(self.showedController){
            //[self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
            self.showedController.containerWidthConstrain.constant = size.width;
            self.showedController.containerHeightConstrain.constant = size.height;
            
            CGSize newContSize = CGSizeMake(self.showedController.containerWidthConstrain.constant, self.showedController.containerHeightConstrain.constant);
            [self callChanginShowedViewWithSize:newContSize From:@"viewWillTransitionToSize"];
            //[self updateViewConstraints];
            //[self.view layoutIfNeeded];
            //-------------------------------------------
            self.mainContainerWidth.constant = size.width;
            self.mainContainerHeight.constant = size.height;
            //set calc screen height
            CGFloat minSide = self.mainContainerWidth.constant < self.mainContainerHeight.constant? self.mainContainerWidth.constant : self.mainContainerHeight.constant;
            
            //
            if(minSide*IPAD_SCREEN_VS_WIDTH_RATIO/self.mainContainerHeight.constant < 0.09){
                //if so narrow screen - fix it
                self.calcScreenHeightConstrain.constant = self.mainContainerHeight.constant*0.09;
            } else {
                self.calcScreenHeightConstrain.constant = minSide*IPAD_SCREEN_VS_WIDTH_RATIO;
            }
            
            maxButtonsCollectionHeight = self.mainContainerHeight.constant/IPAD_RAIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
            if(self.isButtonsCollectionUnderChanging){
                //NSLog(@"sviperBottomConstrain before:%f",self.sviperBottomConstrain.constant );
                //NSLog(@"historyTableSviper hright:%f",self.historyTableSviper.frame.size.height );
                /*self.sviperBottomConstrain.constant = self.calcScreenHeightConstrain.constant/2.+ self.historyTableSviper.frame.size.height/2-self.calcScreenHeightConstrain.constant/10;*/
                self.sviperBottomConstrain.constant = -((self.calcScreenHeightConstrain.constant -self.historyTableSviper.frame.size.height)/2-self.calcScreenHeightConstrain.constant/10);
                
                //NSLog(@"sviperBottomConstrain after:%f",self.sviperBottomConstrain.constant );
                
            } else {
                if(self.isCalcShowed){
                    self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
                    
                    //[self changeHowHistoryShowed:0];
                    
                } else if(self.isHistoryShowed){
                    self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant;
                    //[self changeHowHistoryShowed:1];
                } else {
                    
                    [self changeHowHistoryShowed:((self.displayTopConstrain.constant+self.displayContainer.frame.size.height)-(self.mainContainerHeight.constant-maxButtonsCollectionHeight))/maxButtonsCollectionHeight];
                }
                
                self.sviperBottomConstrain.constant = -self.calcScreenHeightConstrain.constant*14./20.;
            }
            
            [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
            //screen buttons according interfase size
            if(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact){
                self.noticeButton.hidden = YES;
            } else {
                if(IS_IPAD && self.shareButton.hidden == NO){
                    self.noticeButton.hidden = NO;
                }
            }
        }
    }
    //NSLog(@"viewWillTransitionToSize");
}

//test Function
-(void) callChanginShowedViewWithSize:(CGSize)size From:(NSString*)funcName{
   // NSLog(@"Call from %@ \n expLabel width: %f, height: %f", funcName, self.showedController.expressionLabel.bounds.size.width,self.showedController.expressionLabel.bounds.size.height);
    //CGRect containerFrame = self.showedController.containerView.frame;
    
    //perfect works for iphone expressions label
    
    //for expression label frame
    CGRect testViewFrame;
    testViewFrame.origin.x = self.showedController.stackLeadingConstrain.constant+self.showedController.buttonsLeadingConstrain.constant+self.showedController.buttonsWidthConstrain.constant+5;//+labelFrame.origin.x-10.;
    testViewFrame.origin.y = self.showedController.stackTopConstrain.constant+self.showedController.descrLabelHeightConstrain.constant+5;// + labelFrame.origin.y-10.;
    testViewFrame.size.width =size.width-self.showedController.stackLeadingConstrain.constant-self.showedController.stackTrailingConstrain.constant-self.showedController.buttonsLeadingConstrain.constant-
        self.showedController.buttonsWidthConstrain.constant - 10;
    testViewFrame.size.height =size.height-self.showedController.stackTopConstrain.constant-self.showedController.stackBottomConstrain.constant-self.showedController.descrLabelHeightConstrain.constant- self.showedController.resultHeightConstrain.constant - 10;
    CGSize expresionLabelSize = testViewFrame.size;
    
   // [self.showedController.testView setFrame:testViewFrame];

    //-----------------------------------------------------------------------
    //change for result label
    testViewFrame.origin.y = size.height -self.showedController.stackBottomConstrain.constant-self.showedController.resultHeightConstrain.constant+5;// + labelFrame.origin.y-10.;
    testViewFrame.size.height =self.showedController.resultHeightConstrain.constant-10;
    
    CGSize resultLabelSize = testViewFrame.size;
    
    //change for descr label
    testViewFrame.origin.y = self.showedController.stackTopConstrain.constant+5;
    testViewFrame.size.height =self.showedController.descrLabelHeightConstrain.constant-10;
    CGSize descrLablelSize = testViewFrame.size;

    [self.showedController upDateStringsWithInfSize:descrLablelSize
                                           exprSize:expresionLabelSize
                                            resSize:resultLabelSize];
    //[self.showedController.testView setFrame:testViewFrame];
}

#pragma mark VIEW LAYOUT
/*
-(void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    NSLog(@"TraitCollectionDidChange");
}
-(void) willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"willTransitionToTraitCollection");
    if(self.showedController){
    if(newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact){
        self.showedController.resultHeightConstrain.constant = 80;
    } else if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
        self.showedController.resultHeightConstrain.constant = 120;
    }
    }
}
*/
//CGFloat minButtonsCollectionHeight;
CGFloat maxButtonsCollectionHeight;//COPIED
CGFloat bannerYOrigin;//COPIED

-(void)viewDidLayoutSubviews{
    if(DEBUG_MODE){
        NSLog(@"viewDidLayoutSubviews");
    }
    
    //set offset for motion effect
    CGFloat motionOffsetValue = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular ? MOTION_IPAD:MOTION_IPHONE;
    self.historyTableTrailingConstrain.constant = -motionOffsetValue;
    self.historyTableLeadingConstrain.constant = -motionOffsetValue;
    self.historyTableTopConstrain.constant = -motionOffsetValue;
    self.historyTableBottomConstrain.constant = motionOffsetValue;
    //NSLog(@"Display Top before: %f", self.displayTopConstrain.constant);
    
    CGSize viewSize = self.view.bounds.size;
    CGSize windowSize = self.view.window.bounds.size;
    if(viewSize.width != windowSize.width){
        [self.view setFrame:self.view.window.bounds];
    }
    if(!IS_IPAD){
        //UIEdgeInsets insets = UIEdgeInsetsZero;
        //insets.bottom = 0.;//-34.;
        //self.additionalSafeAreaInsets = insets;
        //self.view.insetsLayoutMarginsFromSafeArea = YES;
        
        
        //for iphone alwais short size is width (as nonrotated)
        if(viewSize.width < viewSize.height){
            self.mainContainerWidth.constant = viewSize.width;
            self.mainContainerHeight.constant = viewSize.height;
            //change safe area for iPhoneX
            if(IS_X){
                UIEdgeInsets insets = UIEdgeInsetsZero;
                insets.bottom = -34.;
                insets.top = -44.;
                self.additionalSafeAreaInsets = insets;
            }
            
            /*if(self.showedController){
                //[self callChanginShowedViewFrom:@"viewDidLayoutSubviews iPhone"];

                //CGFloat constrConst = viewSize.height- viewSize.width;
                self.showedController.containerWidthConstrain.constant = viewSize.width < viewSize.height? viewSize.height: viewSize.width;
                self.showedController.containerHeightConstrain.constant = viewSize.width < viewSize.height? viewSize.width: viewSize.height;
                CGSize newContSize = CGSizeMake(self.showedController.containerWidthConstrain.constant, self.showedController.containerHeightConstrain.constant);
                [self callChanginShowedViewWithSize:newContSize From:@"viewDidLayoutSubviews iPhone"];
            }*/
        } else {
            self.mainContainerWidth.constant = viewSize.height;
            self.mainContainerHeight.constant = viewSize.width;
            //change safe area for iPhoneX
            if(IS_X){
                if(self.showedController){
                    UIEdgeInsets insets = UIEdgeInsetsZero;
                    insets.bottom = 0.;
                    insets.top = 0.;
                    insets.left = 44.;
                    insets.right = 44.;
                    self.showedController.additionalSafeAreaInsets = insets;
                    
                } else {
                    UIEdgeInsets insets = UIEdgeInsetsZero;
                    insets.bottom = -21.;
                    insets.top = 0.;
                    insets.left = -44.;
                    insets.right = -44.;
                    self.additionalSafeAreaInsets = insets;
                }
            }
            if(self.showedController){
                
                self.showedController.containerWidthConstrain.constant =viewSize.width < viewSize.height? viewSize.height: viewSize.width;
                self.showedController.containerHeightConstrain.constant = viewSize.width < viewSize.height? viewSize.width: viewSize.height;
                CGSize newContSize = CGSizeMake(self.showedController.containerWidthConstrain.constant, self.showedController.containerHeightConstrain.constant);
                [self callChanginShowedViewWithSize:newContSize From:@"viewDidLayoutSubviews iPhone"];
                
                
            }
        }
        
        /*
        if(self.showedController){
            self.showedController.containerWidthConstrain.constant = viewSize.width < viewSize.height? viewSize.height: viewSize.width;
            self.showedController.containerHeightConstrain.constant = viewSize.width < viewSize.height? viewSize.width: viewSize.height;
        }*/
        
        //set calc screen height
        self.calcScreenHeightConstrain.constant = self.mainContainerWidth.constant*IPHONE_SCREEN_VS_WIDTH_RATIO;
        //if history table whole showed
        //how history showed can change from 1 to 0
        // need detect whole way
        
        if(IS_X){//if iPhoneX
            maxButtonsCollectionHeight = self.mainContainerWidth.constant*IPHONE_X_RATIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
        } else {
            
            maxButtonsCollectionHeight = self.mainContainerWidth.constant*IPHONE_RATIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
        }
        
        
    } else {
        
        self.mainContainerWidth.constant = windowSize.width;
        self.mainContainerHeight.constant = windowSize.height;
        
        //set calc screen height
        CGFloat minSide = self.mainContainerWidth.constant < self.mainContainerHeight.constant? self.mainContainerWidth.constant : self.mainContainerHeight.constant;
        
        //
        if(minSide*IPAD_SCREEN_VS_WIDTH_RATIO/self.mainContainerHeight.constant < 0.09){
            //if so narrow screen - fix it
            self.calcScreenHeightConstrain.constant = self.mainContainerHeight.constant*0.09;
        } else {
            self.calcScreenHeightConstrain.constant = minSide*IPAD_SCREEN_VS_WIDTH_RATIO;
        }
        
        if(self.showedController){

            self.showedController.containerWidthConstrain.constant = viewSize.width;
            self.showedController.containerHeightConstrain.constant = viewSize.height;
            
            CGSize newContSize = CGSizeMake(self.showedController.containerWidthConstrain.constant, self.showedController.containerHeightConstrain.constant);
            [self callChanginShowedViewWithSize:newContSize From:@"viewDidLayoutSubviews iPad"];
        }
        //if history table whole showed
        //how history showed can change from 1 to 0
        // need detect whole way
        //minButtonsCollectionHeight = 0;//self.calcScreenHeightConstrain.constant;
        maxButtonsCollectionHeight = self.mainContainerHeight.constant/IPAD_RAIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
        
    }
    
    //history table height
    if(self.isButtonsCollectionUnderChanging){
        //NSLog(@"sviperBottomConstrain before:%f",self.sviperBottomConstrain.constant );
        //NSLog(@"historyTableSviper hright:%f",self.historyTableSviper.frame.size.height );
        /*self.sviperBottomConstrain.constant = self.calcScreenHeightConstrain.constant/2.+ self.historyTableSviper.frame.size.height/2-self.calcScreenHeightConstrain.constant/10;*/
        self.sviperBottomConstrain.constant = -((self.calcScreenHeightConstrain.constant -self.historyTableSviper.frame.size.height)/2-self.calcScreenHeightConstrain.constant/10);

        //NSLog(@"sviperBottomConstrain after:%f",self.sviperBottomConstrain.constant );
        
    } else {
        if(self.isCalcShowed){
            self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant - maxButtonsCollectionHeight;
            
            //[self changeHowHistoryShowed:0];
            
        } else if(self.isHistoryShowed){
            self.displayTopConstrain.constant = self.mainContainerHeight.constant - self.calcScreenHeightConstrain.constant;
            //[self changeHowHistoryShowed:1];
        } else {

            [self changeHowHistoryShowed:((self.displayTopConstrain.constant+self.displayContainer.frame.size.height)-(self.mainContainerHeight.constant-maxButtonsCollectionHeight))/maxButtonsCollectionHeight];
        }
        
        self.sviperBottomConstrain.constant = -self.calcScreenHeightConstrain.constant*14./20.;
    }
    //screen buttons according interfase size
    if(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact){
        self.noticeButton.hidden = YES;
    } else {
        if(IS_IPAD && self.shareButton.hidden == NO){
            self.noticeButton.hidden = NO;
        }
    }

    //FOR BANNER CONTAINER
    //make bigger place for AD banner on iPhone X
    if(IS_X){
        self.bannerAdHeightConstrain.constant = 94.;
    }
    
    if(self.isIAdBannerOnScreen){
        self.bannerAdTopConstrain.constant =bannerYOrigin;
       if(DEBUG_MODE) NSLog(@"Banner heigth:%f, banner origin:%f",self.bannerAdTopConstrain.constant, self.bannerAdHeightConstrain.constant );
    } else {
        self.bannerAdTopConstrain.constant = -(self.bannerAdHeightConstrain.constant +10.);
    }
    //added to set buttons array
   // [self newButtonsSize];
}

#pragma mark BUTTONS SIZE CHANGE
#define BUTTON_SIDES_RATIO_IPAD 1.8
#define BUTTON_SIDES_RATIO_IPHONE 1.4
#define INSENT_BUTTONS_PART 9. //insent first row
-(void) setIsBigSizeButtons:(BOOL)isBigSizeButtons
{
    _isBigSizeButtons = isBigSizeButtons;
    //reset buttons size only when core data available
    //as exemple don't set in view didload
    /*
    if(self.buttonManagedObjectContext){
        //  [self setUpMainButtonsStartWithPosition];
        //  [self makeTwoArrays];
        //  [self.buttonsCollection reloadData];
        //[self.buttonsStore renewArraysAccordingNewButtonsSize];
        self.buttonsStore.buttonManagedObjectContext = self.buttonManagedObjectContext;
        [self newButtonsSize];
        
    }*/
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if(IS_IPAD){
        /*
        CGSize newContSize = CGSizeMake(self.showedController.containerWidthConstrain.constant, self.showedController.containerHeightConstrain.constant);
        [self callChanginShowedViewWithSize:newContSize From:@"observeValueForKeyPath iPad"];
        
       if(self.showedController){
            NSLog(@"observeValueForKeyPath ShowedController iPad");
            self.showedController.containerWidthConstrain.constant = self.view.bounds.size.width;
            self.showedController.containerHeightConstrain.constant = self.view.bounds.size.height;
        }*/

    }
    //if(![self.presentedViewController isKindOfClass:[SecondViewController class]]){
    if (object == self.buttonsCollection && [keyPath isEqualToString:@"bounds"]) {
        if([self.presentedViewController isKindOfClass:[SecondViewController class]]){
            isNeedReloadAfterOtherController = YES;
        } else {
            [self upDateButtonsCollectionAfterChanginSize];
        }
        /*
        //NSLog(@"buttonsCollectionHeight %f - ", self.buttonsCollection.bounds.size.height);
        if(self.buttonsCollection.bounds.size.width != buttonsCollectionWidth){
            buttonsCollectionWidth = self.buttonsCollection.bounds.size.width;
            lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
            //selectedRowPatch = [self.historyTable indexPathForSelectedRow];
            [self newButtonsSize];
            screenHeight = self.calcScreenHeightConstrain.constant;
            [self updateHistoryTableArraysAndGoBottom:NO];
            [self.historyTable reloadData];
            
        } else if(self.calcScreenHeightConstrain.constant!= screenHeight){
            //screenHeight = self.calcScreenHeightConstrain.constant;
            //need for iPad if changed screen height without changing buttonCollection width
            [self newButtonsSize];
            lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
            //selectedRowPatch = [self.historyTable indexPathForSelectedRow];
            screenHeight = self.calcScreenHeightConstrain.constant;
        }
        [self.designObj changeClassSize];
        */
        
        
        //[self.historyTable reloadData];
    }
    //}
}
static BOOL isNeedReloadAfterOtherController; //COPIED

-(void)upDateButtonsCollectionAfterChanginSize{
    if(DEBUG_MODE){
        NSLog(@"upDateButtonsCollectionAfterChanginSize view:%f", self.view.bounds.size.width);
        NSLog(@"upDateButtonsCollectionAfterChanginSize buttonsCollection:%f", self.mainContainerView.bounds.size.width);
        NSLog(@"upDateButtonsCollectionAfterChanginSize buttonsCollection:%f", self.mainContainerWidth.constant);
    }

    if((self.buttonsCollection.bounds.size.width != buttonsCollectionWidth) && (self.mainContainerWidth.constant!=0)){
        CGFloat width = self.view.bounds.size.width;
        //buttonsCollectionWidth = self.buttonsCollection.bounds.size.width;
        buttonsCollectionWidth = width;
        lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
        //selectedRowPatch = [self.historyTable indexPathForSelectedRow];
        [self newButtonsSize];
        screenHeight = self.calcScreenHeightConstrain.constant;
        [self updateHistoryTableArraysAndGoBottom:NO];
        [self.historyTable reloadData];
        
    } else if((self.calcScreenHeightConstrain.constant!= screenHeight)&&(self.calcScreenHeightConstrain.constant!= 0)){
        //screenHeight = self.calcScreenHeightConstrain.constant;
        //need for iPad if changed screen height without changing buttonCollection width
        [self newButtonsSize];
        lastVisibleCellPatch = [self.historyTable indexPathForCell: [self.historyTable.visibleCells lastObject]];
        //selectedRowPatch = [self.historyTable indexPathForSelectedRow];
        screenHeight = self.calcScreenHeightConstrain.constant;
    }
    [self.designObj changeClassSize];
    isNeedReloadAfterOtherController = NO;
    
}

-(void)newButtonsSize
{
    //find the minimum side for small and big button
    CGFloat buttonsRatio;
    if(IS_IPAD){
        buttonsRatio=BUTTON_SIDES_RATIO_IPAD;
    }else {
        buttonsRatio=BUTTON_SIDES_RATIO_IPHONE;
    }
    
    //qantity for big and small button
    NSInteger xQantity;
    NSInteger yQantity;
    if(self.isBigSizeButtons) {
        xQantity = 4;
        yQantity = 6;
    }else {
        xQantity = 5;
        yQantity = 7;
    }
    
    //find min side
    
    CGFloat xFindSide = self.buttonsCollection.bounds.size.width/xQantity;
    
    
    //count max button collection heigth
    //independ of how histroy showed
    CGFloat buttCollectionHeight;
    if(IS_IPAD){
        buttCollectionHeight =  self.mainContainerHeight.constant/IPAD_RAIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
    } else {
        buttCollectionHeight = self.mainContainerWidth.constant*IPHONE_RATIO_BUTTONS_VIEW - self.calcScreenHeightConstrain.constant;
    }
    CGFloat yFindSide = buttCollectionHeight/yQantity;//(buttCollectionHeight-self.displayContainer.bounds.size.height)/yQantity;
    
    //NSLog(@"buttCollectionHeight: %f, real: %f",buttCollectionHeight, self.buttonsCollectionView.bounds.size.height);
    
    //define wich side will be
    if(xFindSide<yFindSide*buttonsRatio){
        
        buttonsWidth = floor(self.buttonsCollection.bounds.size.width/xQantity);
        buttonsIntens = 0;
        
        //find buttonsHeight
        yQantity = (NSInteger) round((buttCollectionHeight- INSENT_BUTTONS_PART)/(xFindSide/buttonsRatio));//round((buttCollectionHeight-self.displayContainer.bounds.size.height- INSENT_BUTTONS_PART)/(xFindSide/buttonsRatio));
        buttonsHeight = (buttCollectionHeight-INSENT_BUTTONS_PART-(yQantity+2)*buttonsIntens)/yQantity;//(buttCollectionHeight-self.displayContainer.bounds.size.height - INSENT_BUTTONS_PART-(yQantity+2)*buttonsIntens)/yQantity;
        
    } else {
        
        buttonsHeight = (buttCollectionHeight-INSENT_BUTTONS_PART)/yQantity;//(buttCollectionHeight-self.displayContainer.bounds.size.height - INSENT_BUTTONS_PART)/yQantity;
        buttonsIntens = 0;
        
        //find buttonsHeight
        xQantity = (NSInteger) round(self.buttonsCollection.bounds.size.width/(yFindSide*buttonsRatio));
        buttonsWidth = floor((self.buttonsCollection.bounds.size.width - (xQantity+1)*buttonsIntens)/xQantity);
    }
    
    //renew buttons array
    if(self.isButtonsCollectionUnderChanging){
        [self.buttonsStore renewArraysAccordingNewButtonsSize];
    } else {
        [self.buttonsStore renewWorksButtonsArrayAfterSizeChanging];
    }
    //[self.buttonsCollection reloadData];
    
    //renew buttonsCollectionLayout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    flow.itemSize = CGSizeMake(buttonsWidth, buttonsHeight);
    flow.minimumInteritemSpacing = buttonsIntens;
    flow.minimumLineSpacing = buttonsIntens;
    
    UIEdgeInsets insets;
    insets.top = INSENT_BUTTONS_PART+ buttonsIntens;//self.displayContainer.bounds.size.height+INSENT_BUTTONS_PART+ buttonsIntens;
    insets.bottom = buttonsIntens;
    insets.left = buttonsIntens;
    insets.right = buttonsIntens;
    flow.sectionInset = insets;
    
    buttonsFlowLayout = flow;
    [self.buttonsCollection setCollectionViewLayout:buttonsFlowLayout animated:YES];
}


#pragma mark APP CONDITIONS
//only at real enter in foregraund not at launch
-(void) appWillEnterForeground
{
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateKVStoreItems:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:store];
    [store synchronize];
    
    //strange
    
    //[self.buttonsStore renewArryasAfterChanging];
   
    
    /*
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
    */
    //self.isNeedToBeReloadedAfterDesignChanged = NO;

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

-(void)applicationWillResignActive:(NSNotification *)note{
    /*if(DEBUG_MODE){
        NSLog(@"UIApplicationDidEnterBackgroundNotification");
    }*/

}

//possible enter to background, as example iTunes reques
-(void)appWillGoToBackground:(NSNotification *)note
{
    
    //if(DEBUG_MODE) NSLog(@"appWillGoToBackground");
    //if there is byttonAssubview - delete it
    if(buttonsAsSubView){
        CGRect subFrame = subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(findCell){
                             }
                             subCell.alpha = 1.;
                             [buttonsAsSubView removeFromSuperview];
                             buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                         }];
    }
    
    //save managed object context
    //[self.buttonsStore resaveCoreButtons];
    //test
    
    /*
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]; //hope it will work
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    */

    /*
    NSArray *buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
    for(Buttons *btn in buttonsFromCoreData){
        NSLog(@"Button %@ position %@",btn.nameButton, btn.position);
    }
    */
    
   // NSLog(@"appWillGoToBackground fetchedObjs count %lu",[self.fetchedResultsController.fetchedObjects count]);

    if(!self.showedController){
        NSError *error;
    //[self.managedObjectContext save:&error];
    [self.buttonManagedObjectContext save: &error];
        
     //[self.doc updateChangeCount:UIDocumentChangeDone];
    [self discardChanging];
    }

}

//really enter to background
-(void) appDidEnterBackground
{
    //if there is byttonAssubview - delete it
    if(buttonsAsSubView){
        CGRect subFrame = subCell.frame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [buttonsAsSubView setFrame:subFrame];
                             
                         } completion:^(BOOL finished) {
                             if(findCell){
                             }
                             subCell.alpha = 1.;
                             [buttonsAsSubView removeFromSuperview];
                             buttonsAsSubView = nil;
                             NSArray *array = [NSArray arrayWithObject:[self.buttonsCollection indexPathForCell:subCell]];
                             [self.buttonsCollection reloadItemsAtIndexPaths:array];
                         }];
    }
    
    if(self.isButtonsCollectionUnderChanging){
        self.isButtonsCollectionUnderChanging = NO;
        
        for(UICollectionViewCell* cell in [self.buttonsCollection visibleCells]){
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
        }
        NSError *error;
        [self.buttonManagedObjectContext save:&error];
        [self.managedObjectContext save: &error];
        //[self.doc updateChangeCount:UIDocumentChangeDone];
        //[self.buttonsStore resaveCoreButtons];
    }
    
   /* [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];*/
    
    //importand why i've made it
   // [self discardChanging];

    
    //what is this
    [self deleteSuperfluousValuesFromManagedDocuments];
    
    [self.buttonsCollection reloadData];
    
    [self saveMainProperties];

    //for work with AD banner
    self.canShowBanner = NO;
    self.isIAdBannerOnScreen = NO;
    [self hideAdBannerAnimate:NO];
    
}

-(void) appWillTerminate
{
    //[self.doc updateChangeCount:UIDocumentChangeDone];
    NSError *error;
    //[self.managedObjectContext save:&error];
    [self.buttonManagedObjectContext save: &error];

    [self saveMainProperties];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.isNeedToBeReloadedAfterDesignChanged){
        if(self.imageBackgroundView){
            CGFloat inset;
            if(IS_IPAD){
                inset = -60;
            } else {
                inset = -40;
            }
            [self.imageBackgroundView setFrame:CGRectInset(self.mainContainerView.bounds,inset, inset)];
            //[self.imageBackgroundView setFrame:CGRectInset(self.view.frame,inset, inset)];
            if(self.blackViewforPhotoBackground){
                [self.blackViewforPhotoBackground setFrame:self.imageBackgroundView.bounds];
            }
        }
        //[self wholeViewReloadAfterdesignChanged];
        self.isNeedToBeReloadedAfterDesignChanged = NO;
        //[self.buttonsCollection reloadData];
       // [self.historyTable reloadData];
       // [self initialLayoutDynamicContainerWithSize:self.view.frame.size];
    }

    
    /* exlude it because select last cell when returns from showed view
     I don't want it
     
     [self.historyTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.cellHeights count]  inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];*/
    
    ITSCalcAppDelegate* appClass = (ITSCalcAppDelegate*)[[UIApplication sharedApplication] delegate];//((AppDelegate *)
    NSDate* launchTime = appClass.launchDate;
   //NSDate* appearDate = [NSDate date];
    //if(DEBUG_MODE) NSLog(@"viewDidAppear Apperaing time %f",[[NSDate date] timeIntervalSinceDate:launchTime]);
    
    if(!IS_IPAD){
        [self rotateIPhoneAsNonRotateWithSize:self.view.bounds.size];
    }
    if(isNeedReloadAfterOtherController){
            //[self.view updateConstraints];
            [self upDateButtonsCollectionAfterChanginSize];
    }
    
    self.view.alpha = 1.;

    
}

-(void) viewWillAppear:(BOOL)animated{
    
   if(DEBUG_MODE) NSLog(@"MainView Will appear");
    if(self.isSoundOn){
        AudioServicesPlaySystemSound (_blankSoundFileObject);
    }
    self.callShowController = NO;
    
    
    
    //remove notification observer for settings changes
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReciveChangedNotification object:nil];
    [super viewWillAppear:animated];
    
}

-(void) wholeViewReloadAfterdesignChanged
{
    //[self initialLayoutDynamiccontainer];
    self.labelsDisplayContainer.alpha =  1;
    self.settingsButton.alpha =0;

    if(IS_IPAD){
        self.noticeButton.alpha = 0.;
    }
    self.plusButton.alpha = 0;
    self.recountButton.alpha = 0;
    self.deleteButton.alpha = 0;
    [self.buttonsCollection reloadData];
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

//#pragma mark SHOW OTHER CONTROLLERS

//#pragma mark SETTINGS VIEW CONTROLLER

//recived notification from settingsViewcontroller
#pragma mark NOTIFICATION
-(void) recivedNotification:(NSNotification*)notification
{
    NSArray *keys = notification.userInfo.allKeys;
    if(keys.count && (keys.count < 2) && [keys[0] isKindOfClass:[NSString class]]){
        //NSLog(@"Ok recived notification %@ for key %@", [notification.userInfo objectForKey:keys[0]], keys[0]);
        NSString *key = keys[0];
        if([key isEqualToString:@"isBigSizeButtons"]){
            
            self.isBigSizeButtons = [[notification.userInfo objectForKey:keys[0]] boolValue];//self.isBigSizeButtons = [[notification.userInfo objectForKey:keys[0]] boolValue];
            [self newButtonsSize];
            
        } else if([key isEqualToString:@"isSoundOn"]){
            
            self.isSoundOn = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if([key isEqualToString:@"isBigDataBase"]){
            
            self.isBigDataBase = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } /*else if([key isEqualToString:@"isiCloudInUse"]){
            
            self.isiCloudInUse = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        }*/ else if([key isEqualToString:@"wasPurshaised"]){
            
            self.wasPurshaised = [[notification.userInfo objectForKey:keys[0]] boolValue];
            
        } else if ([key isEqualToString:@"setKeyboardDefaultAction"]){
            if([[notification.userInfo objectForKey:keys[0]] boolValue]){
                [self.buttonsStore setButtonsByDefault];
                
                //[self.buttonsStore changeContext:self.buttonManagedObjectContext];
                //[self setUpArrays];
                //[self.doc updateChangeCount:UIDocumentChangeDone];
                //[self.buttonsCollection reloadData];
                NSError *error;
                //[self.managedObjectContext save:&error];
                [self.buttonManagedObjectContext save: &error];

            }
            
        } else if ([key isEqualToString:@"cleanHistoryArchive"]){
            if([[notification.userInfo objectForKey:keys[0]] boolValue]){
                
                [History clearContext:self.managedObjectContext];
                //NSArray *newHeightsOfRows = [[NSArray alloc] init];
                //self.heightsOfRows = newHeightsOfRows;
                [self performFetch];
            }
            
        } else if ([key isEqualToString:@"ChangedDesign"]){
           // if(DEBUG_MODE) NSLog(@"Design changed to: %ld", (long)[[notification.userInfo objectForKey:keys[0]] integerValue]);
            self.designObj.designNumber = [[notification.userInfo objectForKey:keys[0]] integerValue];
            //IMPORTANT NEED TO RELOAD ALL VIEWS
            [self.view setNeedsDisplay];
            
        } else {
            if(DEBUG_MODE) NSLog(@"Not find right key");
        }
    } else {
        if(DEBUG_MODE) NSLog(@"recived wrong notification");
    }
}

-(void) showSettingsViewcontroller
{
    if(!self.settingsController){
        self.showControllerIsForward = NO;
        self.callShowController = NO;
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingsViewController *settingsVC = [storyBoard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        self.settingsController = settingsVC;
    }

    
    //set all properties
    self.settingsController.designObj = self.designObj;
    //self.settingsController.isiCloudInUse = self.isiCloudInUse;;
    self.settingsController.isBigDataBase = self.isBigDataBase; //size dataBase
    self.settingsController.isSoundOn = self.isSoundOn;
    self.settingsController.isBigSizeButtons = self.isBigSizeButtons;
    self.settingsController.isTrialPeriod = self.isTrialPeriod;
    self.settingsController.wasPurshaised = self.wasPurshaised;
    //self.settingsController.isiCloudUseSwitcherEnabled = self.isiCloudUseSwitcherEnabled;
    self.settingsController.designObj = self.designObj;

    //settingsController.isTrialPeriod = self.isTrialPeriod;
    //settingsController.wasPurshaised = self.wasPurshaised;
   // settingsController.isiCloudUseSwitcherEnabled = self.isiCloudUseSwitcherEnabled;

    self.settingsController.transitioningDelegate = self;
    //recive notification from other controllers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:ReciveChangedNotification object:nil];
    [self presentViewController:self.settingsController animated:YES completion:^{
        [self discardChanging];
    }];
    
}

#pragma mark SHOW VIEW CONTROLLER
/*
-(void) showShowedView
{
    //NSLog(@"ATTR str fro show: %@", self.strAtrrForShow.string);
    ShowedViewController *show = [[ShowedViewController alloc] init];
   // NSLog(@"Showed srt before %@",self.resStringForShow.string);
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
*/
#pragma mark PREAPERE STRINGS
/*
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
            [self lastRowUpdate];
            atrStrFromString = [self.lastRowsString mutableCopy];//[self getAttributedStringFromArray:self.lastRowDataArray];
        } else {
            atrStrFromString=  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        }
        if(atrStrFromString.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                
                NSString *lastSymbol = [atrStrFromString.string substringWithRange:NSMakeRange(atrStrFromString.string.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    [atrStrFromString insertAttributedString:self.mainLabel.attributedText atIndex:atrStrFromString.length];
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
 
            NSLog(@"in Loop needRect: %f,%f,%f,%f",
                  neededRect.origin.x,
                  neededRect.origin.y,
                  neededRect.size.width,
                  neededRect.size.height);
 
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
*/
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

/*
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
*/

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
    /*
    if([SKPaymentQueue canMakePayments]) {
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kInAppPurchaseProductID]];
        request.delegate = self;
        
        [request start];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: MainControllerNotAvailableForBuingNotification object:nil];

    }
    */

}

#pragma mark APPEARED CONTROLLER DELEGATE
-(void) appearedControllerDidCloseWithString:(NSString *)returnString
{
    /*
    if([returnString isEqualToString:@"BUY"]){
        NSLog(@"Buy command from about view");
        //show buy allert
        [self buyAdditionsButtonTapped:nil];
        
    } else if ([returnString isEqualToString:@"CONTINUE"]){ //if continue trial period
        NSLog(@"Jus continue fronm about view");
    } else */if ([returnString isEqualToString:@"CLOSE"]){ //if work without addition after trial period is finished
        [self endsOfTrialPeriod];
    }
    
    
}

-(void) endsOfTrialPeriod
{
    if(DEBUG_MODE) NSLog(@"endsOfTrialPeriod Finish trial period from about view");
    self.isTrialPeriod = NO;
    //set settings view for change button
    //Important:
    //1. need to reset buttons array
    //2. need to reset all views
}




#pragma mark SET PROPERTIES
//default properties keys
#define PROG_PROPERTIES_KEY @"programmPropertiesArray"
#define OLD_KEY_VALUES_KEY @"keyValuesArrayLast"
#define OLD_WHOLE_PROG_KEY @"wholeArray"
//define keys for default properies
//prog condition for iCloud
//#define TRIAL_PERIOD @"isTrialPeriod" //17
//#define NEXT_TRIAL_ALLERT_DATE @"nexNeedShovewTrialViewDay"//18
//#define START_TRIAL_DATE @"startTrialDate"//19
//#define WAS_BUYED @"wasPurshaised"

//main properties


#define DISP_FIRST_MEM @"firstMemoryStack"//1
#define DISP_SEC_MEM @"secondMemoryStack"//2
#define DISP_GRAD   @"secondMemoryStack"//3
#define DISP_RESULT @"resultNumber"//4
#define BRAIN @"brainFromDefaults"//5
#define RES_FROM_MEMORY @"isResultFromMemory"//6
#define DEC_RAD @"isDecCounting"//7
#define STRONG_ARGUMENT @"isStronglyArgu"//8
#define PROG_IN_PROCESS @"isProgramInProcess"//9
#define USER_ENTERING @"userIsInTheMidleOfEnteringNumber"//10
#define LAST_ROW @"lastRowDataArray"//11

#define ALLERT_VIEW_COUNTER @"counterForShowingAllertView"//12
#define SOUND_SWITCH_POSITION @"isSoundOn"//13
#define BUTTONS_SIZE @"isBigSizeButtons"//14
#define SIZE_DATA_BASE @"isBigDataBase"//15 data base sixe
#define DATE_LAST_ALLERT @"lastShowAllertViewDate"//16 date of last showing allert view

#define PROG_VERSION @"currentProgrammVersion"//20
#define DESIGN_NUMBER   @"designNumber"//21
#define INFO_STRINGS @"InfoStringsArray"//22 info histroy strings array
#define MAIN_STRINGS @"MainStringsArray"//23 main history strings archived
#define CELL_HEIGHTS @"CellHeightsArray"//24 history cell's heights array arhived
#define BUTTON_NAMES @"WorkButtonNames" //25 work button names array archived

#define TRIAL_DATE @"startTrialDate"
#define NEXT_SHOW_TRIAL_DATE @"nexNeedShovewTrialViewDay"
#define IS_TRIAL @"isTrialPeriod"
#define WAS_BUYED @"userHaveMadePurchase"

#define SAVE_HISTORY_QNTITY 10

-(void)setMainProperties{
    //1. chek and delete old keyValuesArray
    [self checkAndDeleteOldKeyValuesArray];
    //2. if no new version check old versions
    [self checkAndSetPropertiesFromUserDefaultOrDefaultValues];
    //3. if no old and new versions set valuess by default
}
-(void) saveMainProperties{
    [self saveUserDefaults];
    [self saveKVStoreItems];
}
-(void)checkAndSetPropertiesFromUserDefaultOrDefaultValues{
    if(DEBUG_MODE) NSLog(@"checkAndSetPropertiesFromUserDefaultOrDefaultValues");
    
    //------------------- from keyValuesArrayLast--------------------------------------
    id valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DISP_RESULT];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.displayRam.resultNumber = valueForKey;
    } else {
        [self.displayRam clearRam];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DISP_GRAD];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSArray class]]){
        self.displayRam.gradArray = valueForKey;
    } else {
        self.displayRam.gradArray  = [NSArray array];
        self.displayRam.isGradMinutesSecons = 0;
        self.displayRam.resDictionary = nil;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DISP_SEC_MEM];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSArray class]]){
        self.displayRam.secondMemoryStack = valueForKey;
        //set the memory mark
        NSArray* test = [valueForKey copy];
        if([test count] > 0) {
            self.memoryTwoLabel.text = @"MI";
        } else {
            self.memoryTwoLabel.text = @"";
        }
    } else {
        self.memoryTwoLabel.text = @"";//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DISP_FIRST_MEM];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSArray class]]){
        self.displayRam.firstMemoryStack = valueForKey;
        //set the memory mark
        NSArray* test = [valueForKey copy];
        if([test count] > 0) {
            self.memoryOneLabel.text = @"M";
        } else {
            self.memoryOneLabel.text = @"";
        }
    } else {
        self.memoryOneLabel.text = @"";//to key value
    }
    [self.mainLabel showString:[self.displayRam setResult:self.displayRam.resultNumber]];

    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:BRAIN];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSArray class]]){
        self.brain = [ACalcBrain brainFromSavedArray:valueForKey];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:RES_FROM_MEMORY];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isResultFromMemory = [valueForKey boolValue];
    } else {
        self.isResultFromMemory = NO;//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DEC_RAD];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isDecCounting = [valueForKey boolValue];
    } else {
        self.isDecCounting = YES;//to key value
        self.decLabel.text = @"DEG";//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:STRONG_ARGUMENT];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isStronglyArgu = [valueForKey boolValue];
    } else {
        self.isStronglyArgu = NO;//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:PROG_IN_PROCESS];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isProgramInProcess = [valueForKey boolValue];
    } else {
        self.isProgramInProcess = NO;//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ENTERING];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.userIsInTheMidleOfEnteringNumber = [valueForKey boolValue];
    } else {
        self.userIsInTheMidleOfEnteringNumber = YES;//to key value
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_ROW];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSArray class]]){
        self.lastRowDataArray = valueForKey;
    } else {
        self.lastRowDataArray = nil;
    }
    //--------------------------------from old wholeArray---------------------------------------------
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:ALLERT_VIEW_COUNTER];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.counterForShowingAllertView= [valueForKey integerValue];
    } else {
        self.counterForShowingAllertView = 26;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:SOUND_SWITCH_POSITION];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isSoundOn = [valueForKey boolValue];
    } else {
        self.isSoundOn = YES;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:BUTTONS_SIZE];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isBigSizeButtons = [valueForKey boolValue];
    } else {
         self.isBigSizeButtons = YES;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:SIZE_DATA_BASE];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.isBigDataBase = [valueForKey boolValue];
    } else {
        self.isBigDataBase = NO;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_LAST_ALLERT];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSDate class]]){
        self.lastShowAllertViewDate = valueForKey;
    } else {
        self.lastShowAllertViewDate = [NSDate date];
    }
    
    //---------------------------- new features------------------------------------------------------
    
    //-----Trial Period--------------------------------------------------------------------
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:TRIAL_DATE];
    if(valueForKey && [valueForKey isKindOfClass:[NSDate class]]){
        self.startTrialDate = valueForKey;
    } else {
        self.startTrialDate = [NSDate date];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:NEXT_SHOW_TRIAL_DATE];
    if(valueForKey && [valueForKey isKindOfClass:[NSNumber class]]){
        self.nexNeedShovewTrialViewDay = [valueForKey integerValue];
    }else{
        self.nexNeedShovewTrialViewDay = 20;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:IS_TRIAL];
    if(valueForKey && [valueForKey isKindOfClass:[NSNumber class]]){
        self.isTrialPeriod = [valueForKey boolValue];
    } else {
        self.isTrialPeriod = YES;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:WAS_BUYED];
    if(valueForKey && [valueForKey isKindOfClass:[NSNumber class]]){
        self.wasPurshaised = [valueForKey boolValue];
    } else {
        self.wasPurshaised = NO;
    }
    //-------------------------------------------------------------------------
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:PROG_VERSION];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSString class]]){
        self.currentProgrammVersion= valueForKey;
        //check for new version
        NSString *realVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
    } else {
        self.currentProgrammVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:DESIGN_NUMBER];
    if(valueForKey &&  [valueForKey isKindOfClass:[NSNumber class]]){
        self.designObj = [[DesignObject alloc] initWithDesignIndex:[valueForKey integerValue] forDelegator:self];
    } else {
        self.designObj = [[DesignObject alloc] initWithDesignIndex:DESIGN_CLASSIC forDelegator:self];
    }

    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:INFO_STRINGS];
    if(valueForKey && [valueForKey isKindOfClass:[NSData class]]){
        self.infoAttributedStrings =  [NSKeyedUnarchiver unarchiveObjectWithData:valueForKey];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:MAIN_STRINGS];
    if(valueForKey && [valueForKey isKindOfClass:[NSData class]]){
        self.mainAttributedStrings =  [NSKeyedUnarchiver unarchiveObjectWithData:valueForKey];
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:CELL_HEIGHTS];
    if(valueForKey && [valueForKey isKindOfClass:[NSArray class]]){
        self.cellHeights = valueForKey;
    }
    
    valueForKey = [[NSUserDefaults standardUserDefaults] objectForKey:BUTTON_NAMES];
    if(valueForKey && [valueForKey isKindOfClass:[NSData class]]){
        self.buttonsStore.workButtonsNames = [NSKeyedUnarchiver unarchiveObjectWithData:valueForKey];
    }
    
    //not shure that its necessary BUT need to check
    [self.mainLabel showString:[self.displayRam setResult:self.displayRam.resultNumber]];
}

#pragma mark OLD USER DEFAULTS
-(void)checkAndDeleteOldKeyValuesArray{
    if(DEBUG_MODE) NSLog(@"checkAndDeleteOldKeyValuesArray");
    id userDefault;
    //check keyValuesArray
    userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:OLD_KEY_VALUES_KEY];
    if(userDefault && [userDefault isKindOfClass:[NSArray class]]){
        NSMutableArray *wholeArray = [userDefault mutableCopy];
        //extract disaply
        id displayRamArray = [[wholeArray lastObject] mutableCopy];
        if(displayRamArray && [displayRamArray isKindOfClass:[NSArray class]]){
            id top = [displayRamArray lastObject];
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:DISP_RESULT];
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSArray class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:DISP_GRAD];
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSArray class]]){
                 [[NSUserDefaults standardUserDefaults] setObject:top forKey:DISP_SEC_MEM];
                [displayRamArray removeLastObject];
                top = [displayRamArray lastObject];
            }
            if(top && [top isKindOfClass:[NSArray class]]){
                 [[NSUserDefaults standardUserDefaults] setObject:top forKey:DISP_FIRST_MEM];
            }
            [wholeArray removeLastObject];
        }
        //set brain
        id brainArray = [wholeArray lastObject];
        if(brainArray && [brainArray isKindOfClass:[NSArray class]]){
            [[NSUserDefaults standardUserDefaults] setObject:brainArray forKey:BRAIN];
            [wholeArray removeLastObject];
        }
        
        //set controller
        id controllerArray = [[wholeArray lastObject] mutableCopy];
        if(controllerArray && [controllerArray isKindOfClass:[NSMutableArray class]]){
            id top = [controllerArray lastObject];
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:RES_FROM_MEMORY];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:DEC_RAD];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:STRONG_ARGUMENT];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:PROG_IN_PROCESS];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:USER_ENTERING];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSArray class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:LAST_ROW];
            }
        }
        //clear keyValuesArray defaults
        [[NSUserDefaults  standardUserDefaults] removeObjectForKey:OLD_KEY_VALUES_KEY];
        if(DEBUG_MODE) NSLog(@"checkAndDeleteOldKeyValuesArray removeObjectForKey OLD_KEY_VALUES_KEY");
    }
    //-------------------------------------------------------------------------------------
    userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:OLD_WHOLE_PROG_KEY];
    if(userDefault && [userDefault isKindOfClass:[NSArray class]]){
        NSMutableArray *wholeArray = [userDefault mutableCopy];
        //set controller
        id controllerArray = [[wholeArray lastObject] mutableCopy];
        if(controllerArray && [controllerArray isKindOfClass:[NSMutableArray class]]){
            id top = [controllerArray lastObject];
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:ALLERT_VIEW_COUNTER];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:SOUND_SWITCH_POSITION];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:BUTTONS_SIZE];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSNumber class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:SIZE_DATA_BASE];
                [controllerArray removeLastObject];
                top = [controllerArray lastObject];
            }
            
            if(top && [top isKindOfClass:[NSDate class]]){
                [[NSUserDefaults standardUserDefaults] setObject:top forKey:DATE_LAST_ALLERT];
                self.lastShowAllertViewDate = top;
            }
        }
         [[NSUserDefaults  standardUserDefaults] removeObjectForKey:OLD_WHOLE_PROG_KEY];
        if(DEBUG_MODE) NSLog(@"checkAndDeleteOldKeyValuesArray removeObjectForKey OLD_WHOLE_PROG_KEY");
    }
}

-(void)saveUserDefaults{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.displayRam.resultNumber forKey:DISP_RESULT];//1
    [defaults setObject:self.displayRam.gradArray forKey:DISP_GRAD];//2
    [defaults setObject:self.displayRam.secondMemoryStack forKey:DISP_SEC_MEM];//3
    [defaults setObject:self.displayRam.firstMemoryStack forKey:DISP_FIRST_MEM];//4
    [defaults setObject:[self.brain arrayToSaveBrain] forKey:BRAIN];//5
    [defaults setObject:[NSNumber numberWithBool:self.isResultFromMemory] forKey:RES_FROM_MEMORY];//6
    [defaults setObject:[NSNumber numberWithBool:self.isDecCounting] forKey:DEC_RAD];//7
    [defaults setObject:[NSNumber numberWithBool:self.isStronglyArgu] forKey:STRONG_ARGUMENT];//8
    [defaults setObject:[NSNumber numberWithBool:self.isProgramInProcess] forKey:PROG_IN_PROCESS];//9
    [defaults setObject:[NSNumber numberWithBool:self.userIsInTheMidleOfEnteringNumber] forKey:USER_ENTERING];//10
    [defaults setObject:self.lastRowDataArray forKey:LAST_ROW];//11
    
    [defaults setObject:[NSNumber numberWithBool:self.isSoundOn] forKey:SOUND_SWITCH_POSITION];//13
    [defaults setObject:[NSNumber numberWithBool:self.isBigSizeButtons] forKey:BUTTONS_SIZE];//14
    [defaults setObject:[NSNumber numberWithBool:self.isBigDataBase] forKey:SIZE_DATA_BASE];//15
    [defaults setObject:self.lastShowAllertViewDate forKey:DATE_LAST_ALLERT];//16 - to Key Value Storage
    
    [defaults setObject:[NSNumber numberWithInteger:self.counterForShowingAllertView] forKey:ALLERT_VIEW_COUNTER];//12 - to Key Value Storage
    //---------------------------- new features------------------------------------------
    [defaults setObject:self.startTrialDate forKey:TRIAL_DATE];//17 - to Key Value Storage
    [defaults setObject:[NSNumber numberWithInteger:self.nexNeedShovewTrialViewDay] forKey:NEXT_SHOW_TRIAL_DATE];//18 - to Key Value Storage
    [defaults setObject:[NSNumber numberWithBool:self.isTrialPeriod]  forKey:IS_TRIAL];//19 - to Key Value Storage
    [defaults setObject:[NSNumber numberWithBool:self.wasPurshaised]  forKey:WAS_BUYED];//26 - to Key Value Storage
    
    [defaults setObject:self.currentProgrammVersion forKey:PROG_VERSION];//20
    [defaults setObject:[NSNumber numberWithInteger:self.designObj.designNumber] forKey:DESIGN_NUMBER];//21
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self returnOnlyMinQntity:SAVE_HISTORY_QNTITY fromArray:self.infoAttributedStrings]] forKey:INFO_STRINGS];//22
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self returnOnlyMinQntity:SAVE_HISTORY_QNTITY fromArray:self.mainAttributedStrings]] forKey:MAIN_STRINGS];//23
    [defaults setObject:self.cellHeights forKey:CELL_HEIGHTS];//24
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.buttonsStore.workButtonsNames] forKey:BUTTON_NAMES];//25
    
    [defaults synchronize];
    //NSLog(@"Sound default saved: %@", [defaults objectForKey:SOUND_SWITCH_POSITION]);
    
}

#pragma mark KEY VALUE STORAGE
#pragma mark updateKVStoreItems

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
            
            if([key isEqualToString:DATE_LAST_ALLERT] && value &&  [value isKindOfClass:[NSDate class]]) self.lastShowAllertViewDate = value;
            if([key isEqualToString:TRIAL_DATE] && value &&  [value isKindOfClass:[NSDate class]]) self.startTrialDate = value;
            if([key isEqualToString:NEXT_SHOW_TRIAL_DATE] && value &&  [value isKindOfClass:[NSNumber class]]) self.nexNeedShovewTrialViewDay = [value integerValue];
            if([key isEqualToString:IS_TRIAL] && value &&  [value isKindOfClass:[NSNumber class]]) self.isTrialPeriod = [value boolValue];
            if([key isEqualToString:WAS_BUYED] && value &&  [value isKindOfClass:[NSNumber class]]) self.wasPurshaised = [value boolValue];
        }
    }
}
-(void)saveKVStoreItems{
    NSUbiquitousKeyValueStore *kvStore = [NSUbiquitousKeyValueStore defaultStore];
    [kvStore setObject:self.lastShowAllertViewDate forKey:DATE_LAST_ALLERT];//16 - to Key Value Storage
    
    [kvStore setObject:[NSNumber numberWithInteger:self.counterForShowingAllertView] forKey:ALLERT_VIEW_COUNTER];//12 - to Key Value Storage
    //---------------------------- new features------------------------------------------
    [kvStore setObject:self.startTrialDate forKey:TRIAL_DATE];//17 - to Key Value Storage
    [kvStore setObject:[NSNumber numberWithInteger:self.nexNeedShovewTrialViewDay] forKey:NEXT_SHOW_TRIAL_DATE];//18 - to Key Value Storage
    [kvStore setObject:[NSNumber numberWithBool:self.isTrialPeriod]  forKey:IS_TRIAL];//19 - to Key Value Storage
    [kvStore setObject:[NSNumber numberWithBool:self.wasPurshaised]  forKey:WAS_BUYED];//26 - to Key Value Storage
    [kvStore synchronize];
}

-(NSArray*)returnOnlyMinQntity:(NSInteger)qnt fromArray:(NSArray*)arr{
    NSArray* retArray;
    //save only ten history cells heights
    if([arr count]>SAVE_HISTORY_QNTITY){
        retArray =[arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([arr count]-SAVE_HISTORY_QNTITY, SAVE_HISTORY_QNTITY)]];
    } else {
        retArray = arr;
    }
    return retArray;
}

/*
-(NSArray*) arrayToUserDefault
{
    NSMutableArray *wholeArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    
    [controllerArray addObject:[NSKeyedArchiver archivedDataWithRootObject:self.buttonsStore.workButtonsNames]]; //BUTTON_NAMES
    
    [controllerArray addObject:[self returnOnlyMinQntity:SAVE_HISTORY_QNTITY fromArray:self.cellHeights]]; //CELL_HEIGHTS
    [controllerArray addObject:[NSKeyedArchiver archivedDataWithRootObject:[self returnOnlyMinQntity:SAVE_HISTORY_QNTITY fromArray:self.mainAttributedStrings]]];//MAIN_STRINGS
    [controllerArray addObject:[NSKeyedArchiver archivedDataWithRootObject:[self returnOnlyMinQntity:SAVE_HISTORY_QNTITY fromArray:self.infoAttributedStrings]]];//INFO_STRINGS

    [controllerArray addObject:self.lastShowAllertViewDate]; //DATE_LAST_ALLERT
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigDataBase]];//SIZE_DATA_BASE
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigSizeButtons]];//BUTTONS_SIZE
    [controllerArray addObject:[NSNumber numberWithBool:self.isSoundOn]];//SOUND_SWITCH_POSITION
    [controllerArray addObject:[NSNumber numberWithInteger:self.designObj.designNumber]];//DESIGN_NUMBER
    [controllerArray addObject: self.currentProgrammVersion];//PROG_VERSION
    [controllerArray addObject:[NSNumber numberWithInteger:self.counterForShowingAllertView]];//ALLERT_VIEW_COUNTER
    
    
    [wholeArray addObject:[controllerArray copy]];
    
    return [wholeArray copy];
}
*/


- (void)didReceiveMemoryWarning
{

    //[self.doc updateChangeCount:UIDocumentChangeDone];
    NSError *error;
    //[self.managedObjectContext save:&error];
    [self.buttonManagedObjectContext save: &error];

    [self saveMainProperties];
    
    [super didReceiveMemoryWarning];
}




#pragma SHOW CONTROLLER TRANSITION
static NSAttributedString* infoStrForShowcontroller;
static NSAttributedString* mainStrForShowcontroller;
static NSAttributedString* resultStrForShowcontroller;

-(void) showSowedViewController{
    
    if(!self.showedController){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShowedViewController *showedVC = [storyBoard instantiateViewControllerWithIdentifier:@"ShowedViewController"];
        self.showedController = showedVC;
        self.showedController.transitioningDelegate = self;
        self.showedController.design = self.designObj;
        self.showedController.wasOrient = [UIDevice currentDevice].orientation;
        //set string for showed view
        //0. set empty strings
        NSAttributedString *info = [[NSAttributedString alloc] initWithString:@""];
    NSAttributedString *expression = [[NSAttributedString alloc] initWithString:@" "];
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@" "];

        //1. find selected string patch

         if([self.historyTable numberOfRowsInSection: 0] >0){
             [self.showedController setNeedStrings:infoStrForShowcontroller
                                                  expStr:mainStrForShowcontroller
                                            andRes:resultStrForShowcontroller];
         } else {
            [self.showedController setNeedStrings:info
                                            expStr:expression
                                           andRes:result];
         }


        [self presentViewController:self.showedController animated:YES completion:nil];
    }

}

#pragma mark PREAPERE STRINGS SHOWING CONTROLLER
-(void)getStringsForShowedControllerForCell:(NSIndexPath*)patch{
    
    NSInteger numberOfRowsInSection = [self.historyTable numberOfRowsInSection: 0];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableAttributedString* info;
        NSMutableAttributedString* main;
        NSMutableAttributedString* result;
    
        NSIndexPath* selPatch = patch;
        if(!patch) {
            selPatch = [NSIndexPath indexPathForRow:numberOfRowsInSection-1  inSection:0];
        }

        ACalcBrain *copyBrain;
        NSArray *copyProg;
        NSArray *copyArgu;
        int copyOpenBractets;
        BOOL copyIsArguStrongly;
        NSArray *copyProgForInf;
    
        if(selPatch.row == numberOfRowsInSection - 1){
            //get last argument from screen
            copyProg = [ACalcBrain deepArrayCopy:self.brain.programStacks];
            copyArgu = [ACalcBrain deepArrayCopy:self.brain.argu];
            copyOpenBractets = self.brain.openBracets;
            copyIsArguStrongly = self.brain.isStronglyArgu;
        
            copyBrain = [ACalcBrain initWithProgram:copyProg
                                           withArgu:copyArgu
                                    withOpenBracets:copyOpenBractets
                                  andIsStrongluArgu:copyIsArguStrongly];
        
            if(self.userIsInTheMidleOfEnteringNumber){
                [self pushWithBrain:copyBrain];
                copyBrain.isStronglyArgu = YES;
            } else if (self.isResultFromMemory){
                [self pushWithBrain:copyBrain];
                copyBrain.isStronglyArgu = YES;
            }

            copyProgForInf = self.lastRowDataArray;
        } else {
            History *story = [self.fetchedResultsController objectAtIndexPath:selPatch];
            NSMutableArray *programFromHistory = [[NSKeyedUnarchiver unarchiveObjectWithData:story.program] mutableCopy];
            copyProgForInf = [programFromHistory copy];
        
            if([programFromHistory lastObject])[programFromHistory removeLastObject];
            id top = [programFromHistory lastObject];
            //remove result from pprogramm array!
            [programFromHistory removeLastObject];
            if(top){
                copyArgu = [ACalcBrain deepArrayCopy:top];
            }
            top = [programFromHistory lastObject];
            if(top) copyProg = [ACalcBrain deepArrayCopy:top];
            copyOpenBractets = 0;
            copyIsArguStrongly = YES;
        
            copyBrain = [ACalcBrain initWithProgram:copyProg
                                           withArgu:copyArgu
                                    withOpenBracets:copyOpenBractets
                                  andIsStrongluArgu:copyIsArguStrongly];
        }
        //1. find description string
        if(!copyBrain.isStronglyArgu){
            [copyBrain deleteLastElement];
        }
        while(copyBrain.isOpenBracets){
            [copyBrain count];
            [copyBrain insertBracket:NO];
        }
    
        NSMutableArray * muttableLastProgArray = [[NSMutableArray alloc] initWithObjects:[copyBrain.deepProgram copy],[copyBrain.deepArgu copy],@" =",nil];
    
        main = [[self getAttributedStringFromArray:[muttableLastProgArray copy]] mutableCopy];
        info = [[self getAttrInfStringFromProg:copyProgForInf and:nil] mutableCopy];
    
        //3 get result
        NSNumber* resultNumber = [NSNumber numberWithDouble:[copyBrain count]];
        if(resultNumber){
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setExponentSymbol:@"e"];
            [numberFormatter setZeroSymbol:@"0"];
            if (fabs([resultNumber doubleValue])>9e9 || fabs([resultNumber doubleValue])<9e-9) {
                [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
                [numberFormatter setMaximumFractionDigits:7];
            }else{
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                double intPartLenght = log10(fabs([resultNumber doubleValue]));
                double intPart;//fractPart,
                modf(intPartLenght, &intPart);// fractPart =
                if(intPart <0) intPart = 0;
                [numberFormatter setMaximumFractionDigits:(9 - (int)intPart)];
            }
            result = [[[NSAttributedString alloc] initWithString:[numberFormatter stringFromNumber:resultNumber] attributes:self.designObj.atrforHistoryTable] mutableCopy];
        }
        
        //NSLog(@"inf attr %@",self.design.attributesInfo );
        
        [info beginEditing];
        if([info length]>0 && self.designObj.attributesInfo){
            [info addAttributes:self.designObj.attributesInfo range:NSMakeRange(0, [info length])];
        }
        [info endEditing];

        [main beginEditing];
        //NSLog(@"Epl attr %@",self.design.attributesExpl );
        
        if([main length]>0 && self.designObj.attributesExpl){
            [main addAttributes:self.designObj.attributesExpl range:NSMakeRange(0, [main length])];
        }
        [main endEditing];

        [result beginEditing];
        //NSLog(@"Res attr %@",self.design.attributesResult );
        if([result length]>0 && self.designObj.attributesResult){
            [result addAttributes:self.designObj.attributesResult range:NSMakeRange(0, [result length])];
        }
        [result endEditing];

        dispatch_async(dispatch_get_main_queue(), ^{
            infoStrForShowcontroller = [info copy];
            mainStrForShowcontroller = [main copy];
            resultStrForShowcontroller = [result copy];
        
        });
    });
}

/*
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
        ///
        CGRect bannerFrame = self.bannerContainerView.frame;
        bannerFrame.size.width = size.width;
        bannerFrame.size.height = bannerHeight;
        
        [self.bannerContainerView setFrame:bannerFrame];
        [self.iAdBanner setFrame:self.bannerContainerView.bounds];
        ///
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
    //[self setUpMainButtonsStartWithPosition];//ipad
    //[self makeTwoArrays];//ipad
    //[self.buttonsCollection reloadData];//ipad
    //[self changeLayoutDynamicContainerWithSize:size];//ipad
    
    if([self.presentedViewController isKindOfClass:[SecondViewController class]]){
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
        [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];

        
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

        //NSLog(@"Main viewWillTransitionToSize");
        
        ///
        if(!self.wasPurshaised){
            
            CGRect bannerFrame = self.bannerContainerView.frame;
            bannerFrame.size.width = size.width;
            bannerFrame.size.height = bannerHeight;
            
            [self.bannerContainerView setFrame:bannerFrame];
            [self.iAdBanner setFrame:self.bannerContainerView.bounds];
        }
         ///
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

            [self.view setFrame:CGRectMake(0,0, height, width)];
            
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
                [self.view setFrame:CGRectMake(0,0, height, width)];
                
                [self.showedController.cView setTransform:CGAffineTransformMakeRotation(angle)];
                [self.showedController.cView setFrame:CGRectMake(0,0, height, width)];
                
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView setAnimationsEnabled:YES];
                 //   [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
                if(!self.isButtonsCollectionUnderChanging){
                    if(self.isNeedToBeReloadedAfterDesignChanged){
                        
                        self.isNeedToBeReloadedAfterDesignChanged = NO;
                        //[self.buttonsCollection reloadData];
                        //[self.historyTable reloadData];
                        [self wholeViewReloadAfterdesignChanged];
                        [self initialLayoutDynamicContainerWithSize:size];
                        ///
                        if(self.imageBackgroundView){
                            CGFloat inset;
                            if(IS_IPAD){
                                inset = -60;
                            } else {
                                inset = -40;
                            }
                            [self.imageBackgroundView setFrame:CGRectInset(self.mainContainerView.bounds,inset, inset)];
                            //[self.imageBackgroundView setFrame:CGRectInset(self.view.frame,inset, inset)];
                            if(self.blackViewforPhotoBackground){
                                [self.blackViewforPhotoBackground setFrame:self.imageBackgroundView.bounds];
                            }
                        }
                        ///
                    }
                    //[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                    self.callShowController = needCallcontroller;
                }

            });
        }
}

*/

#pragma mark SHOWING IAd BANNER

-(void)appearAdBanner{
    [self moveAdBanner];
    self.isIAdBannerOnScreen = YES;
}
-(void)hideAdBannerAnimate:(BOOL)animate{
    self.bannerAdTopConstrain.constant = -(self.bannerAdHeightConstrain.constant + 10.);
    if(animate){
        [UIView animateWithDuration:0.8 animations:^{
            self.bannerContainerView.alpha = 0.;
        } completion:^(BOOL finished) {
//            [self.bannerContainerView layoutIfNeeded];
            self.bannerContainerView.alpha = 1.;
            self.isIAdBannerOnScreen = NO;
        }];
    } else {
        //[self.bannerContainerView setFrame:frame];
        //[self.bannerContainerView layoutIfNeeded];
    }
}


-(void) setOriginHeightOfAdBannerWithLastRowHeight:(CGFloat)lastRowHeight{
    if(DEBUG_MODE) {
        NSLog(@"setOriginHeightOfAdBannerWithLastRowHeight with height:%f", lastRowHeight);
    }
    CGFloat newOrigin;
    
    if((self.historyTable.frame.size.height-lastRowHeight)<self.bannerContainerView.bounds.size.height){
        newOrigin=self.historyTable.frame.size.height-(lastRowHeight+self.bannerContainerView.bounds.size.height);
    } else{
        newOrigin = 0.;
    }
    
    if(bannerYOrigin != newOrigin){
        bannerYOrigin = newOrigin;
        [self moveAdBanner];
    }
}
-(void)moveAdBanner{
    CGRect frame = self.bannerContainerView.frame;
    frame.origin.y = bannerYOrigin;
    self.bannerAdTopConstrain.constant = bannerYOrigin;
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.bannerContainerView setFrame:frame];
                     } completion:^(BOOL finished) {
                         nil;
                     }];
}

/*
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
*/
#pragma mark DesignAtr delegate
-(UIUserInterfaceSizeClass)currentInterfaceClassSize{
    return self.view.traitCollection.horizontalSizeClass;
}

#pragma mark HELPED FUNCTIONS______________________
//return point according localisation
-(NSString *) point //COPIED
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}

-(double) setPresisson:(NSInteger)pr forDouble:(double) number
{
    NSInteger integerPart = (NSInteger) number;
    double fractionalPart = number - integerPart;
    fractionalPart *= (10*pr);  //It is for upto two decimal values after point.
    //You can increase the zeros to fulfill your needs.
    NSInteger fractPart = (NSInteger) fractionalPart;
    double resultdouble = (double) (integerPart) + (double) (fractPart)/(10*pr);
    return fractionalPart;
}



@end



