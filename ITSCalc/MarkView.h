//
//  MarkView.h
//  Mark
//
//  Created by Serge Sychov on 03.09.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"

@interface MarkView : UIView

@property (nonatomic) CGFloat lineWidht;
@property (nonatomic,weak) UIColor *markColor;
@property (nonatomic,weak) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) BOOL isShadow;
//-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
//-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
@end
