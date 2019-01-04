//
//  NoticeButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "NoticeButton.h"

@implementation NoticeButton
/*
-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor clearColor];
        self.shadowSize = CGSizeMake(0, 0);
        self.shadowBlur = 0.;
    }
    return _shadowColor;
}
*/
-(UIColor*)disabledColor{
    if(!_disabledColor){
        _disabledColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    return _disabledColor;
}

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
    
    CGPoint startPoint = CGPointMake(center.x+width_2, center.y-rad);
    CGPoint endPoint = CGPointMake(center.x+rad, center.y-width_2);
    
    CGPoint pointOne = CGPointMake(center.x-width_2, center.y-width_2+rad);
    //CGPoint pointTwo = CGPointMake(center.x+width_2-rad, center.y-width_2);
    CGPoint pointThree = CGPointMake(center.x+width_2, center.y+width_2-rad);
    CGPoint pointFour = CGPointMake(center.x-width_2+rad, center.y+width_2);
    
    //CGPoint centerOne = CGPointMake(center.x+width_2-rad, center.y-width_2+rad);
    CGPoint centerTwo = CGPointMake(center.x+width_2-rad, center.y+width_2-rad);
    CGPoint centerThree = CGPointMake(center.x-width_2+rad, center.y+width_2-rad);
    CGPoint centerFour = CGPointMake(center.x-width_2+rad, center.y-width_2+rad);
    
    
    //draw rect
    /*
     [patch moveToPoint:startPoint];
     [patch addLineToPoint:pointTwo];
     [patch addArcWithCenter:centerOne
     radius:rad
     startAngle:-M_PI_2
     endAngle:0
     clockwise:YES];
     */
    [patch moveToPoint:startPoint];
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
    
    
    //make pensil
    CGFloat penWidth = rad/2;
    CGPoint pensilOne = CGPointMake(center.x+2*(width_2-rad/2)*cos(M_PI_4)+penWidth*cos(M_PI_4), center.y-2*(width_2-rad/2)*sin(M_PI_4)+penWidth*sin(M_PI_4));
    CGPoint pensilTwo = CGPointMake(center.x+1.5*rad*cos(M_PI_4)+penWidth*cos(M_PI_4), center.y-1.5*rad*sin(M_PI_4)+penWidth*sin(M_PI_4));
    CGPoint pensilFour = CGPointMake(center.x+1.5*rad*cos(M_PI_4)-penWidth*cos(M_PI_4), center.y-1.5*rad*sin(M_PI_4)-penWidth*sin(M_PI_4));
    CGPoint pensilFive = CGPointMake(center.x+2*(width_2-rad/2)*cos(M_PI_4)-penWidth*cos(M_PI_4), center.y-2*(width_2-rad/2)*sin(M_PI_4)-penWidth*sin(M_PI_4));
    
    CGPoint lasOne = CGPointMake(center.x+2*(width_2)*cos(M_PI_4)+penWidth*cos(M_PI_4), center.y-2*(width_2)*sin(M_PI_4)+penWidth*sin(M_PI_4));
    CGPoint lasTwo = CGPointMake(center.x+2*(width_2)*cos(M_PI_4)-penWidth*cos(M_PI_4), center.y-2*(width_2)*sin(M_PI_4)-penWidth*sin(M_PI_4));
    CGPoint lasFour = CGPointMake(center.x+2*(width_2+rad/4)*cos(M_PI_4)+penWidth*cos(M_PI_4), center.y-2*(width_2+rad/4)*sin(M_PI_4)+penWidth*sin(M_PI_4));
    CGPoint lasThree = CGPointMake(center.x+2*(width_2+rad/4)*cos(M_PI_4)-penWidth*cos(M_PI_4), center.y-2*(width_2+rad/4)*sin(M_PI_4)-penWidth*sin(M_PI_4));
    
    [patch moveToPoint:pensilOne];
    [patch addLineToPoint:pensilTwo];
    [patch addLineToPoint:center];
    [patch addLineToPoint:pensilFour];
    [patch addLineToPoint:pensilFive];
    
    [patch moveToPoint:lasOne];
    [patch addLineToPoint:lasTwo];
    [patch addLineToPoint:lasThree];
    [patch addLineToPoint:lasFour];
    [patch addLineToPoint:lasOne];
    
    
    
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    UIColor *color;
    if(self.state == UIControlStateNormal){
        color = self.tintColor;
        
    }else if (self.state == UIControlStateDisabled){
        color =self.disabledColor;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    //CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
