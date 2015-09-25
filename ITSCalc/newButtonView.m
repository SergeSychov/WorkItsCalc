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
//@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic,strong) NSArray *symbolsToMakeBigger;// = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=", nil];//, @"-"
@property (nonatomic,strong)NSArray *pointsToMakeBigger; //= [NSArray arrayWithObjects: @".", @",", nil];
@property (nonatomic) BOOL isOnsuperView;
@property (nonatomic,weak) UIView *paperFillView;
//@property (nonatomic) UIFont* font;
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
    //[self setNeedsDisplay];
}

-(void) setDesign:(NSInteger)design
{
    _design = design;
    [self setNeedsDisplay];
}
-(void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.radiusCorner = (self.frame.size.width - 4)/ 4;
    //set color for border of view
    /*
    struct Color cmyk;
    cmyk.r = 0.51;
    cmyk.g = 0.52;
    cmyk.b = 0.49;
    cmyk.a = 1.0;
    self.buttonColor = cmyk;
    */
    //self.isTaped = NO;
    self.isOnsuperView = NO;
    self.symbolsToMakeBigger = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=",@"-"/*,@"∓"*/, nil];//, @"-"
    self.pointsToMakeBigger = [NSArray arrayWithObjects: @".", @",", nil];
    //self.clipsToBounds = NO;
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
    
    switch (self.design) {
        case DESIGN_PHOTO:

            self.buttonColor = [UIColor colorWithWhite:0.95 alpha:1];
            break;
        case DESIGN_CLASSIC:
            if([digits containsObject:title]){

                self.buttonColor = [Clr digitsButton];
            }else if ([clear containsObject:title]){

                self.buttonColor = [Clr cButton];
            }else if([equal containsObject:title]){

                self.buttonColor = [Clr equalButton];
            } else {

                self.buttonColor = [Clr button];
            }
            break;
        
        case DESIGN_PAPER:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr paperDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr paperC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr paperEqual];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr paperButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }
            break;
        
        case DESIGN_COLOR_BLUE:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr blueDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr blueC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr blueC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr blueButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }
            break;
            
        case DESIGN_COLOR_GREEN:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr greenDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr greenC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr greenC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr greenButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }            break;
            
        case DESIGN_COLOR_YELOW:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr yellowDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr yellowC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr yellowC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr yellowButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }            break;
            
        case DESIGN_COLOR_PINK:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr pinkDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr pinkC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr pinkC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr pinkButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }
            break;
        case DESIGN_COLOR_GRAY:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr grayDigits];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr grayC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr grayC];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            } else {
                
                self.buttonColor = [Clr grayButton];
                //self.buttonColor = [self.buttonColor colorWithAlphaComponent:0.8];
            }            break;

            
        default:
            if([digits containsObject:title]){
                
                self.buttonColor = [Clr digitsButton];
            }else if ([clear containsObject:title]){
                
                self.buttonColor = [Clr cButton];
            }else if([equal containsObject:title]){
                
                self.buttonColor = [Clr equalButton];
            } else {
                
                self.buttonColor = [Clr button];
            }
            break;
    }

}

-(void)setTitle:(NSString *)title
{
  
    //if(self.isOnsuperView){
        if(![_title isEqualToString:title]){
            [self setButtonColorAccordingTitle:title];
            _title = title;
            UIColor *textColor; //color of text
            switch (self.design) {
                case DESIGN_CLASSIC:
                    textColor = [UIColor colorWithWhite:0.95 alpha:1];
                    break;
                case DESIGN_PAPER:
                    textColor = self.buttonColor;
                    break;

                case DESIGN_COLOR_BLUE:
                    textColor =  [UIColor colorWithWhite:1. alpha:1];
                    break;
                case DESIGN_COLOR_GREEN:
                    textColor =  [UIColor colorWithWhite:1. alpha:1];
                    break;
                case DESIGN_COLOR_YELOW:
                    textColor =  [UIColor colorWithWhite:1. alpha:1];
                    break;
                case DESIGN_COLOR_PINK:
                    textColor =  [UIColor colorWithWhite:1. alpha:1];
                    break;
                case DESIGN_COLOR_GRAY:
                    textColor =  [UIColor colorWithWhite:1. alpha:1];
                    break;

                default:
                    textColor = [UIColor colorWithWhite:1. alpha:1];
                    break;
            }

            CGPoint titleCenter;
            titleCenter.x = self.bounds.size.width/2;
            titleCenter.y = self.bounds.size.height/2;
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            UIFont * test = [self setFont: self.frame];
            NSNumber *baselineOffset = @0.;
            //if([title isEqualToString:@"-"]){
            //    title = @"－";
            //}
            if([self.symbolsToMakeBigger containsObject:self.title]){
                baselineOffset = @6.;

            } else if([self.pointsToMakeBigger containsObject:self.title]){
                baselineOffset = @18.;
            }
            //CGFloat pointSize = test.pointSize;
        
            NSMutableAttributedString *newString = [[NSMutableAttributedString alloc]
                                                    initWithString:title
                                                    attributes:@{
                                                                 NSStrokeColorAttributeName: textColor,
                                                                // NSShadowAttributeName: shadow,
                                                                 NSForegroundColorAttributeName:  textColor,
                                                                 NSParagraphStyleAttributeName: style,
                                                                 NSBaselineOffsetAttributeName: baselineOffset,
                                                                 NSFontAttributeName: test}]; //[self setFont]
            if([title isEqualToString:@"logʸ"]){
                newString = [[NSMutableAttributedString alloc]
                             initWithString:@"logy"
                             attributes:@{
                                          NSStrokeColorAttributeName: textColor,
                                          NSForegroundColorAttributeName:  textColor,
                                          NSParagraphStyleAttributeName: style,
                                          NSBaselineOffsetAttributeName: baselineOffset,
                                          NSFontAttributeName: test}];
                

            }
            self.attrbutedTitle = [newString copy];
       
            [self setNeedsDisplay];
        
        }
    //}
}

-(UIFont*) setFont:(CGRect) rect
{
    CGFloat fontSize;//
    //NSArray *symbolsBigger = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=", @"∓",nil];
   // NSArray* pointsBigger = [NSArray arrayWithObjects: @".", @",", nil];
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
    UIFont *font; //if there is no needed font
    switch (self.design) {
        case DESIGN_PHOTO:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightBold];
            break;
            
        case DESIGN_CLASSIC:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightLight ];
            break;
            
        case DESIGN_PAPER:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        case DESIGN_COLOR_BLUE:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        case DESIGN_COLOR_GREEN:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        case DESIGN_COLOR_YELOW:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        case DESIGN_COLOR_PINK:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        case DESIGN_COLOR_GRAY:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightMedium ];
            break;
        default:
            font =[UIFont systemFontOfSize:size weight:UIFontWeightLight ];
            break;
            
    }

    
    return  font;
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
    //drawContext.minimumScaleFactor = 0.5;
    [self changeFontsize:rect];
    CGRect neededRect = [self.attrbutedTitle boundingRectWithSize:rect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                          context:drawContext];
    
    while(neededRect.size.width > (rect.size.width -10)){
        NSDictionary * attributes = [self.attrbutedTitle attributesAtIndex:0 effectiveRange:NULL];
        UIFont *font = [attributes valueForKey:NSFontAttributeName];
        CGFloat newSize = font.pointSize / 1.1;
        [self changeFontsizeWithSize:newSize];
        neededRect = [self.attrbutedTitle boundingRectWithSize:rect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                       context:drawContext];
        
    }
    
    neededRect.origin.y = (rect.size.height - neededRect.size.height)/2;
    neededRect.origin.x = (rect.size.width - neededRect.size.width) /2+0.5;
    switch (self.design) {
        case DESIGN_PHOTO:
            //CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor blackColor].CGColor);
            break;
        case DESIGN_PAPER:
            break;
            
        default:
            CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor clearColor].CGColor);
            break;
    }
    //CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor clearColor].CGColor);
    [self.attrbutedTitle drawWithRect:neededRect options:NSStringDrawingUsesLineFragmentOrigin //
                              context:nil];
}


-(void) drawButtonViewInContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect cornerRect;
    UIBezierPath *drawRectPath;
    CGPathRef pathOfRect;
    CGFloat borderWidth;
    if(IS_IPAD){
        self.radiusCorner = self.frame.size.height-4/ 3.;
        
        borderWidth = self.radiusCorner / 4.9;//9.2;
    } else {
        self.radiusCorner = (self.frame.size.height-4)/ 3.2;
        switch (self.design) {
            case DESIGN_PHOTO:
                self.radiusCorner = (rect.size.height-4)/ 2.8;
                borderWidth = self.radiusCorner / 5.2;
                CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
                CGContextSetStrokeColorWithColor(context, self.buttonColor.CGColor);
                CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor colorWithWhite:0 alpha:0.5].CGColor);

                break;
            case DESIGN_CLASSIC:
                borderWidth = self.radiusCorner / 12.2;
                CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
                CGContextSetStrokeColorWithColor(context, self.buttonColor.CGColor);
                break;
            
            case DESIGN_PAPER:
                borderWidth = self.radiusCorner / 8.2;
                CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
                CGContextSetStrokeColorWithColor(context,self.buttonColor.CGColor);
                CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 0.5, [UIColor colorWithWhite:1 alpha:1].CGColor);
                break;
             
            default:
                borderWidth = self.radiusCorner / 12.2;
                CGContextSetFillColorWithColor(context, self.buttonColor.CGColor);
                CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
                CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
                break;
        }
        //borderWidth = self.radiusCorner / 12.2;
    }

        //to states of buttons
    CGFloat x = borderWidth /2+0.5;
    CGFloat y = borderWidth /2;
    CGFloat width = rect.size.width - borderWidth;
    CGFloat height = rect.size.height -borderWidth;
    cornerRect = CGRectMake(x,y,width,height); //CGRectInset(rect, borderWidth, borderWidth);//
        
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(self.radiusCorner - borderWidth)];
    CGContextSetLineWidth(context, borderWidth);

    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);

        //CGContextSetRGBStrokeColor(context, self.buttonColor.r, self.buttonColor.g, self.buttonColor.b, self.buttonColor.a);
    //CGContextSetStrokeColorWithColor(context, self.buttonColor.CGColor);
    //CGContextClipToRect(context, CGRectInset(rect, 10, 10));
    CGContextDrawPath(context, kCGPathFillStroke);
    //CGContextClosePath(context);
    

}

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawButtonViewInContext:context inRect:CGRectInset(rect, 2, 2)];
    [self drawTitle:CGRectInset(rect, 2, 2) inContext: context];

    //CALayer * viewLayer = self.layer;
    CGSize  shadowOffset;
   shadowOffset.height = 0;
    shadowOffset.width = 0;
   // self.layer.shadowRadius = self.radiusCorner/3.0;
    //if(self.isTaped){
   //         self.layer.shadowOpacity = 1.0;
    //} else {
    //        self.layer.shadowOpacity = .0;
   // }
   
}

-(void) fillButton:(BOOL)filling
{

    if(filling){
        CGFloat borderWidth = self.radiusCorner / 8.2;
        CGFloat x = borderWidth /2+0.5;
        CGFloat y = borderWidth /2;
        CGRect rct = CGRectInset(self.frame,2,2);
        rct.origin = CGPointMake(x, y);
        
        UIView *paperFillView = [[UIView alloc] initWithFrame:rct];
        paperFillView.layer.cornerRadius = self.radiusCorner;
        paperFillView.backgroundColor = self.buttonColor;
        paperFillView.alpha = 0;
        [self addSubview:paperFillView];
        self.paperFillView = paperFillView;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.paperFillView.alpha = .8;
        }];

    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.paperFillView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.paperFillView removeFromSuperview];
        }];
    }
}
@end
