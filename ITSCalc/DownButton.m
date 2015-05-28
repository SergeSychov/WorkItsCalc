//
//  DownButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "DownButton.h"

@implementation DownButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat width = rect.size.width/4;
    
    CGPoint pointOne = CGPointMake(center.x-width, center.y);
    CGPoint pointTwo = CGPointMake(center.x, center.y+width/2);
    CGPoint pointThree = CGPointMake(center.x+width, center.y);

    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointThree];

    
    CGContextSetLineWidth(context, rect.size.width/15);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        UIColor *color = self.tintColor;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
    }else if (self.state == UIControlStateDisabled){
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    }
    
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
