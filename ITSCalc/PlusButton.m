//
//  PlusButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 12.08.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "PlusButton.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@interface PlusButton()

//@property (nonatomic,strong) UIColor* storkeColor;
//@property (nonatomic,strong) UIColor *normalColor;
//@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation PlusButton

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


-(void) drawHistoryTrashWithContect:(CGContextRef)context inRect:(CGRect)rect
{
    //calculate border width
    CGFloat borderWidth;
    CGFloat radiusCorner;
    CGFloat borderVsRadius = 6.2;
    if(IS_IPAD){
        radiusCorner = ((rect.size.height)/1.2)/ 3.;
        
        borderWidth = radiusCorner / 4.9;//9.2;
    } else {
        radiusCorner = ((rect.size.height)/1.2)/ 3.2;
        
        borderWidth = radiusCorner / borderVsRadius;
    }
    
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGFloat width_2 = rect.size.width/5;
    CGFloat rad = width_2/4;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    //draw button's rect
    CGFloat corrHeig = 5*rad/6;
    CGFloat corrWidth = 2*rad;
    
    CGPoint startPoint = CGPointMake(center.x+2*rad+rad, center.y-width_2-corrHeig);
    
    CGPoint pointOne = CGPointMake(center.x-width_2-corrWidth, center.y-width_2+2*rad-corrHeig);
    CGPoint pointTwo = CGPointMake(center.x+width_2-2*rad+corrWidth, center.y-width_2-corrHeig);
    CGPoint pointThree = CGPointMake(center.x+width_2+corrWidth, center.y+width_2-2*rad+rad);
    CGPoint pointFour = CGPointMake(center.x-width_2+2*rad-corrWidth, center.y+width_2+rad);
    
    CGPoint centerOne = CGPointMake(center.x+width_2-2*rad+corrWidth, center.y-width_2+2*rad-corrHeig);
    CGPoint centerTwo = CGPointMake(center.x+width_2-2*rad+corrWidth, center.y+width_2-2*rad+rad);
    CGPoint centerThree = CGPointMake(center.x-width_2+2*rad-corrWidth, center.y+width_2-2*rad+rad);
    CGPoint centerFour = CGPointMake(center.x-width_2+2*rad-corrWidth, center.y-width_2+2*rad-corrHeig);
    
    
    //draw rect
    [patch moveToPoint:startPoint];
    [patch addLineToPoint:pointTwo];
    [patch addArcWithCenter:centerOne
                     radius:2*rad
                 startAngle:-M_PI_2
                   endAngle:0
                  clockwise:YES];
    
    [patch addLineToPoint:pointThree];
    [patch addArcWithCenter:centerTwo
                     radius:2*rad
                 startAngle:0
                   endAngle:M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:pointFour];
    [patch addArcWithCenter:centerThree
                     radius:2*rad
                 startAngle:M_PI_2
                   endAngle:2*M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:pointOne];
    [patch addArcWithCenter:centerFour
                     radius:2*rad
                 startAngle:M_PI
                   endAngle:-M_PI_2
                  clockwise:YES];
    
    [patch addLineToPoint:startPoint];
    
    
    CGFloat plusPart = rect.size.width/6;
    CGFloat corrY = rad/10;
    
    pointOne = CGPointMake(center.x, center.y-plusPart+corrY);
    pointTwo = CGPointMake(center.x, center.y+plusPart+corrY);
    pointThree = CGPointMake(center.x-plusPart, center.y+corrY);
    pointFour = CGPointMake(center.x+plusPart, center.y+corrY);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch moveToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    pathOfRect = patch.CGPath;
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    UIColor *color =  [UIColor colorWithRed:0. green:0. blue:0. alpha:1.0]; ;
    if(self.state == UIControlStateNormal){
        color = self.tintColor;
        
    }else if (self.state == UIControlStateDisabled){
        color = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    //CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawHistoryTrashWithContect:context inRect:rect];
    
    
    
    
}
@end

