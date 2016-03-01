//
//  CloseSetButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "CloseSetButton.h"

@implementation CloseSetButton

-(void)setIsRemoveButton:(BOOL)isRemoveButton{
    _isRemoveButton = isRemoveButton;
     [self setNeedsDisplay];
    
}

-(void)setIsClose:(BOOL)isClose
{
    if(_isClose != isClose){
        _isClose=isClose;
        [self setNeedsDisplay];
    }
}

-(void)drawCircle:(CGContextRef)context inRect:(CGRect)rect
{
    //defend center
    UIBezierPath *patch = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGPathRef pathOfRect;

    UIColor *fillColor;
    if(self.isRemoveButton){
        fillColor = [UIColor redColor];
    }
    else if(self.isClose){
        fillColor= [UIColor lightGrayColor];
    } else {
        fillColor = [UIColor greenColor];
    }
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextFillPath(context);

}

-(void)drawMark:(CGContextRef)context inRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGFloat width = rect.size.width/4;
    UIColor *storkeColor;
    if(self.isRemoveButton){
        CGPoint pointOne = CGPointMake(center.x+width/1.5, center.y-width/1.5);
        CGPoint pointTwo = CGPointMake(center.x-width/1.5, center.y+width/1.5);
        CGPoint pointThree = CGPointMake(center.x-width/1.5, center.y-width/1.5);
        CGPoint pointFour = CGPointMake(center.x+width/1.5, center.y+width/1.5);
        
        [patch moveToPoint:pointOne];
        [patch addLineToPoint:pointTwo];
        [patch moveToPoint:pointThree];
        [patch addLineToPoint:pointFour];
        
        storkeColor = [UIColor whiteColor];
        
    } else if(self.isClose){
        CGPoint pointOne = CGPointMake(center.x+width/1.5, center.y-width/1.5);
        CGPoint pointTwo = CGPointMake(center.x-width/1.5, center.y+width/1.5);
        CGPoint pointThree = CGPointMake(center.x-width/1.5, center.y-width/1.5);
        CGPoint pointFour = CGPointMake(center.x+width/1.5, center.y+width/1.5);
    
        [patch moveToPoint:pointOne];
        [patch addLineToPoint:pointTwo];
        [patch moveToPoint:pointThree];
        [patch addLineToPoint:pointFour];
        
        storkeColor = [UIColor darkGrayColor];
    } else {
        CGPoint pointOne = CGPointMake(center.x-width/2, center.y);
        CGPoint pointTwo = CGPointMake(center.x, center.y+width/2);
        CGPoint pointThree = CGPointMake(center.x+width, center.y-width/2);
        
        [patch moveToPoint:pointOne];
        [patch addLineToPoint:pointTwo];
        [patch addLineToPoint:pointThree];
        
        storkeColor = [UIColor whiteColor];
    }

    
    CGContextSetLineWidth(context, rect.size.width/10);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, storkeColor.CGColor);

    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircle:context inRect:rect];
    [self drawMark:context inRect:rect];
}


@end
