//
//  TestButtonBackGroundView.m
//  ChecButton
//
//  Created by Serge Sychov on 07.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "TestButtonBackGroundView.h"

#define INDENT 20.

@interface TestButtonBackGroundView()

@property (nonatomic,strong) CALayer *buttonLayer;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) BOOL isColored;

@end
@implementation TestButtonBackGroundView

/*
-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    
}
*/
-(void)setColoredColor:(UIColor *)coloredColor
{
    _coloredColor = coloredColor;
    self.isColored = YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.buttonLayer.shadowOpacity = 0.7;
        self.buttonLayer.shadowOffset = CGSizeMake(self.shadowOffset.width/3, self.shadowOffset.height/3);
    }];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.buttonLayer.shadowOpacity = 0.3;
        self.buttonLayer.shadowOffset = self.shadowOffset;
    }];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect qardForButton = CGRectMake(0, 0, rect.size.width, rect.size.width);
    
    CGContextBeginPath(context);
    CGMutablePathRef patch= CGPathCreateMutable();
    CGPathAddEllipseInRect(patch, NULL, CGRectInset(qardForButton, qardForButton.size.width/10, qardForButton.size.height/10.));
    //CGPathAddRect(patch, NULL, CGRectInset(rect, 20., 20.));
    //CGPathAddRect(patch, NULL, rect /*CGRectInset(rect, 20.,20.)*/);
    CGContextAddPath(context, patch);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, self.mainviewcolor.CGColor);
    
    CGSize shadowOffset = CGSizeMake(2., 2.);
    
    self.shadowOffset = shadowOffset;
    CGContextSetShadow(context, shadowOffset, 3);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    //CGContextFillPath(context);

    if(self.isColored){
        CGContextBeginPath(context);
        CGMutablePathRef secondPatch= CGPathCreateMutable();
         CGPathAddEllipseInRect(secondPatch, NULL, CGRectInset(qardForButton, qardForButton.size.width/10+2, qardForButton.size.height/10.+2));
        //CGContextSetLineWidth(context, 6);
        CGContextSetFillColorWithColor(context, self.coloredColor.CGColor);
        CGContextAddPath(context, secondPatch);
        CGContextFillPath(context);
        CGContextClosePath(context);
        
        CGSize shadowOffset = CGSizeMake(0., 0.);
        
        self.shadowOffset = shadowOffset;
        CGContextSetShadow(context, shadowOffset, 0);
        
    }
    
    //CGContextEOFillPath(context);
    /*
    CALayer *buttonLayer = [CALayer layer];
    buttonLayer.backgroundColor = self.mainviewcolor.CGColor;
    buttonLayer.frame = CGRectInset(qardForButton, 2*qardForButton.size.width/10, 2*qardForButton.size.height/10.);
    buttonLayer.cornerRadius = (qardForButton.size.width - 2*qardForButton.size.width/10)/2.59;
    buttonLayer.shadowOffset = shadowOffset;
    buttonLayer.shadowOpacity = 0.3;
    [self.layer addSublayer:buttonLayer];
    self.buttonLayer = buttonLayer;
    */

    //CGContextFillRect(context, CGRectInset(rect, 20., 20.));
}
-(void) setup
{
    self.isColored = NO;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(id) init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}
@end
