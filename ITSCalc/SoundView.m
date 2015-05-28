//
//  SoundView.m
//  ITSCalc
//
//  Created by Serge Sychov on 22.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "SoundView.h"

@implementation SoundView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //defend center
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat width = rect.size.width/2;
    CGFloat onePart = width/4;
    
    
    CGPoint pointOne = CGPointMake(center.x, center.y-2*onePart);
    CGPoint pointTwo = CGPointMake(center.x, center.y+2*onePart);
    CGPoint pointThree = CGPointMake(center.x-onePart, center.y+onePart);
    CGPoint pointFour = CGPointMake(center.x-2*onePart, center.y+onePart);
    CGPoint pointFive = CGPointMake(center.x-2*onePart, center.y-onePart);
    CGPoint pointSix = CGPointMake(center.x-onePart, center.y-onePart);
    
    CGFloat radOne = onePart;
    CGFloat radTwo = 1.5*onePart;
    CGFloat radThree = 2*onePart;
    
    CGFloat angleFrom = -M_PI_4;
    CGFloat angleTo =  M_PI_4;
 
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    [patch addLineToPoint:pointFive];
    [patch addLineToPoint:pointSix];
    [patch addLineToPoint:pointOne];
    
  

    if(self.on == NO){
        
    } else {
        [patch moveToPoint:CGPointMake(center.x+radOne*cosf(angleTo), center.y-radOne*sinf(angleTo))];
        [patch addArcWithCenter:center
                         radius:radOne
                     startAngle:angleFrom
                       endAngle:angleTo
                      clockwise:YES];
        
        [patch moveToPoint:CGPointMake(center.x+radTwo*cosf(angleTo), center.y-radTwo*sinf(angleTo))];
        [patch addArcWithCenter:center
                         radius:radTwo
                     startAngle:angleFrom
                       endAngle:angleTo
                      clockwise:YES];
        
        
        [patch moveToPoint:CGPointMake(center.x+radThree*cosf(angleTo), center.y-radThree*sinf(angleTo))];
        [patch addArcWithCenter:center
                         radius:radThree
                     startAngle:angleFrom
                       endAngle:angleTo
                      clockwise:YES];
    }
    pathOfRect = patch.CGPath;
    CGContextAddPath(context, pathOfRect);
    
    CGContextSetLineWidth(context, rect.size.width/35);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    UIColor *fillColor;
    UIColor *storkeColor;
    
    
    fillColor = [UIColor clearColor];
    storkeColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, storkeColor.CGColor);
    CGContextStrokePath(context);

}


@end
