//
//  ClearHistoryButton.m
//  TestDesignButton
//
//  Created by Serge Sychov on 19.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ClearHistoryButton.h"

@interface ClearHistoryButton();
@property (nonatomic,strong) UIColor* storkeColor;
@end

@implementation ClearHistoryButton

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    self.storkeColor = self.touchedColor;
    [self setNeedsDisplay];
    return [super beginTrackingWithTouch:touch withEvent:event];
    
}

-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.storkeColor = self.normalColor;
    [self setNeedsDisplay];
    [super endTrackingWithTouch:touch
                      withEvent:event];
}

-(UIColor*) normalColor{

    if(self.state != UIControlStateDisabled){
        _normalColor = self.currentTitleColor;
    } else {
        _normalColor = [UIColor grayColor];
    }
    return _normalColor;
}

-(UIColor*) touchedColor{
    if(self.state == UIControlStateNormal){
        if(!_touchedColor){
            _touchedColor = [UIColor colorWithWhite:0.95 alpha:1];
        }
    } else {
        _touchedColor = [UIColor grayColor];
    }
    return _touchedColor;
    
}
-(UIColor*) storkeColor
{
    
    if(!_storkeColor){
        _storkeColor = self.normalColor;
    }
    
    return _storkeColor;
}

-(void) drawHistoryTrashWithContect:(CGContextRef)contex inRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;
    CGFloat width = rect.size.width;
    CGFloat endAngle = -M_PI*3/2;
    CGFloat rad = width/2.5;
    
    [patch addArcWithCenter:center
                     radius:rad
                 startAngle:0
                   endAngle:endAngle
                  clockwise:NO];
    
    //make arrow
    [patch moveToPoint:CGPointMake(center.x - 1.5*rad/5, center.y + rad - 1.5*rad/5)];
    [patch addLineToPoint:CGPointMake(center.x,center.y + rad)];
    [patch addLineToPoint:CGPointMake(center.x - 1.5*rad/5, center.y + rad+ 1.5*rad/5)];
    
    
    CGFloat lineThin = width/45;
    CGContextSetLineWidth(contex, lineThin);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(contex, kCGLineCapRound);
    CGContextSetFillColorWithColor(contex, fillColor.CGColor);
    
    UIColor *storkecolor = self.storkeColor;
    CGContextSetStrokeColorWithColor(contex, storkecolor.CGColor);
    
    //draw trash
    CGPoint pointOne = CGPointMake(center.x+rad/4, center.y+2*rad/4);
    CGPoint pointTwo = CGPointMake(center.x-rad/4, center.y+2*rad/4);
    CGPoint pointThree=CGPointMake(center.x-2*rad/4, center.y-2*rad/4);
    CGPoint pointFour=CGPointMake(center.x+2*rad/4, center.y-2*rad/4);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    [patch addLineToPoint:pointOne];

    
    CGPoint pointFive = CGPointMake(pointThree.x-lineThin, pointThree.y);
    CGPoint pointSix = CGPointMake(pointFour.x+lineThin, pointFour.y);
    [patch moveToPoint:pointFive];
    [patch addLineToPoint:pointSix];
    
    CGPoint controlPointOne = CGPointMake(center.x, center.y- 3*rad/4);
    [patch moveToPoint:pointThree];
    [patch addQuadCurveToPoint:pointFour controlPoint:controlPointOne];
    
    CGPoint pointSeven = CGPointMake(center.x, controlPointOne.y+0.5*rad/4);
    CGPoint poinEight = CGPointMake(center.x, controlPointOne.y+0.25*rad/4);
    [patch moveToPoint:poinEight];
    [patch addLineToPoint:pointSeven];

    CGPoint pointNine = CGPointMake(center.x+0.35*rad/4, center.y+1.5*rad/4);
    CGPoint pointTen = CGPointMake(center.x+0.7*rad/4, center.y-1.5*rad/4);
    
    CGPoint pointEleven = CGPointMake(center.x-0.35*rad/4, center.y+1.5*rad/4);
    CGPoint pointTwelv = CGPointMake(center.x-0.7*rad/4, center.y-1.5*rad/4);
    
    [patch moveToPoint:pointNine];
    [patch addLineToPoint:pointTen];
    
    [patch moveToPoint:pointEleven];
    [patch addLineToPoint:pointTwelv];


    
    
    pathOfRect = patch.CGPath;
    
    CGContextAddPath(contex, pathOfRect);
    CGContextDrawPath(contex, kCGPathFillStroke);

    
    

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawHistoryTrashWithContect:context inRect:rect];
    
    
}



@end
