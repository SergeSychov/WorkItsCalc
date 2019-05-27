//
//  newButtonView.h
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cmyk.h"
#import "DesignObject.h"

@interface newButtonView : UIView

//@property (nonatomic) struct Color buttonColor;

@property (nonatomic,strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor* storkeWithFill;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSAttributedString* attrbutedTitle;
//@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic) CGFloat radiusCorner;//may be not necessary too?
@property (nonatomic) BOOL isTaped;// ONLY FOR SET SHADOW

@property (nonatomic) DesignObject* designObj;

@property (nonatomic) UIColor* textNeedColor;
@property (nonatomic) UIColor* borderNeedColor;
@property (nonatomic) UIColor* fillNeedColor;
@property (nonatomic) BOOL fillButton;
@property (nonatomic) BOOL needStorkeWithFill;
//-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
//-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;
//@property (nonatomic) NSInteger design; //number of design


//-(void) setTextSize:(CGFloat)ratio;

@end
