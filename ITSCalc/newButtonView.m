//
//  newButtonView.m
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "newButtonView.h"
#import "cmyk.h"
#import "Clr.h"

#define X_OFFSET = 2.0f
#define Y_OFFSET = 2.0f
#define ANGLE_OFFSET = (M_PI_4*0.1f)
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

@interface newButtonView()
@property (nonatomic,strong) NSArray *symbolsToMakeBigger;// = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=", nil];//, @"-"
@property (nonatomic,strong)NSArray *pointsToMakeBigger; //= [NSArray arrayWithObjects: @".", @",", nil];
@property (nonatomic) BOOL isOnsuperView;
@property (nonatomic,strong) UIView *paperFillView;

@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) UIColor *digitsColor;
@property (nonatomic,strong) UIColor *equalColor;
@property (nonatomic,strong) UIColor *cColor;
@property (nonatomic) CGFloat fotnWeight;
@property (nonatomic) CGFloat borderVSRadius;
@property (nonatomic) BOOL fillButton;
@property (nonatomic,strong) UIColor *shadowColor;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGSize shadowSize;
@end

@implementation newButtonView


-(void) didMoveToSuperview{
    [super didMoveToSuperview];
    self.isOnsuperView = YES;
}


-(NSAttributedString*)attrbutedTitle
{
    if(!_attrbutedTitle){
        _attrbutedTitle = [[NSAttributedString alloc] initWithString:@""];
    }
    return _attrbutedTitle;
}

-(void) setButtonColor:(UIColor*)buttonColor{
    _buttonColor = buttonColor;
}

-(void) setIsTaped:(BOOL)isTaped{
    _isTaped = isTaped;
    [self setNeedsDisplay];
}

//self.fotnWeight = UIFontWeightLight;
-(void) setDesign:(NSInteger)design
{
    _design = design;
    switch (_design) {
        case DESIGN_CLASSIC:
            self.digitsColor = [Clr digitsButton];
            self.cColor = [Clr cButton];
            self.equalColor = [Clr equalButton];
            self.mainColor = [Clr button];
            self.fotnWeight = UIFontWeightLight;
            self.borderVSRadius = 8.2;;
            self.fillButton = NO;
            
            self.shadowColor = [UIColor clearColor];
            self.shadowBlur = 0.;
            self.shadowSize = CGSizeMake(0, 0);
            break;
        case DESIGN_PAPER:
            self.digitsColor = [Clr paperButton];
            self.cColor = [Clr paperC];
            self.equalColor = [Clr paperEqual];
            self.mainColor = [Clr paperButton];
            self.fotnWeight = UIFontWeightMedium;
            self.borderVSRadius = 8.2;;
            self.fillButton = NO;
            
            self.shadowColor = [UIColor whiteColor];
            self.shadowBlur = 0.5;
            self.shadowSize = CGSizeMake(1, 1);
            break;
        case DESIGN_COLOR_BLUE:
            self.digitsColor = [Clr blueDigits];
            self.cColor = [Clr blueC];
            self.equalColor = [Clr blueC];
            self.mainColor = [Clr blueButton];
            self.fotnWeight = UIFontWeightLight;
            self.borderVSRadius = 8.2;
            self.fillButton = YES;

            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 3.;
            self.shadowSize = CGSizeMake(2, 2);
            break;
        case DESIGN_COLOR_GREEN:
            self.digitsColor = [Clr greenDigits];
            self.cColor = [Clr greenC];
            self.equalColor = [Clr greenC];
            self.mainColor = [Clr greenButton];
            self.fotnWeight = UIFontWeightMedium;
            self.borderVSRadius = 8.2;
            self.fillButton = YES;

            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 3.;
            self.shadowSize = CGSizeMake(2, 2);
            break;
        case DESIGN_COLOR_PINK:
            self.digitsColor = [Clr pinkDigits];
            self.cColor = [Clr pinkC];
            self.equalColor = [Clr pinkC];
            self.mainColor = [Clr pinkButton];
            self.fotnWeight = UIFontWeightMedium;
            self.borderVSRadius = 8.2;
            self.fillButton = YES;

            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 3.;
            self.shadowSize = CGSizeMake(2, 2);
            break;
        case DESIGN_COLOR_YELOW:
            self.digitsColor = [Clr yellowDigits];
            self.cColor = [Clr yellowC];
            self.equalColor = [Clr yellowC];
            self.mainColor = [Clr yellowButton];
            self.fotnWeight = UIFontWeightMedium;
            self.borderVSRadius = 8.2;
            self.fillButton = YES;

            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 3.;
            self.shadowSize = CGSizeMake(2, 2);
            break;
        case DESIGN_COLOR_GRAY:
            self.digitsColor = [Clr grayDigits];
            self.cColor = [Clr grayC];
            self.equalColor = [Clr grayC];
            self.mainColor = [Clr grayButton];
            self.fotnWeight = UIFontWeightLight;
            self.borderVSRadius = 8.2;
            self.fillButton = YES;

            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 3.;
            self.shadowSize = CGSizeMake(2, 2);
            break;
        case DESIGN_PHOTO:
            self.digitsColor = [UIColor whiteColor];
            self.cColor = [UIColor whiteColor];
            self.equalColor = [UIColor whiteColor];
            self.mainColor = [UIColor whiteColor];
            self.fotnWeight = UIFontWeightMedium;
            self.borderVSRadius = 8.2;;
            self.fillButton = NO;
            
            self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.shadowBlur = 8.2;
            self.shadowSize = CGSizeMake(2, 2);

            break;
        default:
            self.digitsColor = [Clr digitsButton];
            self.cColor = [Clr cButton];
            self.equalColor = [Clr equalButton];
            self.mainColor = [Clr button];
            self.fotnWeight = UIFontWeightLight;
            self.borderVSRadius = 8.2;;
            self.fillButton = NO;
            
            self.shadowColor = [UIColor clearColor];
            self.shadowBlur = 0.;
            self.shadowSize = CGSizeMake(0, 0);
            break;
    }
    [self setButtonColorAccordingTitle:self.title];
    [self setNeedsDisplay];
}
-(void) setup
{
    self.backgroundColor = [UIColor clearColor];
    if(IS_IPAD){
        self.radiusCorner = (self.frame.size.height-4)/ 3.;
    } else {
        self.radiusCorner =(self.frame.size.height-4)/ 2.8;
    }
    
    self.digitsColor = [Clr digitsButton];
    self.cColor = [Clr cButton];
    self.equalColor = [Clr equalButton];
    self.mainColor = [Clr button];
    self.fotnWeight = UIFontWeightLight;
    self.borderVSRadius = 8.2;
    self.fillButton = NO;
    self.shadowColor = [UIColor clearColor];
    self.shadowBlur = 0.;
    self.shadowSize = CGSizeMake(0, 0);

    self.isOnsuperView = NO;
    self.symbolsToMakeBigger = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=",@"-"/*,@"∓"*/, nil];//, @"-"
    self.pointsToMakeBigger = [NSArray arrayWithObjects: @".", @",", nil];
    

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

        // Initialization code
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}
-(void) setButtonColorAccordingTitle:(NSString*)title
{
            //set color according the buttonsName
    NSArray *digits = [NSArray arrayWithObjects:@"1", @"2", @"3",@"4", @"5",@"6",@"7",@"8", @"9", @"0",@".", nil];
    NSArray *clear = [NSArray arrayWithObjects:@"C",nil];
    NSArray *equal = [NSArray arrayWithObjects:@"=",nil];
    
    if([digits containsObject:title]){
        _buttonColor = self.digitsColor;
    }else if ([clear containsObject:title]){
        _buttonColor = self.cColor;
    }else if([equal containsObject:title]){
        _buttonColor = self.equalColor;
    } else {
        _buttonColor = self.mainColor;
    }
    
}

-(void)setTitle:(NSString *)title
{
    //if(![_title isEqualToString:title]){
        [self setButtonColorAccordingTitle:title];
        _title = title;

        CGPoint titleCenter;
        titleCenter.x = self.bounds.size.width/2;
        titleCenter.y = self.bounds.size.height/2;
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        UIFont * test = [self setFont: self.frame];
        NSNumber *baselineOffset = @0.;

        if([self.symbolsToMakeBigger containsObject:self.title]){
            baselineOffset = @6.;

        } else if([self.pointsToMakeBigger containsObject:self.title]){
            baselineOffset = @18.;
        }
        NSMutableAttributedString *newString = [[NSMutableAttributedString alloc]
                                                initWithString:title
                                                attributes:@{
                                                            NSParagraphStyleAttributeName: style,
                                                            NSBaselineOffsetAttributeName: baselineOffset,
                                                            NSFontAttributeName: test}]; //[self setFont]
        if([title isEqualToString:@"logʸ"]){
            newString = [[NSMutableAttributedString alloc]
                            initWithString:@"logy"
                            attributes:@{
                                        NSParagraphStyleAttributeName: style,
                                        NSBaselineOffsetAttributeName: baselineOffset,
                                        NSFontAttributeName: test}];
                

        }
        self.attrbutedTitle = [newString copy];

}

-(UIFont*) setFont:(CGRect) rect
{
    CGFloat fontSize;//
    if([self.symbolsToMakeBigger containsObject:self.title]){
        fontSize = rect.size.height /1.3;
        if([self.title isEqualToString:@"-"]){
            fontSize = rect.size.height / 1.;
        }
    } else if([self.pointsToMakeBigger containsObject:self.title]){
        fontSize = rect.size.height ;
    } else if([self.title isEqualToString:@"∓"]){
        fontSize = rect.size.height / 1.3;
    } else {
       fontSize = rect.size.height / 1.7;
    }
    return  [self setFontWithSize:fontSize];
}

-(UIFont*) setFontWithSize:(CGFloat) size
{
    return  [UIFont systemFontOfSize:size weight:self.fotnWeight];
}

-(void) changeFontsize:(CGRect) rect;
{
    NSMutableAttributedString * attrTextMutCopy = [self.attrbutedTitle mutableCopy];
    [attrTextMutCopy beginEditing];
    NSRange wholeRange = NSMakeRange(0, [attrTextMutCopy  length]);
    [attrTextMutCopy  addAttribute:NSFontAttributeName value:[self setFont:rect] range:wholeRange];
    if([attrTextMutCopy.string isEqualToString:@"logy"]){
        NSRange lastSymbol = NSMakeRange([attrTextMutCopy length] -1, 1);
        UIFont *newfontY = [UIFont fontWithName:[self setFont:rect].fontName size:([self setFont:rect].pointSize / 1.5)];
        [attrTextMutCopy  addAttribute:NSFontAttributeName value:newfontY range:lastSymbol];
    }
    [attrTextMutCopy endEditing];
    
    self.attrbutedTitle = [attrTextMutCopy copy];

}

-(void) changeFontsizeWithSize:(CGFloat)size
{
    NSMutableAttributedString * attrTextMutCopy = [self.attrbutedTitle mutableCopy];
    [attrTextMutCopy beginEditing];
    NSRange wholeRange = NSMakeRange(0, [attrTextMutCopy  length]);
    [attrTextMutCopy  addAttribute:NSFontAttributeName value:[self setFontWithSize:size] range:wholeRange];
    [attrTextMutCopy endEditing];
    
    self.attrbutedTitle = [attrTextMutCopy copy];
}

-(void) drawTitle:(CGRect)rect inContext:(CGContextRef) context
{
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    [self changeFontsize:rect];
    CGRect neededRect = [self.attrbutedTitle boundingRectWithSize:rect.size options:NSStringDrawingUsesFontLeading
                                                          context:drawContext];
    
    while(neededRect.size.width > (rect.size.width -10)){
        NSDictionary * attributes = [self.attrbutedTitle attributesAtIndex:0 effectiveRange:NULL];
        UIFont *font = [attributes valueForKey:NSFontAttributeName];
        CGFloat newSize = font.pointSize / 1.1;
        [self changeFontsizeWithSize:newSize];
        neededRect = [self.attrbutedTitle boundingRectWithSize:rect.size options:NSStringDrawingUsesFontLeading
                                                       context:drawContext];
        
    }
    
    neededRect.origin.y = (rect.size.height - neededRect.size.height)/2;
    neededRect.origin.x = (rect.size.width - neededRect.size.width) /2+0.5;
    if(self.design  == DESIGN_COLOR_BLUE || self.design == DESIGN_COLOR_GRAY || self.design == DESIGN_COLOR_GREEN || self.design ==DESIGN_COLOR_PINK || self.design == DESIGN_COLOR_YELOW){
        CGContextSetShadowWithColor(context, CGSizeMake(-1., -1.), 1,[UIColor colorWithWhite:0 alpha:0.3].CGColor);
    }

    //setColor ofAttributed string
    NSMutableAttributedString *mutAtrStr = [self.attrbutedTitle mutableCopy];
    UIColor *textColor;
    if(self.design == DESIGN_PAPER){
        textColor = self.buttonColor;
    } else {
        textColor = [UIColor colorWithWhite:1. alpha:1];
    }
    [mutAtrStr beginEditing];
    NSRange wholeRange = NSMakeRange(0, [mutAtrStr  length]);
    [mutAtrStr  addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
    [mutAtrStr endEditing];
    self.attrbutedTitle = [mutAtrStr copy];
    
    [self.attrbutedTitle drawWithRect:neededRect options:NSStringDrawingUsesLineFragmentOrigin
                              context:nil];
}


-(void) drawButtonViewInContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect cornerRect;
    UIBezierPath *drawRectPath;
    CGPathRef pathOfRect;
    CGFloat borderWidth;
    if(IS_IPAD){
        self.radiusCorner = (self.frame.size.height-4)/ 3.5;
        
        borderWidth = self.radiusCorner / self.borderVSRadius;//9.2;
        if(self.fillButton){
            CGContextSetFillColorWithColor(context, self.buttonColor.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context, self.buttonColor.CGColor);
        }
        
        CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    } else {

        self.radiusCorner = (rect.size.height-4)/ 3.3;
        borderWidth = self.radiusCorner / self.borderVSRadius;
        if(self.fillButton){
            CGContextSetFillColorWithColor(context, self.buttonColor.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context, self.buttonColor.CGColor);
        }
        
        CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);

    }

    CGFloat x = borderWidth /2+0.5;
    CGFloat y = borderWidth /2;
    CGFloat width = rect.size.width - borderWidth;
    CGFloat height = rect.size.height -borderWidth;
    cornerRect = CGRectMake(x,y,width,height); //CGRectInset(rect, borderWidth, borderWidth);//
        
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(self.radiusCorner)];
    CGContextSetLineWidth(context, borderWidth);

    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);

    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawButtonViewInContext:context inRect:CGRectInset(rect, 2, 2)];
    [self drawTitle:CGRectInset(rect, 2, 2) inContext: context];
   
}


@end
