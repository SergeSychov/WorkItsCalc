//
//  MarkView.m
//  Mark
//
//  Created by Serge Sychov on 03.09.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "MarkView.h"

@interface MarkView()
@property (nonatomic,strong) UIColor* storkeColor;
@end

@implementation MarkView
-(UIColor*)markColor{
    if(!_markColor){
        _markColor = [UIColor blackColor];
    }
    return _markColor;
}

-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor colorWithWhite:1. alpha:1.];
    }
    return _shadowColor;
}

-(void) drawMarkWithContect:(CGContextRef)contex inRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;
    
    CGFloat width;
    if(rect.size.width > rect.size.height){
        width = rect.size.height;
    } else {
        width = rect.size.width;
    }
    //CGFloat lineThin = width/30;
    CGContextSetLineWidth(contex, self.lineWidht);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(contex, kCGLineCapRound);
    CGContextSetFillColorWithColor(contex, fillColor.CGColor);
    
    UIColor *storkecolor = self.markColor;
    CGContextSetStrokeColorWithColor(contex, storkecolor.CGColor);
    
    CGFloat plusPart = width/4;
    
    CGPoint pointOne = CGPointMake(center.x-plusPart, center.y-plusPart);
    CGPoint pointTwo = CGPointMake(center.x, center.y+plusPart);
    CGPoint pointThree = CGPointMake(center.x+plusPart, center.y);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointThree];
    pathOfRect = patch.CGPath;
    
    CGContextAddPath(contex, pathOfRect);
    if(self.isShadow){
        CGContextSetShadowWithColor(contex, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
    }
    CGContextDrawPath(contex, kCGPathFillStroke);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawMarkWithContect:context inRect:rect];
    
    
    
}
@end

