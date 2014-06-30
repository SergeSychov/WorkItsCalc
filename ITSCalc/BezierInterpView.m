//
//  BezierInterpView.m
//  SmoothLine
//
//  Created by Serge Sychov on 09.06.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "BezierInterpView.h"

@interface BezierInterpView()

@property (nonatomic, strong) CAShapeLayer *line;

@end

@implementation BezierInterpView
{
    UIBezierPath *patch;
    CGPoint pts[5];
    uint ctr;
}


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];

    }
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];

    }
    return self;
}

- (void) setup
{
    [self setMultipleTouchEnabled:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    patch = [UIBezierPath bezierPath];
    self.isBlueColor = YES;
    self.lineWidth = 4.5;
}

- (void)drawRect:(CGRect)rect
{

}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CAShapeLayer *line = [[CAShapeLayer alloc] init];
    line.fillColor = nil;
    line.lineCap = kCALineCapRound;
    line.lineJoin = kCALineJoinRound;
    if(self.isBlueColor){
        line.opacity = .9;
        line.lineWidth = 2.5;
    } else {
        line.opacity = 0.5;
        line.lineWidth = self.lineWidth;//self.redLineSize;
    }
    
    self.line = line;
    [self.layer addSublayer:line];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"BezierViewIsDirtyNotification" object:nil]];
    NSLog(@"Send durty notification");
    
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if(ctr == 4){
        
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2, (pts[2].y + pts[4].y)/2);
        
        [patch moveToPoint:pts[0]];
        [patch addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
       
        [self drawLine];
        //[self setNeedsDisplay];
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawLine];
    pts[0] = [patch currentPoint];
    [patch removeAllPoints];
    ctr = 0;
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(void) drawLine
{
    UIColor *color;
    if(self.isBlueColor){
        color = [UIColor colorWithRed:0.03 green:0.20 blue:0.5 alpha:0.9];
    } else {
        color = [UIColor colorWithRed:0.55 green:0.1 blue:0.2 alpha:0.9];
    }
    
    self.line.path=patch.CGPath;
    self.line.strokeColor = color.CGColor;
}

@end
