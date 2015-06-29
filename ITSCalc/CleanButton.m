//
//  CleanButton.m
//  ITSCalc
//
//  Created by Sychov Intencom on 18.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "CleanButton.h"

@interface CleanButton()
@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation CleanButton


//work with change color in case of event


-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    self.storkeColor = self.touchedColor;
    [self setNeedsDisplay];
    return [super beginTrackingWithTouch:touch withEvent:event];
    
}
-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.storkeColor = self.currentTitleColor;
    [self setNeedsDisplay];
    [super endTrackingWithTouch:touch
                      withEvent:event];
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    //patch.lineJoinStyle = kCGLineJoinRound;
    [patch setLineCapStyle:kCGLineCapRound];
    //patch.lineCapStyle = kCGLineCapRound;
    CGPathRef pathOfRect;
    //defend center
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat rad = rect.size.width/4;
    CGFloat rad_10 = rad/10;
    
    CGPoint pointOne = CGPointMake(center.x+rad-1.5*rad_10/cos(M_PI_4),  center.y-rad);
    CGPoint pointTwo = CGPointMake(center.x+rad, center.y-rad+1.5*rad_10/cos(M_PI_4));
    CGPoint pointThree = CGPointMake(center.x + rad_10/cos(M_PI_4), center.y);
    CGPoint pointFour = CGPointMake(center.x, center.y-rad_10/cos(M_PI_4));
    [patch moveToPoint:pointOne];
    [patch addCurveToPoint:pointTwo
             controlPoint1:CGPointMake(center.x+rad-0.5*rad_10, center.y-rad+0.5*rad_10)
             controlPoint2:CGPointMake(center.x+rad-0.5*rad_10, center.y-rad+0.5*rad_10)];//[patch addLineToPoint:pointTwo];
    [patch addLineToPoint:pointThree];
    [patch addLineToPoint:pointFour];
    [patch addLineToPoint:pointOne];
    
    //next part
    CGFloat c = sqrtf(4.25)*rad_10;
    CGFloat alpha = asinf(0.5/sqrtf(4.25));
    CGFloat betta = alpha+M_PI_4;
    CGFloat omega = M_PI_4 - alpha;
    
    CGPoint pointFive = CGPointMake(center.x-c*cosf(betta), center.y-c*sinf(betta));
    CGPoint pointSix = CGPointMake(center.x+c*cosf(omega), center.y+c*sinf(omega));
    CGPoint pointSeven = CGPointMake(center.x+c*cosf(betta), center.y+c*sinf(betta));
    CGPoint pointEight = CGPointMake(center.x-c*cosf(omega), center.y-c*sinf(omega));
    [patch moveToPoint:pointFive];
    [patch addLineToPoint:pointSix];
    [patch addLineToPoint:pointSeven];
    [patch addLineToPoint:pointEight];
    [patch addLineToPoint:pointFive];
    
    CGPoint pointNine = CGPointMake(center.x, center.y+rad_10/cosf(M_PI_4));
    CGPoint pointEghteen = CGPointMake(center.x-rad_10/cosf(M_PI_4), center.y);
    
    CGPoint pointTwelw = CGPointMake(pointEghteen.x+(pointNine.x-pointEghteen.x)*2/3, pointEghteen.y+(pointNine.y-pointEghteen.y)*2/3);
    CGPoint pointFiveteen = CGPointMake(pointEghteen.x+(pointNine.x-pointEghteen.x)/3, pointEghteen.y+(pointNine.y-pointEghteen.y)/3);
    CGPoint pointTen = CGPointMake(center.x+rad, center.y+rad);
    CGPoint pointEleven = CGPointMake(center.x+rad_10, center.y+rad);
    CGPoint pointTherteen = CGPointMake(center.x-rad_10, center.y+rad);
    CGPoint pointFourteen = CGPointMake(center.x-1.2*rad*cosf(M_PI*9/36), center.y+1.2*rad*sinf(M_PI*9/36));
    CGPoint pointSixteen = CGPointMake(center.x-1.2*rad*cosf(M_PI*7/36), center.y+1.2*rad*sinf(M_PI*7/36));
    CGPoint pointNineteen = CGPointMake(center.x-1.2*rad*cosf(M_PI/9), center.y+1.2*rad*sinf(M_PI/9));
    
    [patch moveToPoint:pointTwelw];
    [patch addLineToPoint:pointNine];
    [patch addCurveToPoint:pointTen
             controlPoint1:CGPointMake(center.x, center.y+4*rad_10)
             controlPoint2:CGPointMake(center.x+rad-4*rad_10, center.y+rad)];//[patch addLineToPoint:pointTen];//curve
    [patch addLineToPoint:pointEleven];
    [patch addCurveToPoint:pointTwelw
             controlPoint1:CGPointMake(center.x-1*rad_10, center.y+5*rad_10)
             controlPoint2:CGPointMake(center.x-1*rad_10, center.y+5*rad_10)];//[patch addLineToPoint:pointTwelw];//curve
    
    //[patch addLineToPoint:pointTherteen];
    [patch addCurveToPoint:pointTherteen
             controlPoint1:CGPointMake(center.x-2*rad_10, center.y+5*rad_10)
             controlPoint2:CGPointMake(center.x-2*rad_10, center.y+5*rad_10)];//[patch addLineToPoint:pointTherteen];//curve
    [patch addCurveToPoint:pointFourteen
             controlPoint1:CGPointMake(center.x-1.2*rad*cosf(M_PI*11/36), center.y+1.2*rad*sinf(M_PI*11/36))             controlPoint2:CGPointMake(center.x-1.2*rad*cosf(M_PI*11/36), center.y+1.2*rad*sinf(M_PI*11/36))];//[patch addLineToPoint:pointFourteen];
    [patch addCurveToPoint:pointFiveteen
             controlPoint1:CGPointMake(center.x-0.5*rad*cosf(M_PI*6/36), center.y+0.5*rad*sinf(M_PI*6/36))             controlPoint2:CGPointMake(center.x-0.5*rad*cosf(M_PI*6/36), center.y+0.5*rad*sinf(M_PI*6/36))];//[patch addLineToPoint:pointFiveteen];//curve
    
    [patch addCurveToPoint:pointSixteen
             controlPoint1:CGPointMake(center.x-0.5*rad*cosf(M_PI*5/36), center.y+0.5*rad*sinf(M_PI*5/36))             controlPoint2:CGPointMake(center.x-0.5*rad*cosf(M_PI*5/36), center.y+0.5*rad*sinf(M_PI*5/36))];///[patch addLineToPoint:pointSixteen];//curve
    [patch addCurveToPoint:pointNineteen
             controlPoint1:CGPointMake(center.x-1.25*rad*cosf(M_PI*5/36), center.y+1.25*rad*sinf(M_PI*5/36))             controlPoint2:CGPointMake(center.x-1.25*rad*cosf(M_PI*5/36), center.y+1.25*rad*sinf(M_PI*5/36))];//[patch addLineToPoint:pointNineteen];
    [patch addCurveToPoint:pointEghteen
             controlPoint1:CGPointMake(center.x-0.5*rad*cosf(M_PI*3/36), center.y+0.5*rad*sinf(M_PI*3/36))             controlPoint2:CGPointMake(center.x-0.5*rad*cosf(M_PI*3/36), center.y+0.5*rad*sinf(M_PI*3/36))];//[patch addLineToPoint:pointEghteen];//curve
    
    
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);

    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        CGContextSetStrokeColorWithColor(context, self.storkeColor.CGColor);
    } else {
      CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    }
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
