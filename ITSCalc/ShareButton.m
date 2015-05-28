//
//  ShareButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    //defend center
    CGFloat width_2 = rect.size.width/5;
    CGFloat rad = width_2/4;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2+rad);
    
    CGPoint startPoint = CGPointMake(center.x+2*rad, center.y-width_2);
    CGPoint endPoint = CGPointMake(center.x-2*rad, center.y-width_2);
    
    CGPoint pointOne = CGPointMake(center.x-width_2, center.y-width_2+rad);
    CGPoint pointTwo = CGPointMake(center.x+width_2-rad, center.y-width_2);
    CGPoint pointThree = CGPointMake(center.x+width_2, center.y+width_2-rad);
    CGPoint pointFour = CGPointMake(center.x-width_2+rad, center.y+width_2);
    
    CGPoint centerOne = CGPointMake(center.x+width_2-rad, center.y-width_2+rad);
    CGPoint centerTwo = CGPointMake(center.x+width_2-rad, center.y+width_2-rad);
    CGPoint centerThree = CGPointMake(center.x-width_2+rad, center.y+width_2-rad);
    CGPoint centerFour = CGPointMake(center.x-width_2+rad, center.y-width_2+rad);
    

    //draw rect
    [patch moveToPoint:startPoint];
    [patch addLineToPoint:pointTwo];
    [patch addArcWithCenter:centerOne
                     radius:rad
                 startAngle:-M_PI_2
                   endAngle:0
                  clockwise:YES];
    
    [patch addLineToPoint:pointThree];
    [patch addArcWithCenter:centerTwo
                     radius:rad
                 startAngle:0
                   endAngle:M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:pointFour];
    [patch addArcWithCenter:centerThree
                     radius:rad
                 startAngle:M_PI_2
                   endAngle:2*M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:pointOne];
    [patch addArcWithCenter:centerFour
                     radius:rad
                 startAngle:M_PI
                   endAngle:-M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:endPoint];
    
    
    //make arrow
    
    //points for arrow
    CGPoint arrowStart = CGPointMake(center.x, center.y-width_2/2);
    CGPoint arrowOne = CGPointMake(center.x-1.5*rad, center.y-1.8*width_2+1.5*rad);
    CGPoint arrowTwo = CGPointMake(center.x, center.y-1.8*width_2);
    CGPoint arrowThree = CGPointMake(center.x+1.5*rad, center.y-1.8*width_2+1.5*rad);
    
    [patch moveToPoint:arrowStart];
    [patch addLineToPoint:arrowTwo];
    [patch moveToPoint:arrowOne];
    [patch addLineToPoint:arrowTwo];
    [patch addLineToPoint:arrowThree];

    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        UIColor *color = self.tintColor;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
    }else if (self.state == UIControlStateDisabled){
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    }else if (self.state == UIControlStateHighlighted){
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    }
    
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);

}

@end
