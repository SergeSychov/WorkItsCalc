//
//  recBut.m
//  ITSCalc
//
//  Created by Serge Sychov on 16.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "convertBut.h"

@interface ConvertBut()
@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation ConvertBut

//work with change color in case of event


-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.15;
    }];
    return [super beginTrackingWithTouch:touch withEvent:event];
    
}


-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
    [super endTrackingWithTouch:touch
                      withEvent:event];
}

-(void) cancelTrackingWithEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
    [super cancelTrackingWithEvent:event];

}

-(UIColor*) touchedColor{
    if(self.state == UIControlStateNormal){
        //if(!_touchedColor){
            _touchedColor = [UIColor colorWithWhite:0.95 alpha:1];
       // }
    } else {
        _touchedColor = [UIColor grayColor];
    }
    return _touchedColor;
    
}
-(UIColor*) storkeColor
{
    
    if(!_storkeColor){
        _storkeColor = self.currentTitleColor;
    }
    
    return _storkeColor;
}



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
                 startAngle:-M_PI/2-M_PI/6
                   endAngle:-M_PI*3/2
                  clockwise:NO];
    //make arrow
    [patch moveToPoint:CGPointMake(center.x - 1.5*rect.size.width/20, center.y + rect.size.width/4 - 1.5*rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x,center.y + rect.size.width/4)];
    [patch addLineToPoint:CGPointMake(center.x - 1.5*rect.size.width/20, center.y + rect.size.width/4 + 1.5*rect.size.width/20)];
    
    [patch moveToPoint:CGPointMake(center.x + rect.size.width/4*sin(M_PI/6), center.y + rect.size.width/4*cos(M_PI/6))];
    [patch addArcWithCenter:center
                     radius:rect.size.width/4
                 startAngle:-M_PI*3/2-M_PI/6
                   endAngle:-M_PI*5/2
                  clockwise:NO];
    //make arrow
    [patch moveToPoint:CGPointMake(center.x + 1.5*rect.size.width/20, center.y - rect.size.width/4 + 1.5*rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x,center.y - rect.size.width/4)];
    [patch addLineToPoint:CGPointMake(center.x + 1.5*rect.size.width/20, center.y - rect.size.width/4 - 1.5*rect.size.width/20)];
    
    
    //make equal sign
    [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y - rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y - rect.size.width/20)];
    
    [patch moveToPoint:CGPointMake(center.x - 2*rect.size.width/20, center.y + rect.size.width/20)];
    [patch addLineToPoint:CGPointMake(center.x + 2*rect.size.width/20, center.y + rect.size.width/20)];
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
      CGContextSetStrokeColorWithColor(context, self.storkeColor.CGColor);
    }else {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    }
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);

}


@end
