//
//  HistoryTableSviper.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "HistoryTableSviper.h"

@implementation HistoryTableSviper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) drawSwipeSymbolInContext:(CGContextRef) context
{
    CGRect rect = self.frame;
   
    CGFloat lineWith = rect.size.height/4;
    CGContextSetLineWidth(context, lineWith);
    CGContextMoveToPoint(context, rect.size.width/6 +.5, rect.size.height /2 +.5 );
    CGContextAddLineToPoint(context, rect.size.width/2 +.5, rect.size.height - ( lineWith) +.5);
    CGContextAddLineToPoint(context, rect.size.width *5/6 +.5, rect.size.height /2 +.5);
    CGContextSetLineCap(context , kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    CGContextStrokePath(context);  
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawSwipeSymbolInContext: context];
}


@end
