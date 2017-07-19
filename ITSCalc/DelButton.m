//
//  DelButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "DelButton.h"

@implementation DelButton

-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor clearColor];
        self.shadowSize = CGSizeMake(0, 0);
        self.shadowBlur = 0.;
    }
    return _shadowColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //defend center
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat width = rect.size.width/6;
    
    CGPoint pointOne = CGPointMake(center.x+width, center.y-width);
    CGPoint pointTwo = CGPointMake(center.x-width, center.y+width);
    CGPoint pointThree = CGPointMake(center.x-width, center.y-width);
    CGPoint pointFour = CGPointMake(center.x+width, center.y+width);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch moveToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    UIColor *color;
    if(self.state == UIControlStateNormal){
        color = self.tintColor;
        
    }else if (self.state == UIControlStateDisabled){
        color = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
