//
//  DesignButton.m
//  TestDesignButton
//
//  Created by Serge Sychov on 19.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "DesignButton.h"

@interface DesignButton();

@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation DesignButton

//work with change color in case of event


-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.15;
    }];
   // self.storkeColor = self.touchedColor;
   // [self setNeedsDisplay];
    return [super beginTrackingWithTouch:touch withEvent:event];
    
}
-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
    //self.storkeColor = self.currentTitleColor;
    //[self setNeedsDisplay];
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
        if(!_touchedColor){
            _touchedColor = [UIColor colorWithWhite:0.95 alpha:1];
        }
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


-(CGPoint) transformPoint:(CGPoint)inputPoint onAngle:(CGFloat)angle throughCenter:(CGPoint)center
{
    CGPoint outputPoint;
    //find width and height according center and hipotinuse
    CGFloat currHeight = center.y - inputPoint.y;
    CGFloat currWidth = inputPoint.x - center.x;
    CGFloat addToAngle = 0;
    if(currWidth<0 && currWidth<0){
        addToAngle = M_PI;
    } else if(currWidth<0 && currHeight >0){
        addToAngle = M_PI_2;
    }
    if(currWidth == 0 && currHeight == 0){
        outputPoint.x = center.x;
        outputPoint.y = center.y;
    } else {
        CGFloat hipotinuse = sqrtf(powf(currHeight,2)+ pow(currWidth,2));
        
        //calculate current angle
        
        CGFloat currAngle = addToAngle + atanf(currHeight/currWidth);

        
        //add new angle
        CGFloat newAngle = currAngle + angle;
        
        //calculate new hipotinuse, width and height
        CGFloat newWidth = hipotinuse * cosf(newAngle);
        //newWidth = (currWidth>0)? newWidth : newWidth *(-1);
        CGFloat newHeight = hipotinuse * sinf(newAngle);
        
        //make point
        outputPoint.x = center.x + newWidth;
        outputPoint.y = center.y - newHeight;
    }
    
    return outputPoint;
}

-(void) drawBrushWithContext:(CGContextRef)context inRect:(CGRect)rect
{
    //context behaviors
    CGFloat linewidth = rect.size.width/45;
    CGContextSetLineWidth(context, linewidth);
    UIColor *fillColor = self.superview.backgroundColor;
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        CGContextSetStrokeColorWithColor(context, self.storkeColor.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    }
    //CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    CGRect rectForPicture;
    if(rect.size.width > rect.size.height){
        rectForPicture.origin.x = (rect.size.width - rect.size.height)/2;
        rectForPicture.origin.y = 0;
        rectForPicture.size.width = rect.size.height;
        rectForPicture.size.height = rect.size.height;
    } else {
        rectForPicture.origin.y = (rect.size.height - rect.size.width)/2;
        rectForPicture.origin.x = 0;
        rectForPicture.size.width = rect.size.width;
        rectForPicture.size.height = rect.size.width;
    }
    // CGPoint cornerLeftTop = CGPointMake(rectForPicture.origin.x, rectForPicture.origin.y);
    CGPoint cornerRightTop = CGPointMake(rectForPicture.origin.x + rectForPicture.size.width,
                                         rectForPicture.origin.y);
    CGPoint cornerRightBottom = CGPointMake(rectForPicture.origin.x + rectForPicture.size.width,
                                            rectForPicture.origin.y + rectForPicture.size.height);
    // CGPoint cornerLeftBottom = CGPointMake(rectForPicture.origin.x,
    //                                        rectForPicture.origin.y + rectForPicture.size.height);
    
    
    CGFloat thingWidth = rectForPicture.size.width/20;
    
    //---------------draw brush----------------------
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPoint pointOne = CGPointMake(center.x - thingWidth/2,
                                   cornerRightBottom.y);
    
    CGPoint pointTwo = CGPointMake(center.x - thingWidth*2/3,
                                   cornerRightBottom.y -rectForPicture.size.height*2/3);
    CGPoint controlPointOne = CGPointMake(center.x - thingWidth*4/3,
                                          cornerRightBottom.y-rectForPicture.size.height*2/3 + 4*thingWidth);
    
    CGFloat needAngle = -M_PI/8;
    CGPoint throughPoint = CGPointMake(center.x, cornerRightBottom.y);
    
    pointOne = [self transformPoint:pointOne onAngle:needAngle throughCenter:throughPoint];
    pointTwo = [self transformPoint:pointTwo onAngle:needAngle throughCenter:throughPoint];
    controlPointOne = [self transformPoint:controlPointOne onAngle:needAngle throughCenter:throughPoint];
    
    
    [patch moveToPoint:pointOne];
    [patch addQuadCurveToPoint:pointTwo controlPoint:controlPointOne];
    
    CGPoint pointThree = CGPointMake(center.x + thingWidth/2,
                                     cornerRightBottom.y);
    CGPoint pointFour = CGPointMake(center.x + thingWidth*2/3,
                                    cornerRightBottom.y-rectForPicture.size.height*2/3);
    CGPoint controlPointTwo = CGPointMake(center.x + thingWidth*4/3,
                                          cornerRightBottom.y-rectForPicture.size.height*2/3 + 4*thingWidth);
    
    pointThree = [self transformPoint:pointThree onAngle:needAngle throughCenter:throughPoint];
    pointFour = [self transformPoint:pointFour onAngle:needAngle throughCenter:throughPoint];
    controlPointTwo = [self transformPoint:controlPointTwo onAngle:needAngle throughCenter:throughPoint];
    [patch moveToPoint:pointThree];
    [patch addQuadCurveToPoint:pointFour controlPoint:controlPointTwo];
    
    
    
    CGPoint pointFive = CGPointMake(center.x - thingWidth*2/3,
                                    cornerRightBottom.y -rectForPicture.size.height*2/3 - 2*thingWidth);
    
    CGPoint pointSix = CGPointMake(center.x + thingWidth*2/3,
                                   cornerRightBottom.y -rectForPicture.size.height*2/3 - 2*thingWidth);
    pointFive = [self transformPoint:pointFive onAngle:needAngle throughCenter:throughPoint];
    pointSix = [self transformPoint:pointSix onAngle:needAngle throughCenter:throughPoint];
    
    
    [patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointFive];
    [patch addLineToPoint:pointSix];
    [patch addLineToPoint:pointFour];
    
    CGPoint pointSeven = CGPointMake(center.x, cornerRightTop.y);
    CGPoint controlLeft = CGPointMake(center.x - 2*thingWidth, pointFive.y - 2*thingWidth);
    CGPoint controlRight = CGPointMake(center.x + 2*thingWidth, pointFive.y - 2*thingWidth);
    
    pointSeven = [self transformPoint:pointSeven onAngle:needAngle throughCenter:throughPoint];
    controlLeft = [self transformPoint:controlLeft onAngle:needAngle throughCenter:throughPoint];
    controlRight = [self transformPoint:controlRight onAngle:needAngle throughCenter:throughPoint];
    
    
    
    [patch moveToPoint:pointFive];
    [patch addQuadCurveToPoint:pointSeven controlPoint:controlLeft];
    [patch addQuadCurveToPoint:pointSix controlPoint:controlRight];
    
    
    CGPathRef pathOfRect = patch.CGPath;
    
    CGContextAddPath(context, pathOfRect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    //-------------------------------------------------
    //----- draw pencils-------------------------------
    
    // make points for one pencil
    pointOne = CGPointMake(center.x - thingWidth,
                           cornerRightBottom.y);
    
    pointTwo = CGPointMake(center.x - thingWidth,
                           cornerRightBottom.y -rectForPicture.size.height*2/3);
    pointThree = CGPointMake(center.x + thingWidth,
                             cornerRightBottom.y -rectForPicture.size.height*2/3);
    
    pointFour = CGPointMake(center.x + thingWidth,
                            cornerRightBottom.y);
    pointFive = CGPointMake(center.x, pointTwo.y - 2*thingWidth/ cosf(M_PI_2/3));
    
    pointSix = CGPointMake(center.x - thingWidth/3, pointFive.y + (2*thingWidth/ cosf(M_PI_2/3))/3);
    
    pointSeven = CGPointMake(center.x + thingWidth/3, pointFive.y + (2*thingWidth/ cosf(M_PI_2/3))/3);
    
    controlPointOne = CGPointMake(center.x, pointTwo.y + thingWidth/2);
    
    controlPointTwo = CGPointMake(center.x, pointSix.y + thingWidth/6);
    
    
    //transform and draw one
    needAngle = M_PI/20;
    
    pointOne = [self transformPoint:pointOne onAngle:needAngle throughCenter:throughPoint];
    pointTwo = [self transformPoint:pointTwo onAngle:needAngle throughCenter:throughPoint];
    pointThree = [self transformPoint:pointThree onAngle:needAngle throughCenter:throughPoint];
    pointFour = [self transformPoint:pointFour onAngle:needAngle throughCenter:throughPoint];
    pointFive = [self transformPoint:pointFive onAngle:needAngle throughCenter:throughPoint];
    pointSix = [self transformPoint:pointSix onAngle:needAngle throughCenter:throughPoint];
    pointSeven = [self transformPoint:pointSeven onAngle:needAngle throughCenter:throughPoint];
    controlPointOne = [self transformPoint:controlPointOne onAngle:needAngle throughCenter:throughPoint];
    controlPointTwo = [self transformPoint:controlPointTwo onAngle:needAngle throughCenter:throughPoint];
    
    
    //draw
    UIBezierPath *pencilOnePatch = [UIBezierPath bezierPath];
    [pencilOnePatch moveToPoint:pointThree];
    [pencilOnePatch addLineToPoint:pointFour];
    [pencilOnePatch addLineToPoint:pointOne];
    [pencilOnePatch addLineToPoint:pointTwo];
    
    [pencilOnePatch addLineToPoint:pointFive];
    [pencilOnePatch addLineToPoint:pointThree];
    [pencilOnePatch addQuadCurveToPoint:pointTwo controlPoint:controlPointOne];
    
    [pencilOnePatch moveToPoint:pointSix];
    [pencilOnePatch addQuadCurveToPoint:pointSeven controlPoint:controlPointTwo];
    
    pathOfRect = pencilOnePatch.CGPath;
    
    CGContextAddPath(context, pathOfRect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //transform and draw second
    needAngle = M_PI/14;
    
    pointOne = [self transformPoint:pointOne onAngle:needAngle throughCenter:throughPoint];
    pointTwo = [self transformPoint:pointTwo onAngle:needAngle throughCenter:throughPoint];
    pointThree = [self transformPoint:pointThree onAngle:needAngle throughCenter:throughPoint];
    pointFour = [self transformPoint:pointFour onAngle:needAngle throughCenter:throughPoint];
    pointFive = [self transformPoint:pointFive onAngle:needAngle throughCenter:throughPoint];
    pointSix = [self transformPoint:pointSix onAngle:needAngle throughCenter:throughPoint];
    pointSeven = [self transformPoint:pointSeven onAngle:needAngle throughCenter:throughPoint];
    controlPointOne = [self transformPoint:controlPointOne onAngle:needAngle throughCenter:throughPoint];
    controlPointTwo = [self transformPoint:controlPointTwo onAngle:needAngle throughCenter:throughPoint];
    
    
    //draw
    UIBezierPath *pencilTwoPatch = [UIBezierPath bezierPath];
    [pencilTwoPatch moveToPoint:pointThree];
    [pencilTwoPatch addLineToPoint:pointFour];
    [pencilTwoPatch addLineToPoint:pointOne];
    [pencilTwoPatch addLineToPoint:pointTwo];
    
    [pencilTwoPatch addLineToPoint:pointFive];
    [pencilTwoPatch addLineToPoint:pointThree];
    [pencilTwoPatch addQuadCurveToPoint:pointTwo controlPoint:controlPointOne];
    
    [pencilTwoPatch moveToPoint:pointSix];
    [pencilTwoPatch addQuadCurveToPoint:pointSeven controlPoint:controlPointTwo];
    
    pathOfRect = pencilTwoPatch.CGPath;
    
    CGContextAddPath(context, pathOfRect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //draw brushes cap
    needAngle = M_PI/10;
    
    pointOne = CGPointMake(center.x - 2*thingWidth, cornerRightBottom.y - linewidth/2);
    pointTwo = CGPointMake(pointOne.x - rectForPicture.size.height*3.5/8 * sinf(needAngle),
                           pointOne.y - rectForPicture.size.height*3.5/8 * cosf(needAngle));
    pointFour = CGPointMake(center.x + 2*thingWidth, cornerRightBottom.y-linewidth/2);
    pointThree = CGPointMake(pointFour.x + rectForPicture.size.height*3.5/8* sinf(needAngle),
                             pointFour.y - rectForPicture.size.height*3.5/8 * cosf(needAngle));
    
    
    UIBezierPath *capPatch = [UIBezierPath bezierPath];
    [capPatch moveToPoint:pointOne];
    [capPatch addLineToPoint:pointTwo];
    [capPatch addLineToPoint:pointThree];
    [capPatch addLineToPoint:pointFour];
    [capPatch addLineToPoint:pointOne];
    
    pathOfRect = capPatch.CGPath;
    
    CGContextAddPath(context, pathOfRect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBrushWithContext: context inRect: rect];
}


@end
