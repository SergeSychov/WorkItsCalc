//
//  RoundedGroundView.m
//  RoundedGround
//
//  Created by Serge Sychov on 04.10.15.
//  Copyright © 2015 Sergey Sychov. All rights reserved.
//

#import "RoundedGroundView.h"
#import <stdlib.h>

@implementation RoundedGroundView

+(UIImage*)getImageForRect:(CGRect)rct withColor:(UIColor *)color
{
    
    UIGraphicsBeginImageContextWithOptions(rct.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);

    
    CGContextFillRect(context, rct);
    [RoundedGroundView drawRoundedGroundWithContext:context inRect:rct withColor:color];
    
    //[self drawViewHierarchyInRect:rct afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

-(void) setColor:(UIColor *)color
{
    _color = color;
    self.backgroundColor = color;
    [self setNeedsDisplay];
}
+(UIColor*) setLineColor:(UIColor*)inputColor Black:(BOOL)isBlack;
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [inputColor getRed:&red green:&green blue:&blue alpha:nil];
    
    UIColor *color;
    if(isBlack){
        color= [UIColor colorWithRed:red*.8 green:green*.8 blue:blue*.8 alpha:1];
    } else {
        color= [UIColor colorWithRed:red*1.1 green:green*1.1 blue:blue*1.1 alpha:1];
    }
    
    
    return color;
}

+(void) drawColor:(UIColor*)color CirclesWithRadius:(CGFloat)rad inCenter:(CGPoint)center inContext:(CGContextRef)context inRect:(CGRect)rect;
{
    
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    
    CGContextSetLineWidth(context, 2);
    
    UIColor *storkecolor = color;
    CGContextSetStrokeColorWithColor(context, storkecolor.CGColor);
    
    [patch addArcWithCenter:center
                     radius:rad
                 startAngle:0
                   endAngle:2*M_PI
                  clockwise:NO];
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathStroke);
    
}
+(void) drawCirclesFromRadius:(CGFloat)rad inCenter:(CGPoint)center inContext:(CGContextRef)context inRect:(CGRect)rect withcolor:(UIColor*)color
{
    UIColor *lineColor = [RoundedGroundView setLineColor:color Black:NO];
    UIColor *storkeColor;
    for(NSInteger i = 4; i < (NSInteger)rad; i+=2){
        if((i%4) == 0){
            storkeColor = lineColor;
            
        }else {
            storkeColor = color;
            //lineColor = [self setLineColorBlack:NO];
        }
        [self drawColor:storkeColor
        CirclesWithRadius:i
                inCenter:center
                inContext:context
                    inRect:rect];
    }
}

+(void) drawRoundedGroundWithContext:(CGContextRef)context inRect:(CGRect)rect withColor:(UIColor*) color;
{
    CGFloat onePart = rect.size.height/4;
    CGFloat startHeight = onePart;
    CGFloat oneRadiusStep = rect.size.width/8;
    CGFloat strartRadius = oneRadiusStep;
    
   // NSLog(@"BackgroundColor %@, newColor %@", self.backgroundColor, [self setLineColor]);
    for(NSInteger i = 0; i<3; i++){
        CGFloat randForRadius = (strartRadius + 1.5*oneRadiusStep*i)*(0.9 + ((float)arc4random()/0x100000000)*0.2);
        CGFloat randForX = rect.size.width *((float)arc4random()/0x100000000);
        CGFloat randForY = startHeight + onePart*i + onePart*((float)arc4random()/0x100000000);

        [RoundedGroundView drawCirclesFromRadius:randForRadius
                                        inCenter:CGPointMake(randForX, randForY)
                                       inContext:context
                                          inRect:rect
                                       withcolor:color];
      
    }
}


@end
