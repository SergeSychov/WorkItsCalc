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


#import "NewButtonsCollectionViewCell.h"
#import "HistroryTableViewCell.h"

#import "ACalcBrain.h"

#import "DisplayLabel.h"
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
#import "DelButton.h"
#import "DownButton.h"

#import "AppearedController.h"
#import "Transition.h"
#import "BackTransition.h"
//here its only test
#import "SettingsViewController.h"
#import "ShowedViewController.h"

#import "AboutViewController.h"
#import "SettingViewController.h"
#import "ClearHistoryButton.h"
#import "DesignButton.h"

#import "Clr.h"



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

//define design numbers
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4


//NSString *const MainControllerSendPayPossibilityNotification = @"MainControllerSendPayPossibilityNotification";
//NSString *const MainControllerNotAvailableForBuingNotification = @"MainControllerNotAvailableForBuingNotification";
#pragma mark CHANGES FROM OTHER CONTROLLERS
NSString *const ReciveChangedNotification=@"SendChangedNotification";

@interface ITSCalcViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIApplicationDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, HistoryTableViewCellDelegate, UICollectionViewDelegateFlowLayout,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, DisplayRamDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, /* not shure its needed*/AppearedViewControllerProtocol, UIViewControllerTransitioningDelegate,ButtonsStoreProtocol>


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


@property (weak,nonatomic) UIImageView *imageBackgroundView;
@property (nonatomic) int wasRightShowed; //need for show Shoving view at rotation 0 - not on screen, 1- was in left rotation, 2 - was in right rotation
//important not shure its need
@property (nonatomic) UIDeviceOrientation wasRotatedNotificationAnotherController;
@property (nonatomic) BOOL willBePortraitRotated;
//necessary height of element for 3,5" screen
@property (nonatomic) CGFloat histroryTableViewHeight;
//@property (nonatomic) CGFloat labelViewHeight;
@property (nonatomic) CGFloat lastRowHistoryTableHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
//recognizers
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *moveButtonsPanGestureRecognizer; //pan gesture recognizer

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
//Display view
@property (weak, nonatomic) IBOutlet UIView *displayContainer;
@property (weak, nonatomic) IBOutlet  DisplayLabel *display; //calc display
@property (nonatomic, strong) DisplayRam *displayRam; //outbut dta from dislplay /input to display
@property (weak, nonatomic) IBOutlet UIVisualEffectView *displayBackground;
@property (weak, nonatomic) UIView*blackViewforPhotoBackground;
//@property (weak, nonatomic) IBOutlet UIToolbar *backgroundToolBar; //background for display
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


@property (nonatomic) CGFloat wasDynamicOriginY;
@property (weak, nonatomic) IBOutlet HistoryTableSviper *historyTableSviper;
@property (nonatomic) CGPoint svipeGestureLocation;


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
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;

@property (nonatomic) BOOL isIAdBaneerAvailable;
@property (nonatomic) NSInteger bannerRequestCounter;// need to limitation of IAd banner request at pressing "equal"
@property (nonatomic) BOOL isIAdBannerOnScreen; //to find out if the banner on the screen

//Settings
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons
@property (nonatomic) BOOL isSoundOn;
@property (nonatomic) BOOL isBigDataBase; //size dataBase
@property (nonatomic) int limitInDataBase;
@property (nonatomic) NSInteger design;
@property (nonatomic) BOOL isNeedToBeReloadedAfterDesignChanged;

@property (nonatomic) BOOL isiCloudInUse;
@property (nonatomic) BOOL isiCloudUseSwitcherEnabled;
@property (nonatomic) BOOL fristLunchWithicloudAvailable;
//need to set iClouds images whole & empty

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
@property (nonatomic,strong) NSAttributedString *lastRowsString;

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
@property (nonatomic,strong) ButtonsStore *buttonsStore;




//necessary conditions for counting
@property (nonatomic, assign) BOOL userIsInTheMidleOfEnteringNumber;
@property (nonatomic, assign) BOOL isProgramInProcess;// for not clear stack at the entering new number: 2 + newNumber instead on 2 + 2 =, newNumber
@property (nonatomic, assign) BOOL isStronglyArgu; //the argument is strongly setted by user
@property (nonatomic,assign) BOOL isDecCounting;
@property (nonatomic,assign) BOOL isResultFromMemory; //is result on screen is taked up from memory
@property (nonatomic, strong) NSString *currencyExhangeString; //striing to show currency exhange rate, setup - nil at start, setup string as currensy was checked, clear at clear brain

//make int property only for test NSTimer
@property (nonatomic,strong) NSIndexPath * patch;
@property (nonatomic, strong) NSTimer *animationTimer;//for delet and set buttonsView animation
@property (nonatomic, strong) NSTimer *secondTimer; //for move button at pan gesture
@property (nonatomic,strong) NSMutableArray *buttonsToMoveArray;
@property (nonatomic, assign) NSInteger itemOfNeedPosition;

//make this property to move button
@property (nonatomic,strong) newButtonView * buttonsAsSubView; //strong
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

#pragma mark INITIALIZATION

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

-(void) setDesign:(NSInteger)design
{
    //if(_design != design){
    _design = design;
    self.display.design = design;
    self.historyTableSviper.design = design;
    UIColor* buttonShadowColor;
    CGSize buttonShadowSize;
    CGFloat buttonShadowBlur;
    switch (_design) {
        case DESIGN_CLASSIC:
            self.view.backgroundColor = [UIColor blackColor];
            self.displayContainer.backgroundColor = [UIColor clearColor];
            self.historyTable.backgroundColor = [UIColor whiteColor];
            self.displayBackground.alpha = 1;
            self.displayBackground.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            
            if(self.imageBackgroundView){
                [self.imageBackgroundView removeFromSuperview];
            }
            
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
            
        case DESIGN_PAPER:
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.displayContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.historyTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];

            self.displayBackground.alpha = 0;
            if(self.imageBackgroundView){
                [self.imageBackgroundView removeFromSuperview];
            }
            
            buttonShadowColor = [UIColor whiteColor];
            buttonShadowSize = CGSizeMake(1., 1.);
            buttonShadowBlur = 0.5;

            break;
            
        case DESIGN_COLOR_BLUE:
            self.view.backgroundColor = [Clr blueGround];
            self.displayContainer.backgroundColor = [Clr blueDisplay];
            self.historyTable.backgroundColor = [Clr blueFirstGradient];
            self.displayBackground.alpha = 0.;
            [self setPhotoBackGround:NO];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
        case DESIGN_COLOR_GREEN:
            self.view.backgroundColor = [Clr greenGround];
            self.displayContainer.backgroundColor = [Clr greenDisplay];
            self.historyTable.backgroundColor = [Clr greenFirstGradient];
            self.displayBackground.alpha = 0;
            [self setPhotoBackGround:NO];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
        case DESIGN_COLOR_YELOW:
            self.view.backgroundColor = [Clr yellowGround];
            self.displayContainer.backgroundColor = [Clr yellowDisplay];
            self.historyTable.backgroundColor = [Clr yellowFirstGradient];
            self.displayBackground.alpha = 0;
            [self setPhotoBackGround:NO];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
        case DESIGN_COLOR_PINK:
            self.view.backgroundColor = [Clr pinkGround];
            self.displayContainer.backgroundColor = [Clr pinkDisplay];
            self.historyTable.backgroundColor = [Clr pinkFirstGradient];
            self.displayBackground.alpha = 0;
            [self setPhotoBackGround:NO];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
        case DESIGN_COLOR_GRAY:
            self.view.backgroundColor = [Clr grayGround];
            self.displayContainer.backgroundColor = [Clr grayDisplay];
            self.historyTable.backgroundColor = [Clr grayFirstGradient];
            self.displayBackground.alpha = 0;
            [self setPhotoBackGround:NO];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;
            break;
        case DESIGN_PHOTO:

            self.view.backgroundColor = [Clr blueGround];
            self.displayContainer.backgroundColor = [UIColor clearColor];
            self.historyTable.backgroundColor = [Clr photoFirstGradient];
            self.displayBackground.alpha = 1;
            self.displayBackground.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            
            
            [self setPhotoBackGround:YES];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;

            break;
        default:
            self.view.backgroundColor = [UIColor clearColor];
            self.displayContainer.backgroundColor = [UIColor clearColor];
            self.historyTable.backgroundColor = [UIColor clearColor];
            self.displayBackground.alpha = 1;
            self.displayBackground.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            buttonShadowColor = [UIColor clearColor];
            buttonShadowSize = CGSizeMake(0., 0.);
            buttonShadowBlur = 0.;

            break;
    }

    [self.historyTable reloadData];
    [self.buttonsCollection reloadData];
    
    self.recountButton.shadowColor = buttonShadowColor;
    self.recountButton.shadowBlur = buttonShadowBlur;
    self.recountButton.shadowSize = buttonShadowSize;
    [self.recountButton setNeedsDisplay];

    
    self.deleteButton.shadowColor = buttonShadowColor;
    self.deleteButton.shadowBlur = buttonShadowBlur;
    self.deleteButton.shadowSize = buttonShadowSize;
    [self.deleteButton setNeedsDisplay];
    
    self.settingsButton.shadowColor = buttonShadowColor;
    self.settingsButton.shadowBlur = buttonShadowBlur;
    self.settingsButton.shadowSize = buttonShadowSize;
    [self.settingsButton setNeedsDisplay];
    
    self.settingsBottomButtn.shadowColor = buttonShadowColor;
    self.settingsBottomButtn.shadowBlur = buttonShadowBlur;
    self.settingsBottomButtn.shadowSize = buttonShadowSize;
    [self.settingsBottomButtn setNeedsDisplay];
    
    self.downButton.shadowColor = buttonShadowColor;
    self.downButton.shadowBlur = buttonShadowBlur;
    self.downButton.shadowSize = buttonShadowSize;
    [self.downButton setNeedsDisplay];
    
    self.noticeButton.shadowColor = buttonShadowColor;
    self.noticeButton.shadowBlur = buttonShadowBlur;
    self.noticeButton.shadowSize = buttonShadowSize;
    [self.noticeButton setNeedsDisplay];
    
    if(self.noticeRealButton){
        self.noticeRealButton.shadowColor = buttonShadowColor;
        self.noticeRealButton.shadowBlur = buttonShadowBlur;
        self.noticeRealButton.shadowSize = buttonShadowSize;
        [self.noticeRealButton setNeedsDisplay];
    }
    self.isNeedToBeReloadedAfterDesignChanged = YES;

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
                CGRect collectionVisibleRect = self.viewforCurrencyRecognizer.frame;
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
            
            CGRect collectionVisibleRect = self.viewforCurrencyRecognizer.frame;
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
    if ([title isEqualToString:ALERT_ASSES_ASSES_APLICATION_BUTTON]){
        //NSString *iTunesLink = @"itms-apps://itunes.apple.com/us/app/its-calc/id873164530?l=ru&ls=1&mt=8";
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=873164530&type=Purple+Software";//&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALERT_ASSES_NO_BUTTON]){
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:USE_ICLOUD]){
        self.isiCloudInUse = YES;
    }
    
}

-(void) setIsBigDataBase:(BOOL)isBigDataBase
{
    _isBigDataBase = isBigDataBase;
}

-(int) limitInDataBase{
    return self.isBigDataBase ? 200 : 500;
}

-(void) setIsBigSizeButtons:(BOOL)isBigSizeButtons
{
    _isBigSizeButtons = isBigSizeButtons;
    //reset buttons size only when core data available
    //as exemple don't set in view didload
    if(self.buttonManagedObjectContext){
      //  [self setUpMainButtonsStartWithPosition];
      //  [self makeTwoArrays];
      //  [self.buttonsCollection reloadData];
        [self.buttonsStore renewArraysAccordingNewButtonsSize];
        
    }
}



//delegate method to allow read gestures (PAN AND SCROLL) toogether
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark BUTTONS DELEGATE
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

-(void)buttonsArrayDidChangedWithReload:(BOOL)isNeedReload
{
    if(isNeedReload){
        [self.buttonsCollection reloadData];
    }
     [self.doc updateChangeCount:UIDocumentChangeDone];
    if(self.counterForShowingAllertView == 37 && self.buttonsStore.allButtonObj){
       // NSLog(@"All buttons obj in changing version %@", self.buttonsStore.allButtonObj);
        [self.buttonsStore checkButtonsArray];
    }
}
#pragma mark ACTIONS

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

        if([programFromHistory lastObject]) [programFromHistory removeLastObject];

        
        if([ACalcBrain chekForCurrensiesProgramm:[programFromHistory copy]]){
            //if there are currencies in count - asck  currencies controller to make request for particukar currencies pair
            [self.currensies askResultForCurrensiesArray:[ACalcBrain chekForCurrensiesProgramm:[programFromHistory copy]]];
        }

        id top = [programFromHistory lastObject];
        //remove result from pprogramm array!
        [programFromHistory removeLastObject];
        NSMutableArray *argArrayCopy;
        if(top){
           argArrayCopy = [[ACalcBrain deepArrayCopy:top] mutableCopy];
        }

        
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

-(void) resetProgrammAfterCurrensiesChecked:(NSArray*)currencies{
    //NSLog(@"Curr array after request: %@", currencies);
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
        //NSLog(@"after programCopy %@:",programCopy );
        ACalcBrain *newBrain = [ACalcBrain initWithProgram:[programCopy copy] withArgu:[argArrayCopy copy]];
        
        self.brain = newBrain;
        NSLog(@"[NSNumber numberWithDouble:[self.brain count]]] %@", [NSNumber numberWithDouble:[self.brain count]]);
        
        [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain count]]]];
        self.isProgramInProcess = NO;
        self.isStronglyArgu = YES;
        self.userIsInTheMidleOfEnteringNumber = NO;
        [self showStringThrouhgmanagerAtEqualPress];
        
        
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
                
                
                //check if the button has a program
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
                request.predicate = [NSPredicate predicateWithFormat:@"nameButton = %@", title];
                
                NSError *error;
                NSArray *matches = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
                
                if(!matches || error ){
                    NSLog(@"Button not fetched");
                } else {
                    Buttons *obj = [matches firstObject];
                    if(obj.program == nil){
                        NSLog(@"Program haven't program");
                    } else {
                        NSLog(@"Button has a program");
                    }
                }
 

                [self tappedButtonWithTitle: title];
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
            NSLog(@"Array from button convercion %@", title);
            self.currencyExhangeString = [self currencyStringFromCurrencyArray:title];
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
            [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
            
            
            
        }
    }else if([title isKindOfClass:[NSString class]]){
        if((([title floatValue] != 0.0) || [title isEqualToString:@"0"]) && ![operands containsObject:title] ){
            NSNumber *symbol = [NSNumber numberWithInt:[title intValue]];
            if(self.userIsInTheMidleOfEnteringNumber){
                [self.display showString:[self.displayRam addSymbol:symbol]];
            }else {
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                    self.currencyExhangeString = nil;
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
                    self.currencyExhangeString = nil;
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
                self.currencyExhangeString = nil;
                
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
            
        } else if ([title isEqualToString:@"X"] || [title isEqualToString:@"Z"]){
            //add number value string code
            /*
            NSNumber *symbol = [NSNumber numberWithInt:[title intValue]];
            if(self.userIsInTheMidleOfEnteringNumber){
                [self.display showString:[self.displayRam addSymbol:symbol]];
            }else {
            
                [self.displayRam clearRam];
                if(!self.isProgramInProcess){
                    [self setStoryInforamtion];
                    [self.brain clearOperation]; //if it's just new argument, not new counting
                    self.currencyExhangeString = nil;
                }
                //[self.display showString:[self.displayRam addSymbol:title]];
                self.userIsInTheMidleOfEnteringNumber = NO;
            [self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
           //}
             */
            
            //add
            
            if(self.userIsInTheMidleOfEnteringNumber){
                [self push];
                self.userIsInTheMidleOfEnteringNumber = NO;
            } else {
                [self.brain clearArgu];
            }
            [self.display showString:[self.displayRam addSymbol:[title lowercaseString]]];
            [self.brain performOperationInArgu:[title lowercaseString]];
            //[self.display showString:[self.displayRam setResult:[NSNumber numberWithDouble:[self.brain performOperationInArgu:title]]]];
            self.isStronglyArgu = YES;
            [self showStringThruManageDocument];
            
            
        } else if ([title isEqualToString:@"Z"]){
            
        } else if ([title isEqualToString:@"Tab"]){
            
        } else if ([title isEqualToString:@"Grph"]){
            
        } else if ([title isEqualToString:@"+f(x)"]){
            
        } else if ([title isEqualToString:@"rad"] || [title isEqualToString:@"deg"] ) {
            if([title isEqualToString:@"rad"]){
                //cell.name = @"deg";
                [self.display.decRadLabel setText:@" RAD"];
                self.isDecCounting = NO;
            } else if ([title isEqualToString:@"deg"]){
                //cell.name = @"rad";
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
        NSLog(@"muttableOutputArray %@", muttableOutputArray);
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
        
        //if programm has currensies, get currencies array
        NSArray* currensies = [ACalcBrain chekForCurrensiesProgramm:[muttableOutputArray copy]];
        NSLog(@"Currensies %@", currensies);
        
        //add result to array
        [muttableOutputArray addObject:[NSNumber numberWithDouble:[self.brain count]]];
        
        //create new object in manageddoc with empty array
        /*
        if(self.currencyExhangeString){
            [History storyWithProgram:[muttableOutputArray copy]
                               atDate:currDate
                         currensyRate:self.currencyExhangeString
                  variabledescription:nil
                inManageObjectContext:self.managedObjectContext];
        }
        */
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
            
            
            [History storyWithProgram:[muttableOutputArray copy]
                               atDate:currDate
                         currensyRate:currStr
                  variabledescription:nil
                inManageObjectContext:self.managedObjectContext];
            
        }
        else {
            [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
        }
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

            
            CGRect buttonsCollectionViewBounds = self.viewforCurrencyRecognizer.frame;
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
                                // [self.buttonsCollection setFrame: buttonsCollectionViewBounds];
                                 [self.viewforCurrencyRecognizer setFrame:buttonsCollectionViewBounds];
                                 [self.buttonsCollection setFrame: self.viewforCurrencyRecognizer.bounds];
                                 self.display.alpha = .0;
                                 
                                 //allow show settings button only in paid version
                                 if(self.wasPurshaised || self.isTrialPeriod) self.settingsButton.alpha = 1.;
                                 self.downButton.alpha = 1.;
                                 
                             } completion:^(BOOL finihed){
                                
                                 if(!(self.wasPurshaised || self.isTrialPeriod)){
                                     [self showSettingsViewcontroller];

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
                        self.buttonsAsSubView.design = self.design;
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
}

- (IBAction)tapSettingsButton:(UIButton *)sender
{
    [self showSettingsViewcontroller];

}

-(void) discardChanging
{
    
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
        // NSError *error;
       // [self.buttonManagedObjectContext save:&error];
        //[self.doc.managedObjectContext save: &error];
        [self.doc updateChangeCount:UIDocumentChangeDone];
      //  [self.buttonsStore resaveCoreButtons];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];

    CGRect dynamicRect = self.dynamicContainer.frame;
    dynamicRect.size.height = 2*self.mainContainerView.bounds.size.height - self.histroryTableViewHeight - self.labelViewHeight;
    
    //initial origin
    dynamicRect.origin.y = self.histroryTableViewHeight + self.labelViewHeight - self.mainContainerView.bounds.size.height;
    
    CGRect buttonsCollectionViewBounds = self.mainContainerView.bounds;
    buttonsCollectionViewBounds.size.height = self.mainContainerView.bounds.size.height - self.histroryTableViewHeight;
    buttonsCollectionViewBounds.origin.y = self.historyTable.bounds.size.height;

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
                         
                        [self.viewforCurrencyRecognizer setFrame:buttonsCollectionViewBounds];
                         [self.buttonsCollection setFrame:self.viewforCurrencyRecognizer.bounds];


                         
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
    if((IS_IPAD)||(!([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight ))){
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

        if(ABS(CGRectGetMidY(strongSelf.dynamicContainer.frame) - centerY) < 1 && [dynamicItem linearVelocityForItem:view].y < 0.01){
           [animator removeAllBehaviors];
            CGRect dynamicRect = view.frame;
            dynamicRect.origin.y = needY;
            [view setFrame:dynamicRect];
            
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
            
        }

    };
    [animator addBehavior:collision];
    
    self.animator = animator;
}

//tap on history sviper
- (IBAction)tapSviper:(UITapGestureRecognizer *)sender
{
    if((IS_IPAD)||(!([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight ))){
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
                    
                    [UIView animateWithDuration: 1.5 * (blockOffset / self.viewforCurrencyRecognizer.frame.size.height)
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
                   ((self.buttonsCollection.contentOffset.y + self.viewforCurrencyRecognizer.frame.size.height - self.buttonsAsSubView.center.y) <  1.5*self.subCell.bounds.size.height) &&
                   ((self.buttonsCollection.contentOffset.y +self.viewforCurrencyRecognizer.frame.size.height) < self.buttonsCollection.contentSize.height)){
                    self.wasInMoveOffsetSection = YES;
                    if(offset > (self.subCell.frame.size.height*4)){
                        blockOffset = self.subCell.frame.size.height*4;
                    } else {
                        blockOffset = self.buttonsCollection.contentSize.height - self.buttonsCollection.contentOffset.y - self.viewforCurrencyRecognizer.frame.size.height;
                    }
                    CGPoint newOffset = self.buttonsCollection.contentOffset;
                    newOffset.y = self.buttonsCollection.contentOffset.y + blockOffset;
                    CGPoint newCenter = self.buttonsAsSubView.center;
                    newCenter.y = self.buttonsAsSubView.center.y + blockOffset;
                    
                    [UIView animateWithDuration:1.5 * (blockOffset / self.viewforCurrencyRecognizer.frame.size.height)
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
    NSLog(@"moveButtonOfArray");
    if(self.buttonsToMoveArray.count > 1){
        [self moveCellFromPosition:self.buttonsToMoveArray[1] toPosition:self.buttonsToMoveArray[0] withDuration:0.04];
        [self.buttonsToMoveArray removeObjectAtIndex:0];
    } else {
        //
        [self.secondTimer invalidate];
    }
}


//move buttonView from global variable subCell and findCell
-(void) move
{
    NSLog(@"move");
    //here is ok for all buttons
    NSIndexPath *findPatch = [self.buttonsCollection indexPathForCell:self.findCell];
    Buttons *findButtonObj = [self.buttonsStore.allButtonObj objectAtIndex:findPatch.item];
    NSNumber* findButtonObjPositionInCoreData = findButtonObj.position;
    //new position in changeble  array
    NSInteger indexFindButtonObjInChangebleArray = [self.buttonsStore.changebleButtonObjs indexOfObject:findButtonObj];
    
    NSIndexPath *subPatch = [self.buttonsCollection indexPathForCell:self.subCell];
    Buttons *subButtonObj = [self.buttonsStore.allButtonObj objectAtIndex:subPatch.item];
    NSNumber *subButtonObjPositionInCoreData = subButtonObj.position;
   
    if(!self.secondTimer.isValid){
        
        NSMutableArray *mutableCahngebleArray = [self.buttonsStore.changebleButtonObjs mutableCopy];
        [mutableCahngebleArray removeObject:subButtonObj];
        [mutableCahngebleArray insertObject:subButtonObj atIndex:indexFindButtonObjInChangebleArray];
        self.buttonsStore.changebleButtonObjs = [mutableCahngebleArray copy];
        //findButtonObjPositionInCoreData
        //subButtonObjPositionInCoreData

        [self.buttonsStore moveButton:subButtonObj fromPosition:subButtonObjPositionInCoreData toPosition:findButtonObjPositionInCoreData];
        
        [self moveCellsFromPatch:subPatch toPatch:findPatch];
    }
}

/*

//move buttons view from global subCell to view according data model changeble position
-(void) moveButtonObjFromPosition:(NSNumber*)subPuttonObjPosition toPosition:(NSNumber*)finButtonObjPosition
{
    [self.buttonsStore mo]
        if(subPuttonObjPosition > finButtonObjPosition){
        for(ButtonObject *buttonObj in self.buttonsStore.allButtonObj){
            if(!buttonObj.isMain){
                if((buttonObj.position < subPuttonObjPosition)&& (buttonObj.position >= finButtonObjPosition)){
                    buttonObj.position +=1;
                } else if (buttonObj.position == subPuttonObjPosition){
                    buttonObj.position = finButtonObjPosition;
                }
            }
        }
    }else if (subPuttonObjPosition < finButtonObjPosition){
        for(ButtonObject *buttonObj in self.buttonsStore.allButtonObj){
            if(!buttonObj.isMain){
                if((buttonObj.position > subPuttonObjPosition)&& (buttonObj.position <= finButtonObjPosition)){
                    buttonObj.position -=1;
                } else if (buttonObj.position == subPuttonObjPosition){
                    buttonObj.position = finButtonObjPosition;
                }
            }
        }
    }
    [self.buttonsStore renewArryasAfterChanging];
    //[self makeTwoArrays];

}
*/
-(void) moveCellsFromPatch:(NSIndexPath*)subPatch toPatch:(NSIndexPath*)findPatch
{
    
    NSLog(@"moveCellsFromPatch");
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSIndexPath *patch = [self.buttonsCollection indexPathForCell:self.findCell];
    
    if(subPatch.item > findPatch.item){
        for(NSInteger i = subPatch.item; i >= findPatch.item; i-- ){
            Buttons* changeObject = [self.buttonsStore.allButtonObj objectAtIndex:i];
            if((![changeObject.isMain boolValue]) && ([self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patch]]))
                
                [mutArray addObject:[NSIndexPath indexPathForItem:i inSection:subPatch.section]];
        }
        
    } else if(subPatch.item < findPatch.item){
        for(NSInteger i = subPatch.item; i <= findPatch.item; i++ ){
            Buttons * changeObject = [self.buttonsStore.allButtonObj objectAtIndex:i];
            if((![changeObject.isMain boolValue])  && ([self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patch]]))
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
                       && ((self.buttonsCollection.contentOffset.y + self.viewforCurrencyRecognizer.frame.size.height - self.buttonsAsSubView.center.y) <  1.5 *self.subCell.bounds.size.height)
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
            NSIndexPath *patch = [self.buttonsCollection indexPathForItemAtPoint:self.buttonsAsSubView.center];
            if(patch){
                self.findCell = (NewButtonsCollectionViewCell*)[self.buttonsCollection  cellForItemAtIndexPath:patch];
                
                while (YES){
                    if(([self.buttonsStore.changebleButtonObjs containsObject:[self.buttonsStore.allButtonObj objectAtIndex:[self.buttonsCollection indexPathForCell:self.findCell].item]])
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
            /*
            for(NSInteger i = 0; i < self.buttonsStore.changebleButtonObjs.count; i++){
                ButtonObject *butObj = self.buttonsStore.changebleButtonObjs[i];
                butObj.alowedTodelete = NO;
            }
            */
            for (Buttons* butObj in self.buttonsStore.changebleButtonObjs){
                butObj.aloweToDelete = [NSNumber numberWithBool:NO];// NO;
            }
            [self.buttonsStore renewArryasAfterChanging];
            //[self makeTwoArrays];

            for(int i = 0; i < ([self.buttonsStore.changebleButtonObjs  count] + 19); i ++){
                NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewCell* cell =[self.buttonsCollection cellForItemAtIndexPath:index];
                ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = NO;
            }
            
        } else {
            /*
            for(NSInteger i = 0; i < self.buttonsStore.changebleButtonObjs.count; i++){
                ButtonObject *butObj = self.buttonsStore.changebleButtonObjs[i];
                butObj.alowedTodelete = YES;
            }
            */
            for (Buttons* butObj in self.buttonsStore.changebleButtonObjs){
                butObj.aloweToDelete = [NSNumber numberWithBool:YES];//YES;
            }
            //[self makeTwoArrays];
            [self.buttonsStore renewArryasAfterChanging];
            
            for(int i = 0; i <self.buttonsStore.allButtonObj.count; i ++){
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
                
                Buttons* button = [self.buttonsStore.allButtonObj objectAtIndex:indexPath.item];
                
                if([button.enable boolValue]){
                    
                    NSMutableArray *mutableChangebleButtonObjs = [self.buttonsStore.changebleButtonObjs mutableCopy];
                    NSMutableArray *mutableDeletedButtonObjs = [self.buttonsStore.delettedButtonObjs mutableCopy];
                    
                    button.enable = [NSNumber numberWithBool:![button.enable boolValue]];
                    button.dateOfDeletting = [NSDate date];
                    
                    [mutableChangebleButtonObjs removeObject:button];
                    [mutableDeletedButtonObjs insertObject:button atIndex:0];
                    
                    self.buttonsStore.changebleButtonObjs = [mutableChangebleButtonObjs copy];
                    self.buttonsStore.delettedButtonObjs = [mutableDeletedButtonObjs copy];
                    
                    //[self makeTwoArrays];
                    //[self.buttonsStore renewArryasAfterChanging];
                    
                   
                    
                    //[self makeTwoArrays];
                    [self.buttonsStore renewArryasAfterChanging];
                    
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
                    
                    if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
                        self.isAllowedToDelete = NO;
                    } else {
                        self.isAllowedToDelete = YES;
                    }
                    
                } else {
                    
                    NSMutableArray *mutableChangebleButtonObjs = [self.buttonsStore.changebleButtonObjs mutableCopy];
                    NSMutableArray *mutableDeletedButtonObjs = [self.buttonsStore.delettedButtonObjs mutableCopy];
                    
                    [mutableDeletedButtonObjs removeObject:button];
                    //find neede position in short array
                    NSInteger i = 0;
                    while (i  < mutableChangebleButtonObjs.count){
                        Buttons *butObj = mutableChangebleButtonObjs[i];
                        if([butObj.position integerValue] > [button.position integerValue]) break;
                        i++;
                    }
                    button.enable = [NSNumber numberWithBool:![button.enable boolValue]];
                    button.dateOfDeletting = [NSDate distantFuture];
                    
                    [mutableChangebleButtonObjs insertObject:button atIndex:i];
                    
                    self.buttonsStore.changebleButtonObjs = [mutableChangebleButtonObjs copy];
                    self.buttonsStore.delettedButtonObjs = [mutableDeletedButtonObjs copy];
                    
                    //[self makeTwoArrays];
                    [self.buttonsStore renewArryasAfterChanging];

                    ((NewButtonsCollectionViewCell*)cell).isEnable  = !((NewButtonsCollectionViewCell*)cell).isEnable;
                    self.itemOfNeedPosition = [self.buttonsStore.allButtonObj indexOfObject:button];
                    self.patch = indexPath; //set the start patch for moveButtonDownSelector
                    self.animationTimer  = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                                            target: self
                                                                          selector:@selector(moveButtonsUp)  //find the selector moveButtonsDown early
                                                                          userInfo: nil repeats:YES];
                    
                    if((self.buttonsStore.changebleButtonObjs.count +19) < 31){
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
    
    if(self.patch.item == (self.buttonsStore.changebleButtonObjs.count +19)){
        [self.animationTimer invalidate];
        
        NSArray * pathesToReload = [NSArray arrayWithObjects:
                                    self.patch,
                                    nil];
        [self.buttonsCollection reloadItemsAtIndexPaths:pathesToReload];
        
    } else {
        //find next chngeble position
        //while position is lees than quantity of work button and cell is visible
        while ((patchFrom.item < (self.buttonsStore.changebleButtonObjs.count +19)) &&
               
               [self.buttonsCollection.visibleCells containsObject:[self.buttonsCollection cellForItemAtIndexPath:patchFrom]] && (self.isButtonsCollectionUnderChanging)){
            
            Buttons *buttonObject = [self.buttonsStore.allButtonObj objectAtIndex:patchFrom.item];
            
            if(![buttonObject.isMain boolValue]) {
                break;
            } else {
                patchFrom = [NSIndexPath indexPathForItem:patchFrom.item +1 inSection:patchFrom.section];
            }
        }
        
        [self moveCellFromPosition:patchFrom toPosition:self.patch withDuration:0.02];
        self.patch = patchFrom;
        
        if((self.patch.item > ((self.buttonsStore.changebleButtonObjs.count +19) - 1))||
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
            Buttons *buttonObject = [self.buttonsStore.allButtonObj objectAtIndex:patchFrom.item];
            if(![buttonObject.isMain boolValue]) {
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
    return self.isButtonsCollectionUnderChanging? [self.buttonsStore.allButtonObj count] : [self.buttonsStore.workButtonsNames count] ;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Button" forIndexPath:indexPath];
    ((NewButtonsCollectionViewCell *)cell).delegate = (ButtonsCollectionView*)collectionView;
    ((NewButtonsCollectionViewCell *)cell).isIpadPortraitView = self.willBePortraitRotated;
    [((NewButtonsCollectionViewCell *)cell)removeFromSuperview];
    [collectionView insertSubview:((NewButtonsCollectionViewCell *)cell) atIndex:indexPath.item];
    
    if([cell isKindOfClass:[NewButtonsCollectionViewCell class]]){
        NSInteger item = indexPath.item;
        ((NewButtonsCollectionViewCell*)cell).design = self.design;
        if(self.isButtonsCollectionUnderChanging){
            Buttons *button = [self.buttonsStore.allButtonObj objectAtIndex:item];
            
            ((NewButtonsCollectionViewCell*)cell).isEnable = [button.enable boolValue];
            ((NewButtonsCollectionViewCell*)cell).isChangeble = ![button.isMain boolValue];
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = self.isButtonsCollectionUnderChanging;
            ((NewButtonsCollectionViewCell*)cell).isAllovedToDelete = [button.aloweToDelete boolValue];
            
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
            NSString* nameFromModel = [self.buttonsStore.workButtonsNames objectAtIndex:item];
            ((NewButtonsCollectionViewCell*)cell).design = self.design;
            
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
    //NSLog(@"GetAttrString nextTop: %@", top);
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
    //NSLog(@"GetAttrString topOfArguArray: %@", topOfArgArray);
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
    
   // NSLog(@"geAttrString wholeProgCopy:%@",wholeProgramCopy);
    
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
        ((HistroryTableViewCell*)cell).design = self.design;
        
        if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            ((HistroryTableViewCell*)cell).isCanDrag = NO;

            ((HistroryTableViewCell*)cell).historyDateString = @"";
            ((HistroryTableViewCell*)cell).historyExchangeCurrencyString = nil;
            if(!self.lastRowDataArray) self.lastRowDataArray = [[NSArray alloc] init];//if no array till now
            NSAttributedString *resultAtrStr = self.lastRowsString;//[self getAttributedStringFromArray:self.lastRowDataArray];
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
            ((HistroryTableViewCell*)cell).historyExchangeCurrencyString = story.currensyRate;
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
    //init button store with context
    //ask inside initialization makes all needed arrays
    ButtonsStore* buttons = [[ButtonsStore alloc] initWithContext:buttonManagedObjectContext];
    buttons.delegate = self;
    //all setup inside buttons store
    self.buttonsStore = buttons;
    [self.buttonsStore setUpArrays];
    
    //[self setUpArrays];
    //all buttons reload in delegate methods buttonsArrayDidChanged
    //[self.buttonsCollection reloadData];
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
    //NSLog(@"Last row Data array %@", lastRowDataArray);
    self.lastRowsString = [self getAttributedStringFromArray:self.lastRowDataArray];
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
            atrStrFromString = [self.lastRowsString mutableCopy];
           // atrStrFromString =  [[self getAttributedStringFromArray:self.lastRowDataArray] mutableCopy];
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
   // NSLog(@"Need to migrate to URL %@", newStorageURL);
}



-(void) iCloudAccountChanged:(NSNotification*)notification
{
  //  NSLog(@"Storage did change");
}

-(void)cloudDidChange:(NSNotification*)notification
{
   // NSLog(@"cloud Did Change %@", notification);// %@", [notification userInfo]);
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
            //[self setUpArrays];
            //[self.buttonsCollection reloadData];

            [self.buttonsStore changeContext:self.buttonManagedObjectContext];
            
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
        self.isiCloudUseSwitcherEnabled = YES;
        
    } else {
        [[NSUserDefaults standardUserDefaults]
         removeObjectForKey:@"com.apple.ItsCalc.UbiquityIdentyToken"];
        self.isiCloudInUse = NO;
        self.isiCloudUseSwitcherEnabled = NO;
    }
}

#pragma mark VIEW_DID_LOAD
- (void)viewDidLoad
{
    ButtonsStore *buttonsStore = [[ButtonsStore alloc] init];
    buttonsStore.delegate = self;

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
    
    //USER DEFAULT
    id userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"wholeArray"];
    if(userDefault && [self extractFromUserDefault:userDefault]){
        
    } else {
        self.isBigDataBase = NO;
        self.isBigSizeButtons = YES;
        self.isSoundOn = YES;
        self.design = DESIGN_CLASSIC;
        self.lastShowAllertViewDate = [NSDate date];
        self.counterForShowingAllertView = 26;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.currentProgrammVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }

    
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
    
    self.currencyExhangeString = nil;
    
    
    self.historyTable.allowsMultipleSelectionDuringEditing = NO;
    self.historyTable.allowsMultipleSelection = NO;
    if(IS_BLACK_MODE){
        [self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
        [self.buttonsCollection setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    } else {
        //[self.historyTable setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
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

    self.isNeedToBeReloadedAfterDesignChanged = NO;
}



#pragma mark VIEW LAYOUT

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
    self.displayBackground.frame = self.displayContainer.frame;
    
    //if Ipad set Layout for display buttons
    if(IS_IPAD){
        CGSize displaySize = self.displayContainer.bounds.size;
        [self setDisplayButtonsLayout:displaySize];
    }
    
    /*
    [self.buttonsCollection setFrame:CGRectMake(0,
                                                self.mainContainerView.frame.size.height - self.labelViewHeight,
                                                self.mainContainerView.bounds.size.width,
                                                self.mainContainerView.bounds.size.height - self.histroryTableViewHeight)];
    */
    [self.viewforCurrencyRecognizer setFrame:CGRectMake(0,
                                                self.mainContainerView.frame.size.height - self.labelViewHeight,
                                                self.mainContainerView.bounds.size.width,
                                                self.mainContainerView.bounds.size.height - self.histroryTableViewHeight)];
    
    [self.buttonsCollection setFrame:self.viewforCurrencyRecognizer.bounds];
    

    
    
    CGRect sviperRect = self.historyTableSviper.frame;
    sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.bounds.size.width)/2;
    sviperRect.origin.y = self.displayContainer.frame.origin.y - self.historyTableSviper.bounds.size.height*2/3;
    [self.historyTableSviper setFrame:sviperRect];
    if(self.imageBackgroundView){
        CGFloat inset;
        if(IS_IPAD){
            inset = -60;
        } else {
            inset = -40;
        }
        [self.imageBackgroundView setFrame:CGRectInset(rect,inset, inset)];
        //[self.imageBackgroundView setFrame:CGRectInset(self.view.frame,inset, inset)];
        if(self.blackViewforPhotoBackground){
            [self.blackViewforPhotoBackground setFrame:self.imageBackgroundView.bounds];
        }
    }

}

-(void) changeLayoutDynamicContainerWithSize:(CGSize)size
{
    if(self.animator){
        self.animator = nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    [self.mainContainerView setFrame:rect];
    if(self.imageBackgroundView){
        CGFloat inset;
        if(IS_IPAD){
            inset = -60;
        } else {
            inset = -40;
        }
        [self.imageBackgroundView setFrame:CGRectInset(rect,inset, inset)];
        if(self.blackViewforPhotoBackground){
            [self.blackViewforPhotoBackground setFrame:self.imageBackgroundView.bounds];
        }
    }
    
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
    self.displayBackground.frame = self.displayContainer.frame;
    
    
    
    //if Ipad set Layout for display buttons
    if(IS_IPAD){
        CGSize displaySize = self.displayContainer.bounds.size;
        [self setDisplayButtonsLayout:displaySize];
    }
    
    
    CGRect sviperRect = self.historyTableSviper.frame;
    sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.bounds.size.width)/2;
    sviperRect.origin.y = self.displayContainer.frame.origin.y - self.historyTableSviper.bounds.size.height*2/3;
    [self.historyTableSviper setFrame:sviperRect];
    
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
    /*
    //self.historyTable.style=
    CGRect rc = self.historyTable.frame;
    NSLog(@"Rect:%f, %f, %f, %f", rc.origin.x,
          rc.origin.y,
          rc.size.width,
          rc.size.height);
    */
    
    /*
    [self.buttonsCollection setFrame:CGRectMake(0,
                                                displayViewFrame.origin.y,
                                                size.width,
                                                self.dynamicContainer.bounds.size.height - self.historyTable.frame.size.height)];
    */
    [self.viewforCurrencyRecognizer setFrame:CGRectMake(0,
                                                displayViewFrame.origin.y,
                                                size.width,
                                                self.dynamicContainer.bounds.size.height - self.historyTable.frame.size.height)];
    [self.buttonsCollection setFrame:self.viewforCurrencyRecognizer.bounds];
    
    
    //Important may be Need to deleted it
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
    if(IS_IPAD){
        [self.buttonsStore renewArraysAccordingNewButtonsSize];
        //[self setUpMainButtonsStartWithPosition];//ipad
        //[self makeTwoArrays];//ipad
       // [self.buttonsCollection reloadData];//ipad
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
    
    self.displayBackground.frame = self.displayContainer.frame;
    //set size buttonsViews and frames
    struct Color clr;
    clr.r = 0.95;//0.26;
    clr.g = 0.95;//0.57;
    clr.b = 0.95;//0.70;
    clr.a = 1.0;

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
    
    //strange
    
    [self.buttonsStore renewArryasAfterChanging];
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
    //[self.buttonsStore resaveCoreButtons];
    //test
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]; //hope it will work
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    NSArray *buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
    
    for(Buttons *btn in buttonsFromCoreData){
        NSLog(@"Button %@ position %@",btn.nameButton, btn.position);
    }
    
    //[self.buttonManagedObjectContext save:&error];
    [self.buttonManagedObjectContext save: &error];
     [self.doc updateChangeCount:UIDocumentChangeDone];
    [self discardChanging];


}

//really enter to background
-(void) appDidEnterBackground
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
    
    if(self.isButtonsCollectionUnderChanging){
        self.isButtonsCollectionUnderChanging = NO;
        
        for(UICollectionViewCell* cell in [self.buttonsCollection visibleCells]){
            ((NewButtonsCollectionViewCell*)cell).isUnderChanging = NO;
        }
        NSError *error;
        //[self.buttonManagedObjectContext save:&error];
        //[self.doc.managedObjectContext save: &error];
        [self.doc updateChangeCount:UIDocumentChangeDone];
        //[self.buttonsStore resaveCoreButtons];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"HistoryTableViewCellViewDidBeginScrolingNotification" object:self.historyTable];
    
    //importand why i've made it
   // [self discardChanging];

    
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
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
   // NSLog(@"MainView Will appear");
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
    [self initialLayoutDynamiccontainer];
    self.display.alpha =  1;
    self.settingsBottomButtn.alpha =0;
    self.noticeButton.alpha = 0;
    if(IS_IPAD){
        self.noticeRealButton.alpha = 0.;
    }
    self.recountButton.alpha = 0;
    self.deleteButton.alpha = 0;
    self.isHistoryWholeShowed = 0;
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
                [self.buttonsStore setButtonsByDefault];
                
                //[self.buttonsStore changeContext:self.buttonManagedObjectContext];
                //[self setUpArrays];
                //[self.doc updateChangeCount:UIDocumentChangeDone];
                //[self.buttonsCollection reloadData];
            }
            
        } else if ([key isEqualToString:@"cleanHistoryArchive"]){
            if([[notification.userInfo objectForKey:keys[0]] boolValue]){
                
                [History clearContext:self.managedObjectContext];
                NSArray *newHeightsOfRows = [[NSArray alloc] init];
                self.heightsOfRows = newHeightsOfRows;
                [self performFetch];
            }
            
        } else if ([key isEqualToString:@"ChangedDesign"]){
            NSLog(@"Design changed to: %ld", (long)[[notification.userInfo objectForKey:keys[0]] integerValue]);
            self.design = [[notification.userInfo objectForKey:keys[0]] integerValue];
        } else {
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
    settingsController.isiCloudUseSwitcherEnabled = self.isiCloudUseSwitcherEnabled;
    settingsController.design = self.design;

    //settingsController.isTrialPeriod = self.isTrialPeriod;
    //settingsController.wasPurshaised = self.wasPurshaised;
   // settingsController.isiCloudUseSwitcherEnabled = self.isiCloudUseSwitcherEnabled;

    self.settingsController = settingsController;
    self.settingsController.transitioningDelegate = self;
    //recive notification from other controllers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:ReciveChangedNotification object:nil];
    [self presentViewController:self.settingsController animated:YES completion:^{
        [self discardChanging];
    }];
    
}

#pragma mark SHOW VIEW CONTROLLER

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
            atrStrFromString = [self.lastRowsString mutableCopy];//[self getAttributedStringFromArray:self.lastRowDataArray];
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
    NSLog(@"Finish trial period from about view");
    self.isTrialPeriod = NO;
    //set settings view for change button
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
    [controllerArray addObject:[NSNumber numberWithInteger:self.design]];
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
            self.design = [top integerValue];
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
    //[self setUpMainButtonsStartWithPosition];//ipad
    //[self makeTwoArrays];//ipad
    //[self.buttonsCollection reloadData];//ipad
    [self changeLayoutDynamicContainerWithSize:size];//ipad
    
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
                        /*
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
                        */
                    }
                    //[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                    self.callShowController = needCallcontroller;
                }

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

#pragma mark HELPED FUNCTIONS______________________
//return point according localisation
-(NSString *) point
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



