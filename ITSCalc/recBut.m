//
//  recBut.m
//  ITSCalc
//
//  Created by Serge Sychov on 16.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "recBut.h"

@interface recBut()
//@property (nonatomic,strong) UIColor* storkeColor;
//@property (nonatomic,strong) UIColor *normalColor;
//@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation recBut

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
    
    //defend center
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;
    /*
     CGFloat width;
     if(rect.size.width > rect.size.height){
     width = rect.size.width;
     } else {
     width = rect.size.height;
     }
     */
    //start positoin
    
    [patch addArcWithCenter:center
                     radius:rect.size.width/4
                 startAngle:0
                   endAngle:-M_PI*3/2
                  clockwise:NO];
    //make arrow
    [patch moveToPoint:CGPointMake(center.x - 1.5*rect.size.width/20, center.y + rect.size.width/4 - 1.5*rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x,center.y + rect.size.width/4)];
    [patch addLineToPoint:CGPointMake(center.x - 1.5*rect.size.width/20, center.y + rect.size.width/4 + 1.5*rect.size.width/20)];
    //make equal sign
    [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y - rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y - rect.size.width/20)];
    
    [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y + rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y + rect.size.width/20)];
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    UIColor *color;
    if(self.state == UIControlStateNormal){
        color = self.tintColor;
        
    }else if (self.state == UIControlStateDisabled){
        color = self.disabledColor;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    //CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


@end
