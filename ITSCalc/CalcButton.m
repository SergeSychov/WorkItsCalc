//
//  CalcButton.m
//  ITSCalc
//
//  Created by Sychov Intencom on 19.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "CalcButton.h"

@interface CalcButton()
@property (nonatomic,strong) UIColor* storkeColor;
@property (nonatomic,strong) UIColor *touchedColor;

@end

@implementation CalcButton

//work with change color in case of event


-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.15;
    }];
    return [super beginTrackingWithTouch:touch withEvent:event];
    
}
-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Golden ratio
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef pathOfRect;
    CGContextSetLineWidth(context, rect.size.width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    if(self.state == UIControlStateNormal){
        CGContextSetStrokeColorWithColor(context, self.storkeColor.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    }
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);

    //first rect
    CGFloat goldenRatio = 1.618;
    //defend center
    CGFloat width = rect.size.width / 2.5;
    CGFloat height = width*goldenRatio;
    CGRect calcRect = CGRectMake(center.x - width/2, center.y-height/2, width, height);
    CGFloat cornerRadius = width/10;
    UIBezierPath *patch = [UIBezierPath bezierPathWithRoundedRect:calcRect cornerRadius:cornerRadius];
    pathOfRect = patch.CGPath;
    CGContextAddPath(context, pathOfRect);
    //
    //heigth line
    CGFloat heightLine = center.y-2*cornerRadius;
    
    //second rect
    CGFloat widthDisp = width - 2*cornerRadius;
    CGFloat heightDisp = height/4;
    CGRect dispRect = CGRectMake(center.x-widthDisp/2, heightLine-heightDisp, widthDisp, heightDisp);
    UIBezierPath *dispPatch = [UIBezierPath bezierPathWithRoundedRect:dispRect cornerRadius:cornerRadius];
    CGPathRef patchOfDispl = dispPatch.CGPath;
    CGContextAddPath(context, patchOfDispl);
    
    //button rect
    CGFloat buttonWidth = width/5;
    CGFloat buttonHeith = width/5;
    CGFloat buttonCorner = width/20;
    CGPoint origButton = CGPointMake(center.x-width/2+cornerRadius, heightLine+cornerRadius);
    CGRect buttOneRect = CGRectMake(origButton.x, origButton.y, buttonWidth, buttonHeith);
    UIBezierPath *buttOnePatch = [UIBezierPath bezierPathWithRoundedRect:buttOneRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonOne = buttOnePatch.CGPath;
    CGContextAddPath(context, patchOfButtonOne);
    
    CGPoint origButtonTwo = CGPointMake(center.x-buttonWidth/2, heightLine + cornerRadius);
    CGRect buttTwoRect = CGRectMake(origButtonTwo.x, origButtonTwo.y, buttonWidth, buttonHeith);
    UIBezierPath *buttTwoPatch = [UIBezierPath bezierPathWithRoundedRect:buttTwoRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonTwo = buttTwoPatch.CGPath;
    CGContextAddPath(context, patchOfButtonTwo);
    
    CGPoint origButtonThree = CGPointMake(center.x+2*cornerRadius,heightLine+cornerRadius);
    CGRect buttThreeRect = CGRectMake(origButtonThree.x, origButtonThree.y, buttonWidth, buttonHeith);
    UIBezierPath *buttThreePatch = [UIBezierPath bezierPathWithRoundedRect:buttThreeRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonThree = buttThreePatch.CGPath;
    CGContextAddPath(context, patchOfButtonThree);
    //---------------------------------------------------------------
    CGPoint origButtonFour = CGPointMake(center.x-width/2+cornerRadius, heightLine+4*cornerRadius);
    CGRect buttFourRect = CGRectMake(origButtonFour.x, origButtonFour.y, buttonWidth, buttonHeith);
    UIBezierPath *buttFourPatch = [UIBezierPath bezierPathWithRoundedRect:buttFourRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonFour = buttFourPatch.CGPath;
    CGContextAddPath(context, patchOfButtonFour);
    
    CGPoint origButtonFive = CGPointMake(center.x-buttonWidth/2, heightLine+4*cornerRadius);
    CGRect buttFiveRect = CGRectMake(origButtonFive.x, origButtonFive.y, buttonWidth, buttonHeith);
    UIBezierPath *buttFivePatch = [UIBezierPath bezierPathWithRoundedRect:buttFiveRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonFive = buttFivePatch.CGPath;
    CGContextAddPath(context, patchOfButtonFive);
    
    CGPoint origButtonSix = CGPointMake(center.x+2*cornerRadius,heightLine+4*cornerRadius);
    CGRect buttSixRect = CGRectMake(origButtonSix.x, origButtonSix.y, buttonWidth, buttonHeith);
    UIBezierPath *buttSixPatch = [UIBezierPath bezierPathWithRoundedRect:buttSixRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonSix = buttSixPatch.CGPath;
    CGContextAddPath(context, patchOfButtonSix);
    //----------------------------------
    
    CGPoint origButtonSeven = CGPointMake(center.x-width/2+cornerRadius, heightLine+7*cornerRadius);
    CGRect buttSevenRect = CGRectMake(origButtonSeven.x, origButtonSeven.y, buttonWidth, buttonHeith);
    UIBezierPath *buttSevenPatch = [UIBezierPath bezierPathWithRoundedRect:buttSevenRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonSeven = buttSevenPatch.CGPath;
    CGContextAddPath(context, patchOfButtonSeven);
    
    CGPoint origButtonEight = CGPointMake(center.x-buttonWidth/2, heightLine+7*cornerRadius);
    CGRect buttEightRect = CGRectMake(origButtonEight.x, origButtonEight.y, buttonWidth, buttonHeith);
    UIBezierPath *buttEightPatch = [UIBezierPath bezierPathWithRoundedRect:buttEightRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonEight = buttEightPatch.CGPath;
    CGContextAddPath(context, patchOfButtonEight);
    
    CGPoint origButtonNine = CGPointMake(center.x+2*cornerRadius,heightLine+7*cornerRadius);
    CGRect buttNineRect = CGRectMake(origButtonNine.x, origButtonNine.y, buttonWidth, buttonHeith);
    UIBezierPath *buttNinePatch = [UIBezierPath bezierPathWithRoundedRect:buttNineRect cornerRadius:buttonCorner];
    CGPathRef patchOfButtonNine = buttNinePatch.CGPath;
    CGContextAddPath(context, patchOfButtonNine);

    
    CGContextDrawPath(context, kCGPathFillStroke);
    

}


@end
