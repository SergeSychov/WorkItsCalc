//
//  CalcButton.h
//  ITSCalc
//
//  Created by Sychov Intencom on 19.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalcButton : UIButton
@property (nonatomic, weak) UIColor* disabledColor;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;

@end
