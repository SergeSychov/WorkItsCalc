//
//  PlusButton.h
//  ITSCalc
//
//  Created by Serge Sychov on 12.08.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlusButton : UIButton

//@property (nonatomic,strong) UIColor *normalColor;
//@property (nonatomic,strong) UIColor *touchedColor;

@property (nonatomic, weak) UIColor* disabledColor;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
//@property (nonatomic,weak) UIColor *shadowColor;
//@property (nonatomic) CGSize shadowSize;
//@property (nonatomic) CGFloat shadowBlur;

@end
