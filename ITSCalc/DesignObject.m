//
//  DesignObject.m
//  CalcLayout
//
//  Created by Serge Sychov on 03.04.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import "DesignObject.h"
#import "Clr.h"

@interface DesignObject()
//for attributed text
@property (nonatomic, strong) NSDictionary* atrforHistoryTableIn;
@property (nonatomic, strong) NSDictionary* atrForLabelHistoryTableIn;
@property (nonatomic, strong) NSDictionary* atrForScreenIn;
@property (nonatomic, strong) NSDictionary* atrforButtonsIn;

@property (nonatomic,  strong)UIColor* mainAtrTextColorIn;
@property (nonatomic) UIFontTextStyle compactTextStyleIn;
@property (nonatomic) UIFontTextStyle regularTextStyleIn;

//form main container view
@property (nonatomic) UIColor* mainViewBackgroundColorIn;

//for history table view
@property (nonatomic, strong) UIColor* historySwiperColorIn;
@property (nonatomic, strong) UIColor* historyTableColorIn;
@property (nonatomic, strong )UIColor* colorSelectedHistoryRowIn;
@property (nonatomic, strong )UIColor* colorUnselectedHistoryRowIn;
@property (nonatomic, strong )UIColor* colorForSelectedTextIn;
@property (nonatomic, strong )UIColor* colorForUnselectedTextIn;
@property (nonatomic, strong )UIColor *moreButtonColorIn;
@property (nonatomic, strong )UIColor *moreButtonBackgroundColorIn;
@property (nonatomic, strong )UIColor *buttonShadowColorIn;
@property (nonatomic )CGSize buttonShadowSizeIn;
@property (nonatomic )CGFloat buttonShadowBlurIn;
@property (nonatomic, strong )UIColor *deleteButtonColorIn;
@property (nonatomic, strong )UIColor *deleteButtonBackgroundColorIn;



//for buttons collection view
@property (nonatomic, strong) UIColor *buttonTextColorIn;
@property (nonatomic,strong ) UIColor *mainColorIn;
@property (nonatomic,strong ) UIColor *digitsColorIn;
@property (nonatomic,strong ) UIColor *equalColorIn;
@property (nonatomic,strong ) UIColor *cColorIn;
@property (nonatomic ) CGFloat fotnWeightIn;
@property (nonatomic ) CGFloat borderVSRadiusIn;
@property (nonatomic ) BOOL fillButtonIn;
@property (nonatomic,strong) UIColor* storkeButtonWithFillIn;
@property (nonatomic ,strong) UIColor *shadowColorIn;
@property (nonatomic ) CGFloat shadowBlurIn;
@property (nonatomic ) CGSize shadowSizeIn;

@property (nonatomic) CGFloat ButtonIndentIn;
@property (nonatomic) CGFloat radiusOfHeightIn;

//for calc screen label
@property (nonatomic,strong) UIColor *displayContainerColorIn;
@property (nonatomic,strong) UIColor *screenTextColorIn;
@property (nonatomic) BOOL isScreenShadowIn;
@property (nonatomic) CGFloat screenShadowOpasityIn;
@property (nonatomic) CGFloat screenShadowRadiusIn;
@property (nonatomic, strong) UIColor *screenButtonsEnabledColorIn;
@property (nonatomic, strong) UIColor *screenButtonsDisabledColorIn;

//@property (nonatomic,strong) UIBlurEffect* screenBlurEffectIn;
//@property (nonatomic,strong) UIColor* screenButtonShadowColorIn;
//@property (nonatomic) CGFloat screenButtonShadowOpacityIn;
//@property (nonatomic) CGFloat screenButtonShadowBlurIn;

//for showed view
@property (nonatomic,strong)NSDictionary* attributesInfoIn;
@property (nonatomic,strong)NSDictionary* attributesExplIn;
@property (nonatomic,strong)NSDictionary* attributesResultIn;
@property (nonatomic,strong)UIColor* infoShowViewColor;
@property (nonatomic,strong)UIColor* explShowViewColor;
@property (nonatomic,strong)UIColor* resultShowViewColor;


@end

@implementation DesignObject
-(id)initWithDesignIndex:(NSInteger)designIndex forDelegator:(id)controller{
    self = [super init];
    if(self){
        self.delegate = controller;
        switch (designIndex) {
            case DESIGN_CLASSIC:
                _designString =DESIGN_CLASSIC_STR;
                break;
            case DESIGN_PAPER:
                _designString =DESIGN_PAPER_STR;
                break;
            case DESIGN_COLOR:
                _designString =DESIGN_COLOR_STR;
                break;
            case DESIGN_MARTINI:
                _designString =DESIGN_MARTINI_STR;
                break;
            case DESIGN_ADVENTURE_TIME:
                _designString =DESIGN_ADVENTURE_TIME_STR;
                break;
            case DESIGN_OLD_SCOOL:
                _designString =DESIGN_OLD_SCOOL_STR;
                break;
            case DESIGN_HIGH_TECH:
                _designString =DESIGN_HIGH_TECH_STR;
                break;
            default:
                _designString =DESIGN_CLASSIC_STR;
                break;
        }
        self.designNumber = designIndex;
    }
    return self;
}

-(void)setDesignString:(NSString *)designString{
    _designString = designString;
    if([designString isEqualToString:DESIGN_CLASSIC_STR]){
        self.designNumber = DESIGN_CLASSIC;
    } else if([designString isEqualToString:DESIGN_PAPER_STR]){
        self.designNumber = DESIGN_PAPER;
    }else if([designString isEqualToString:DESIGN_COLOR_STR]){
        self.designNumber= DESIGN_COLOR;
    }else if([designString isEqualToString:DESIGN_MARTINI_STR]){
        self.designNumber = DESIGN_MARTINI;
    }else if([designString isEqualToString:DESIGN_ADVENTURE_TIME_STR]){
        self.designNumber = DESIGN_ADVENTURE_TIME;
    }else if([designString isEqualToString:DESIGN_OLD_SCOOL_STR]){
        self.designNumber = DESIGN_OLD_SCOOL;
    }else if([designString isEqualToString:DESIGN_HIGH_TECH_STR]){
        self.designNumber = DESIGN_HIGH_TECH;
    } else {
        self.designNumber = DESIGN_CLASSIC;
    }
}



-(UIColor*)textcolorButtonWithTitle:(NSString*)title {
    //need to be changed according title
    return self.digitsColor;
}


-(void)setDesignNumber:(NSInteger)designNumber{
    _designNumber = designNumber;
    switch (self.designNumber) {
        case DESIGN_CLASSIC:
            //for attr text
            self.mainAtrTextColorIn = [UIColor whiteColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [UIColor colorWithWhite:0.15 alpha:1];//[UIColor clearColor];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [UIColor whiteColor];
            self.colorSelectedHistoryRowIn = [UIColor whiteColor];
            self.colorUnselectedHistoryRowIn = [UIColor colorWithWhite:0.95 alpha:1];
            self.colorForSelectedTextIn = [UIColor darkTextColor];
            self.colorForUnselectedTextIn = [UIColor lightGrayColor];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:1. green:0.231 blue:0.188 alpha:0.9];
            self.buttonShadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.buttonShadowSizeIn = BUTTON_SHADOW_OFFSET;
            self.buttonShadowBlurIn = 0.;

            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr digitsButton];
            self.cColorIn = [Clr cButton];
            self.equalColorIn = [Clr equalButton];
            self.mainColorIn = [Clr button];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.shadowBlurIn = 0.;
            self.shadowSizeIn = CGSizeMake(0, 0);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor blackColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = NO;
            self.screenShadowOpasityIn = 0.;
            self.screenShadowRadiusIn = 0;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            //self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            //self.screenButtonShadowColorIn = [UIColor clearColor];;
            //self.screenButtonShadowOpacityIn = 0.;
            //self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];
            
            break;
            
        case DESIGN_PAPER:
            //for attr text
            self.mainAtrTextColorIn = [Clr paperButton];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            
            //HistoryTableView
            self.historySwiperColorIn = [[Clr paperDigits] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.colorSelectedHistoryRowIn = [UIColor clearColor];
            self.colorUnselectedHistoryRowIn = [UIColor clearColor];
            self.colorForSelectedTextIn = [Clr paperDigits];
            self.colorForUnselectedTextIn = [[Clr paperDigits] colorWithAlphaComponent:0.4];

            self.moreButtonColorIn = [Clr paperEqual];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:1. green:0.231 blue:0.188 alpha:0.9];
            self.buttonShadowColorIn = [UIColor whiteColor];
            self.buttonShadowSizeIn = BUTTON_SHADOW_OFFSET;//CGSizeMake(1., 1.);
            self.buttonShadowBlurIn = BUTTON_SHADOW_RADIUS;//0.5;
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr paperDigits];
            self.cColorIn = [Clr paperC];
            self.equalColorIn = [Clr paperEqual];
            self.mainColorIn = [Clr paperButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_COLOR;//[UIColor whiteColor];
            self.shadowBlurIn = SHADOW_RADIUS;//0.5;
            self.shadowSizeIn = SHADOW_OFFSET;// CGSizeMake(1, 1);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.screenTextColorIn = [Clr paperDigits];
            self.isScreenShadowIn = YES;
            self.screenShadowOpasityIn = SHADOW_OPACITY;// 0.15;
            self.screenShadowRadiusIn = SHADOW_RADIUS;// 8.;
            self.screenButtonsEnabledColorIn = [Clr paperDigits];
            self.screenButtonsDisabledColorIn = [[Clr paperDigits] colorWithAlphaComponent:0.4];

            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            
            break;
            
        case DESIGN_COLOR:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr blueGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [Clr blueGround];
            self.colorSelectedHistoryRowIn = [Clr blueGround];//[UIColor whiteColor];
            self.colorUnselectedHistoryRowIn = [Clr blueSecondGradient];
            self.colorForSelectedTextIn = [Clr blueDisplay];
            self.colorForUnselectedTextIn =  [[Clr blueDisplay] colorWithAlphaComponent:0.4];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:1. green:0.231 blue:0.188 alpha:0.9];
            self.buttonShadowColorIn = BUTTON_SHADOW_COLOR;//[UIColor clearColor];
            self.buttonShadowSizeIn = BUTTON_SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = BUTTON_SHADOW_RADIUS;

            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr blueDigits];
            self.cColorIn = [Clr blueC];
            self.equalColorIn = [Clr blueEqual];
            self.mainColorIn = [Clr blueButton];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_COLOR;// [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = SHADOW_RADIUS;//3.;
            self.shadowSizeIn = SHADOW_OFFSET;// CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr blueDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = YES;
            self.screenShadowOpasityIn = SHADOW_OPACITY;// 0.85;
            self.screenShadowRadiusIn = SHADOW_RADIUS;// 4;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            
            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            
            break;
        case DESIGN_MARTINI:
            //for attr text
            self.mainAtrTextColorIn = [Clr greenText];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr greenGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[Clr greenText] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [Clr greenFirstGradient];
            self.colorSelectedHistoryRowIn = [Clr greenFirstGradient];
            self.colorUnselectedHistoryRowIn = [Clr greenFirstGradient];
            self.colorForSelectedTextIn = [Clr greenText];
            self.colorForUnselectedTextIn =  [[Clr greenText] colorWithAlphaComponent:0.4];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr greenMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr greenDelButton];
            self.buttonShadowColorIn = BUTTON_SHADOW_COLOR;//[UIColor clearColor];
            self.buttonShadowSizeIn = BUTTON_SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = BUTTON_SHADOW_RADIUS;// 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr greenDigits];
            self.cColorIn = [Clr greenC];
            self.equalColorIn = [Clr greenEqual];
            self.mainColorIn = [Clr greenButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            self.storkeButtonWithFillIn =[Clr greenStorkeAndScreenColor];
            
            self.shadowColorIn = SHADOW_COLOR;//[UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = SHADOW_RADIUS;//3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn =[Clr greenDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = YES;
            self.screenShadowOpasityIn = SHADOW_OPACITY;// 0.75;//0.85;
            self.screenShadowRadiusIn = SHADOW_RADIUS;//12;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];

            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            
            break;
        case DESIGN_ADVENTURE_TIME:
            //for attr text
            self.mainAtrTextColorIn = [Clr yellowText];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr yellowGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [Clr yellowFirstGradient];
            self.colorSelectedHistoryRowIn = [Clr yellowFirstGradient];
            self.colorUnselectedHistoryRowIn = [Clr yellowSecondGradient];
            self.colorForSelectedTextIn = [Clr yellowText];
            self.colorForUnselectedTextIn =  [[Clr yellowText] colorWithAlphaComponent:0.4];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr yellowMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr yellowDelButton];
            self.buttonShadowColorIn =  SHADOW_CLEAR;//[UIColor clearColor];
            self.buttonShadowSizeIn = SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [Clr yellowText];
            self.digitsColorIn = [Clr yellowDigits];
            self.cColorIn = [Clr yellowC];
            self.equalColorIn = [Clr yellowEqal];
            self.mainColorIn = [Clr yellowButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            self.storkeButtonWithFillIn = [Clr yellowText];
            
            self.shadowColorIn = SHADOW_COLOR;//[UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = SHADOW_RADIUS;//3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr yellowDisplay];
            self.screenTextColorIn = [Clr yellowText];
            self.isScreenShadowIn = NO;
            self.screenShadowOpasityIn = SHADOW_OPACITY;// 0.5;
            self.screenShadowRadiusIn = SHADOW_RADIUS;//8.0;
            self.screenButtonsEnabledColorIn = [Clr yellowText];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];

            //for showed view
            self.infoShowViewColor =[Clr yellowText];
            self.explShowViewColor =[Clr yellowText];
            self.resultShowViewColor=[Clr yellowText];

            
            break;
        case DESIGN_HIGH_TECH:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [UIColor clearColor];//[Clr pinkGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
            self.historyTableColorIn =[UIColor clearColor];// [Clr pinkFirstGradient];
            self.colorSelectedHistoryRowIn = [UIColor clearColor];//[Clr pinkFirstGradient];
            self.colorUnselectedHistoryRowIn = [UIColor clearColor];//[[UIColor whiteColor] colorWithAlphaComponent:0.2];// [Clr pinkFirstGradient];
            self.colorForSelectedTextIn = [UIColor whiteColor];//[Clr pinkText];
            self.colorForUnselectedTextIn = [[UIColor whiteColor] colorWithAlphaComponent:0.4];//[[Clr pinkDisplay] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr pinkMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr pinkDelButton];
            self.buttonShadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.buttonShadowSizeIn = SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [[UIColor whiteColor] colorWithAlphaComponent:0.35];//[Clr pinkDigits];
            self.cColorIn = [[UIColor whiteColor] colorWithAlphaComponent:1.];//[Clr pinkC];
            self.equalColorIn = [Clr pinkEqual];
            self.mainColorIn = [[UIColor whiteColor] colorWithAlphaComponent:0.2];//[Clr pinkButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_CLEAR;//[UIColor colorWithWhite:0 alpha:0.0];
            self.shadowBlurIn = 0.;
            self.shadowSizeIn = CGSizeMake(0, 0);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn =[[UIColor whiteColor] colorWithAlphaComponent:0.0];//[Clr pinkDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = YES;
            self.screenShadowOpasityIn = SHADOW_OPACITY;// 0.8;
            self.screenShadowRadiusIn = SHADOW_RADIUS;//12;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];

            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            break;
        case DESIGN_OLD_SCOOL:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn =[Clr grayGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [Clr grayFirstGradient];
            self.colorSelectedHistoryRowIn = [Clr grayFirstGradient];
            self.colorUnselectedHistoryRowIn = [Clr graySecondGradient];
            self.colorForSelectedTextIn = [Clr grayText];
            self.colorForUnselectedTextIn = [[Clr grayText] colorWithAlphaComponent:0.4];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr grayMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr grayDelButton];
            self.buttonShadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.buttonShadowSizeIn = SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr grayDigits];
            self.cColorIn = [Clr grayC];
            self.equalColorIn = [Clr grayC];
            self.mainColorIn = [Clr grayButton];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_COLOR;//[UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = SHADOW_RADIUS;//3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr grayDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = NO;
            self.screenShadowOpasityIn = 0.;
            self.screenShadowRadiusIn = 0;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            
            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            
            break;
        case DESIGN_PHOTO:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr blueGround];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [Clr photoFirstGradient];
            self.colorSelectedHistoryRowIn = [UIColor colorWithWhite:0 alpha:0.2];
            self.colorUnselectedHistoryRowIn = [Clr photoFirstGradient];
            self.colorForSelectedTextIn = [UIColor whiteColor];
            self.colorForUnselectedTextIn =  [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithWhite:0 alpha:0.1];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithWhite:0 alpha:0.1];
            self.buttonShadowColorIn = SHADOW_COLOR;//[UIColor grayColor];
            self.buttonShadowSizeIn = SHADOW_OFFSET;//CGSizeMake(2, 2.);
            self.buttonShadowBlurIn = SHADOW_RADIUS;//3.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [UIColor whiteColor];
            self.cColorIn = [UIColor whiteColor];
            self.equalColorIn = [UIColor whiteColor];
            self.mainColorIn = [UIColor whiteColor];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_COLOR;//[UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = SHADOW_RADIUS;//BORDER_VS_RADIUS;
            self.shadowSizeIn = SHADOW_OFFSET;// CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor clearColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = NO;
            self.screenShadowOpasityIn = 0.;
            self.screenShadowRadiusIn = 0;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];

            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];


            
            break;
        default:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn =  [UIColor clearColor];
            
            //HistoryTableView
            self.historySwiperColorIn = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            self.historyTableColorIn = [UIColor whiteColor];
            self.colorSelectedHistoryRowIn = [UIColor whiteColor];
            self.colorUnselectedHistoryRowIn = [Clr blueButton];
            
            self.colorForSelectedTextIn = [UIColor darkTextColor];
            self.colorForUnselectedTextIn = [UIColor grayColor];
            //[self.contentView setBackgroundColor:[UIColor clearColor]];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:0.68 green:0.13 blue:0. alpha:0.9];
            self.buttonShadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.buttonShadowSizeIn = SHADOW_OFFSET;//CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.buttonTextColorIn = [UIColor colorWithWhite:1. alpha:1];
            self.digitsColorIn = [Clr digitsButton];
            self.cColorIn = [Clr cButton];
            self.equalColorIn = [Clr equalButton];
            self.mainColorIn = [Clr button];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            self.storkeButtonWithFillIn = nil;
            
            self.shadowColorIn = SHADOW_CLEAR;//[UIColor clearColor];
            self.shadowBlurIn = 0.;
            self.shadowSizeIn = SHADOW_OFFSET;// CGSizeMake(0, 0);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor clearColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenShadowIn = NO;
            self.screenShadowOpasityIn = 0.;
            self.screenShadowRadiusIn = 0;
            self.screenButtonsEnabledColorIn = [UIColor whiteColor];
            self.screenButtonsDisabledColorIn = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];

            //for showed view
            self.infoShowViewColor =[UIColor darkTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor darkTextColor];

            
            break;
    }
    [self setAtrforHistoryTableInWith:self.colorForUnselectedText];
    [self setAtrForLabelHistoryTableInWith:self.colorForUnselectedText];
    [self setAtrforButtonsInWith:self.mainColorIn];
    [self setAttributesInfoInWith:self.infoShowViewColor];
    [self setAttributesExplInWith:self.explShowViewColor];
    [self setAttributesResultInWith:self.resultShowViewColor];
    
}

//set attributes for text
             
-(void)setAtrforHistoryTableInWith:(UIColor *)texColor{

    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.s
    UIFontDescriptor* fontDescriptor;
    UIFont *font;
    if ([self.delegate currentInterfaceClassSize] == UIUserInterfaceSizeClassCompact) {
        //get current class size
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.compactTextStyleIn];
        CGFloat compactTextSize = [self.delegate currentCalcWith]*PHONE_HISTORY_CELL_HEIGHT_VS_WIDTH/3;
        font  = [UIFont fontWithDescriptor:fontDescriptor size:compactTextSize];
        style.alignment = NSTextAlignmentLeft;
    }else {
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.regularTextStyle];
        font  = [UIFont fontWithDescriptor:fontDescriptor size:45];
       // font  = [UIFont preferredFontForTextStyle:self.regularTextStyle];
        style.alignment = NSTextAlignmentRight;
    }
    self.atrforHistoryTableIn = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,self.colorForUnselectedText, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    
}

-(void)setAtrForLabelHistoryTableInWith:(UIColor *)texColor{
    
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.s
    UIFontDescriptor* fontDescriptor;
    UIFont *font;
    if ([self.delegate currentInterfaceClassSize] == UIUserInterfaceSizeClassCompact) {
        //get current class size
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.compactTextStyleIn];
        font  = [UIFont fontWithDescriptor:fontDescriptor size:12];
        style.alignment = NSTextAlignmentLeft;
    }else {
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.regularTextStyle];
        font  = [UIFont fontWithDescriptor:fontDescriptor size:16];
        // font  = [UIFont preferredFontForTextStyle:self.regularTextStyle];
        style.alignment = NSTextAlignmentRight;
    }
    self.atrForLabelHistoryTableIn = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,self.colorForUnselectedText, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    
}

-(void)setAtrforButtonsInWith:(UIColor *)texColor{
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.s
    UIFontDescriptor* fontDescriptor;
    UIFont *font;
    if ([self.delegate currentInterfaceClassSize] == UIUserInterfaceSizeClassCompact) {
        //get current class size
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.compactTextStyleIn];
        font  = [UIFont fontWithDescriptor:fontDescriptor size:12];
        style.alignment = NSTextAlignmentLeft;
    }else {
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:self.regularTextStyle];
        font  = [UIFont fontWithDescriptor:fontDescriptor size:18];
        // font  = [UIFont preferredFontForTextStyle:self.regularTextStyle];
        style.alignment = NSTextAlignmentRight;
    }
    self.atrforButtonsIn = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,texColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
}
-(void)setAttributesInfoInWith:(UIColor*)color{
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByWordWrapping;

    self.attributesInfoIn = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [style copy], NSParagraphStyleAttributeName,
                             color,NSForegroundColorAttributeName,
                             NSTextEffectLetterpressStyle,NSTextEffectAttributeName, nil];
}

-(void) setAttributesExplInWith:(UIColor*)color{
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributesExplIn = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [style copy], NSParagraphStyleAttributeName,
                             color, NSForegroundColorAttributeName,
                             NSTextEffectLetterpressStyle,NSTextEffectAttributeName, nil];
}

-(void)setAttributesResultInWith:(UIColor*)color{
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentRight;

    self.attributesResultIn = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [style copy], NSParagraphStyleAttributeName,
                               color, NSForegroundColorAttributeName,
                               NSTextEffectLetterpressStyle,NSTextEffectAttributeName, nil];
}

-(void) changeClassSize{
    [self setAtrforHistoryTableInWith:self.mainAtrTextColorIn];
    [self setAtrForLabelHistoryTableInWith:self.mainAtrTextColorIn];
    [self setAtrforButtonsInWith:self.mainColorIn];
}


//for attributed text color
-(NSDictionary*)atrforButtons{
    return self.atrforButtonsIn;
}
-(NSDictionary*)atrforHistoryTable{
    return self.atrforHistoryTableIn;
}
-(NSDictionary*)atrForLabelHistoryTable{
    return self.atrForLabelHistoryTableIn;
}

-(UIColor*)mainAtrTextColor{
    return self.mainAtrTextColorIn;
}

-(UIFontTextStyle)compactTextStyle{
    return  self.compactTextStyleIn;
}

-(UIFontTextStyle)regularTextStyle{
    return  self.regularTextStyleIn;
}

//for main container
-(UIColor*)mainViewBackgroundColor{
    return self.mainViewBackgroundColorIn;
}

//for history table view
-(UIColor*)historySwiperColor{
    return self.historySwiperColorIn;
}

-(UIColor*)historyTableColor{
    return  self.historyTableColorIn;
}

-(UIColor*) colorSelectedHistoryRow{
    return self.colorSelectedHistoryRowIn;
}

-(UIColor*) colorUnselectedHistoryRow{
    return self.colorUnselectedHistoryRowIn;
}

-(UIColor*) colorForSelectedText{
    return self.colorForSelectedTextIn;
}
-(UIColor*) colorForUnselectedText{
    return self.colorForUnselectedTextIn;
}
-(UIColor*) moreButtonColor{
    return self.moreButtonColorIn;
}
-(UIColor*) moreButtonBackgroundColor{
    return self.moreButtonBackgroundColorIn;
}
-(UIColor*) buttonShadowColor{
    return self.buttonShadowColorIn;
}

-(CGSize) buttonShadowSize{
    return self.buttonShadowSizeIn;
}
-(CGFloat) buttonShadowBlur{
    return self.buttonShadowBlurIn;
}

-(UIColor*) deleteButtonColor{
    return self.deleteButtonColorIn;
}

-(UIColor*) deleteButtonBackgroundColor{
    return self.deleteButtonBackgroundColorIn;
}



//for buttons collection view
-(UIColor*) buttonTextColor{
    return self.buttonTextColorIn;
}

-(UIColor*) mainColor{
    return self.mainColorIn;
}

-(UIColor*) digitsColor{
    return self.digitsColorIn;
}
-(UIColor*) equalColor{
    return self.equalColorIn;
}

-(UIColor*) cColor{
    return self.cColorIn;
}

-(CGFloat) fotnWeight{
    return self.fotnWeightIn;
}

-(CGFloat) borderVSRadius{
    return self.borderVSRadiusIn;
}

-(BOOL) fillButton{
    return self.fillButtonIn;
}

-(UIColor*) storkeButtonWithFill{
    return self.storkeButtonWithFillIn;
}

-(UIColor *)shadowColor{
    return self.shadowColorIn;
}

-(CGFloat) shadowBlur{
    return self.shadowBlurIn;
}

-(CGSize) shadowSize{
    return self.shadowSizeIn;
}
-(CGFloat)ButtonIndent {
    return self.ButtonIndentIn;
}
-(CGFloat)radiusOfHeight{
    return self.radiusOfHeightIn;
}


//for calc screen display
-(UIColor*)displayContainerColor{
    return self.displayContainerColorIn;
}
-(UIColor*)screenTextColor {
    return self.screenTextColorIn;
}
-(BOOL)isScreenShadow{
    return self.isScreenShadowIn;
}
-(CGFloat)screenShadowRadius{
    return self.screenShadowRadiusIn;
}
-(CGFloat)screenShadowOpasity{
    return self.screenShadowOpasityIn;
}

-(UIColor*)screenButtonsEnabledColor{
    return self.screenButtonsEnabledColorIn;
}
-(UIColor*)screenButtonsDisabledColor{
    return self.screenButtonsDisabledColorIn;
}

-(NSDictionary*)attributesInfo{
    return self.attributesInfoIn;
}
-(NSDictionary*)attributesExpl{
    return self.attributesExplIn;
}
-(NSDictionary*)attributesResult{
    return self.attributesResultIn;
}

//IMPORTANT may be it's need be deletted
+(UIFont*) titleFontForDesing:(NSInteger)design{
    UIFont *font;
    if(IS_IPAD){
        font = [UIFont systemFontOfSize:18];
    } else {
        font = [UIFont systemFontOfSize:20];
    }
    return font;
}

+(NSString*)titleButtonForDesign:(NSInteger)design{
    NSString* title;
 
    switch (design) {
        case DESIGN_CLASSIC:
            title = @"классический";
            break;
            
        case DESIGN_PAPER:
            title = @"бумажный";
            break;
            
        case DESIGN_COLOR:
            title = @"цветной";
            break;
            
        case DESIGN_MARTINI:
            title = @"Martini";
            break;
            
        case DESIGN_ADVENTURE_TIME:
            title = @"цветной";
            break;
            
        case DESIGN_HIGH_TECH:
            title = @"цветной";
            break;
            
        case DESIGN_OLD_SCOOL:
            title = @"old scool";
            break;
            
        case DESIGN_PHOTO:
            title = @"фото";
            break;
            
        default:
            title =@"NO DESIGN";
            break;
    }
    return title;
}

+(UIColor*)titleColorForDesing:(NSInteger)design{
    
    UIColor* titleColor;
    
    switch (design) {
        case DESIGN_CLASSIC:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_PAPER:
            titleColor = [UIColor darkTextColor];
            break;
            
        case DESIGN_COLOR:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_MARTINI:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_ADVENTURE_TIME:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_HIGH_TECH:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_OLD_SCOOL:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_PHOTO:
            titleColor = [UIColor whiteColor];
            break;
            
        default:
            titleColor = [UIColor lightGrayColor];
            break;
    }
    return titleColor;
}

+(BOOL)titleShadowForDesign:(NSInteger)design{
    BOOL isNeedTitleShadow;
    
    switch (design) {
        case DESIGN_CLASSIC:
            isNeedTitleShadow = YES;
            break;
            
        case DESIGN_PAPER:
            isNeedTitleShadow = YES;
            break;
            
        case DESIGN_COLOR:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_MARTINI:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_ADVENTURE_TIME:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_HIGH_TECH:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_OLD_SCOOL:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_PHOTO:
            isNeedTitleShadow = YES;
            break;
            
        default:
            isNeedTitleShadow = YES;
            break;
    }
    return isNeedTitleShadow;
}
+(UIColor*)borderColorForDesing:(NSInteger)design{
    UIColor* borderColor;
   
    switch (design) {
        case DESIGN_CLASSIC:
            borderColor = [Clr digitsButton];
            break;
            
        case DESIGN_PAPER:
            borderColor = [UIColor darkTextColor];
            break;
            
        case DESIGN_COLOR:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_MARTINI:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_ADVENTURE_TIME:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_HIGH_TECH:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_OLD_SCOOL:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_PHOTO:
            borderColor = [UIColor whiteColor];
            break;
            
        default:
            borderColor = [UIColor lightGrayColor];
            break;
    }
    return borderColor;

}
+(UIColor*)bodyColorForDesing:(NSInteger)design{
    UIColor* bodyColor;
    switch (design) {
        case DESIGN_CLASSIC:
            bodyColor = [UIColor clearColor];
            break;
            
        case DESIGN_PAPER:
            bodyColor = [UIColor clearColor];
            break;
            
        case DESIGN_COLOR:
            bodyColor = [Clr blueButton];
            break;
            
        case DESIGN_MARTINI:
            bodyColor = [Clr greenButton];
            break;
            
        case DESIGN_ADVENTURE_TIME:
            bodyColor = [Clr yellowButton];
            break;
            
        case DESIGN_HIGH_TECH:
            bodyColor =[Clr pinkButton];
            break;
            
        case DESIGN_OLD_SCOOL:
            bodyColor = [Clr grayButton];
            break;
            
        case DESIGN_PHOTO:
            bodyColor = [UIColor clearColor];
            break;
            
        default:
            bodyColor = [UIColor clearColor];
            break;
    }
    return bodyColor;

}
+(CGFloat) borderVsRadiusForDesing:(NSInteger)design{
    CGFloat borderVsRadius;
    switch (design) {
        case DESIGN_CLASSIC:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_PAPER:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_COLOR:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_MARTINI:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_ADVENTURE_TIME:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_HIGH_TECH:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_OLD_SCOOL:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_PHOTO:
            borderVsRadius = 6.2;
            break;
            
        default:
            borderVsRadius = 12.2;
            break;
    }
    return borderVsRadius;

}
+(UIColor*)shadowColorForDesing:(NSInteger)design{
    UIColor* shadowColor;
    switch (design) {
        case DESIGN_CLASSIC:
            SHADOW_CLEAR;// shadowColor = [UIColor colorWithWhite:0 alpha:0];
            break;
            
        case DESIGN_PAPER:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:1 alpha:1.];
            break;
            
        case DESIGN_COLOR:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_MARTINI:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_ADVENTURE_TIME:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_HIGH_TECH:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_OLD_SCOOL:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_PHOTO:
            SHADOW_COLOR;//shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
            
        default:
            SHADOW_CLEAR;//shadowColor = [UIColor colorWithWhite:0 alpha:0];
            break;
    }
    return shadowColor;

}
+(CGSize) shadowOffsetForDesing:(NSInteger)design{
    CGSize shadowOffset;
    
    switch (design) {
        case DESIGN_CLASSIC:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(0, 0);
            break;
            
        case DESIGN_PAPER:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(1, 1);
            break;
            
        case DESIGN_COLOR:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(3, 3);
            break;
            
        case DESIGN_MARTINI:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(3, 3);
            break;
            
        case DESIGN_ADVENTURE_TIME:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(3, 3);
            break;
            
        case DESIGN_HIGH_TECH:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(3, 3);
            break;
            
        case DESIGN_OLD_SCOOL:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(3, 3);
            break;
            
        case DESIGN_PHOTO:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(1, 1);
            break;
            
        default:
            shadowOffset = SHADOW_OFFSET;//CGSizeMake(0, 0);
            break;
    }
    return shadowOffset;

}
+(CGFloat) shadowBlurForDesing:(NSInteger)design{
    CGFloat shadowBlur;
    switch (design) {
        case DESIGN_CLASSIC:
            shadowBlur = 0;
            break;
            
        case DESIGN_PAPER:
            shadowBlur = SHADOW_RADIUS;//0.5;
            break;
            
        case DESIGN_COLOR:
            shadowBlur = SHADOW_RADIUS;//6;
            break;
            
        case DESIGN_MARTINI:
            shadowBlur = SHADOW_RADIUS;//6;
            break;
            
        case DESIGN_ADVENTURE_TIME:
            shadowBlur = SHADOW_RADIUS;//6;
            break;
            
        case DESIGN_HIGH_TECH:
            shadowBlur = SHADOW_RADIUS;//6;
            break;
            
        case DESIGN_OLD_SCOOL:
            shadowBlur = SHADOW_RADIUS;//6;
            break;
            
        case DESIGN_PHOTO:
            shadowBlur = SHADOW_RADIUS;//0.5;
            break;
            
        default:
            shadowBlur = 0;
            break;
    }
    return shadowBlur;

}
+(CGFloat) shadowOpacityForDesing:(NSInteger)design{
    CGFloat shadowOpacity;
    switch (design) {
        case DESIGN_CLASSIC:
            shadowOpacity = 0;
            break;
            
        case DESIGN_PAPER:
            shadowOpacity = SHADOW_OPACITY;// 1;
            break;
            
        case DESIGN_COLOR:
            shadowOpacity = SHADOW_OPACITY;// 0.3;
            break;
            
        case DESIGN_MARTINI:
            shadowOpacity = SHADOW_OPACITY;// 0.3;
            break;
            
        case DESIGN_ADVENTURE_TIME:
            shadowOpacity = SHADOW_OPACITY;// 0.3;
            break;
            
        case DESIGN_HIGH_TECH:
            shadowOpacity = SHADOW_OPACITY;// 0.3;
            break;
            
        case DESIGN_OLD_SCOOL:
            shadowOpacity = SHADOW_OPACITY;// 0.3;
            break;
            
        case DESIGN_PHOTO:
            shadowOpacity = SHADOW_OPACITY;// 0.5;
            break;
            
        default:
            shadowOpacity = 0;
            break;
    }
    return shadowOpacity;
}
             
-(NSAttributedString*)atrStrForButtonsFrom:(NSAttributedString*)inStr{
                 
                 NSMutableAttributedString *atrOutStr = [inStr mutableCopy];
                 
                 //for each char set point size according ratio and needFontName
                 [atrOutStr beginEditing];
                 NSRange wholeRange = NSMakeRange(0, [atrOutStr length]);
                 
                 //set left aliment in any case
                 NSMutableParagraphStyle *style = [[[atrOutStr attributesAtIndex:0 effectiveRange:NULL] valueForKey:NSParagraphStyleAttributeName] mutableCopy];
                 style.alignment = NSTextAlignmentCenter;
                 [atrOutStr addAttribute:NSParagraphStyleAttributeName value:[style copy] range:wholeRange];
                 
                 [atrOutStr endEditing];
                 
                 return [atrOutStr copy];
}
             
+(NSAttributedString*)changeFontSizeFrom:(NSAttributedString*)inStr toSize:(CGSize)size{
    NSMutableAttributedString *atrOutStr = [inStr mutableCopy];
                 //for each char set point size according ratio and needFontName
    [atrOutStr beginEditing];
    for (NSInteger index = 0; index < [atrOutStr length]; index++){
        CGFloat newPointSize = size.height*BUTTON_TITLE_INSET;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        UIFont *newFont = [UIFont fontWithName:font.fontName size:newPointSize];
        NSRange charRange = NSMakeRange(index, 1);
        [atrOutStr addAttribute:NSFontAttributeName value:newFont range:charRange];
        
    }
    [atrOutStr endEditing];
    return [atrOutStr copy];
}
             

@end
