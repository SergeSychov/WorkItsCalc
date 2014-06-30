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

@interface NewButtonsCollectionViewCell : UICollectionViewCell //<SetingCellFrameDelegate>
//@property (weak, nonatomic) IBOutlet newButton *cellButton;
@property (weak, nonatomic) IBOutlet UIButton *closeAndSetButton;
@property (weak, nonatomic) IBOutlet newButtonView *cellSubView;
@property (nonatomic) CGPoint collectionViewOffset;
@property (nonatomic,strong) NSString* name;
@property (nonatomic) BOOL isUnderChanging;//is there buttons in underchangeble condition
@property (nonatomic) BOOL isEnable; //is button normaly enabled
@property (nonatomic) BOOL isChangeble; //is button can change;
@property (nonatomic) BOOL isAllovedToDelete; //is button alloved to be hiden
//for buttons animation
-(BOOL) isShakeAnimationRunning;
-(void) startShakeAnimation;
-(void) stopShakeanimation;

-(void) myTouchBegan;
-(void) myTouchEnded;
@end
