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
    CGRect qardForButton = CGRectMake(0, 0, rect.size.width, rect.size.width);
    
    CGContextBeginPath(context);
    CGMutablePathRef patch= CGPathCreateMutable();
    CGPathAddEllipseInRect(patch, NULL, CGRectInset(qardForButton, qardForButton.size.width/10, qardForButton.size.height/10.));
    CGContextAddPath(context, patch);

    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
}
@end
