//
//  DesignObject.h
//  CalcLayout
//
//  Created by Serge Sychov on 03.04.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define DEBUG_MODE NO

#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

//types of calculator buttons
#define MAIN_BUTTON 1
#define CHANGE_BUTTON 2
#define CHANGE_BUTTON_NOT_DELETABLE 3
#define DELETED_BUTTON 4
#define DELETED_USER_BUTTON 5



#define BORDER_VS_RADIUS  [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 16.2 : 7.2;

#define BUTTON_TITLE_INSET 0.8
#define BUTTON_INDENT 5.
#define BUTTON_RADIUS_OF_HEIGHT_IPHONE 4.
#define BUTTON_RADIUS_OF_HEIGHT_IPAD    4.
#define MULTIPLY_BUTTON_BY_TOUCH 2.

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_X ([[UIScreen mainScreen]bounds].size.height == 812. || [[UIScreen mainScreen]bounds].size.width == 812.)
#define MOTION_IPAD 30.
#define MOTION_IPHONE 20.
@class DesignObject;
@protocol DesignStrDelegate <NSObject>
-(UIUserInterfaceSizeClass)currentInterfaceClassSize;
@end

@interface DesignObject : NSObject

@property (nonatomic) NSInteger designNumber;
@property (nonatomic, weak) id <DesignStrDelegate> delegate;


//for main attributed string
@property (nonatomic, readonly) NSDictionary* atrforHistoryTable;
@property (nonatomic, readonly) NSDictionary* atrForLabelHistoryTable;
//@property (nonatomic, readonly) NSDictionary* atrForScreen;
@property (nonatomic, readonly) NSDictionary* atrforButtons;

@property (nonatomic, readonly) UIColor* mainAtrTextColor;
@property (nonatomic, readonly) UIFontTextStyle compactTextStyle;
@property (nonatomic, readonly) UIFontTextStyle regularTextStyle;
//form main container view
@property (nonatomic, readonly) UIColor* mainViewBackgroundColor;


//for history table view
@property (nonatomic, readonly) UIColor* historyTableColor;
@property (nonatomic, readonly)UIColor* colorSelectedFirstGradient;
@property (nonatomic, readonly)UIColor* colorSelectedSecondGradient;
@property (nonatomic, readonly)UIColor* colorUnselectedFirstGradient;
@property (nonatomic, readonly)UIColor* colorUnselectedSecondGradient;
@property (nonatomic, readonly)UIColor* colorForSelectedText;
@property (nonatomic, readonly)UIColor* colorForUnselectedText;
@property (nonatomic, readonly)UIColor *moreButtonColor;
@property (nonatomic, readonly)UIColor *moreButtonBackgroundColor;
@property (nonatomic, readonly)UIColor *buttonShadowColor;
@property (nonatomic, readonly)CGSize buttonShadowSize;
@property (nonatomic, readonly)CGFloat buttonShadowBlur;
@property (nonatomic, readonly)UIColor *deleteButtonColor;
@property (nonatomic, readonly)UIColor *deleteButtonBackgroundColor;



//for buttons collection view
@property (nonatomic, readonly) UIColor *mainColor;
@property (nonatomic, readonly) UIColor *digitsColor;
@property (nonatomic, readonly) UIColor *equalColor;
@property (nonatomic, readonly) UIColor *cColor;
@property (nonatomic, readonly) CGFloat fotnWeight;
@property (nonatomic, readonly) CGFloat borderVSRadius;
@property (nonatomic, readonly) BOOL fillButton;
@property (nonatomic, readonly,strong) UIColor *shadowColor;
@property (nonatomic, readonly) CGFloat shadowBlur;
@property (nonatomic, readonly) CGSize shadowSize;

@property (nonatomic, readonly) CGFloat ButtonIndent;
@property (nonatomic, readonly) CGFloat radiusOfHeight;

//for calc screen label
@property (nonatomic, readonly) UIColor *displayContainerColor;
@property (nonatomic, readonly) UIColor *screenTextColor;
@property (readonly) BOOL isScreenBlurHiden;
@property (nonatomic, readonly) UIBlurEffect* screenBlurEffect;
@property (readonly) UIColor* screenButtonShadowColor;
@property (readonly) CGSize screenButtonShadowSize;
@property (readonly) CGFloat screenButtonShadowBlur;

//for showed view
@property (nonatomic,readonly)NSDictionary* attributesInfo;
@property (nonatomic,readonly)NSDictionary* attributesExpl;
@property (nonatomic,readonly)NSDictionary* attributesResult;


-(id)initWithDesignIndex:(NSInteger)designIndex forDelegator:(id)controller;
-(UIColor*)textcolorButtonWithTitle:(NSString*)title;
-(NSAttributedString*)atrStrForButtonsFrom:(NSAttributedString*)inStr;
-(void)changeClassSize;


//external function for designButtonView
//IMPORTANT may be it's need be deletted
+(UIFont*) titleFontForDesing:(NSInteger)design;

+(NSString*)titleButtonForDesign:(NSInteger)design;
+(UIColor*)titleColorForDesing:(NSInteger)design;
+(BOOL)titleShadowForDesign:(NSInteger)design;
+(UIColor*)borderColorForDesing:(NSInteger)design;
+(UIColor*)bodyColorForDesing:(NSInteger)design;
+(CGFloat) borderVsRadiusForDesing:(NSInteger)design;
+(UIColor*)shadowColorForDesing:(NSInteger)design;
+(CGSize) shadowOffsetForDesing:(NSInteger)design;
+(CGFloat) shadowBlurForDesing:(NSInteger)design;
+(CGFloat) shadowOpacityForDesing:(NSInteger)design;

+(NSAttributedString*)changeFontSizeFrom:(NSAttributedString*)inStr toSize:(CGSize)size;


@end
