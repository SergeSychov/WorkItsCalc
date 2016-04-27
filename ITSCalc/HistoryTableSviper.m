//
//  HistoryTableSviper.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

//define design numbers
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

#define IS_BLACK_MODE NO
#import "HistoryTableSviper.h"

@interface HistoryTableSviper()
@property (nonatomic,strong) UIColor *color;

@end

@implementation HistoryTableSviper

-(UIColor*)color{
    if(!_color){
        _color = [UIColor blackColor];
    }
    return _color;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pattOfDown = 0;
        // Initialization code
    }
    return self;
}

-(void) setPattOfDown:(CGFloat)pattOfDown
{
    _pattOfDown = pattOfDown;
    [self setNeedsDisplay];
}

-(void) setDesign:(NSInteger)design
{
    _design = design;
    if(design == DESIGN_PHOTO){
        self.color = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    } else {
        self.color = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    [self setNeedsDisplay];
}
-(void) drawSwipeSymbolInContext:(CGContextRef) context
{
    CGFloat fivePart = self.frame.size.height/5;
    CGRect rect = CGRectMake(self.frame.origin.x,
                             self.frame.origin.y + 2*fivePart,
                             self.frame.size.width,
                             fivePart);
    
    CGFloat lineWith = rect.size.height/3;
    CGContextSetLineWidth(context, lineWith);
    CGContextMoveToPoint(context, rect.size.width/6 +.5, rect.size.height /2 +.5 + 2*fivePart);
    
    CGContextAddLineToPoint(context, rect.size.width/2 +.5, 2*fivePart +.5 + (rect.size.height * (1-  self.pattOfDown)));
    /*
    if(self.isShowedButtom){
        CGContextAddLineToPoint(context, rect.size33333.width/2 +.5, rect.size.height /2 + thirdPart +.5 + (lineWith) );
    } else {
        CGContextAddLineToPoint(context, rect.size.width/2 +.5, rect.size.height - (lineWith) +.5 + thirdPart);
    }
    */
    CGContextAddLineToPoint(context, rect.size.width *5/6 +.5, rect.size.height /2 +.5 + 2*fivePart);
    CGContextSetLineCap(context , kCGLineCapRound);
    //if(IS_BLACK_MODE){
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    //    CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 0.3);
    //} else {
   //     CGContextSetRGBStrokeColor(context, 0.0, 0., 0., 0.3);
   // }
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
