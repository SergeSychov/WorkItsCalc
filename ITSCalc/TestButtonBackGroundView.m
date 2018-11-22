//
//  TestButtonBackGroundView.m
//  ChecButton
//
//  Created by Serge Sychov on 07.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "TestButtonBackGroundView.h"
#import "MarkView.h"
#import "RoundViewForDesignChooseButton.h"

//for colors
#import "Clr.h"

#define INDENT 20.

NSString *const TestButtonReciveChangedNotification=@"SendChangedNotification";

@interface TestButtonBackGroundView()


@property (nonatomic,strong) CALayer *buttonLayer;
@property (nonatomic) CGFloat boardWidht;

@property (nonatomic) UIColor* borderColor;
@property (nonatomic) UIColor* bodyColor;
@property (nonatomic) UIColor* titleColor;
@property (nonatomic) BOOL titleShadow;

@property (nonatomic) CGFloat borderVsRadius;

@property (nonatomic) UIColor* shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGFloat shadowOpacity;

@property (nonatomic,weak) MarkView *markView;

@end
@implementation TestButtonBackGroundView



-(void)drawRect:(CGRect)rect
{
    rect = CGRectInset(rect, 3, 3);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect qardForButton = CGRectMake(0, 0, rect.size.width, rect.size.width);
    
    CGFloat borderWidth;
    CGFloat radiusCorner;
    
    
    if(IS_IPAD){
        radiusCorner = rect.size.height/ 3.;
        
        borderWidth = radiusCorner / self.borderVsRadius;//4.9;//9.2;
    } else {
        radiusCorner = self.frame.size.height/ 3.2;
        
        borderWidth = radiusCorner / self.borderVsRadius;
    }
    self.boardWidht = borderWidth;
    
    CGContextBeginPath(context);
    CGMutablePathRef patch= CGPathCreateMutable();
    CGPathAddEllipseInRect(patch, NULL, CGRectInset(qardForButton, qardForButton.size.width/10, qardForButton.size.height/10.));
    CGContextAddPath(context, patch);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    //set shadow
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if(self.isChoosed){
        if(self.markView){
            [self.markView setFrame:CGRectInset(rect, rect.size.width/5, rect.size.width/5)];
            
            self.markView.markColor = self.titleColor;
            self.markView.isShadow = self.titleShadow;
            self.markView.shadowColor = self.shadowColor;
            self.markView.shadowBlur = self.shadowBlur;
            self.markView.shadowOffset = self.shadowOffset;
            self.markView.backgroundColor = [UIColor clearColor];
            self.markView.lineWidht = borderWidth;
            
        } else {
            
        }
    }
    
}
-(void) setup
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:TestButtonReciveChangedNotification object:nil];
}
-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
