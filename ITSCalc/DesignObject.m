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
@property (nonatomic, strong) UIColor* historyTableColorIn;
@property (nonatomic, strong )UIColor* colorSelectedFirstGradientIn;
@property (nonatomic, strong )UIColor* colorSelectedSecondGradientIn;
@property (nonatomic, strong )UIColor* colorUnselectedFirstGradientIn;
@property (nonatomic, strong )UIColor* colorUnselectedSecondGradientIn;
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
@property (nonatomic,strong ) UIColor *mainColorIn;
@property (nonatomic,strong ) UIColor *digitsColorIn;
@property (nonatomic,strong ) UIColor *equalColorIn;
@property (nonatomic,strong ) UIColor *cColorIn;
@property (nonatomic ) CGFloat fotnWeightIn;
@property (nonatomic ) CGFloat borderVSRadiusIn;
@property (nonatomic ) BOOL fillButtonIn;
@property (nonatomic ,strong) UIColor *shadowColorIn;
@property (nonatomic ) CGFloat shadowBlurIn;
@property (nonatomic ) CGSize shadowSizeIn;

@property (nonatomic) CGFloat ButtonIndentIn;
@property (nonatomic) CGFloat radiusOfHeightIn;

//for calc screen label
@property (nonatomic,strong) UIColor *displayContainerColorIn;
@property (nonatomic,strong) UIColor *screenTextColorIn;
@property (nonatomic) BOOL isScreenBlurHidenIn;
@property (nonatomic,strong) UIBlurEffect* screenBlurEffectIn;
@property (nonatomic,strong) UIColor* screenButtonShadowColorIn;
@property (nonatomic) CGSize screenButtonShadowSizeIn;
@property (nonatomic) CGFloat screenButtonShadowBlurIn;

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
        self.designNumber = designIndex;
    }
    return self;
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
            self.mainViewBackgroundColorIn = [UIColor clearColor];
            
            //HistoryTableView
            self.historyTableColorIn = [UIColor whiteColor];
            self.colorSelectedFirstGradientIn = [UIColor whiteColor];
            self.colorSelectedSecondGradientIn = [UIColor whiteColor];
            self.colorUnselectedFirstGradientIn = [UIColor colorWithWhite:0.95 alpha:1];
            self.colorUnselectedSecondGradientIn = [UIColor colorWithWhite:0.9 alpha:1];
            self.colorForSelectedTextIn = [UIColor darkTextColor];
            self.colorForUnselectedTextIn = [UIColor lightGrayColor];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:1. green:0.231 blue:0.188 alpha:0.9];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            
            //ButtonsCollection
            self.digitsColorIn = [Clr digitsButton];
            self.cColorIn = [Clr cButton];
            self.equalColorIn = [Clr equalButton];
            self.mainColorIn = [Clr button];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            
            self.shadowColorIn = [UIColor clearColor];
            self.shadowBlurIn = 0.;
            self.shadowSizeIn = CGSizeMake(0, 0);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor clearColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor blackColor];
            self.explShowViewColor =[UIColor blackColor];
            self.resultShowViewColor=[UIColor blackColor];
            
            break;
            
        case DESIGN_PAPER:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            
            //HistoryTableView
            self.historyTableColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.colorSelectedFirstGradientIn = [UIColor clearColor];
            self.colorSelectedSecondGradientIn = [UIColor clearColor];
            self.colorUnselectedFirstGradientIn = [UIColor clearColor];
            self.colorUnselectedSecondGradientIn = [UIColor clearColor];
            self.colorForSelectedTextIn = [Clr paperButton];
            self.colorForUnselectedTextIn = [[Clr paperButton] colorWithAlphaComponent:0.6];
            /*if(!self.lineView){
                LineView *lineView = [[LineView alloc] init];
                lineView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:lineView];
                self.lineView = lineView;
            }
            
            self.lineView.color = self.colorForUnselectedText;
            self.lineView.shadowColor = [UIColor whiteColor];
            self.lineView.shadowBlur = 0.5;
            self.lineView.shadowSize = CGSizeMake(1., 1.);
            */
            self.moreButtonColorIn = [Clr paperEqual];
            self.moreButtonBackgroundColorIn = [UIColor clearColor];
            self.deleteButtonColorIn =[UIColor colorWithRed:0.68 green:0.13 blue:0. alpha:0.9];
            self.deleteButtonBackgroundColorIn = [UIColor clearColor];
            self.buttonShadowColorIn = [UIColor whiteColor];
            self.buttonShadowSizeIn = CGSizeMake(1., 1.);
            self.buttonShadowBlurIn = 0.5;
            //ButtonsCollection
            self.digitsColorIn = [Clr paperButton];
            self.cColorIn = [Clr paperC];
            self.equalColorIn = [Clr paperEqual];
            self.mainColorIn = [Clr paperButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            
            self.shadowColorIn = [UIColor whiteColor];
            self.shadowBlurIn = 0.5;
            self.shadowSizeIn = CGSizeMake(1, 1);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
            
        case DESIGN_COLOR_BLUE:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr blueGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr blueFirstGradient];
            self.colorSelectedFirstGradientIn = [UIColor whiteColor];
            self.colorSelectedSecondGradientIn = [UIColor whiteColor];
            self.colorUnselectedFirstGradientIn = [Clr blueFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr blueSecondGradient];
            self.colorForSelectedTextIn = [Clr blueDisplay];
            self.colorForUnselectedTextIn =  [[Clr blueDisplay] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr blueMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr blueDelButton];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr blueDigits];
            self.cColorIn = [Clr blueC];
            self.equalColorIn = [Clr blueC];
            self.mainColorIn = [Clr blueButton];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = 3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr blueDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
        case DESIGN_COLOR_GREEN:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr greenGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr greenFirstGradient];
            self.colorSelectedFirstGradientIn = [Clr greenFirstGradient];
            self.colorSelectedSecondGradientIn = [Clr greenFirstGradient];
            self.colorUnselectedFirstGradientIn = [Clr greenFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr greenSecondGradient];
            self.colorForSelectedTextIn = [Clr greenDisplay];
            self.colorForUnselectedTextIn =  [[Clr greenDisplay] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr greenMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr greenDelButton];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr greenDigits];
            self.cColorIn = [Clr greenC];
            self.equalColorIn = [Clr greenC];
            self.mainColorIn = [Clr greenButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = 3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn =[Clr greenDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
        case DESIGN_COLOR_YELOW:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr yellowGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr yellowFirstGradient];
            self.colorSelectedFirstGradientIn = [Clr yellowFirstGradient];
            self.colorSelectedSecondGradientIn = [Clr yellowFirstGradient];
            self.colorUnselectedFirstGradientIn = [Clr yellowFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr yellowSecondGradient];
            self.colorForSelectedTextIn = [Clr yellowText];
            self.colorForUnselectedTextIn =  [[Clr yellowText] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr yellowMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr yellowDelButton];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr yellowDigits];
            self.cColorIn = [Clr yellowC];
            self.equalColorIn = [Clr yellowC];
            self.mainColorIn = [Clr yellowButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = 3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr yellowDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
        case DESIGN_COLOR_PINK:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr pinkGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr pinkFirstGradient];
            self.colorSelectedFirstGradientIn = [Clr pinkFirstGradient];
            self.colorSelectedSecondGradientIn = [Clr pinkFirstGradient];
            self.colorUnselectedFirstGradientIn = [Clr pinkFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr pinkSecondGradient];
            self.colorForSelectedTextIn = [Clr pinkText];
            self.colorForUnselectedTextIn =  [[Clr pinkDisplay] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr pinkMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr pinkDelButton];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr pinkDigits];
            self.cColorIn = [Clr pinkC];
            self.equalColorIn = [Clr pinkC];
            self.mainColorIn = [Clr pinkButton];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = 3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn =[Clr pinkDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];
            
            break;
        case DESIGN_COLOR_GRAY:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn =[Clr grayGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr grayFirstGradient];
            self.colorSelectedFirstGradientIn = [Clr grayFirstGradient];
            self.colorSelectedSecondGradientIn = [Clr grayFirstGradient];
            self.colorUnselectedFirstGradientIn = [Clr grayFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr graySecondGradient];
            self.colorForSelectedTextIn = [Clr grayText];
            self.colorForUnselectedTextIn = [[Clr grayText] colorWithAlphaComponent:0.4];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [Clr grayMoreButton];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [Clr grayDelButton];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr grayDigits];
            self.cColorIn = [Clr grayC];
            self.equalColorIn = [Clr grayC];
            self.mainColorIn = [Clr grayButton];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;
            self.fillButtonIn = YES;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = 3.;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [Clr grayDisplay];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
        case DESIGN_PHOTO:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn = [Clr blueGround];
            
            //HistoryTableView
            self.historyTableColorIn = [Clr photoFirstGradient];
            self.colorSelectedFirstGradientIn = [UIColor colorWithWhite:0 alpha:0.2];
            self.colorSelectedSecondGradientIn = [UIColor colorWithWhite:0 alpha:0.2];
            self.colorUnselectedFirstGradientIn = [Clr photoFirstGradient];
            self.colorUnselectedSecondGradientIn = [Clr photoSecondGradient];
            self.colorForSelectedTextIn = [UIColor whiteColor];
            self.colorForUnselectedTextIn =  [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithWhite:0 alpha:0.1];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithWhite:0 alpha:0.1];
            self.buttonShadowColorIn = [UIColor grayColor];
            self.buttonShadowSizeIn = CGSizeMake(2, 2.);
            self.buttonShadowBlurIn = 3.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [UIColor whiteColor];
            self.cColorIn = [UIColor whiteColor];
            self.equalColorIn = [UIColor whiteColor];
            self.mainColorIn = [UIColor whiteColor];
            self.fotnWeightIn = UIFontWeightMedium;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            
            self.shadowColorIn = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlurIn = BORDER_VS_RADIUS;
            self.shadowSizeIn = CGSizeMake(2, 2);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor clearColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
            break;
        default:
            //for attr text
            self.mainAtrTextColorIn = [UIColor lightTextColor];
            self.compactTextStyleIn = UIFontTextStyleTitle2;
            self.regularTextStyleIn = UIFontTextStyleTitle1;
            
            //form main container view
            self.mainViewBackgroundColorIn =  [UIColor clearColor];
            
            //HistoryTableView
            self.historyTableColorIn = [UIColor whiteColor];
            self.colorSelectedFirstGradientIn = [UIColor whiteColor];
            self.colorSelectedSecondGradientIn = [UIColor whiteColor];
            self.colorUnselectedFirstGradientIn = [Clr blueButton];
            self.colorUnselectedSecondGradientIn =[UIColor colorWithWhite:0.8 alpha:1];
            
            self.colorForSelectedTextIn = [UIColor darkTextColor];
            self.colorForUnselectedTextIn = [UIColor grayColor];
            //[self.contentView setBackgroundColor:[UIColor clearColor]];
            
            self.moreButtonColorIn = [UIColor whiteColor];
            self.moreButtonBackgroundColorIn = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
            self.deleteButtonColorIn = [UIColor whiteColor];
            self.deleteButtonBackgroundColorIn = [UIColor colorWithRed:0.68 green:0.13 blue:0. alpha:0.9];
            self.buttonShadowColorIn = [UIColor clearColor];
            self.buttonShadowSizeIn = CGSizeMake(0, 0.);
            self.buttonShadowBlurIn = 0.;
            /*if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }*/
            //ButtonsCollection
            self.digitsColorIn = [Clr digitsButton];
            self.cColorIn = [Clr cButton];
            self.equalColorIn = [Clr equalButton];
            self.mainColorIn = [Clr button];
            self.fotnWeightIn = UIFontWeightLight;
            self.borderVSRadiusIn = BORDER_VS_RADIUS;;
            self.fillButtonIn = NO;
            
            self.shadowColorIn = [UIColor clearColor];
            self.shadowBlurIn = 0.;
            self.shadowSizeIn = CGSizeMake(0, 0);
            self.ButtonIndentIn = BUTTON_INDENT;
            self.radiusOfHeightIn = IS_IPAD ? BUTTON_RADIUS_OF_HEIGHT_IPAD : BUTTON_RADIUS_OF_HEIGHT_IPHONE;
            
            //calc screen
            self.displayContainerColorIn = [UIColor clearColor];
            self.screenTextColorIn = [UIColor whiteColor];
            self.isScreenBlurHidenIn = NO;
            self.screenBlurEffectIn = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.screenButtonShadowColorIn = [UIColor clearColor];;
            self.screenButtonShadowSizeIn = CGSizeMake(0., 0.);
            self.screenButtonShadowBlurIn = 0;
            
            //for showed view
            self.infoShowViewColor =[UIColor lightTextColor];
            self.explShowViewColor =[UIColor darkTextColor];
            self.resultShowViewColor=[UIColor blackColor];

            
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
        font  = [UIFont fontWithDescriptor:fontDescriptor size:20];
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
    //NSLog(@"atrForLabelHistoryTable %@", [self.atrForLabelHistoryTableIn objectForKey:NSFontAttributeName]);
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

-(UIColor*)historyTableColor{
    return  self.historyTableColorIn;
}

-(UIColor*) colorSelectedFirstGradient{
    return self.colorSelectedFirstGradientIn;
}
-(UIColor*) colorSelectedSecondGradient{
    return self.colorSelectedSecondGradientIn;
}
-(UIColor*) colorUnselectedFirstGradient{
    return self.colorUnselectedFirstGradientIn;
}

-(UIColor*) colorUnselectedSecondGradient{
    return self.colorUnselectedSecondGradientIn;
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
-(BOOL)isScreenBlurHiden{
    return self.isScreenBlurHidenIn;
}

-(UIBlurEffect*)screenBlurEffect{
    return self.screenBlurEffectIn;
}
-(UIColor*)screenButtonShadowColor{
 return self.screenButtonShadowColorIn;
}
-(CGSize)screenButtonShadowSize{
    return self.screenButtonShadowSizeIn;
}
-(CGFloat)screenButtonShadowBlur{
    return self.screenButtonShadowBlurIn;
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
            
        case DESIGN_COLOR_BLUE:
            title = @"цветной";
            break;
            
        case DESIGN_COLOR_GREEN:
            title = @"цветной";
            break;
            
        case DESIGN_COLOR_YELOW:
            title = @"цветной";
            break;
            
        case DESIGN_COLOR_PINK:
            title = @"цветной";
            break;
            
        case DESIGN_COLOR_GRAY:
            title = @"цветной";
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
            
        case DESIGN_COLOR_BLUE:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_COLOR_GREEN:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_COLOR_YELOW:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_COLOR_PINK:
            titleColor = [UIColor whiteColor];
            break;
            
        case DESIGN_COLOR_GRAY:
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
            
        case DESIGN_COLOR_BLUE:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_COLOR_GREEN:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_COLOR_YELOW:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_COLOR_PINK:
            isNeedTitleShadow = NO;
            break;
            
        case DESIGN_COLOR_GRAY:
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
            
        case DESIGN_COLOR_BLUE:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_COLOR_GREEN:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_COLOR_YELOW:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_COLOR_PINK:
            borderColor = [UIColor clearColor];
            break;
            
        case DESIGN_COLOR_GRAY:
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
            
        case DESIGN_COLOR_BLUE:
            bodyColor = [Clr blueButton];
            break;
            
        case DESIGN_COLOR_GREEN:
            bodyColor = [Clr greenButton];
            break;
            
        case DESIGN_COLOR_YELOW:
            bodyColor = [Clr yellowButton];
            break;
            
        case DESIGN_COLOR_PINK:
            bodyColor =[Clr pinkButton];
            break;
            
        case DESIGN_COLOR_GRAY:
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
            
        case DESIGN_COLOR_BLUE:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_COLOR_GREEN:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_COLOR_YELOW:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_COLOR_PINK:
            borderVsRadius = 12.2;
            break;
            
        case DESIGN_COLOR_GRAY:
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
            shadowColor = [UIColor colorWithWhite:0 alpha:0];
            break;
            
        case DESIGN_PAPER:
            shadowColor = [UIColor colorWithWhite:1 alpha:1.];
            break;
            
        case DESIGN_COLOR_BLUE:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_COLOR_GREEN:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_COLOR_YELOW:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_COLOR_PINK:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_COLOR_GRAY:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            break;
            
        case DESIGN_PHOTO:
            shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
            
        default:
            shadowColor = [UIColor colorWithWhite:0 alpha:0];
            break;
    }
    return shadowColor;

}
+(CGSize) shadowOffsetForDesing:(NSInteger)design{
    CGSize shadowOffset;
    
    switch (design) {
        case DESIGN_CLASSIC:
            shadowOffset = CGSizeMake(0, 0);
            break;
            
        case DESIGN_PAPER:
            shadowOffset = CGSizeMake(1, 1);
            break;
            
        case DESIGN_COLOR_BLUE:
            shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GREEN:
            shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_YELOW:
            shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_PINK:
            shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_COLOR_GRAY:
            shadowOffset = CGSizeMake(3, 3);
            break;
            
        case DESIGN_PHOTO:
            shadowOffset = CGSizeMake(1, 1);
            break;
            
        default:
            shadowOffset = CGSizeMake(0, 0);
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
            shadowBlur = 0.5;
            break;
            
        case DESIGN_COLOR_BLUE:
            shadowBlur = 6;
            break;
            
        case DESIGN_COLOR_GREEN:
            shadowBlur = 6;
            break;
            
        case DESIGN_COLOR_YELOW:
            shadowBlur = 6;
            break;
            
        case DESIGN_COLOR_PINK:
            shadowBlur = 6;
            break;
            
        case DESIGN_COLOR_GRAY:
            shadowBlur = 6;
            break;
            
        case DESIGN_PHOTO:
            shadowBlur = 0.5;
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
            shadowOpacity = 1;
            break;
            
        case DESIGN_COLOR_BLUE:
            shadowOpacity = 0.3;
            break;
            
        case DESIGN_COLOR_GREEN:
            shadowOpacity = 0.3;
            break;
            
        case DESIGN_COLOR_YELOW:
            shadowOpacity = 0.3;
            break;
            
        case DESIGN_COLOR_PINK:
            shadowOpacity = 0.3;
            break;
            
        case DESIGN_COLOR_GRAY:
            shadowOpacity = 0.3;
            break;
            
        case DESIGN_PHOTO:
            shadowOpacity = 0.5;
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
