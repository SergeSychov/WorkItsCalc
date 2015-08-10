//
//  designButtonView.m
//  ITSCalc
//
//  Created by Serge Sychov on 28.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "designButtonView.h"

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

@interface designButtonView()
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic) UIColor* titleColor;
@property (nonatomic,weak) UIFont *titleFont;

@property (nonatomic) UIColor* borderColor;
@property (nonatomic) UIColor* bodyColor;

@property (nonatomic) CGFloat borderVsRadius;

@property (nonatomic) UIColor* shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGFloat shadowOpacity;

@end

@implementation designButtonView
-(void) setDesign:(NSInteger)design
{
    _design = design;
    switch (self.design) {
        case DESIGN_CLASSIC:
            self.title = @"классический";
            self.borderColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.55 alpha:1];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = 0;
            self.shadowOffset = CGSizeMake(0, 0);
            break;
            
        case DESIGN_PAPER:
            self.title = @"бумажный";
            self.borderColor = [UIColor darkTextColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor darkTextColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 1;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor whiteColor];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        case DESIGN_COLOR_BLUE:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [UIColor colorWithRed:0.58 green:0.812 blue:0.922 alpha:.6];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GREEN:
            self.title = @"цветной";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_YELOW:
            self.title = @"цветной";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_PINK:
            self.title = @"цветной";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GRAY:
            self.title = @"цветной";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_PHOTO:
            self.title = @"фото";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            self.titleFont = [UIFont boldSystemFontOfSize:20];
            self.borderVsRadius = 6.2;
            
            self.shadowOpacity = 0.5;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor blackColor];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        default:
            self.title =@"NO DESIGN";
            self.borderColor = [UIColor lightGrayColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor lightGrayColor];
            
            self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = 0;
            self.shadowOffset = CGSizeMake(0, 0);
            break;
    }

}

-(NSString*)title{
    if(!_title){
        _title = @"any design";
    }
    return _title;
}



-(UIColor*) titleColor
{
    if(!_titleColor){
        _titleColor = [UIColor redColor];
    }
    return _titleColor;
}

-(UILabel*) titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.title;
        titleLabel.textColor = self.titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = self.titleFont;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(void) drawButtonViewInContext:(CGContextRef)context
{
    CGRect cornerRect;
    UIBezierPath *drawRectPath;
    CGPathRef pathOfRect;
    CGFloat borderWidth;
    CGFloat radiusCorner;
    
    
    if(IS_IPAD){
        radiusCorner = self.frame.size.height/ 3.;
        
        borderWidth = radiusCorner / 4.9;//9.2;
    } else {
        radiusCorner = self.frame.size.height/ 3.2;
        
        borderWidth = radiusCorner / self.borderVsRadius;
    }
    
    //to states of buttons
    CGFloat x = borderWidth /2;
    CGFloat y = borderWidth /2;
    CGFloat width = self.bounds.size.width - borderWidth;
    CGFloat height = self.bounds.size.height -borderWidth;
    cornerRect = CGRectMake(x,y,width,height);
    
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(radiusCorner - borderWidth)];
    CGContextSetLineWidth(context, borderWidth);
    
    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);
    
    //UIColor *borderColor;
    //UIColor *bodyColor;

    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}



-(void) drawRect:(CGRect)rect{
    
    //self.backgroundColor = [UIColor clearColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawButtonViewInContext:context];
    

    CALayer *layer = self.layer;
    //layer.shadowOffset = CGSizeMake(10, 10);
    layer.shadowOpacity = self.shadowOpacity;
    //layer.shadowColor = self.shadowColor.CGColor;
    //layer.shadowRadius = self.shadowBlur;
    

    layer.shadowOffset = self.shadowOffset;
    layer.shadowColor = self.shadowColor.CGColor;
    layer.shadowRadius = self.shadowBlur;

    
    CGRect labelRect = CGRectInset(rect, rect.size.height/5, rect.size.height/5);
    [self.titleLabel setFrame:labelRect];
}

@end
