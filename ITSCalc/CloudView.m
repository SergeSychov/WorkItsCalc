//
//  CloudView.m
//  ITSCalc
//
//  Created by Serge Sychov on 22.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "CloudView.h"

@implementation CloudView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //defend center
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    [patch setLineCapStyle:kCGLineCapRound];
    CGPathRef pathOfRect;
    CGFloat width = rect.size.width/1.7;
    CGFloat mainRad = width/5;
    CGFloat lenght = mainRad*3.3;// width - 2*mainRad;
    CGFloat h = lenght/(tanf(M_PI/3)+tanf(5*M_PI_4/3));
    center.y +=h;
    CGFloat bigRad = (h/sinf(M_PI_4/3))/2;//lenght*sinf(M_PI/3)/2;
    CGFloat smalRad = (h/sinf(M_PI/6))/2;//lenght*cosf(M_PI/3)/2;
    
    CGPoint pointOne = CGPointMake(center.x-lenght/2, center.y-mainRad);
    //CGPoint pointTwo = CGPointMake(center.x-2*mainRad, center.y+mainRad);
    CGPoint pointThree = CGPointMake(center.x+lenght/2, center.y+mainRad);
    CGPoint pointFour = CGPointMake(center.x+lenght/2, center.y-mainRad);
    //CGPoint pointFive = CGPointMake(pointOne.x+2*smalRad*cosf(M_PI/3), pointOne.y-2*smalRad*sinf(M_PI/3));
    
    CGPoint centerOne = CGPointMake(center.x-lenght/2, center.y);
    CGPoint centerTwo = CGPointMake(center.x+lenght/2, center.y);
    CGPoint centerThree = CGPointMake(pointFour.x-bigRad*cosf(M_PI_4/3), pointFour.y-bigRad*sinf(M_PI_4/3));
    CGPoint centerFour = CGPointMake(pointOne.x+smalRad*cosf(M_PI/6), pointOne.y-smalRad*sinf(M_PI/6));
    
    
    [patch moveToPoint:pointOne];
    
    [patch addArcWithCenter:centerOne
                     radius:mainRad
                 startAngle:-M_PI_2
                   endAngle:M_PI_2
                  clockwise:NO];
    [patch addLineToPoint:pointThree];
    
    [patch addArcWithCenter:centerTwo
                     radius:mainRad
                 startAngle:M_PI_2
                   endAngle:-M_PI_2
                  clockwise:NO];
    
    
    [patch addArcWithCenter:centerThree
                     radius:bigRad
                 startAngle:M_PI_4/3
                   endAngle:-10*M_PI_4/3
                  clockwise:NO];
    
    
    
    [patch addArcWithCenter:centerFour
                     radius:smalRad
                 startAngle:-M_PI/6
                   endAngle:5*M_PI/6
                  clockwise:NO];
    
    
    
    pathOfRect = patch.CGPath;
    CGContextAddPath(context, pathOfRect);
    
    CGContextSetLineWidth(context, rect.size.width/35);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    UIColor *fillColor;
    UIColor *storkeColor;
    if(self.on == NO){
        fillColor = [UIColor clearColor];
        storkeColor = [UIColor whiteColor];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextSetStrokeColorWithColor(context, storkeColor.CGColor);
        CGContextStrokePath(context);
    } else {
        fillColor = [UIColor whiteColor];
        storkeColor = [UIColor whiteColor];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextSetStrokeColorWithColor(context, storkeColor.CGColor);
        //CGContextStrokePath(context);
        CGContextFillPath(context);
    }

    
}


@end
