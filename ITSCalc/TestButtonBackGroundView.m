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

#define INDENT 20.

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

//define design string
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

NSString *const ReciveChangedNotification=@"SendChangedNotification";

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

#pragma mark NOTIFICATION
-(void) recivedNotification:(NSNotification*)notification
{
    NSArray *keys = notification.userInfo.allKeys;
    if(keys.count && (keys.count < 2) && [keys[0] isKindOfClass:[NSString class]]){
        //NSLog(@"Ok recived notification %@ for key %@", [notification.userInfo objectForKey:keys[0]], keys[0]);
        NSString *key = keys[0];
        if([key isEqualToString:@"ChangedDesign"]){
            
            NSInteger newDesign = [[notification.userInfo objectForKey:keys[0]] integerValue];
            if(self.designIndex == newDesign){
                self.isChoosed = YES;
            } else {
                self.isChoosed = NO;
            }
            
        }
        //NSLog(@"recived wrong notification");
    }
    
}

-(void) setIsChoosed:(BOOL)isChoosed
{
    if(_isChoosed != isChoosed){
        if(_isChoosed){
            [UIView animateWithDuration:0.4 animations:^{
                self.markView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.markView removeFromSuperview];
                self.markView = nil;
            }];
        } else {
            MarkView *markView = [[MarkView alloc] initWithFrame:CGRectInset(self.bounds, self.bounds.size.width/5, self.bounds.size.width/5)];
            markView.markColor = self.titleColor;
            markView.isShadow = self.titleShadow;
            markView.shadowColor = self.shadowColor;
            markView.shadowBlur = self.shadowBlur;
            markView.shadowOffset = self.shadowOffset;
            markView.lineWidht = self.boardWidht;
            markView.backgroundColor = [UIColor clearColor];
            markView.alpha = 0;
            [self addSubview:markView];
            self.markView = markView;
            
            RoundViewForDesignChooseButton *roundView = [[RoundViewForDesignChooseButton alloc] initWithFrame:self.bounds];
            roundView.bodyColor = self.titleColor;
            roundView.backgroundColor = [UIColor clearColor];
            roundView.alpha = 0;
            [self addSubview:roundView];
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.markView.alpha = 1;
                                 roundView.alpha = 1;
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.8
                                                  animations:^{
                                                      roundView.alpha = 0;
                                                  } completion:^(BOOL finished) {
                                                      [roundView removeFromSuperview];
                                                  }];
                             }];
            
        }
    }
    _isChoosed = isChoosed;
}

-(void) setDesignIndex:(NSInteger)designIndex
{
    _designIndex = designIndex;
    switch (self.designIndex) {
        case DESIGN_CLASSIC:
            self.borderColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.55 alpha:1];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = YES;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0];
            self.shadowOffset = CGSizeMake(0, 0);
            break;
            
        case DESIGN_PAPER:
            self.borderColor = [UIColor darkTextColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor darkTextColor];
            self.titleShadow = YES;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 1;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor colorWithWhite:1 alpha:1.];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        case DESIGN_COLOR_BLUE:
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithRed:0.58 green:0.812 blue:0.922 alpha:1];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = NO;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GREEN:
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithRed:.404 green:0.875 blue:0.624 alpha:1];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = NO;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_YELOW:
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithRed:1. green:0.788 blue:0.212 alpha:1];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = NO;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_PINK:
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithRed:1. green:0.663 blue:0.565 alpha:1];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = NO;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GRAY:
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithWhite:0.3 alpha:1];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = NO;
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_PHOTO:
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            self.titleShadow = YES;
            self.borderVsRadius = 6.2;
            
            self.shadowOpacity = 0.5;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        default:
            self.borderColor = [UIColor lightGrayColor];
            self.bodyColor = [UIColor clearColor];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0];
            self.shadowOffset = CGSizeMake(0, 0);
            break;
    }
    
}

-(void)drawRect:(CGRect)rect
{
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNotification:) name:ReciveChangedNotification object:nil];
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
