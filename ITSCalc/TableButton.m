//
//  TableButton.m
//  CalcLayout
//
//  Created by Serge Sychov on 30.05.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import "TableButton.h"
@interface TableButton()

@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end
@implementation TableButton
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
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
  

    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGFloat widthStep = rect.size.width/5;
    CGFloat rad = widthStep/4;
    CGPoint center = CGPointMake(rect.size.width/2-rad, rect.size.height/2+rad);
    
    //inside rect as 2/3
    CGRect iRct = CGRectMake(rect.size.width/6, rect.size.height/6, rect.size.width*2/3, rect.size.height*2/3);

    //Draw axises
    CGFloat width_4 = iRct.size.width/2;
    
    
    [patch moveToPoint:CGPointMake(center.x, center.y - 1.5*widthStep)];
    [patch addLineToPoint:CGPointMake(center.x, center.y + widthStep)];
    
    CGFloat height_5 = iRct.size.height/6;
    [patch moveToPoint:CGPointMake(center.x-1.5*widthStep, center.y+height_5)];
    [patch addLineToPoint:CGPointMake(center.x+1.5*widthStep, center.y+height_5)];
    

    [patch moveToPoint:CGPointMake(center.x-1.5*widthStep, center.y-height_5)];
    [patch addLineToPoint:CGPointMake(center.x+1.5*widthStep, center.y-height_5)];
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    UIColor *color =  [UIColor colorWithRed:0. green:0. blue:0. alpha:1.0]; ;
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
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [@"X" drawAtPoint:CGPointMake(center.x-1.1*widthStep, center.y-width_4-0.2*widthStep) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:widthStep], NSForegroundColorAttributeName:color}];
    [@"Y" drawAtPoint:CGPointMake(center.x+0.4*widthStep, center.y-width_4-0.2*widthStep) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:widthStep], NSForegroundColorAttributeName: color}];

}

@end
