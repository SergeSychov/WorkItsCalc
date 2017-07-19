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
    } else {
        if(!isChoosed){
            if(self.markView){
                [self.markView removeFromSuperview];
                self.markView = nil;
            }
        }
    }
    _isChoosed = isChoosed;
}

-(void) setDesignIndex:(NSInteger)designIndex
{
    _designIndex = designIndex;
    self.borderColor = [DesignObject borderColorForDesing:designIndex];
    self.bodyColor = [DesignObject bodyColorForDesing:designIndex];
    self.titleColor = [DesignObject titleColorForDesing:designIndex];
    self.titleShadow = [DesignObject titleShadowForDesign:designIndex];
    self.borderVsRadius = [DesignObject borderVsRadiusForDesing:designIndex];
    self.shadowOpacity = [DesignObject shadowOpacityForDesing:designIndex];
    self.shadowBlur = [DesignObject shadowBlurForDesing:designIndex];
    self.shadowColor = [DesignObject shadowColorForDesing:designIndex];
    self.shadowOffset = [DesignObject shadowOffsetForDesing:designIndex];
    
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
