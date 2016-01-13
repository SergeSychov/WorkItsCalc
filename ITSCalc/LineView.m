//
//  LineView.m
//  ITSCalc
//
//  Created by Serge Sychov on 26.09.15.
//  Copyright © 2015 Sergey Sychov. All rights reserved.
//

#import "LineView.h"

@implementation LineView
-(UIColor*)color{
    if(!_color){
        _color = [UIColor blackColor];
    }
    return _color;
}

-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor clearColor];
        self.shadowSize = CGSizeMake(0, 0);
        self.shadowBlur = 0.;
    }
    return _shadowColor;
}

-(void) drawLineInRect:(CGRect)rect withContext:(CGContextRef) context
{
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGPoint pointOne = CGPointMake(rect.size.width*0.1, rect.size.height - 2);
    CGPoint pointTwo = CGPointMake(rect.size.width*0.9, rect.size.height - 2);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    pathOfRect = patch.CGPath;
    
    CGContextAddPath(context, pathOfRect);
    CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLineInRect:rect withContext: context];
}

@end
