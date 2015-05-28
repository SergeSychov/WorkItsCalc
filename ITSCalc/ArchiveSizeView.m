//
//  ArchiveSizeView.m
//  ITSCalc
//
//  Created by Serge Sychov on 22.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "ArchiveSizeView.h"

@implementation ArchiveSizeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //defend center
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *patch = [UIBezierPath bezierPath];
    
    CGPathRef pathOfRect;
    CGFloat width = rect.size.width;
    CGFloat endAngle;
    if(self.isBig){
        endAngle = -M_PI*3/2;
    } else {
        endAngle = -M_PI;
    }
    /*
     CGFloat width;
     if(rect.size.width > rect.size.height){
     width = rect.size.width;
     } else {
     width = rect.size.height;
     }
     */
    //start positoin
    CGFloat rad = width/3;
    
    [patch addArcWithCenter:center
                     radius:rad
                 startAngle:0
                   endAngle:endAngle
                  clockwise:NO];
    NSAttributedString *string;
    
    //make arrow
    if(!self.isBig){
        [patch moveToPoint:CGPointMake(center.x-rad-1.5*rad/5, center.y-1.5*rad/5)];
        [patch addLineToPoint:CGPointMake(center.x-rad,center.y)];
        [patch addLineToPoint:CGPointMake(center.x-rad+1.5*rad/5, center.y-1.5*rad/5)];
        string = [[NSAttributedString alloc] initWithString:@"200"];
    } else {
        [patch moveToPoint:CGPointMake(center.x - 1.5*rad/5, center.y + rad - 1.5*rad/5)];
        [patch addLineToPoint:CGPointMake(center.x,center.y + rad)];
        [patch addLineToPoint:CGPointMake(center.x - 1.5*rad/5, center.y + rad+ 1.5*rad/5)];
        string = [[NSAttributedString alloc] initWithString:@"500"];
    }

    
    CGContextSetLineWidth(context, width/35);
    UIColor *fillColor = [UIColor clearColor];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    UIColor *storkecolor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, storkecolor.CGColor);
    
    
    pathOfRect = patch.CGPath;
    
    
    CGContextAddPath(context, pathOfRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSMutableAttributedString * countAtrStr = [string mutableCopy];
    
    UIFont *font = [UIFont systemFontOfSize:rad/1.6];
    UIColor *textColor = [UIColor whiteColor];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineHeightMultiple = 0;
    [countAtrStr beginEditing];
    NSRange wholeRange = NSMakeRange(0, [countAtrStr length]);
    [countAtrStr addAttribute:NSFontAttributeName value:font range:wholeRange];
    [countAtrStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
    //[countAtrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
    [countAtrStr addAttribute:NSParagraphStyleAttributeName value:style range:wholeRange];
    [countAtrStr endEditing];
    string = [countAtrStr copy];
    
    CGRect rectForText = CGRectMake(center.x-1.5*width/8 , center.y-width/8, 3*width/8, 2*width/8);
    [string drawInRect:rectForText];
   
    
}


@end
