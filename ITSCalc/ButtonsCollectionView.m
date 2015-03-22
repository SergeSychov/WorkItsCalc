//
//  ButtonsCollectionView.m
//  ACalcTry
//
//  Created by Serge Sychov on 16.07.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "ButtonsCollectionView.h"
#import "NewButtonsCollectionViewCell.h"
#import "newButtonView.h"

@interface ButtonsCollectionView()


@end

@implementation ButtonsCollectionView

-(CGFloat) buttonCollectionOffset
{
    return self.contentOffset.y;
}

/*

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Draw rect");
}
 */

@end
