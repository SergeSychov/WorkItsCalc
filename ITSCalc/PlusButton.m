//
//  PlusButton.m
//  ITSCalc
//
//  Created by Serge Sychov on 12.08.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "PlusButton.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@interface PlusButton();
@property (nonatomic,strong) UIColor* storkeColor;
@end

@implementation PlusButton

-(UIColor*)shadowColor{
    if(!_shadowColor){
        _shadowColor = [UIColor clearColor];
        self.shadowSize = CGSizeMake(0, 0);
        self.shadowBlur = 0.;
    }
    return _shadowColor;
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
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;


    CGFloat plusPart = rect.size.width/3;
    
    CGPoint pointOne = CGPointMake(center.x, center.y-plusPart);
    CGPoint pointTwo = CGPointMake(center.x, center.y+plusPart);
    CGPoint pointThree = CGPointMake(center.x-plusPart, center.y);
    CGPoint pointFour = CGPointMake(center.x+plusPart, center.y);
    
    [patch moveToPoint:pointOne];
    [patch addLineToPoint:pointTwo];
    [patch moveToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    pathOfRect = patch.CGPath;
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        UIColor *color = self.tintColor;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
    }else if (self.state == UIControlStateDisabled){
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    }
    
    CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
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

