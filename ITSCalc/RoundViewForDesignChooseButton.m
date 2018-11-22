//
//  RoundViewForDesignChooseButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 03.09.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "RoundViewForDesignChooseButton.h"

@implementation RoundViewForDesignChooseButton
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect newRect = CGRectInset(rect,rect.size.height*0.35, rect.size.height*0.35);
    CGContextBeginPath(context);
    CGMutablePathRef patch= CGPathCreateMutable();
    CGPathAddEllipseInRect(patch, NULL, newRect);
    CGContextAddPath(context, patch);

    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);
}
@end
