//
//  DesignViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 13.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "DesignViewController.h"
#import "CildDesignViewController.h"
#import "designButtonView.h"
#import "Transition.h"
#import "CalcButton.h"
#import "SettingButton.h"
#import "TestButtonBackGroundView.h"
#import "newButtonView.h"
#import "PlusButton.h"
#import "Clr.h"


//NSString *const DesignSendChangedNotification=@"SendChangedNotification";

//#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
//#define INDENT 20.0f
//define design numbers
//#define DESIGN_CLASSIC 1
//#define DESIGN_PAPER 2
//#define DESIGN_COLOR_BLUE 30
//#define DESIGN_COLOR_GREEN 31
//#define DESIGN_COLOR_PINK 32
//#define DESIGN_COLOR_YELOW 33
//#define DESIGN_COLOR_GRAY 34
//#define DESIGN_PHOTO 4

@interface DesignViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design

//@property (nonatomic, weak) UIView *cView;

/*
@property (nonatomic,weak) CalcButton* calcButton;
@property (nonatomic,weak) SettingButton *settingButton;

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

//necessary to add plus button


@end

@implementation DesignViewController
@dynamic cView;

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

/*
#define ALERT_MESSAGE_CHOOSE_NEW_PHOTO NSLocalizedStringFromTable(@"ALERT_MESSAGE_CHOOSE_NEW_PHOTO",@"ACalcTryViewControllerTableNew", @"Выберите фотографию из Вашего фотоархива")
#define TITLE_BUTTON_CHOOSE_NEW_PHOTO_OK NSLocalizedStringFromTable(@"TITLE_BUTTON_CHOOSE_NEW_PHOTO_OK",@"ACalcTryViewControllerTableNew", @"Ok")

#pragma mark SET NEW DESIGN
-(void)sendNoteChangeDesign:(NSInteger)design
{
    //self.design = design;
    NSNumber *message = [NSNumber numberWithInteger:design];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"ChangedDesign",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:DesignSendChangedNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void)trySetDesign:(NSInteger)design
{
    if(self.designIndex != design){
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
        //}
        
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
*/
#pragma mark TAP ACTION SEND NOTIFICATION

- (IBAction)calcButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate designViewControllerDidCloseWithString:@"TO CALC"];
    }];
}
- (IBAction)settingButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.delegate designViewControllerDidCloseWithString:@"BACK"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    for (UIViewController *childViewController in [self childViewControllers])
    {
        if ([childViewController isKindOfClass:[CildDesignViewController class]])
        {
            CildDesignViewController *cildDesignViewController = (CildDesignViewController *)childViewController;
            cildDesignViewController.designObj = self.designObj;
            cildDesignViewController.paymetObj = self.paymentObj;
            break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appDidGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification//UIApplicationDidEnterBackgroundNotification
                                                 object:[UIApplication sharedApplication]];
    [super viewWillAppear:animated];
}

#pragma mark ROTATION
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
    
    [self updateViewConstraints];
}


-(void)appDidGoToBackground:(NSNotification *)note
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
   [self dismissViewControllerAnimated:NO completion:^{
        // [self dismis];
    [self.delegate designViewControllerDidCloseWithString:@"BACKGROUND"];
    }];
}

-(void) dismis {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismis];
}

@end
