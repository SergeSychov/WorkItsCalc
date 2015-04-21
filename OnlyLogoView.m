//
//  OnlyLogoView.m
//  ITSCalc
//
//  Created by Serge Sychov on 09.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "OnlyLogoView.h"

@implementation OnlyLogoView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;
    /*
     CGFloat width;
     if(rect.size.width > rect.size.height){
     width = rect.size.width;
     } else {
     width = rect.size.height;
     }
     */
    //start positoin
    
    [patch addArcWithCenter:center
                     radius:rect.size.width/4
                 startAngle:0
                   endAngle:M_PI*2
                  clockwise:NO];
    //make arrow
    /*
     [patch moveToPoint:CGPointMake(center.x - rect.size.width/8,
                                    center.y - rect.size.width/16)];
    [patch addLineToPoint:CGPointMake(center.x + rect.size.width/8,
                                      center.y - rect.size.width/16)];
    [patch moveToPoint:CGPointMake(center.x - rect.size.width/8,
                                   center.y + rect.size.width/16)];
    [patch addLineToPoint:CGPointMake(center.x + rect.size.width/8,
                                      center.y + rect.size.width/16)];
    */
     //make equal sign
     [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y - rect.size.width/25)];
     [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y - rect.size.width/25)];
     
     [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y + rect.size.width/25)];
     [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y + rect.size.width/25)];
    
    CGContextSetLineWidth(context, rect.size.width/50);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    

}

@end
