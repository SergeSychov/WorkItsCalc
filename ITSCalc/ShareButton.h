//
//  ShareButton.h
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareButton : UIButton
@property (nonatomic, weak) UIColor* disabledColor;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
//@property (nonatomic,weak) UIColor *shadowColor;
//@property (nonatomic) CGSize shadowSize;
//@property (nonatomic) CGFloat shadowBlur;

@end
