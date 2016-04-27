//
//  designButtonView.m
//  ITSCalc
//
//  Created by Serge Sychov on 28.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "designButtonView.h"
#import "Clr.h"

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
    if(IS_IPAD){
        self.titleFont = [UIFont systemFontOfSize:18];
    } else {
        self.titleFont = [UIFont systemFontOfSize:20];
    }
    switch (self.design) {
        case DESIGN_CLASSIC:
            self.title = @"классический";
            self.borderColor = [Clr digitsButton];
            self.bodyColor = [UIColor clearColor];

            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0];
            self.shadowOffset = CGSizeMake(0, 0);
            break;
            
        case DESIGN_PAPER:
            self.title = @"бумажный";
            self.borderColor = [UIColor darkTextColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor darkTextColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 1;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor colorWithWhite:1 alpha:1.];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        case DESIGN_COLOR_BLUE:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [Clr blueButton];
            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GREEN:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [Clr greenButton];
            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_YELOW:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [Clr yellowButton];
            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_PINK:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor =[Clr pinkButton];
            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GRAY:
            self.title = @"цветной";
            self.borderColor = [UIColor clearColor];
            self.bodyColor = [Clr grayButton];
            self.titleColor = [UIColor whiteColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0.3;
            self.shadowBlur = 6;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_PHOTO:
            self.title = @"фото";
            self.borderColor = [UIColor whiteColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor whiteColor];
            
            if(IS_IPAD){
                self.titleFont = [UIFont boldSystemFontOfSize:18];
            } else {
                self.titleFont = [UIFont boldSystemFontOfSize:20];
            }
            self.borderVsRadius = 6.2;
            
            self.shadowOpacity = 0.5;
            self.shadowBlur = 0.5;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowOffset = CGSizeMake(1, 1);
            break;
            
        default:
            self.title =@"NO DESIGN";
            self.borderColor = [UIColor lightGrayColor];
            self.bodyColor = [UIColor clearColor];
            self.titleColor = [UIColor lightGrayColor];
            
            //self.titleFont = [UIFont systemFontOfSize:20];
            self.borderVsRadius = 12.2;
            
            self.shadowOpacity = 0;
            self.shadowBlur = 0;
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0];
            self.shadowOffset = CGSizeMake(0, 0);
            break;
    }
    [self setNeedsDisplay];
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

-(void) drawButtonViewInContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect cornerRect;
    UIBezierPath *drawRectPath;
    CGPathRef pathOfRect;
    CGFloat borderWidth;
    CGFloat radiusCorner;
    
    
    if(IS_IPAD){
        radiusCorner = ((rect.size.height)/1.2)/ 3.;
        
        borderWidth = radiusCorner /self.borderVsRadius;// 4.9;//9.2;
    } else {
        radiusCorner = ((rect.size.height)/1.2)/ 3.2;
        
        borderWidth = radiusCorner / self.borderVsRadius;
    }
    
    //to states of buttons
    CGFloat x = rect.size.width/12 + borderWidth /2;
    CGFloat y = rect.size.height/12+borderWidth /2;
    CGFloat width = rect.size.width/1.2 - borderWidth;
    CGFloat height = rect.size.height/1.2 -borderWidth;
    cornerRect = CGRectMake(x,y,width,height);
    
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(radiusCorner - borderWidth)];
    CGContextSetLineWidth(context, borderWidth);
    
    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);

    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);

}



-(void) drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawButtonViewInContext:context inRect:rect];

    CGRect labelRect = CGRectInset(rect, rect.size.height/5, rect.size.height/5);
    [self.titleLabel setFrame:labelRect];
    if(self.design ==DESIGN_PHOTO || self.design == DESIGN_PAPER){
        self.titleLabel.shadowColor = self.shadowColor;
        self.titleLabel.shadowOffset = self.shadowOffset;
    }
}

@end
