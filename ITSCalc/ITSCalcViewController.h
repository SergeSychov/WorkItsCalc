//
//  ITSCalcViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 15.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ITSCalcAppDelegate.h"

#import "ButtonsCollectionView.h"

#import "Currensies.h"
#import "ACalcBrain.h"

//important delete
//#import <StoreKit/StoreKit.h>

@interface ITSCalcViewController : UIViewController /* <ADBannerViewDelegate important delete, SKPaymentTransactionObserver, SKProductsRequestDelegate>*/


//@property (weak, nonatomic) IBOutlet UIView *dynamicContainer; //dynamic container to set pickers view

//@property (nonatomic) CGFloat labelViewHeight;//to set right origin y for pickers
//Buttons collection

@property (weak, nonatomic) IBOutlet ButtonsCollectionView *buttonsCollection;
//initial layout
@property (weak, nonatomic) IBOutlet UIView *viewforCurrencyRecognizer; //dublicate area of button collection
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

//constrains
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calcScreenHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *displayTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sviperBottomConstrain;

//constrain of historyTable
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTableTrailingConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTableLeadingConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTableTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTableBottomConstrain;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonscollectionHeightConstrain;

//Models
@property (nonatomic, strong) ACalcBrain *brain; //main brain

#pragma mark CURRENSIES


@property (nonatomic,strong) Currensies *currensies;

-(void) initialLayoutDynamicContainerWithSize:(CGSize)size;//for initial layout in ItsCalc

-(void)tappedButtonWithTitle:(id)title; //for convert button tapped in ItsCalc.

-(void)discardChanging; //to renew currency convrter

- (IBAction)dragSviperGesturRecognizer:(UIPanGestureRecognizer *)sender;

-(void) resetProgrammAfterCurrensiesChecked:(NSArray*)currencies;

@end

