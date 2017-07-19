//
//  designButtonView.m
//  ITSCalc
//
//  Created by Serge Sychov on 28.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "designButtonView.h"
#import "Clr.h"
#import "DesignObject.h"


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
-(void) setDesignIndex:(NSInteger)designIndex{
    _designIndex = designIndex;
    
    self.title = [DesignObject titleButtonForDesign:designIndex];
    self.titleFont = [DesignObject titleFontForDesing:designIndex];
    self.borderColor = [DesignObject borderColorForDesing:designIndex];
    self.bodyColor = [DesignObject bodyColorForDesing:designIndex];
    self.titleColor = [DesignObject titleColorForDesing:designIndex];
    self.borderVsRadius = [DesignObject borderVsRadiusForDesing:designIndex];
    self.shadowOpacity = [DesignObject shadowOpacityForDesing:designIndex];
    self.shadowBlur = [DesignObject shadowBlurForDesing:designIndex];
    self.shadowColor = [DesignObject shadowColorForDesing:designIndex];
    self.shadowOffset = [DesignObject shadowOffsetForDesing:designIndex];
    

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
    if(self.designIndex ==DESIGN_PHOTO || self.designIndex == DESIGN_PAPER){
        self.titleLabel.shadowColor = self.shadowColor;
        self.titleLabel.shadowOffset = self.shadowOffset;
    }
}

@end
