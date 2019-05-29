//
//  GradientView.m
//  GradientViewTest
//
//  Created by Serge Sychov on 26.09.15.
//  Copyright © 2015 Sergey Sychov. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

-(UIColor*) firstGradientColor
{
    if(!_firstGradientColor){
        _firstGradientColor = [UIColor greenColor];
    }
    return _firstGradientColor;
}
-(UIColor*)secondGradientColor
{
    if(!_secondGradientColor){
        _secondGradientColor = [UIColor redColor];
    }
    return _secondGradientColor;
}
-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)self.firstGradientColor.CGColor, (id)self.secondGradientColor.CGColor,nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, NULL);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSaveGState(context);
    
    CGSize viewSize = [self frame].size;
    
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(viewSize.width/2, 0),           CGPointMake(viewSize.width/2, viewSize.height), kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
}



@end
