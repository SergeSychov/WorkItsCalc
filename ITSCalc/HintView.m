//
//  HintView.m
//  ITSCalc
//
//  Created by Serge Sychov on 19.05.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "HintView.h"
#import <Accelerate/Accelerate.h>


@interface HintView()
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic) NSInteger typeOfHint;
@property (nonatomic) CGRect labelRect;

@end
@implementation HintView

+(HintView*) newHintViewWithFrame:(CGRect)frame labelRect:(CGRect)labelrect type:(NSInteger)type
{
    HintView* newHintView = [[HintView alloc] initWithFrame:frame];
    newHintView.labelRect = labelrect;
    
    newHintView.typeOfHint = type;
    
    [newHintView setNeedsDisplay];
    
    
    return newHintView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        // Initialization code
    }
    return self;
}

-(void) setup
{
    self.contentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect labelRect = self.frame;
    labelRect.origin.x +=30.;
    labelRect.size.width -=60.;
    labelRect.size.height = self.frame.size.height / 3.;
    labelRect.origin.y = self.frame.size.height *2 / 3 - 30;
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:labelRect];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor colorWithRed:.26 green:0.57 blue:0.7 alpha:1];
    textLabel.font = [UIFont systemFontOfSize:25.];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;

    
    self.hintLabel = textLabel;
    [self addSubview:textLabel];
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tapOnView];
    
}

-(void) tapped
{
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#define ASK_TO_TOUCH_DISPLAY NSLocalizedStringFromTable(@"ASK_TO_TOUCH_DISPLAY",@"ACalcTryViewControllerTable", @"Touch and hold to copy to clipboard")
#define ASK_TO_ROTATE_DEVICE NSLocalizedStringFromTable(@"ASK_TO_ROTATE_DEVICE",@"ACalcTryViewControllerTable", @"Rotate to see counting")
#define ASK_TO_TOUCH_KEYBOARD NSLocalizedStringFromTable(@"ASK_TO_TOUCH_KEYBOARD",@"ACalcTryViewControllerTable", @"Touch and hold to change keyboard")


-(void) setTypeOfHint:(NSInteger)typeOfHint
{
    _typeOfHint = typeOfHint;
    switch (typeOfHint) {
        case 30:
            self.hintLabel.text = ASK_TO_TOUCH_DISPLAY;//@"Touch and hold to copy to clipboard";
            break;
        case 33:
            self.hintLabel.text = ASK_TO_ROTATE_DEVICE;//@"Rotate to see counting";
            break;
        case 36:
            self.hintLabel.text = ASK_TO_TOUCH_KEYBOARD;//@"Touch and hold to change keyboard";
            break;
            
        default:
            self.hintLabel.text = @"";
            break;
    }
}

-(void) drawRoundetRect:(CGContextRef)context
{
    if(self.typeOfHint == 36 || self.typeOfHint == 30){
        CGRect cornerRect;
        UIBezierPath *drawRectPath;
        CGPathRef pathOfRect;
    
        CGFloat radiusCorner = 10.;
    
        CGFloat borderWidth = 3;
    
        cornerRect = self.labelRect;
        cornerRect.origin.x +=7;
        cornerRect.size.width -=14.;
        cornerRect.origin.y += 7.;
        cornerRect.size.height -=14.;
    
    
        drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:radiusCorner];
        CGContextSetLineWidth(context, borderWidth);
    
        pathOfRect = drawRectPath.CGPath;
        CGContextAddPath(context, pathOfRect);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);
        
    }
    
    CGRect winRct = self.window.frame;
    CGFloat addY = self.frame.origin.y *(-0.85);

    if(self.typeOfHint == 30){//27
        UIBezierPath *linePath=[UIBezierPath bezierPath];

        
        CGPoint startPoint = CGPointMake(winRct.size.width / 2, winRct.size.height *2 /3 - 30 + addY);
        CGPoint endPoint = CGPointMake(winRct.size.width / 2, winRct.size.height *2 /3 -60  -30 + addY);
        CGPoint leftsidePoint = CGPointMake(winRct.size.width / 2 -10, winRct.size.height *2 /3 -60 -30 +10 + addY);
        CGPoint rightSidePoint = CGPointMake(winRct.size.width / 2 + 10, winRct.size.height *2 /3 -60 -30 +10 + addY);

        [linePath moveToPoint:startPoint];
        [linePath addLineToPoint:endPoint];
        
        [linePath moveToPoint:leftsidePoint];
        [linePath addLineToPoint:endPoint];
        [linePath addLineToPoint:rightSidePoint];
        
        CGPathRef linePatchRef;
        CGContextSetLineWidth(context, 3);
        linePatchRef = linePath.CGPath;
        
        CGContextAddPath(context, linePatchRef);
        
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);

    } else if(self.typeOfHint == 33){//30
        
        
        
        CGPoint centrPoint = CGPointMake(winRct.size.width / 2, winRct.size.height *2 / 3 -30 + addY);

        UIBezierPath *arcPatch = [UIBezierPath bezierPathWithArcCenter:centrPoint radius:60 startAngle:0 endAngle:M_PI clockwise:NO];
        
        CGPathRef arcPatchRef;
        CGContextSetLineWidth(context, 3);
        arcPatchRef = arcPatch.CGPath;
        CGContextAddPath(context, arcPatchRef);
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        
        CGPoint endPoint = CGPointMake(winRct.size.width / 2 + 60, winRct.size.height *2 / 3 -30 +2 + addY);
        CGPoint leftPoint = CGPointMake(winRct.size.width / 2 + 60 -10, winRct.size.height *2 / 3 -30 - 10 +2 + addY);
        CGPoint rightPoint = CGPointMake(winRct.size.width / 2 + 60 + 10, winRct.size.height *2 / 3 -30 - 10 +2 + addY);
        [linePath moveToPoint:leftPoint];
        // [linePath addQuadCurveToPoint:secondPoint controlPoint:controlPoint];
        [linePath addLineToPoint:endPoint];
        [linePath addLineToPoint:rightPoint];
        
        CGPathRef linePatchRef;
        CGContextSetLineWidth(context, 3);
        linePatchRef = linePath.CGPath;
        
        CGContextAddPath(context, linePatchRef);
        
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        UIBezierPath *linePathtwo=[UIBezierPath bezierPath];
        
        CGPoint endPointtwo = CGPointMake(winRct.size.width / 2 - 60, winRct.size.height *2 / 3 -30 +2 + addY);
        CGPoint leftPointtwo = CGPointMake(winRct.size.width / 2 - 60 -10, winRct.size.height *2 / 3 -30 - 10 +2 + addY);
        CGPoint rightPointtwo = CGPointMake(winRct.size.width / 2 - 60 + 10, winRct.size.height *2 / 3 -30 - 10 +2 + addY);
        [linePathtwo moveToPoint:leftPointtwo];
        // [linePath addQuadCurveToPoint:secondPoint controlPoint:controlPoint];
        [linePathtwo addLineToPoint:endPointtwo];
        [linePathtwo addLineToPoint:rightPointtwo];
        
        CGPathRef linePatchReftwo;
        CGContextSetLineWidth(context, 3);
        linePatchReftwo = linePathtwo.CGPath;
        
        CGContextAddPath(context, linePatchReftwo);
        
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);
        
    }else if(self.typeOfHint == 36){//33
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        
        
        CGPoint startPoint = CGPointMake(winRct.size.width / 2, winRct.size.height *2 /3 -60 -30 + addY);
        CGPoint endPoint = CGPointMake(winRct.size.width / 2, winRct.size.height *2 / 3 -30 + addY);
        CGPoint leftsidePoint = CGPointMake(winRct.size.width / 2 -10, winRct.size.height *2 /3 -30 -10 + addY);
        CGPoint rightSidePoint = CGPointMake(winRct.size.width / 2 + 10, winRct.size.height *2 /3 -30 - 10 + addY);
        
        [linePath moveToPoint:startPoint];
        [linePath addLineToPoint:endPoint];
        
        [linePath moveToPoint:leftsidePoint];
        [linePath addLineToPoint:endPoint];
        [linePath addLineToPoint:rightSidePoint];
        
        CGPathRef linePatchRef;
        CGContextSetLineWidth(context, 3);
        linePatchRef = linePath.CGPath;
        
        CGContextAddPath(context, linePatchRef);
        
        CGContextSetRGBStrokeColor(context, 0.26, 0.57, 0.7, 1);
        CGContextDrawPath(context, kCGPathStroke);
    }
    

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRoundetRect:context];
    // Drawing code
}

@end
