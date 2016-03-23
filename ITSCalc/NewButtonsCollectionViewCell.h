//
//  NewButtonsCollectionViewCell.h
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//
@import UIKit;


#import <UIKit/UIKit.h>
#import "newButtonView.h"
#import "CloseSetButton.h"

@class NewButtonsCollectionViewCell;

@protocol ButtonCellSource <NSObject>
-(CGFloat) buttonCollectionOffset;
@end

@protocol CellButtonActionDelegate <NSObject>
-(void) tapCloseCheckButton:(UIButton *)sender;
- (void)tapRemoveItsButton:(UIButton *)sender;
@end

@interface NewButtonsCollectionViewCell : UICollectionViewCell //<SetingCellFrameDelegate>

@property (nonatomic) NSInteger design;
@property (strong, nonatomic) CloseSetButton *closeAndSetButton;
@property (strong, nonatomic) CloseSetButton *removeButton;
@property (weak, nonatomic) IBOutlet newButtonView *cellSubView;

@property (weak,nonatomic) UIColor *drawColor;
//@property (nonatomic) CGPoint collectionViewOffset;
@property (nonatomic,strong) NSString* name;

@property (nonatomic) NSInteger typeOfButton;//main, changeble or users button
@property (nonatomic) BOOL isUnderChanging;//is there buttons in underchangeble condition
//@property (nonatomic) BOOL isEnable; //is button normaly enabled
//@property (nonatomic) BOOL isCanBeRemoved;//is button was create by user and can be removed from arrays
//@property (nonatomic) BOOL isChangeble; //is button can change;
//@property (nonatomic) BOOL isAllovedToDelete; //is button alloved to be hiden

@property (nonatomic) BOOL isIpadPortraitView;

//for buttons animation
-(BOOL) isShakeAnimationRunning;
-(void) startShakeAnimation;
-(void) stopShakeanimation;

-(void) myTouchBegan;
-(void) myTouchEnded;

@property (nonatomic,weak) id <ButtonCellSource> delegate;
@property (nonatomic,weak) id <CellButtonActionDelegate> actionDelegate;

@end
