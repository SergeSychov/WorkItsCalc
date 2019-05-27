//
//  DesignButton.h
//  TestDesignButton
//
//  Created by Serge Sychov on 19.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignButton : UIButton
@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor* fillColor;
@property (nonatomic,strong) UIColor *touchedColor;
//-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
//-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
@end
