//
//  ButtonsCollectionView.h
//  ACalcTry
//
//  Created by Serge Sychov on 16.07.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NewButtonsCollectionViewCell.h"


@interface ButtonsCollectionView : UICollectionView <ButtonCellSource>

//-(void) moveCellViewFromPosition: (NSIndexPath*) fromPatch toPosition:(NSIndexPath*) toPatch;

@end
