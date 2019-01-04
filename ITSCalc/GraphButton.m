//
//  GraphButton.m
//  CalcLayout
//
//  Created by Serge Sychov on 30.05.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import "GraphButton.h"
@interface GraphButton()

@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end
@implementation GraphButton
/*

-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor clearColor];
        self.shadowSize = CGSizeMake(0, 0);
        self.shadowBlur = 0.;
    }
    return _shadowColor;
}
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
        _normalColor = [UIColor darkGrayColor];
    }
    return _normalColor;
}

-(UIColor*) touchedColor{
    if(self.state == UIControlStateNormal){
        if(!_touchedColor){
            _touchedColor = [UIColor colorWithWhite:0.95 alpha:1];
        }
    } else {
        _touchedColor = [UIColor greenColor];
    }
    return _touchedColor;
    
}
-(UIColor*) storkeColor
{
    
    if(!_storkeColor){
        _storkeColor = self.normalColor;
    }
    
    return _storkeColor;
}*/

-(UIColor*)disabledColor{
    if(!_disabledColor){
        _disabledColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    return _disabledColor;
}

-(CGFloat) func:(CGFloat)arg{
    return powf(arg,0.5)/2;//*cosf(arg);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGFloat width_2 = rect.size.width/5;
    CGFloat rad = width_2/4;
    CGPoint center = CGPointMake(rect.size.width/2-rad, rect.size.height/2+rad);
    
    //inside rect as 2/3
    CGRect iRct = CGRectMake(rect.size.width/6, rect.size.height/6, rect.size.width*2/3, rect.size.height*2/3);
    CGFloat x0 = rect.size.width/6-rad;
    CGFloat y0 = center.y-1.8*width_2;//rect.size.height/6+rad;

    CGFloat heighD = rad*2/3;
    //Draw axises
    CGFloat width_4 = iRct.size.width/2;

    
    [patch moveToPoint:CGPointMake(x0+width_4, y0)];
    [patch addLineToPoint:CGPointMake(x0+width_4, y0+iRct.size.height-2*rad)];
    CGFloat height_4 = iRct.size.height/2;
    [patch moveToPoint:CGPointMake(x0+2*rad, y0+height_4)];
    [patch addLineToPoint:CGPointMake(center.x+1.8*width_2, y0+height_4)];
    
    //Draw axis's arrows

    //Y arrow
    [patch moveToPoint:CGPointMake(x0+width_4-1.5*rad, y0+1.5*rad)];
    [patch addLineToPoint:CGPointMake(x0+width_4, y0)];
    [patch addLineToPoint:CGPointMake(x0+width_4+1.5*rad, y0+1.5*rad)];
    //X arrow
    [patch moveToPoint:CGPointMake(center.x+1.8*width_2-1.5*rad, y0+height_4-1.5*rad)];
    [patch addLineToPoint:CGPointMake(center.x+1.8*width_2,y0+height_4)];
    [patch addLineToPoint:CGPointMake(center.x+1.8*width_2-1.5*rad, y0+height_4+1.5*rad)];


    //draw graph
    
    
    CGPoint startPoint = CGPointMake(center.x+width_2, center.y-width_2-heighD);
    CGPoint endPoint = CGPointMake(center.x, center.y-width_2-heighD);
    
    CGPoint pointOne = CGPointMake(center.x+width_2, center.y+width_2-3*rad-heighD);
    CGPoint pointTwo = CGPointMake(center.x, center.y+width_2-heighD);
    CGPoint pointThree = CGPointMake(center.x-width_2, center.y+width_2-heighD);
    CGPoint pointFour = CGPointMake(center.x-width_2, center.y-width_2+3*rad-heighD);

    CGPoint centerOne = CGPointMake(center.x+width_2-3*rad, center.y+width_2-3*rad-heighD);
    CGPoint centerTwo = CGPointMake(center.x-width_2+3*rad, center.y-width_2+3*rad-heighD);

    //draw graph

    [patch moveToPoint:startPoint];
    [patch addLineToPoint:pointOne];
    [patch addArcWithCenter:centerOne
                     radius:3*rad
                 startAngle:0
                   endAngle:M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:pointTwo];
    
    [patch moveToPoint:pointThree];
    
    [patch addLineToPoint:pointFour];
    [patch addArcWithCenter:centerTwo
                     radius:3*rad
                 startAngle:M_PI
                   endAngle:-M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:endPoint];

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
    //CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
