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

@interface NewButtonsCollectionViewCell : UICollectionViewCell //<SetingCellFrameDelegate>
//@property (weak, nonatomic) IBOutlet newButton *cellButton;
@property (weak, nonatomic) IBOutlet CloseSetButton *closeAndSetButton;
@property (weak, nonatomic) IBOutlet newButtonView *cellSubView;

@property (weak,nonatomic) UIColor *drawColor;
//@property (nonatomic) CGPoint collectionViewOffset;
@property (nonatomic,strong) NSString* name;
@property (nonatomic) BOOL isUnderChanging;//is there buttons in underchangeble condition
@property (nonatomic) BOOL isEnable; //is button normaly enabled
@property (nonatomic) BOOL isChangeble; //is button can change;
@property (nonatomic) BOOL isAllovedToDelete; //is button alloved to be hiden

@property (nonatomic) BOOL isIpadPortraitView;

//for buttons animation
-(BOOL) isShakeAnimationRunning;
-(void) startShakeAnimation;
-(void) stopShakeanimation;

-(void) myTouchBegan;
-(void) myTouchEnded;

@property (nonatomic,weak) id <ButtonCellSource> delegate;

@end
