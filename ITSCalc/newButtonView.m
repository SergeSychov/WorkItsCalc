//
//  newButtonView.m
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "newButtonView.h"
//#import "cmyk.h"
#import "Clr.h"

#define X_OFFSET = 2.0f
#define Y_OFFSET = 2.0f
#define ANGLE_OFFSET = (M_PI_4*0.1f)
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])


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
#pragma mark DESIGN PROPERTIES
//set buttons design behaviours
-(UIColor*)digitsColor{
    return self.designObj.digitsColor;
}
-(UIColor*) cColor{
    return self.designObj.cColor;
}
-(UIColor*)equalColor{
    return self.designObj.equalColor;
}
-(UIColor*)mainColor{
    return self.designObj.mainColor;
}
-(CGFloat)fotnWeight{
    return self.designObj.fotnWeight;
}
-(CGFloat)borderVSRadius{
    return self.designObj.borderVSRadius;
}
-(BOOL)fillButton{
    return self.designObj.fillButton;
}
-(UIColor*)shadowColor{
    return self.designObj.shadowColor;
}

-(CGFloat)shadowBlur{
    return self.designObj.shadowBlur;
}
-(CGSize)shadowSize{
    return self.designObj.shadowSize;
}

-(void)setDesignObj:(DesignObject *)designObj{
    _designObj = designObj;
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
    
    //self.digitsColor = [Clr digitsButton];
    //self.cColor = [Clr cButton];
    //self.equalColor = [Clr equalButton];
    //self.mainColor = [Clr button];
    //self.fotnWeight = UIFontWeightLight;
    //self.borderVSRadius = 8.2;
    //self.fillButton = NO;
    //self.shadowColor = [UIColor clearColor];
    //self.shadowBlur = 0.;
    //self.shadowSize = CGSizeMake(0, 0);

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
        if(newSize<5.){
            break;
        }
        
    }
    
    neededRect.origin.y = (rect.size.height - neededRect.size.height)/2;
    neededRect.origin.x = (rect.size.width - neededRect.size.width) /2+0.5;
    if(self.designObj.designNumber  == DESIGN_COLOR_BLUE || self.designObj.designNumber == DESIGN_COLOR_GRAY || self.designObj.designNumber == DESIGN_COLOR_GREEN){
        CGContextSetShadowWithColor(context, CGSizeMake(-1., -1.), 1,[UIColor colorWithWhite:0 alpha:0.3].CGColor);
    }

    //setColor ofAttributed string
    NSMutableAttributedString *mutAtrStr = [self.attrbutedTitle mutableCopy];
    UIColor *textColor;
    if(self.designObj.designNumber == DESIGN_PAPER){
        textColor = self.buttonColor;
    } else if(self.designObj.designNumber==DESIGN_COLOR_PINK && [self.title isEqualToString:@"C"]){
        textColor = [UIColor blackColor];
    } else {
        if(self.designObj){
            textColor = self.designObj.buttonTextColor;//[UIColor whiteColor];//
        } else {
            textColor = [UIColor whiteColor];
        }
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
    
    UIColor * strColor;
    CGFloat borderVsRadius;
    if(self.designObj){
        strColor = self.buttonColor;
        borderVsRadius = self.borderVSRadius;
    } else {
        strColor = [UIColor whiteColor];
        borderVsRadius = BORDER_VS_RADIUS;
    }
    if(IS_IPAD){
        self.radiusCorner = (self.frame.size.height-4)/ 3.5;
        
        borderWidth = self.radiusCorner / borderVsRadius;//9.2;
        if(self.fillButton){
            CGContextSetFillColorWithColor(context, strColor.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context, strColor.CGColor);
        }
        
        CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);
    } else {

        self.radiusCorner = (rect.size.height-4)/ 3.3;
        borderWidth = self.radiusCorner / borderVsRadius;
        if(self.fillButton){
            CGContextSetFillColorWithColor(context, strColor.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context, strColor.CGColor);
        }
        
        CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, self.shadowColor.CGColor);

    }

    CGFloat x = 2*(borderWidth /2+0.5);
    CGFloat y = 2*(borderWidth /2);
    CGFloat width = rect.size.width - borderWidth;
    CGFloat height = rect.size.height -borderWidth;
    cornerRect = CGRectMake(x,y,width,height); //CGRectInset(rect, borderWidth, borderWidth);//
        
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(self.radiusCorner)];
    CGContextSetLineWidth(context, borderWidth);

    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);

    CGContextDrawPath(context, kCGPathFillStroke);
    
    if(self.designObj.storkeButtonWithFill){
        UIBezierPath *drawStrokePath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(self.radiusCorner)];
        CGContextSetStrokeColorWithColor(context, self.designObj.storkeButtonWithFill.CGColor);
        CGContextSetLineWidth(context, borderWidth*3);
        CGContextSetShadowWithColor(context, self.shadowSize, self.shadowBlur, [UIColor clearColor].CGColor);
       // CGPathRef patchToStorke;
        CGContextAddPath(context, drawStrokePath.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    
}

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawButtonViewInContext:context inRect:CGRectInset(rect, 3, 3)];
    [self drawTitle:CGRectInset(rect, 3, 3) inContext: context];

}


@end
