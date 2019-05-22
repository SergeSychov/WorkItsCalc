//
//  ClearHistoryButton.h
//  TestDesignButton
//
//  Created by Serge Sychov on 19.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearHistoryButton : UIButton


@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *touchedColor;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
@end
