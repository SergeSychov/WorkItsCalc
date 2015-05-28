//
//  SettingButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 17.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "SettingButton.h"

@implementation SettingButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    //patch.lineJoinStyle = kCGLineJoinRound;
    [patch setLineCapStyle:kCGLineCapRound];
    //patch.lineCapStyle = kCGLineCapRound;
    CGPathRef pathOfRect;
    //defend center
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat rad = rect.size.width/4;
    
    CGPoint pointOne = CGPointMake(center.x - rad*sin(M_PI /12), center.y - rad*cos(M_PI /12));
    CGPoint pointTwo = CGPointMake(center.x + rad*sin(M_PI /12), center.y - rad*cos(M_PI /12));
    CGPoint pointThree = CGPointMake(center.x + rad*sin(M_PI_4), center.y - rad*cos(M_PI_4));
    CGPoint pointFour = CGPointMake(center.x + rad*sin(5* M_PI /12), center.y - rad*cos(5* M_PI /12));
    CGPoint pointFive = CGPointMake(center.x + rad*sin(5* M_PI /12), center.y + rad*cos(5* M_PI /12));
    CGPoint pointSix = CGPointMake(center.x + rad*sin(M_PI_4), center.y + rad*cos(M_PI_4));
    CGPoint pointSeven = CGPointMake(center.x + rad*sin(M_PI /12), center.y + rad*cos(M_PI /12));
    CGPoint pointEight = CGPointMake(center.x - rad*sin(M_PI /12), center.y + rad*cos(M_PI /12));
    CGPoint pointNine = CGPointMake(center.x - rad*sin(M_PI_4), center.y + rad*cos(M_PI_4));
    CGPoint pointTen = CGPointMake(center.x - rad*sin(5* M_PI /12), center.y + rad*cos(5* M_PI /12));
    CGPoint pointEleven = CGPointMake(center.x - rad*sin(5* M_PI /12), center.y - rad*cos(5* M_PI /12));
    CGPoint pointTwelw = CGPointMake(center.x - rad*sin(M_PI_4), center.y - rad*cos(M_PI_4));
    
    //make center rounf
    //[patch moveToPoint:CGPointMake(center.x+rad, center.y)];
    [patch addArcWithCenter:center
                     radius:1.5*rad*sin(M_PI/12)
                 startAngle:0
                   endAngle:2*M_PI
                  clockwise:YES];
    //start positoin & topLine
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    //first arc
   
    [patch addArcWithCenter:CGPointMake((pointTwo.x + pointThree.x)/2 , (pointTwo.y + pointThree.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(M_PI- M_PI/6)
                   endAngle:(M_PI/6)
                  clockwise:NO];
  
    //[patch moveToPoint:pointThree];
    
    
    [patch addLineToPoint:pointFour];
    
    [patch addArcWithCenter:CGPointMake((pointFour.x + pointFive.x)/2 , (pointFour.y + pointFive.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(-M_PI_2)
                   endAngle:(M_PI_2)
                  clockwise:NO];
    
    //[patch moveToPoint:pointFive];
    
    [patch addLineToPoint:pointSix];
    
    [patch addArcWithCenter:CGPointMake((pointSix.x + pointSeven.x)/2 , (pointSix.y + pointSeven.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(-M_PI/6)
                   endAngle:(M_PI -M_PI/6)
                  clockwise:NO];
   
    //[patch moveToPoint:pointSeven];
    
    [patch addLineToPoint:pointEight];
  
    [patch addArcWithCenter:CGPointMake((pointEight.x + pointNine.x)/2 , (pointEight.y + pointNine.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(-M_PI/6)
                   endAngle:(M_PI + M_PI/6)
                  clockwise:NO];
    
    //[patch moveToPoint:pointNine];
    
    [patch addLineToPoint:pointTen];
   
    [patch addArcWithCenter:CGPointMake((pointTen.x + pointEleven.x)/2 , (pointTen.y + pointEleven.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(M_PI_2)
                   endAngle:(-M_PI_2)
                  clockwise:NO];
    
    //[patch moveToPoint:pointEleven];
    
    
    [patch addLineToPoint:pointTwelw];
    
    [patch addArcWithCenter:CGPointMake((pointTwelw.x + pointOne.x)/2 , (pointTwelw.y + pointOne.y)/2)
                     radius:rad*sin(M_PI/12)
                 startAngle:(M_PI - M_PI/6)
                   endAngle:(-M_PI/6)
                  clockwise:NO];
    
   // [patch moveToPoint:pointOne];
    
    
    CGContextSetLineWidth(context, rect.size.width/35);
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
