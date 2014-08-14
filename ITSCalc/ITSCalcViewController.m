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
//#import <AVFoundation/AVFoundation.h>

#import "ITSCalcViewController.h"

#import "ButtonsCollectionView.h"
#import "NewButtonsCollectionViewCell.h"
#import "HistroryTableViewCell.h"

#import "ACalcBrain.h"
#import "cmyk.h"
#import "DisplayLabel.h"
#import "DisplayRam.h"
#import "History.h"
#import "History+Maker.h"
#import "Buttons.h"
#import "Buttons+Buttons_Maker.h"
#import "ButtonObject.h"
#import "HistoryTableSviper.h"
#import "HistoryTableView.h"
#import "ShowedView.h"

#import "HintView.h"

#define ANGLE_OFFSET (M_PI_4 * 0.1f)
#define X_OFFSET 2.0f
#define Y_OFFSET 2.0f
#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define TIMES_TO_LIMIT_IAD_BANNER 3
#define TIME_INTERVAL_FROM_LAST_ALERT 43200. //need to be setted as 12 hours - 43 000;

#define kInAppPurchaseProductID @"ItsCalc.changekeyboard"

NSString *const ShowedViewIsDirtyNotification = @"ShowedViewIsDirtyNotification";


@interface ITSCalcViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIApplicationDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, HistoryTableViewCellDelegate, UICollectionViewDelegateFlowLayout,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, DisplayRamDelegate, UICollisionBehaviorDelegate>


//outlets
//
//Main container view

@property (weak, nonatomic) HintView *hintView;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (nonatomic) int wasRightShowed; //need for show Shoving view at rotation 0 - not on screen, 1- was in left rotation, 2 - was in right rotation
//necessary height of element for 3,5" screen
@property (nonatomic) CGFloat histroryTableViewHeight;
@property (nonatomic) CGFloat labelViewHeight;
@property (nonatomic) CGFloat lastRowHistoryTableHeight;
//@property (nonatomic) CGFloat settingsViewHeight;

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
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (weak, nonatomic) IBOutlet UIButton *recountButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak,nonatomic) IBOutlet UIButton *settingsButton;
@property (weak,nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsBottomButtn;

//History table view
@property (weak, nonatomic) IBOutlet HistoryTableView *historyTable;
//property to show is one row from history table is selected
@property (strong,nonatomic) HistroryTableViewCell *selectedRow;
//attributes for historyTable
@property (nonatomic,strong) NSDictionary * attributes;
@property (weak, nonatomic) IBOutlet HistoryTableSviper *historyTableSviper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesturerecognizer;
//for set values of row hight in historyTableView
@property (nonatomic,strong) NSArray *heightsOfRows;


//bool property for paid version
@property (nonatomic, strong) SKProduct *product;

@property (nonatomic) BOOL wasPurshaised;
//iAd banner
@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;
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
@property (weak, nonatomic) IBOutlet UIView *smallButtonView;
@property (weak, nonatomic) IBOutlet UIView *bigbuttonView;
@property (weak, nonatomic) IBOutlet UISwitch *isBigSizeSwitcher;
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons

@property (weak, nonatomic) IBOutlet UISwitch *soundSwitcher;
@property (weak, nonatomic) IBOutlet UIImageView *soundOffView;
@property (weak, nonatomic) IBOutlet UIImageView *soundOnView;
@property (nonatomic) BOOL isSoundOn;

@property (weak, nonatomic) IBOutlet UISwitch *isBigDataBaseSwitcher;
@property (weak, nonatomic) IBOutlet UIImageView *smallDataBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *bigDataBaseView;
@property (nonatomic) BOOL isBigDataBase; //size dataBase
@property (nonatomic) int limitInDataBase;
@property (weak, nonatomic) IBOutlet UIButton *clearHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *keyboardDefaultButton;
//add spin activity to show process of purchaising
@property (weak, nonatomic) UIActivityIndicatorView *processSpinner;




//Showed View
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) IBOutlet ShowedView *viewToPDF;
@property (weak, nonatomic) IBOutlet UIButton *redPanButton;
@property (weak, nonatomic) IBOutlet UIButton *bluePanButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

//Document
@property (nonatomic, retain) UIDocumentInteractionController *docController;
@property (nonatomic, strong) UIManagedDocument *doc;

//Fetch controller
// Causes the fetchedResultsController to refetch the data.
// You almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSManagedObjectContext *buttonManagedObjectContext;
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

//@property (nonatomic) BOOL appWasOnBackGroundTwice;
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

#pragma mark TEXT ATTRIBUTES
//attributes for history table
-(NSDictionary*) attributes
{
    if(!_attributes){

        UIColor *textColor = [UIColor darkGrayColor]; //color of text
        
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
            //style.alignment = NSTextAlignmentCenter;
        } else {
            fontSize = 17.0;
            //style.alignment = NSTextAlignmentLeft;
        }
        
        UIFont *font; //if there is no needed font
        if(fontName){
            font = [UIFont fontWithName:fontName size:fontSize];
        }else {
            font =[UIFont boldSystemFontOfSize:fontSize];
        }

        _attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    }
    return _attributes;
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



#pragma mark SETTINGS VIEW

#define BUY_REQUEST_BUTTON NSLocalizedStringFromTable(@"BUY_REQUEST_BUTTON",@"ACalcTryViewControllerTable", @"buy button title")

#define TITLE_RESET_BUTTON NSLocalizedStringFromTable(@"TITLE_RESET_BUTTON",@"ACalcTryViewControllerTable", @"reset button title")
#define ALERT_MESAGE_RESET_BUTTONS NSLocalizedStringFromTable(@"ALERT_MESAGE_RESET_BUTTONS",@"ACalcTryViewControllerTable", @"reset button alert mesage")
#define ALERT_CANCEL_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_CANCEL_BUTTON_TITLE",@"ACalcTryViewControllerTable", @"alert cancel buton title")
#define ALERT_RESTORE_BUTTON_TITLE NSLocalizedStringFromTable(@"ALERT_RESTORE_BUTTON_TITLE ",@"ACalcTryViewControllerTable", @"restore buton title")

#define TITLE_CLEAR_HISTORY_BUTTON NSLocalizedStringFromTable(@"TITLE_CLEAR_HISTORY_BUTTON",@"ACalcTryViewControllerTable", @"clear history button title")
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


- (IBAction)defaultKeyboardbuttonTapped:(id)sender
{
    UIAlertView *alert;
    if(self.wasPurshaised){
        alert = [[UIAlertView alloc] initWithTitle:TITLE_RESET_BUTTON
                                                    message:ALERT_MESAGE_RESET_BUTTONS//@"restore initial buttons settings"
                                                   delegate:self
                                          cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                          otherButtonTitles:ALERT_RESTORE_BUTTON_TITLE, nil]; //@"Restore"
        
    } else {
        alert = [[UIAlertView alloc] initWithTitle:ALLERT_TITLE_CHANGE_KEYBOARD//@"Change keyboard"//TITLE_RESET_BUTTON
                                           message:@""
                                          delegate:self
                                 cancelButtonTitle:ALERT_CANCEL_BUTTON_TITLE//@"Cancel"
                                 otherButtonTitles: ALLERT_BUTTON_BUY,ALLERT_BUTTON_RESTORE, nil]; //@"Restore"
        
        //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        //[self restorePurchase];
        
    }
    [alert show];
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
    if((intervalFromLastShowAllert < (TIME_INTERVAL_FROM_LAST_ALERT * -1)) && (_counterForShowingAllertView > 30)){
        if((_counterForShowingAllertView) % 2 == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_ASSES//@"YOUR OPINION IS IMPORTANT TO ME"
                                                            message:ALERT_MESSAGE_ASSES//@"...should I stay or should I go?"
                                                           delegate:self
                                                  cancelButtonTitle:ALERT_ASSES_ASSES_APLICATION_BUTTON//ALERT_ASSES_NO_BUTTON //@"No, thanks"
                                                  otherButtonTitles: ALERT_ASSES_REMIND_LATER_BUTTON, ALERT_ASSES_NO_BUTTON,nil]; //@"Аssess the application", @"Remind later"
            [alert show];
            self.lastShowAllertViewDate = [NSDate date];
        }
    }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:ALERT_RESTORE_BUTTON_TITLE]){
        [Buttons clearContext:self.buttonManagedObjectContext];
        [self setUpArrays];
        
        [self.buttonsCollection reloadData];
        
    } else if ([title isEqualToString:ALERT_CLEAR_BUTTON_TITLE]){
        
        [History clearContext:self.managedObjectContext];
        NSArray *newHeightsOfRows = [[NSArray alloc] init];
        self.heightsOfRows = newHeightsOfRows;
        [self performFetch];
        
    } else if ([title isEqualToString:ALERT_ASSES_ASSES_APLICATION_BUTTON]){
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/us/app/its-calc/id873164530?l=ru&ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALERT_ASSES_NO_BUTTON]){
        self.counterForShowingAllertView = -1;
        
    } else if ([title isEqualToString:ALLERT_BUTTON_RESTORE]){
        [self restorePurchase];
        
    } else if ([title isEqualToString:ALLERT_BUTTON_BUY]){
        [self buyUnlockKeyboard];
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
    _managedObjectContext = managedObjectContext;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.fetchLimit = self.limitInDataBase + 20;//!!!!set this value to allow use set it by settings
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

-(void) setButtonManagedObjectContext:(NSManagedObjectContext *)buttonManagedObjectContext
{
    _buttonManagedObjectContext = buttonManagedObjectContext;
     [self.buttonsCollection reloadData];
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
                    if(25 < self.counterForShowingAllertView < 34){
                        switch (self.counterForShowingAllertView) {
                            case 27:{
                                HintView *hintView = [HintView newHintViewWithFrame:self.view.frame
                                                                          labelRect:self.displayContainer.frame
                                                                               type:self.counterForShowingAllertView];
                                hintView.alpha = 0;
                                [self.mainContainerView addSubview:hintView];
                                self.hintView = hintView;
                                [UIView animateWithDuration:0.4
                                                      delay:0.4
                                                    options:UIViewAnimationOptionCurveEaseIn
                                                 animations:^{
                                                     self.hintView.alpha = 0.95;
                                                 } completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                                break;
                            case 30 : {
                                CGRect collectionVisibleRect = self.buttonsCollection.frame;
                                collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
                                collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
                                HintView *hintView = [HintView newHintViewWithFrame:self.view.frame
                                                                          labelRect:collectionVisibleRect
                                                                               type:self.counterForShowingAllertView];
                                hintView.alpha = 0;
                                [self.mainContainerView addSubview:hintView];
                                self.hintView = hintView;
                                [UIView animateWithDuration:0.4
                                                      delay:0.4
                                                    options:UIViewAnimationOptionCurveEaseIn
                                                 animations:^{
                                                     self.hintView.alpha = 0.95;
                                                 } completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                                break;
                            case 33 :{
                                CGRect collectionVisibleRect = self.buttonsCollection.frame;
                                collectionVisibleRect.size.height -= self.displayContainer.bounds.size.height;
                                collectionVisibleRect.origin.y += self.displayContainer.bounds.size.height;
                                HintView *hintView = [HintView newHintViewWithFrame:self.view.frame
                                                                          labelRect:collectionVisibleRect
                                                                               type:self.counterForShowingAllertView];
                                hintView.alpha = 0;
                                [self.mainContainerView addSubview:hintView];
                                self.hintView = hintView;
                                [UIView animateWithDuration:0.4
                                                      delay:0.4
                                                    options:UIViewAnimationOptionCurveEaseIn
                                                 animations:^{
                                                     self.hintView.alpha = 0.95;
                                                 } completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                                break;
                            default:
                                break;
                        }
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
        NSDate *currDate = [NSDate date];
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
        
        if([self.historyTable numberOfRowsInSection:0] >0){
            History *currentStory = [self.fetchedResultsController objectAtIndexPath:
                                     [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0] -1
                                                        inSection:0]];
            currentStory.program = [NSKeyedArchiver archivedDataWithRootObject:[muttableOutputArray copy]];
        } else {
            //make currentStory
            [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
        }
    }
}

-(void) showStringThruManageDocument
{
    NSDate *currDate = [NSDate date];
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
    
    if([self.historyTable numberOfRowsInSection:0] >0){
        History *currentStory = [self.fetchedResultsController objectAtIndexPath:
                                 [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0] -1
                                                    inSection:0]];
        currentStory.program = [NSKeyedArchiver archivedDataWithRootObject:[muttableOutputArray copy]];
    } else {
        //make currentStory
        [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
    }
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
        
        if([self.historyTable numberOfRowsInSection:0] >0){
            History *currentStory = [self.fetchedResultsController objectAtIndexPath:
                                     [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection:0] -1
                                                        inSection:0]];
            currentStory.date = currDate;
            currentStory.program = [NSKeyedArchiver archivedDataWithRootObject:[muttableOutputArray copy]];
        } else {
            //make currentStory
            [History storyWithProgram:[muttableOutputArray copy] atDate:currDate inManageObjectContext:self.managedObjectContext];
        }
        
        //create new object in manageddoc with empty array
        NSDate *lastDay = [NSDate distantFuture];
        NSArray *new = [[NSArray alloc] init];
        [History storyWithProgram:new atDate:lastDay inManageObjectContext:self.managedObjectContext];
        //CHECK HERE!!!!!!!!
        //?? with no rows
        if([self.historyTable numberOfRowsInSection:0] > 0){
            NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0] -1 inSection:0];
            [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
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
            //[self.buttonsCollection reloadData];
            
            CGRect historyTableFrame = self.historyTable.frame;
            historyTableFrame.origin.y = - historyTableFrame.size.height;
            
            //lift banner on settings screen (need to do if banner visible)
            //CGRect iAdBannerFrame = self.bannerContainerView.frame;
            //iAdBannerFrame.origin.y += - historyTableFrame.size.height;
            
            CGRect displayViewFrame = self.displayContainer.frame;
            displayViewFrame.origin.y = 0;
            
            CGRect buttonsCollectionViewBounds = self.view.frame;
            buttonsCollectionViewBounds.size.height = self.view.frame.size.height;
            buttonsCollectionViewBounds.origin.y = 0;
            
            CGRect sviperRect = self.historyTableSviper.frame;
            sviperRect.origin.x = (self.view.frame.size.width - self.historyTableSviper.frame.size.width)/2;
            sviperRect.origin.y = displayViewFrame.origin.y - self.historyTableSviper.frame.size.height;
            
            CGRect settingsViewframe = self.SettingsView.frame;
            settingsViewframe.origin.y = self.displayContainer.frame.size.height;
            
            
            //allow show settings button only in paid version
            if(self.wasPurshaised) self.settingsButton.hidden = NO;
            self.downButton.hidden = NO;
            //[self.buttonsCollection reloadData];
            
            [UIView animateWithDuration:.35
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.historyTable setFrame:historyTableFrame];
                                 //lift banner on settings screen (need to do if banner visible)
                                 //if(self.isIAdBaneerAvailable)[self.bannerContainerView setFrame:iAdBannerFrame];
                                 if(self.isIAdBaneerAvailable){
                                 [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, 50)];
                                 }
                                 [self.displayContainer setFrame:displayViewFrame];
                                 [self.backgroundToolBar setFrame:displayViewFrame];
                                 [self.buttonsCollection setFrame: buttonsCollectionViewBounds];
                                 [self.historyTableSviper setFrame:sviperRect]; //STOP to checked self.history table HERE!!
                                 
                                 [self.SettingsView setFrame:settingsViewframe];
                                 [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                                 
                                 
                                 self.display.alpha = .0;
                                 
                                 //allow show settings button only in paid version
                                 if(self.wasPurshaised) self.settingsButton.alpha = 1.;
                                 self.downButton.alpha = 1.;
                                 
                             } completion:^(BOOL finihed){
                                 if(!self.wasPurshaised){
                                         //enable buttons to buy product
                                    self.keyboardDefaultButton.enabled = NO;
                                    [self.keyboardDefaultButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
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
                                        self.keyboardDefaultButton.titleLabel.textColor = [UIColor grayColor];
                                    }

                                     //if no paid version show at moment only setting view
                                     //not allow user change buttons
                                    CGRect settingsViewNewframe = self.SettingsView.frame;
                                    settingsViewNewframe.origin.y = self.display.bounds.size.height;
                                    [self.SettingsView setFrame:settingsViewNewframe];
                                    [self.settingsBackgroundToolBar setFrame:settingsViewNewframe];
                                     
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
                         }];
        
    } else {
        
        
        CGRect settingsViewframe = self.SettingsView.frame;
        
        settingsViewframe.origin.y = 0;
        [self.SettingsView setFrame:settingsViewframe];
        [self.settingsBackgroundToolBar setFrame:settingsViewframe];
        
        if(!self.wasPurshaised){
            //enable buttons to buy product
            self.keyboardDefaultButton.enabled = NO;
            [self.keyboardDefaultButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
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
                self.keyboardDefaultButton.titleLabel.textColor = [UIColor grayColor];
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
    
}

- (IBAction)tapSettingsButton:(UIButton *)sender
{

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
                         }];
        
    } else {
        
        
        CGRect settingsViewframe = self.SettingsView.frame;
        settingsViewframe.origin.y = self.display.bounds.size.height;
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

    CGRect historyTableFrame = self.historyTable.frame; //ok
    historyTableFrame.origin.y = 0;
    historyTableFrame.size.height = self.histroryTableViewHeight;//ok
    
    //set banner frame at discarding changin to apropriate hight (according height of last rows)
    //CGRect iAdBannerFrame = self.bannerContainerView.frame;
    //iAdBannerFrame.origin.y = self.iAdBannerOriginHeight;
    
    CGRect displayViewFrame = self.displayContainer.frame;
    displayViewFrame.origin.y = self.histroryTableViewHeight;//ok
    
    CGRect buttonsCollectionViewBounds = self.mainContainerView.bounds;
    buttonsCollectionViewBounds.origin.y = self.histroryTableViewHeight;
    buttonsCollectionViewBounds.size.height = self.mainContainerView.bounds.size.height - self.histroryTableViewHeight;
    
    CGRect sviperRect = self.historyTableSviper.frame;
    sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.frame.size.width)/2;
    sviperRect.origin.y = displayViewFrame.origin.y - self.historyTableSviper.frame.size.height;
    
    CGPoint histroyContentSizePoint = CGPointMake(0, self.historyTable.contentSize.height - self.histroryTableViewHeight);
    
    CGRect settingsViewframe = self.SettingsView.frame;
    if(self.isBottomSettingsViewOnScreen){
        settingsViewframe.origin.y = displayViewFrame.origin.y - settingsViewframe.size.height;
    } else {
        settingsViewframe.origin.y = displayViewFrame.origin.y + displayViewFrame.size.height;
    }
    settingsViewframe.origin.x = - self.mainContainerView.bounds.size.width;
    
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.historyTable setFrame:historyTableFrame];
                         //set banner frame at discarding changin to apropriate hight (according height of last rows)
                         //if(self.isIAdBaneerAvailable) [self.bannerContainerView setFrame:iAdBannerFrame];
                         
                         if(self.isIAdBannerOnScreen){
                             [self.bannerContainerView setFrame:CGRectMake(0, 0, self.mainContainerView.bounds.size.width, 50)];
                         }
                        
                         [self.displayContainer setFrame:displayViewFrame];
                         [self.backgroundToolBar setFrame:displayViewFrame];
                         [self.buttonsCollection setFrame: buttonsCollectionViewBounds];
                         [self.buttonsCollection setContentOffset:CGPointZero];
                         
                         [self.SettingsView setFrame:settingsViewframe];
                         [self.settingsBackgroundToolBar setFrame:settingsViewframe];
                         
                         [self.historyTableSviper setFrame:sviperRect];
                         self.historyTableSviper.alpha = 1.;
                         self.display.alpha = 1.;
                         
                         self.settingsBottomButtn.alpha = 0.;
                         self.noticeButton.alpha = 0.;
                         self.recountButton.alpha = 0.;
                         self.upButton.alpha = 0.;
                         self.deleteButton.alpha = 0.;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised) self.settingsButton.alpha = 0.;
                         self.downButton.alpha = 0.;
                         
                         [self.historyTable setContentOffset:histroyContentSizePoint];
                         
                     } completion:^(BOOL finished){
                         CGRect rect = self.historyTable.frame;
                         rect.origin.y = self.historyTable.contentSize.height - self.historyTable.frame.size.height;
                         [self.historyTable scrollRectToVisible:rect animated:NO];
                         self.settingsBottomButtn.hidden = YES;
                         self.noticeButton.hidden = YES;
                         self.recountButton.hidden = YES;
                         self.upButton.hidden = YES;
                         self.deleteButton.hidden = YES;
                         //allow show settings button only in paid version
                         if(self.wasPurshaised) self.settingsButton.hidden = YES;
                         self.downButton.hidden = YES;
                         self.isSettingsViewOnScreen = NO;
                         self.isBottomSettingsViewOnScreen = NO;
                         if(!self.wasPurshaised){
                             [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         }
                         if(self.isSoundOn){
                             AudioServicesPlaySystemSound (_blankSoundFileObject);
                         }
                         //
                         [self.buttonsCollection reloadData];
                         self.buttonsCollection.scrollEnabled = YES;
                     }];
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.historyTable.isNeedToSetOffsetToButton = YES;
    }
    
    //set to 0 indication of previous rotation, also need at discard changing
    //self.wasRightShowed = 0;

    
}

- (IBAction)tapFixButton:(UIButton*)sender
{
    if(!self.animationTimer.isValid){
        [self discardChanging];
        /*
        //dont think its necessary now
        if(self.heightsOfRows.count <=2){
            [self hideIAdBaner];
            [self showIAdBannerInTime];
        }
        */
    }
}
#pragma mark sviper gesture recognizer
- (IBAction)sviperRecognizer:(id *)sender
{
    
    CGRect displayViewFrame = self.displayContainer.frame;
    displayViewFrame.origin.y = self.view.frame.size.height - self.displayContainer.frame.size.height;
    
    CGRect historyTableFrame = self.historyTable.frame;//ok
    historyTableFrame.origin.y = 0;
    historyTableFrame.size.height = displayViewFrame.origin.y;
    
    CGRect sviperRect = self.historyTableSviper.frame;//may be need to be checked
    sviperRect.origin.y = displayViewFrame.origin.y - self.historyTableSviper.frame.size.height;
    
    CGRect buttonsCollectionViewBounds = self.view.frame;
    buttonsCollectionViewBounds.size.height = self.view.frame.size.height;
    buttonsCollectionViewBounds.origin.y = self.view.frame.size.height;
    
    CGPoint histroyContentSizePoint = CGPointMake(0, self.historyTable.contentSize.height - historyTableFrame.size.height);//not shure
    

    self.settingsBottomButtn.hidden = NO;
    self.noticeButton.hidden = NO;
    self.recountButton.hidden = NO;
    self.upButton.hidden = NO;
    self.deleteButton.hidden = NO;
    
    [UIView animateWithDuration:.38
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.historyTable setFrame:historyTableFrame];
                         [self.displayContainer setFrame:displayViewFrame];
                         [self.backgroundToolBar setFrame:displayViewFrame];
                         [self.buttonsCollection setFrame: buttonsCollectionViewBounds];
                         [self.historyTableSviper setFrame:sviperRect];
                         //[self.bannerContainerView setFrame:bannerIAdRect];
                         self.display.alpha = .0;
                         self.historyTableSviper.alpha = .0;
                         
                         self.settingsBottomButtn.alpha = 1.;
                         self.noticeButton.alpha = 1;
                         self.recountButton.alpha = 1;
                         self.upButton.alpha = 1;
                         self.deleteButton.alpha = 1;
                         
                         [self.historyTable setContentOffset:histroyContentSizePoint];
                     } completion:^(BOOL finished){
                         
                         
                     }];
    
    if([self.historyTable numberOfRowsInSection:0] >1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];

       if(!self.selectedRow || (self.selectedRow == [self.historyTable cellForRowAtIndexPath:lastRowPatch])){
            
            [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
        } else {
           [self.historyTable selectRowAtIndexPath:[self.historyTable indexPathForCell:self.selectedRow] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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
    if([cell isKindOfClass:[NewButtonsCollectionViewCell class]]){
        NSInteger item = indexPath.item;
        if(self.isButtonsCollectionUnderChanging){
            ButtonObject *button = [self.allButtonObj objectAtIndex:item];
            
            
            ((NewButtonsCollectionViewCell *)cell).collectionViewOffset = self.buttonsCollection.contentOffset; //nessesary for pressed button view
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
            ((NewButtonsCollectionViewCell *)cell).collectionViewOffset = self.buttonsCollection.contentOffset; //nessesary for pressed button view
            
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
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        UIInterfaceOrientation cachedOrientation = [self interfaceOrientation];
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationFaceUp ||
            orientation == UIDeviceOrientationFaceDown) {
            
            orientation = (UIDeviceOrientation)cachedOrientation;
        }
        if(UIDeviceOrientationIsPortrait(orientation)){
            result = CGSizeMake(140, 83);
        } else if (UIDeviceOrientationIsLandscape(orientation)){
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
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        UIInterfaceOrientation cachedOrientation = [self interfaceOrientation];
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationFaceUp ||
            orientation == UIDeviceOrientationFaceDown) {
            
            orientation = (UIDeviceOrientation)cachedOrientation;
        }
        if(UIDeviceOrientationIsPortrait(orientation)){
            collectionWidth = 768;
        } else if (UIDeviceOrientationIsLandscape(orientation)){
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
        insets.top = 119;
        insets.left = 11;
        insets.right = 11;
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

-(NSArray*) heightsOfRows
{
    if(!_heightsOfRows){
        NSArray * fetchedObjects = self.fetchedResultsController.fetchedObjects;
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
         if([fetchedObjects count] > 0){
            
            for(int i = 0; i < [fetchedObjects count]; i++){
                CGFloat height;
                if(IS_IPAD){ // if iPad
                    height = 75;
                } else {
                    height = 55;
                }
                NSAttributedString* stringInCell = [self getAttributedStringFronFetchForIndexPatch:[NSIndexPath indexPathForItem:i inSection:0]];
                NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
                CGSize neededSize = CGSizeMake(280, 1000);
                CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:drawContext];
                if(IS_IPAD){
                    if(neededRect.size.height > 60.){
                        height = neededRect.size.height + 15;
                    }
                } else {
                    if(neededRect.size.height > 42.){
                        height = neededRect.size.height + 13;
                    }
                }
                
                if(i == ([fetchedObjects count]-1)){
                    NSAttributedString* stringInCell = [self resizeStrforFirstCell:[self getAttributedStringFronFetchForIndexPatch:[NSIndexPath indexPathForItem:i inSection:0]]];
                    
                    neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:drawContext];
                    
                    //set heigth of first cell according ios screen
                    if(IS_IPAD){ // if iPad
                        height = 85.;
                        if(neededRect.size.height > 60.){
                            height = neededRect.size.height * 1.2 + 15;
                        }
                    } else
                    if(IS_568_SCREEN){
                        height = 65.;
                        if(neededRect.size.height > 48.){
                            height = neededRect.size.height * 1.2 + 13;
                        }
                    } else {
                        height = 60.;
                        if(neededRect.size.height > 43.){
                            height = neededRect.size.height *1.2 + 13;
                        }
                    }
                }
                [mutArray addObject:[NSNumber numberWithFloat:height]];
            }
        } else {
            
        }
        _heightsOfRows = [mutArray copy];
    }
    return _heightsOfRows;
}

-(void) resetHeightsofRows
{
    NSArray * fetchedObjects = self.fetchedResultsController.fetchedObjects;
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    if([fetchedObjects count] > 0){
        //if([fetchedObjects count] >1 ){
        
        for(int i = 0; i < [fetchedObjects count]; i++){
            CGFloat height;
            if(IS_IPAD){ // if iPad
                height = 75;
            } else {
                height = 55;
            }
            NSAttributedString* stringInCell = [self getAttributedStringFronFetchForIndexPatch:[NSIndexPath indexPathForItem:i inSection:0]];
            NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
            CGSize neededSize = CGSizeMake(280, 1000);
            CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:drawContext];
            if(IS_IPAD){
                if(neededRect.size.height > 60.){
                    height = neededRect.size.height + 15;
                }
            } else {
                if(neededRect.size.height > 42.){
                    height = neededRect.size.height + 13;
                }
            }
            
            if(i == ([fetchedObjects count]-1)){
                NSAttributedString* stringInCell = [self resizeStrforFirstCell:[self getAttributedStringFronFetchForIndexPatch:[NSIndexPath indexPathForItem:i inSection:0]]];
                
                neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading
                                                        context:drawContext];
                //set heigth of first cell according ios screen
                if(IS_IPAD){ // if iPad
                    height = 85.;
                    if(neededRect.size.height > 60.){
                        height = neededRect.size.height * 1.2 + 15;
                    }
                } else
                    if(IS_568_SCREEN){
                        height = 65.;
                        if(neededRect.size.height > 48.){
                            height = neededRect.size.height * 1.2 + 13;
                        }
                    } else {
                        height = 60.;
                        if(neededRect.size.height > 43.){
                            height = neededRect.size.height + 18;
                        }
                    }
                
            }
            [mutArray addObject:[NSNumber numberWithFloat:height]];
        }
    } else {
        
    }
    self.heightsOfRows = [mutArray copy];
}


-(NSMutableAttributedString*) getAttributedStringFronFetchForIndexPatch:(NSIndexPath*) indexPath
{
    History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSMutableArray *programFromHistory = [[NSKeyedUnarchiver unarchiveObjectWithData:story.program] mutableCopy];
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
            font = [UIFont fontWithName:fontName size:wasFont.pointSize*1.1];
        }else {
            font =[UIFont boldSystemFontOfSize:wasFont.pointSize*1.1];
        }
        UIColor *textColor = [UIColor darkTextColor];
        
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
        History *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSMutableAttributedString * resultAtrStr = [self getAttributedStringFronFetchForIndexPatch:indexPath];
        
        
        ((HistroryTableViewCell*)cell).delegate = self;
        
        if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            ((HistroryTableViewCell*)cell).isCanDrag = NO;
            ((HistroryTableViewCell*)cell).historyDateString = @"";
            ((HistroryTableViewCell*)cell).historyProgramString = [self resizeStrforFirstCell:[resultAtrStr copy]];
            
            if(![self.historyTable indexPathForSelectedRow]){
                [self.historyTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            }
        } else {
            ((HistroryTableViewCell*)cell).historyProgramString = [resultAtrStr copy];
            ((HistroryTableViewCell*)cell).isCanDrag = YES;
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
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return one more rows than in fatched result controller
    NSInteger rows = 0;
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    
    if(rows == 0){
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

/*
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //think it not necessary now
    //need set very first row "WELCOME
    
    if([scrollView isKindOfClass:[HistoryTableView class]]){
        if(self.isIAdBaneerAvailable) [self hideIAdBaner];
        
    }
 

}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //think it not necessary now
    //need set very first row "WELCOME
    
    if([scrollView isKindOfClass:[HistoryTableView class]]){
        if(self.isIAdBaneerAvailable) [self showIAdBannerInTime];
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
    self.historyTable.isNeedToSetOffsetToButton = NO;
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
}

#pragma mark - FETCHING
- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            
        } else {

        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];

    } else {

    }
    [self resetHeightsofRows];
    [self.historyTable reloadData];

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
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.historyTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.historyTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.historyTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:{
            
            NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
            
            //CGFloat height = 55;
            CGFloat height;
            if(IS_IPAD){ // if iPad
                height = 75;
            } else {
                height = 55;
            }
            
            if([self.historyTable numberOfRowsInSection:newIndexPath.section]>0){
            //if([self.fetchedResultsController.fetchedObjects count] > 1){
                NSIndexPath *patchOfPrevious = [NSIndexPath indexPathForRow:newIndexPath.row-1 inSection:newIndexPath.section];
                NSAttributedString* stringInCell = [self getAttributedStringFronFetchForIndexPatch:patchOfPrevious];
                NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
                CGSize neededSize = CGSizeMake(280, 1000);
                CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading
                                                               context:drawContext];
                if(IS_IPAD){
                    if(neededRect.size.height > 60.){
                        height = neededRect.size.height + 15;
                    }
                } else {
                    if(neededRect.size.height > 42.){
                        height = neededRect.size.height + 13;
                    }
                }
                
                //previous
                [mutArray removeLastObject];
                [mutArray addObject:[NSNumber numberWithFloat:height]];
            }
            
            //curent
            if(IS_IPAD){ // if iPad
                [mutArray addObject:[NSNumber numberWithFloat:85.]];
            } else

            if(IS_568_SCREEN){
                [mutArray addObject:[NSNumber numberWithFloat:65.]];
            } else {
                [mutArray addObject:[NSNumber numberWithFloat:60.]];
            }
            
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
            
            self.heightsOfRows = [mutArray copy];
            //replace row above
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
            
            
        }
            
            break;
            
        case NSFetchedResultsChangeDelete: {
            
            NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
            [mutArray removeObjectAtIndex:indexPath.row];
            self.heightsOfRows = [mutArray copy];
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
            break;
            
        case NSFetchedResultsChangeUpdate:{
            
            NSMutableArray *mutArray = [self.heightsOfRows mutableCopy];
            //CGFloat height = 60;
            CGFloat height;
            if(IS_IPAD){ // if iPad
                height = 85;
            } else {
                height = 60;
            }

            if(self.heightsOfRows.count > 0){
                height = [[mutArray objectAtIndex:indexPath.row] floatValue];
                [mutArray removeObjectAtIndex:indexPath.row];
            }
            
            NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
            CGSize neededSize = CGSizeMake(280, 1000);
            if(indexPath.row == [mutArray count]){
                NSAttributedString* stringInCell = [self resizeStrforFirstCell:[self getAttributedStringFronFetchForIndexPatch:indexPath]];
                
                CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading
                                                               context:drawContext];
                if(IS_IPAD){ // if iPad
                    height = 85.;
                    if(neededRect.size.height > 60.){
                        height = neededRect.size.height * 1.2 + 15;
                    }
                } else

                if(IS_568_SCREEN){
                    if(neededRect.size.height > 48.){
                        height = neededRect.size.height + 18;
                    }
                } else {
                    if(neededRect.size.height > 43.){
                        height = neededRect.size.height + 18;
                    }
                }
                
                
                [mutArray insertObject:[NSNumber numberWithFloat:height] atIndex:indexPath.row];
                
                //if(height != wasHeight){
                    self.heightsOfRows = [mutArray copy];
                //}
                [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            } else {
                NSAttributedString* stringInCell = [self getAttributedStringFronFetchForIndexPatch:indexPath];
                CGRect neededRect = [stringInCell boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading
                                                               context:drawContext];
                /*
                if(neededRect.size.height > 42.){
                    height = neededRect.size.height + 18;
                    
                }
                */
                if(IS_IPAD){ // if iPad
                    height = 85.;
                    if(neededRect.size.height > 60.){
                        height = neededRect.size.height * 1.2 + 15;
                    }
                } else
                    if(IS_568_SCREEN){
                        height = 65.;
                        if(neededRect.size.height > 48.){
                            height = neededRect.size.height * 1.2 + 13;
                        }
                    } else {
                        height = 60.;
                        if(neededRect.size.height > 43.){
                            height = neededRect.size.height *1.2 + 13;
                    }
                }
                
                [mutArray insertObject:[NSNumber numberWithFloat:height] atIndex:indexPath.row];
                
                self.heightsOfRows = [mutArray copy];

                [self.historyTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.historyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.historyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
    
    //NSError *error = nil;
    //[self.managedObjectContext save:&error];
   
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.historyTable endUpdates];
    NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
    [self.historyTable selectRowAtIndexPath:lastRowPatch animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
}


#pragma mark SHOW VIEW

-(void) showCount
{
    if([self.historyTable numberOfRowsInSection: 0] >0){
        NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
        if(!indexPath) indexPath = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        NSMutableAttributedString *atrStrFromString =  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        if(atrStrFromString.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                
                
                NSString *lastSymbol = [atrStrFromString.string substringWithRange:NSMakeRange(atrStrFromString.string.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    [atrStrFromString insertAttributedString:self.display.attributedText atIndex:atrStrFromString.length];
                }
            }
            
        }
        
        if(![atrStrFromString.string isEqualToString:[self.viewToPDF stringOnScreen]]){
            NSAttributedString * count;
            NSAttributedString *result;
            NSRange equalRange = [atrStrFromString.string rangeOfString:@"="];
            if(equalRange.location == NSNotFound){
                count = [atrStrFromString copy];
                result = [[NSAttributedString alloc] initWithString:@""];
            } else {
                count = [atrStrFromString attributedSubstringFromRange:NSMakeRange(0, equalRange.location +1)];
                result = [atrStrFromString attributedSubstringFromRange:NSMakeRange(equalRange.location +1, atrStrFromString.length - equalRange.location -1)];
            }
            
            [self.viewToPDF setShowedViewWithCountedStr:count resultStr:result andBluePan:YES];
            
            //set new image for that button
            [self.redPanButton setImage:[UIImage imageNamed:@"redPanUnselected2.png"] forState:normal];
            [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanSelected2.png"] forState:normal];
        }
    }
    //NSAttributedString
}

//tapped at share button in showed view
- (IBAction)tapeShareButton:(id)sender
{
    
    UIGraphicsBeginImageContextWithOptions(self.viewToPDF.bounds.size, self.viewToPDF.opaque, 0.0);
    [self.viewToPDF.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects:img, /*strToShare, */nil];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc]
                                          initWithActivityItems:activityItems
                                          applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact];
    [self presentViewController:activity animated:YES completion:nil];
    //activity.
    
}

- (IBAction)tabBluePanButton:(id)sender
{
    self.viewToPDF.isBluePanOrRed = YES;
    //set new image for that button
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanUnselected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanSelected2.png"] forState:normal];
    
    //!!
    //need to set new image for red button
}

- (IBAction)tapRedPanButton:(id)sender
{
    self.viewToPDF.isBluePanOrRed = NO;
    //set new image for that button
    //!!
    //need to set new image for red button
    [self.redPanButton setImage:[UIImage imageNamed:@"redPanSelected2.png"] forState:normal];
    [self.bluePanButton setImage:[UIImage imageNamed:@"bluePanUnselected2.png"] forState:normal];
    
}

- (IBAction)tapClearButton:(UIButton *)sender
{
    [self.viewToPDF clearPaintedView];
}

//tapped at share button in table condition
- (IBAction)tappedNoticeButton:(UIButton *)sender
{
    //sharing resulr of counting
    if([self.historyTable numberOfRowsInSection:0] > 0) {
    
        NSIndexPath *indexPath = [self.historyTable indexPathForCell:self.selectedRow];
        if(!indexPath) indexPath = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        NSMutableAttributedString *atrStrFromString =  [[self getAttributedStringFronFetchForIndexPatch:indexPath] mutableCopy];
        NSString *strToShare = atrStrFromString.string;
        if(strToShare.length >0){
            if(indexPath.row == [self.historyTable numberOfRowsInSection: 0] - 1){
                NSString *lastSymbol = [strToShare substringWithRange:NSMakeRange(strToShare.length -1, 1)];
                if([lastSymbol isEqualToString: @"="]){
                    NSAttributedString *result = [[NSAttributedString alloc] initWithString:self.display.attributedText.string attributes:self.attributes];
                    [atrStrFromString insertAttributedString:result atIndex:atrStrFromString.length];
                }
            }
        
        
            NSArray *activityItems = [[NSArray alloc] initWithObjects:atrStrFromString, nil];
        
            UIActivityViewController *activity = [[UIActivityViewController alloc]
                                                  initWithActivityItems:activityItems
                                                  applicationActivities:nil];
            activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
            [self presentViewController:activity animated:YES completion:nil];
        }
        
    }
    
}

-(void) isDurtyShovedView
{
    if(self.viewToPDF.isDurty){
        self.cleanButton.enabled = YES;
    } else {
        self.cleanButton.enabled = NO;
    }
}

//attach the gesture recognizer for line drawing to viewToPDF
-(void) setViewToPDF:(ShowedView *)viewToPDF
{
    _viewToPDF = viewToPDF;
   // [self.viewToPDF addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.viewToPDF action:@selector(drawLine:)]];
}

#pragma mark VIEW LAYOUT

-(void) setLayOutOfSettingsView
{
    
    CGFloat measure = (self.mainContainerView.bounds.size.height - self.displayContainer.frame.size.height )/ 6;
    
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
    CGRect sounOffFrame = self.soundOffView.frame;
    sounOffFrame.origin.y =2 * measure - sounOffFrame.size.height / 2;
    [self.soundOffView setFrame:sounOffFrame];
    CGRect soundOnFrame = self.soundOnView.frame;
    soundOnFrame.origin.y = 2 * measure - soundOnFrame.size.height / 2;
    [self.soundOnView setFrame:soundOnFrame];
    
    CGRect bigDataSwitcher = self.isBigDataBaseSwitcher.frame;
    bigDataSwitcher.origin.y = 3 * measure - bigDataSwitcher.size.height / 2;
    [self.isBigDataBaseSwitcher setFrame:bigDataSwitcher];
    CGRect smallDataFrame = self.smallDataBaseView.frame;
    smallDataFrame.origin.y =3 * measure - smallDataFrame.size.height / 2;
    [self.smallDataBaseView setFrame:smallDataFrame];
    CGRect bigDataFrame = self.bigDataBaseView.frame;
    bigDataFrame.origin.y = 3 * measure - bigDataFrame.size.height / 2;
    [self.bigDataBaseView setFrame:bigDataFrame];
    
    CGRect clearHistoryButtonFrame = self.clearHistoryButton.frame;
    clearHistoryButtonFrame.origin.y = 4 * measure - clearHistoryButtonFrame.size.height / 2;
    self.clearHistoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.clearHistoryButton setFrame:clearHistoryButtonFrame];
    [self.clearHistoryButton setTitle:TITLE_CLEAR_HISTORY_BUTTON forState:UIControlStateNormal];
    
    CGRect keyboarddefaultButtonFrame = self.keyboardDefaultButton.frame;
    keyboarddefaultButtonFrame.origin.y = 5 * measure - keyboarddefaultButtonFrame.size.height / 2;
    [self.keyboardDefaultButton setFrame:keyboarddefaultButtonFrame];
    self.keyboardDefaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if(self.wasPurshaised){
        [self.keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
    } else {
        [self.keyboardDefaultButton setTitle:BUY_REQUEST_BUTTON forState:UIControlStateNormal];
    }
}

-(void) setHeightOfElementAccordingToScreenIPhone
{
    CGRect buttonsRect = CGRectMake(0, 0, 60, 60);
    if(IS_IPAD){
        //for ipad try through autolayout
        /*
        self.histroryTableViewHeight = 182.f;
        self.labelViewHeight = 108.f;
        self.lastRowHistoryTableHeight = 85.f;
        */
        
        [self.testView setFrame:CGRectMake(-1280,0, 1280, 1280)];
        
        [self.viewToPDF setFrame:CGRectMake(128, 256, 1024, 768)];
        
        //need to be changed
        buttonsRect.origin.x = 60;
        buttonsRect.origin.y = 176;
        [self.shareButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.redPanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.bluePanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.cleanButton setFrame:buttonsRect];
        //else if iPhone
    } else if(IS_568_SCREEN){
        self.histroryTableViewHeight = 136.f;
        self.labelViewHeight = 72.f;
        self.lastRowHistoryTableHeight = 65.f;
        
        //[self.testView setFrame:CGRectMake(-166, -166, 652, 652)];
        [self.testView setFrame:CGRectMake(-652,0, 652, 652)];

        [self.viewToPDF setFrame:CGRectMake(42, 166, 568, 320)];
        
        buttonsRect.origin.x = 60;
        buttonsRect.origin.y = 176;
        [self.shareButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.redPanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.bluePanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.cleanButton setFrame:buttonsRect];
        
        
        //STOP HERE
        //self.displayBaseLineOffset =[NSNumber numberWithFloat:0];
    } else {
        self.histroryTableViewHeight = 112.f;
        self.labelViewHeight = 65;
        self.lastRowHistoryTableHeight = 60.f;
        
        //[self.testView setFrame:CGRectMake(-42, -164, 577, 577)];
        [self.testView setFrame:CGRectMake(-577, 0, 577, 577)];

        [self.viewToPDF setFrame:CGRectMake(48, 128, 480, 320)];
        
        
        buttonsRect.origin.x = 70;
        buttonsRect.origin.y = 140;
        [self.shareButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.redPanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.bluePanButton setFrame:buttonsRect];
        buttonsRect.origin.y += 80;
        [self.cleanButton setFrame:buttonsRect];
        

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

- (void)viewDidLoad
{
    //for testing delegate
    //set Hegths of ellement according screen height
    [self setHeightOfElementAccordingToScreenIPhone];
    
    //init managed document
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSString* documentName = @"MyDocument.sqlite";

    NSURL *storeURL = [documentsDirectory
                       URLByAppendingPathComponent:documentName];
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"History" withExtension:@"mom"];
    //NSLog(@"modelURL: %@", modelURL);
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
                                                 initWithManagedObjectModel:model];
    NSDictionary *storeOptions =
    @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore"};
    
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                         configuration:nil
                                                                   URL:storeURL
                                                               options:storeOptions
                                                                 error:&error];
    NSURL *finaliCloudURL = [store URL];
    //NSLog(@"finaliCloudURL: %@", finaliCloudURL);
    
    NSURL *iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];
   // NSLog(@"iCloud: %@", iCloud);

    
    //NSURL *myUrl = [documentsDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:storeURL];
    //question ? the string before the same
    //document = [[UIManagedDocument alloc] initWithFileURL:myUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady: document];
        }];
    } else {
        [document saveToURL:storeURL forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) [self documentIsReady: document];
          }];
    }
    //try to save core data through update document
    self.doc = document;
    
    
    [super viewDidLoad];
    
    if(!IS_IPAD){ //make ipads in auto layout
    
        [self.historyTable setFrame:CGRectMake(0, 0, self.mainContainerView.bounds.size.width, self.histroryTableViewHeight)];
        CGRect displayViewFrame = CGRectMake(0,
                                             self.histroryTableViewHeight,
                                             self.mainContainerView.bounds.size.width,
                                             self.labelViewHeight);//self.displayContainer.frame;
        displayViewFrame.origin.y = self.histroryTableViewHeight;
        [self.displayContainer setFrame:displayViewFrame];
        [self.buttonsCollection setFrame:CGRectMake(0,
                                                    self.histroryTableViewHeight,
                                                    self.mainContainerView.bounds.size.width,
                                                    self.mainContainerView.bounds.size.height - self.histroryTableViewHeight)];
    }
    
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    UIGraphicsEndImageContext();
    //set manage buttons
    [self.settingsBottomButtn setImage:[UIImage imageNamed:@"settingsBig2.png"] forState:UIControlStateNormal];
    [self.noticeButton setImage:[UIImage imageNamed:@"share60Blue2.png"]  forState:UIControlStateNormal];
    [self.recountButton setImage:[UIImage imageNamed:@"Rec2.png"]  forState:UIControlStateNormal];
    [self.recountButton setImage:[UIImage imageNamed:@"RecBigDisable2.png"]  forState:UIControlStateDisabled];
    [self.upButton setImage:[UIImage imageNamed:@"Up2.png"]  forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"deleteBig2.png"]  forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"DelBigDisable2.png"]  forState:UIControlStateDisabled];
    [self.downButton setImage:[UIImage imageNamed:@"Down2.png"]  forState:UIControlStateNormal];
    [self.settingsButton setImage:[UIImage imageNamed:@"settingsBig2.png"]  forState:UIControlStateNormal];
    
    [self.cleanButton setImage:[UIImage imageNamed:@"cleanDisable2.png"] forState:UIControlStateDisabled];
    [self.cleanButton setImage:[UIImage imageNamed:@"clear60Blue2.png"] forState:UIControlStateNormal];
    
    self.settingsBottomButtn.hidden = YES;

    
    self.noticeButton.hidden = YES;
    self.noticeButton.enabled = NO;
    
    self.recountButton.hidden = YES;
    self.recountButton.enabled = NO;
    
    self.upButton.hidden = YES;
    
    self.deleteButton.hidden = YES;
    self.deleteButton.enabled = NO;
    
    self.settingsButton.hidden = YES;
    self.downButton.hidden = YES;
    
    //set pan gesture delegate
    self.moveButtonsPanGestureRecognizer.delegate = self;
    self.isThreadInWork = NO;
    
    //USER DEFAULT
    id userDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"wholeArray"];
    if(userDefault && [self extractFromUserDefault:userDefault]){
        [self.display showString:[self.displayRam setResult:self.displayRam.resultNumber]];
        [self showStringThruManageDocument];
    } else {
        //memory label
        self.display.firstMemoryLabel.text = @"";
        self.display.secondMemoryLabel.text = @"";
        self.display.decRadLabel.text = @"DEG";
        self.userIsInTheMidleOfEnteringNumber = YES;
        self.isProgramInProcess = NO;
        self.isStronglyArgu = NO;
        self.isResultFromMemory = NO;
        self.isDecCounting = YES;
        self.isBigDataBase = NO;
        self.isBigSizeButtons = NO;
        self.isSoundOn = YES;
        self.self.lastShowAllertViewDate = [NSDate date];
        self.counterForShowingAllertView = 26;
        
        [self.displayRam clearRam];
        [self.display showString:[self.displayRam addSymbol:@0]];
    }
    self.isSettingsViewOnScreen = NO;
    self.isBottomSettingsViewOnScreen = NO;
    
    self.historyTable.allowsMultipleSelectionDuringEditing = NO;
    self.historyTable.allowsMultipleSelection = NO;
    
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
    
    // Request to turn on accelerometer and begin receiving accelerometer events
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
     */
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isDurtyShovedView) name:@"ShowedViewIsDirtyNotification" object:nil];
    
    
    self.testView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];

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

        [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, 50)];
        self.bannerRequestCounter = 2;

        
    }
    
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
}

-(void) viewWillAppear:(BOOL)animated{

    
    if(self.isSoundOn){
        AudioServicesPlaySystemSound (_blankSoundFileObject);
    }
   // self.timesRequestToHideIAdBanner = 0;
    [self.buttonsCollection reloadData];
    [super viewWillAppear:animated];
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!IS_IPAD) {//for ipad try to set autolayout

        self.displayContainer.frame = CGRectMake(0,
                                                 self.historyTable.bounds.size.height + self.historyTable.frame.origin.y,
                                                 self.mainContainerView.bounds.size.width,
                                                 self.labelViewHeight);
        CGRect sviperRect = self.historyTableSviper.frame;
        sviperRect.origin.x = (self.mainContainerView.bounds.size.width - self.historyTableSviper.bounds.size.width)/2;
        sviperRect.origin.y = self.displayContainer.frame.origin.y - self.historyTableSviper.bounds.size.height;
        [self.historyTableSviper setFrame:sviperRect];
    }
    //--------------------------------------------------------------------------
    
    self.backgroundToolBar.frame = self.displayContainer.frame;
    
    self.settingsBackgroundToolBar.frame = self.SettingsView.frame;
    
    self.display.frame = self.displayContainer.bounds;
    
    //set size buttonsViews and frames
    struct Color clr;
    clr.r = 0.95;//0.26;
    clr.g = 0.95;//0.57;
    clr.b = 0.95;//0.70;
    clr.a = 1.0;
    
    self.smallButtonView.backgroundColor = [UIColor clearColor];
    newButtonView *smalButtonLook = [[newButtonView alloc] initWithFrame:self.smallButtonView.bounds];
    smalButtonLook.title = @"=";
    smalButtonLook.buttonColor = clr;
    [self.smallButtonView addSubview:smalButtonLook];
    
    self.bigbuttonView.backgroundColor = [UIColor clearColor];
    newButtonView *bigButtonLook = [[newButtonView alloc] initWithFrame:self.bigbuttonView.bounds];
    bigButtonLook.title = @"=";
    bigButtonLook.buttonColor = clr;
    [self.bigbuttonView addSubview:bigButtonLook];
    
    [self setLayOutOfSettingsView];
    
    if(self.wasPurshaised){
        self.downButton.center = CGPointMake(223, 36);
        
        self.settingsButton.center = CGPointMake(97, 36);
    } else {
        self.downButton.center = CGPointMake(160, 36);
    }
}

//only at real enter in foregraund not at launch
-(void) appWillEnterForeground
{
    
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
    [self discardChanging];
    
    if([self.historyTable numberOfRowsInSection:0] > 1){
        NSIndexPath *lastRowPatch = [NSIndexPath indexPathForRow:[self.historyTable numberOfRowsInSection: 0]-1  inSection:0];
        
        [self.historyTable selectRowAtIndexPath:lastRowPatch animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.historyTable.isNeedToSetOffsetToButton = YES;
    }
    
    [self deleteSuperfluousValuesFromManagedDocuments];
    
    //set to 0 indication of previous rotation, also need at discard changing
    //!!!!!!!
   // self.wasRightShowed = 0;
    
     //save managed object context
   // NSError *error = nil;
   // [self.managedObjectContext save:&error];
    //
    //-------
    [self.buttonsCollection reloadData];

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //[defaults setObject:self.workButtonsNames forKey:@"preWorkButtonsNames"];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [defaults synchronize];
}


-(void) appWillTerminate


{
    //save managed object context
    //NSError *error = nil;
    //[self.managedObjectContext save:&error];
     [self.doc updateChangeCount:UIDocumentChangeDone];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //[defaults setObject:self.workButtonsNames forKey:@"preWorkButtonsNames"];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [defaults synchronize];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
   // [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [super viewWillDisappear:animated];

}


#pragma mark FOR USER DEFAULT
-(NSArray*) arrayToUserDefault
{
    NSMutableArray *wholeArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    [controllerArray addObject:self.lastShowAllertViewDate];
    [controllerArray addObject:[NSNumber numberWithBool:self.userIsInTheMidleOfEnteringNumber]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isProgramInProcess]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isStronglyArgu]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isDecCounting]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isResultFromMemory]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigDataBase]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isBigSizeButtons]];
    [controllerArray addObject:[NSNumber numberWithBool:self.isSoundOn]];
    [controllerArray addObject:[NSNumber numberWithInteger:self.counterForShowingAllertView]];
    
    [wholeArray addObject:[controllerArray copy]];
    
    //[wholeArray addObject:[self.heightsOfRows copy]];
    
    [wholeArray addObject:[self.brain arrayToSaveBrain]];
    
    NSMutableArray *displayRamArray = [[NSMutableArray alloc] init];
    [displayRamArray addObject:self.displayRam.firstMemoryStack];
    [displayRamArray addObject:self.displayRam.secondMemoryStack];
    [displayRamArray addObject:self.displayRam.gradArray];
    [displayRamArray addObject:self.displayRam.resultNumber];
    [wholeArray addObject:[displayRamArray copy]];
    
    return [wholeArray copy];
    //settings for
}

-(BOOL) extractFromUserDefault:(NSArray*) array
{
    BOOL sucsess = YES;
    NSMutableArray *wholeArray = [array mutableCopy];
    
    //extract disaply
    id displayRamArray = [[wholeArray lastObject] mutableCopy];
    DisplayRam *newDisplayRam = [[DisplayRam alloc] init];
    newDisplayRam.delegate = self;
    if(displayRamArray && [displayRamArray isKindOfClass:[NSArray class]]){
        id top = [displayRamArray lastObject];
        if(top && [top isKindOfClass:[NSNumber class]]){
            newDisplayRam.resultNumber = top;
            [displayRamArray removeLastObject];
            top = [displayRamArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSArray class]]){
            newDisplayRam.gradArray = top;
            [displayRamArray removeLastObject];
            top = [displayRamArray lastObject];
        } else {
            sucsess = NO;
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
            sucsess = NO;
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
            sucsess = NO;
        }
        self.displayRam = newDisplayRam;
        
        [wholeArray removeLastObject];
        
    } else {
        sucsess = NO;
    }
    
    //set brain
    id brainArray = [wholeArray lastObject];
    if(brainArray && [brainArray isKindOfClass:[NSArray class]]){
        self.brain = [ACalcBrain brainFromSavedArray:brainArray];
        [wholeArray removeLastObject];
    } else {
        sucsess = NO;
    }
    
    //set controller
    id controllerArray = [[wholeArray lastObject] mutableCopy];
    if(controllerArray && [controllerArray isKindOfClass:[NSMutableArray class]]){
        
        id top = [controllerArray lastObject];
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.counterForShowingAllertView= [top integerValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isSoundOn = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isBigSizeButtons = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isBigDataBase = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isResultFromMemory = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isDecCounting = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isStronglyArgu = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.isProgramInProcess = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSNumber class]]){
            self.userIsInTheMidleOfEnteringNumber = [top boolValue];
            [controllerArray removeLastObject];
            top = [controllerArray lastObject];
        } else {
            sucsess = NO;
        }
        
        if(top && [top isKindOfClass:[NSDate class]]){
            self.self.lastShowAllertViewDate = top;
        } else {
            sucsess = NO;
        }
        
    } else {
        sucsess = NO;
    }
    
    return sucsess;
}

- (void)didReceiveMemoryWarning
{
    //------
    //
   // NSError *error = nil;
    //[self.managedObjectContext save:&error];
     [self.doc updateChangeCount:UIDocumentChangeDone];
    //
    //-------
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[self arrayToUserDefault] forKey:@"wholeArray"];
    [defaults synchronize];
    
    [super didReceiveMemoryWarning];
}

/*
-(BOOL) shouldAutorotate
{
    return NO;
}
*/

- (void)orientationChanged:(NSNotification *)notification
{
    //exept if it isn't IPad
    UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
    if(IS_IPAD){
        NSLog(@"Device orient:%d", orient);
        UIInterfaceOrientation cachedOrientation = [self interfaceOrientation];
        NSLog(@"Interface orient:%d", cachedOrientation);
        if (orient == UIDeviceOrientationUnknown ||
            orient == UIDeviceOrientationFaceUp ||
            orient == UIDeviceOrientationFaceDown) {
            
            orient = (UIDeviceOrientation)cachedOrientation;
        }
        NSLog(@"Now Device orient:%d", orient);

        if((orient <3)!= (self.wasRightShowed <3)) {
           // [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [self setUpMainButtonsStartWithPosition];
            [self makeTwoArrays];
            [self.buttonsCollection reloadData];
        }
        self.wasRightShowed = orient;
        

    } else {
    
    if(orient == UIDeviceOrientationLandscapeLeft){
        //if there ara hint view - remove it
        if(self.hintView){
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.hintView.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self.hintView removeFromSuperview];
                             }];
            
        }
        
        if(self.wasRightShowed != 1){
            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            //!!!! check if ios 8 set
            /*
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                // code here
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            } else {
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            }
            */
            // [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            
            if(!self.isButtonsCollectionUnderChanging){
                if(self.wasRightShowed == 0){
                    
                    //strongly think about it
                    [self showCount];
                    
                    [self.testView setTransform:CGAffineTransformMakeRotation(0)];

                    CGRect initialFrame = self.testView.frame;
                    initialFrame.origin.x =  (self.view.frame.size.height - initialFrame.size.height)/2;
                    initialFrame.origin.y = -self.testView.frame.size.height;
                    
                    [self.testView setFrame:initialFrame];
                    
                    int64_t delayInSeconds = 0.05;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //do something to the button(s)
                        [UIView setAnimationsEnabled:YES];
                        
                        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
                        gravity.gravityDirection = CGVectorMake(0.0, 4.0);
                        [animator addBehavior:gravity];
                        
                       UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.testView]];
                        CGFloat stopY;
                        
                        //check if ios 8
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                            stopY = self.view.frame.size.height + ( self.testView.frame.size.height  - self.view.frame.size.height ) / 2;
                        } else {
                            stopY = self.view.frame.size.width + ( self.testView.frame.size.height  - self.view.frame.size.width ) / 2;
                        }
                        
                       [collisionBehavior addBoundaryWithIdentifier:@"Right"
                                                        fromPoint:CGPointMake(0, stopY)
                                                            toPoint:CGPointMake(568, stopY)];
                       [animator addBehavior:collisionBehavior];
                        
                        UIDynamicItemBehavior *elastic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.testView]];
                        elastic.elasticity = 0.4;
                        [animator addBehavior:elastic];
                        
                        self.animator = animator;
                    });

                } else if(self.wasRightShowed == 2){
                   [self.testView setTransform:CGAffineTransformMakeRotation(-M_PI)];
                    int64_t delayInSeconds = 0.05;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //do something to the button(s)
                        [UIView setAnimationsEnabled:YES];
                        [UIView animateWithDuration:0.36
                                              delay:0
                                            options:UIViewAnimationOptionCurveLinear
                                         animations:^{
                                             [self.testView setTransform:CGAffineTransformMakeRotation(0)];
                                         } completion:^(BOOL finished) {
                                             
                                         }];
                    });
                }
                
            } else {
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //do something to the button(s)
                    [UIView setAnimationsEnabled:YES];
                });
            }
            self.wasRightShowed = 1;
        }
        
    } else if (orient == UIDeviceOrientationLandscapeRight){

        //if there ara hint view - remove it
        if(self.hintView){
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.hintView.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self.hintView removeFromSuperview];
                             }];
            
        }
        
        if(self.wasRightShowed != 2){
            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            
            //check if ios 8
            /*
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            } else {
            
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            }
            */
            [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            //strongly think about it
            
            if(!self.isButtonsCollectionUnderChanging){
                if(self.wasRightShowed == 0){
                //strongly think about it
                [self showCount];
                
                [self.testView setTransform:CGAffineTransformMakeRotation(0)];
                
                CGRect initialFrame = self.testView.frame;
                initialFrame.origin.x =  (self.view.frame.size.height - initialFrame.size.width)/2;
                initialFrame.origin.y = - self.testView.frame.size.height;
                
                [self.testView setFrame:initialFrame];
                
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //do something to the button(s)
                    [UIView setAnimationsEnabled:YES];
                    
                    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
                    gravity.gravityDirection = CGVectorMake(0.0, 4.0);
                    [animator addBehavior:gravity];
                    
                    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.testView]];
                    //check if ios 8
                    CGFloat stopY;
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                        stopY = self.view.frame.size.height + ( self.testView.frame.size.height  - self.view.frame.size.height ) / 2;
                    } else {
                        stopY = self.view.frame.size.width + ( self.testView.frame.size.height  - self.view.frame.size.width ) / 2;
                    }
                    
                    [collisionBehavior addBoundaryWithIdentifier:@"Right"
                                                       fromPoint:CGPointMake(0, stopY)
                                                         toPoint:CGPointMake(568, stopY)];
                    [animator addBehavior:collisionBehavior];
                    
                    UIDynamicItemBehavior *elastic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.testView]];
                    elastic.elasticity = 0.4;
                    [animator addBehavior:elastic];
                    
                    self.animator = animator;
                });
                
            } else if(self.wasRightShowed == 1){
                [self.testView setTransform:CGAffineTransformMakeRotation(M_PI)];
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //do something to the button(s)
                    [UIView setAnimationsEnabled:YES];
                    [UIView animateWithDuration:0.36
                                          delay:0
                                        options:UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         [self.testView setTransform:CGAffineTransformMakeRotation(0)];
                                     } completion:^(BOOL finished) {
                                         
                                     }];
                });
                }
            } else {
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //do something to the button(s)
                    [UIView setAnimationsEnabled:YES];
                });
            }

            self.wasRightShowed = 2;
        }
        
        
    } else if (orient == UIDeviceOrientationPortrait){
        if(self.wasRightShowed != 0){
            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(0)];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            } else {
                [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }
            
            if(!self.isButtonsCollectionUnderChanging){
                
                if(self.wasRightShowed == 1){
                    [self.testView setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
                } else if(self.wasRightShowed == 2){
                    [self.testView setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                }
                //check if ios 8
                
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    [self.testView setFrame:CGRectMake((self.view.frame.size.height -self.testView.bounds.size.width)/2,
                                                       (self.view.frame.size.width -self.testView.bounds.size.height)/2,
                                                       self.testView.bounds.size.height,
                                                       self.testView.bounds.size.width)];
                } else {
                    [self.testView setFrame:CGRectMake((self.view.frame.size.width -self.testView.bounds.size.width)/2,
                                                       (self.view.frame.size.height -self.testView.bounds.size.height)/2,
                                                       self.testView.bounds.size.height,
                                                       self.testView.bounds.size.width)];
                }
                

                
                self.wasRightShowed = 0;
                //hide
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

                    [UIView setAnimationsEnabled:YES];
                    
                    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
                    gravity.gravityDirection = CGVectorMake(.0, 4.0);
                    [animator addBehavior:gravity];
                
                    self.animator = animator;
                });

            } else {
                //if was not portrait and but changin view, just hide restView
                [self.testView setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
                [self.testView setFrame:CGRectMake((self.view.frame.size.height -self.testView.bounds.size.width)/2,
                                                   self.testView.bounds.size.height,
                                                   self.testView.bounds.size.height,
                                                   self.testView.bounds.size.width)];
                int64_t delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //do something to the button(s)
                    [UIView setAnimationsEnabled:YES];
                });
            }
            
        } else {
            //was in portrait view
            [UIView setAnimationsEnabled:NO];
            [self.mainContainerView setTransform:CGAffineTransformMakeRotation(0)];
            [self.mainContainerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            //[self.testView setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            //try this in ios 8
            /*
             [self.testView setFrame:CGRectMake((self.view.frame.size.height - self.testView.bounds.size.width)/2,
             self.testView.bounds.size.height,
             self.testView.bounds.size.height,
             self.testView.bounds.size.width)];
            */
             

            
            int64_t delayInSeconds = 0.05;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //do something to the button(s)
                [UIView setAnimationsEnabled:YES];
            });
            
            
        }
    
        self.wasRightShowed = 0;
        if(self.isSoundOn){
            AudioServicesPlaySystemSound (_blankSoundFileObject);
        }
    }
    }//exept if it isn't IPad
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
        self.bannerContainerView.alpha = 1.;
        
        [UIView animateWithDuration:.8
                         animations:^{
                             [self.bannerContainerView setFrame:CGRectMake(0,0, self.mainContainerView.bounds.size.width, 50)];
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
                         [self.bannerContainerView setFrame:CGRectMake(0, -self.buttonsCollection.bounds.size.height, self.mainContainerView.bounds.size.width, 50)];
                         self.isIAdBannerOnScreen = NO;
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
        
              //  self.bannerContainerView.hidden = NO;
              //  [UIView beginAnimations:nil context:nil];
               // [UIView setAnimationDuration:0.4];
             //   [banner setAlpha:1];
             //   [UIView commitAnimations];
            
                self.isIAdBaneerAvailable = YES;
            }
        }
    }
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    /*
    if([self.historyTable numberOfRowsInSection:0] > 2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
       // [self.bannerContainerView setFrame:CGRectMake(0,self.historyTable.frame.origin.y + self.iAdBannerOriginHeight-50,self.mainContainerView.bounds.size.width , 50)];
        [banner setAlpha:0];
        [UIView commitAnimations];
        self.bannerContainerView.hidden = YES;
        self.isIAdBaneerAvailable = NO;
    }*/
    self.isIAdBaneerAvailable = NO;
    if(self.isIAdBannerOnScreen){
        [self hideIAdBanner];
    }
    
    
}

#pragma mark IN-APP PURSHASE
-(void) startSpinner
{
    CGRect spinnerFrame = CGRectMake((self.SettingsView.bounds.size.width -40)/2,
                                     self.keyboardDefaultButton.frame.origin.y - 40,
                                     40.,
                                     40.);

    UIActivityIndicatorView *processSpinner = [[UIActivityIndicatorView alloc] initWithFrame:spinnerFrame];
    [self.SettingsView addSubview:processSpinner];
    processSpinner.hidesWhenStopped = YES;
    self.processSpinner = processSpinner;
    [self.processSpinner startAnimating];
}

-(void) wasSuccesTransaction
{
    //3.
    self.wasPurshaised = YES;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:self.wasPurshaised] forKey:@"wasPurchaisedMark"];
    [defaults synchronize];
    
    self.settingsButton.alpha = 0.;
    self.settingsButton.hidden = self.downButton.hidden;

    self.settingsButton.center = CGPointMake(97, 36);
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.downButton.center = CGPointMake(223, 36);
                         self.keyboardDefaultButton.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                         [self.keyboardDefaultButton setTitle:TITLE_RESET_BUTTON forState:UIControlStateNormal];
                         //set hide banner if its available
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         [self hideIAdBanner];
                         self.isIAdBaneerAvailable = NO;
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              self.keyboardDefaultButton.alpha = 1;
                                              self.settingsButton.alpha = self.downButton.alpha;
                                          }];
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
    /*
    if(queue.transactions.count == 0){
        [self startSpinner];
        [self buyUnlockKeyboard];
    }
    */
    
}

#pragma mark _
#pragma mark SKProductsRequestDelegate

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if(products.count != 0) {
        
        
        self.product = products[0];
        self.keyboardDefaultButton.enabled = YES;

    } else {
       // NSLog(@"Product not FUND");
    }
    //stop and remove process spinner
    [self.processSpinner stopAnimating];
    [self.processSpinner removeFromSuperview];
    
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



