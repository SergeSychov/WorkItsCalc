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

#define DESIGN_CLASSIC_STR @"Classic"
#define DESIGN_PAPER_STR @"Paper"
#define DESIGN_COLOR_STR @"Color"
#define DESIGN_MARTINI_STR @"Martini"
#define DESIGN_ADVENTURE_TIME_STR @"Adventure Time"
#define DESIGN_HIGH_TECH_STR @"Hight Tech"

//types of calculator buttons
#define MAIN_BUTTON 1
#define CHANGE_BUTTON 2
#define CHANGE_BUTTON_NOT_DELETABLE 3
#define DELETED_BUTTON 4
#define DELETED_USER_BUTTON 5



#define BORDER_VS_RADIUS  [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 16.2 : 12.2;

#define BUTTON_TITLE_INSET 0.8
#define BUTTON_INDENT 5.
#define BUTTON_RADIUS_OF_HEIGHT_IPHONE 4.
#define BUTTON_RADIUS_OF_HEIGHT_IPAD    4.
#define MULTIPLY_BUTTON_BY_TOUCH 2.

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_X (([[UIScreen mainScreen]bounds].size.height/[[UIScreen mainScreen]bounds].size.width > 1.8) || ([[UIScreen mainScreen]bounds].size.height/[[UIScreen mainScreen]bounds].size.width < 0.52))
#define PHONE_HISTORY_CELL_HEIGHT_VS_WIDTH 0.1875
#define MOTION_IPAD 0.//30.
#define MOTION_IPHONE 0.//20.
@class DesignObject;
@protocol DesignStrDelegate <NSObject>
-(UIUserInterfaceSizeClass)currentInterfaceClassSize;
-(CGFloat)currentCalcWith;
@end

@interface DesignObject : NSObject

@property (nonatomic) NSInteger designNumber;
@property (nonatomic) NSString* designString;
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
@property (nonatomic, readonly) UIColor* historySwiperColor;
@property (nonatomic, readonly) UIColor* historyTableColor;
@property (nonatomic, readonly)UIColor* colorSelectedHistoryRow;
@property (nonatomic, readonly)UIColor* colorUnselectedHistoryRow;
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
@property (nonatomic, readonly) UIColor* storkeButtonWithFill;
@property (nonatomic, readonly,strong) UIColor *shadowColor;
@property (nonatomic, readonly) CGFloat shadowBlur;
@property (nonatomic, readonly) CGSize shadowSize;

@property (nonatomic, readonly) CGFloat ButtonIndent;
@property (nonatomic, readonly) CGFloat radiusOfHeight;

//for calc screen label
@property (nonatomic, readonly) UIColor *displayContainerColor;
@property (nonatomic, readonly) UIColor *screenTextColor;
@property (readonly) BOOL isScreenShadow;
@property (nonatomic, readonly) CGFloat screenShadowOpasity;
@property (nonatomic, readonly) CGFloat screenShadowRadius;
@property (nonatomic, readonly) UIColor *screenButtonsEnabledColor;
@property (nonatomic, readonly) UIColor *screenButtonsDisabledColor;
//@property (nonatomic, readonly) UIBlurEffect* screenBlurEffect;
//@property (readonly) UIColor* screenButtonShadowColor;
//@property (readonly) CGFloat screenButtonShadowOpacity;
//@property (readonly) CGFloat screenButtonShadowBlur;

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
