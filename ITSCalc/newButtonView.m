//
//  newButtonView.m
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "newButtonView.h"
#import "cmyk.h"

#define X_OFFSET = 2.0f
#define Y_OFFSET = 2.0f
#define ANGLE_OFFSET = (M_PI_4*0.1f)

@interface newButtonView()
//@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic,strong) NSArray *symbolsToMakeBigger;// = [NSArray arrayWithObjects:@"÷", @"×", @"+",@"=", nil];//, @"-"
@property (nonatomic,strong)NSArray *pointsToMakeBigger; //= [NSArray arrayWithObjects: @".", @",", nil];
@property (nonatomic) BOOL isOnsuperView;
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

-(void) setButtonColor:(struct Color)buttonColor{
    _buttonColor = buttonColor;
}

-(void) setIsTaped:(BOOL)isTaped{
    _isTaped = isTaped;
    //[self setNeedsDisplay];
}


-(void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.radiusCorner = self.frame.size.width / 4;
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
            
            struct Color clr;
            
            if([digits containsObject:title]){
                clr.r = 0.69;
                clr.g = 0.69;
                clr.b = 0.55;
                clr.a = 1.;
                self.buttonColor = clr;
            }else if ([clear containsObject:title]){
                clr.r = 1.0;
                clr.g = 0.72;
                clr.b = 0.25;
                clr.a = 1.0;
                self.buttonColor = clr;
            }else if([equal containsObject:title]){
                clr.r = 0.26;//0.26;
                clr.g = 0.57;//0.57;
                clr.b = 0.70;//0.70;
                clr.a = 1.0;
                self.buttonColor = clr;
            } else {
                clr.r = 0.51;
                clr.g = 0.52;
                clr.b = 0.49;
                clr.a = 1.0;
                self.buttonColor = clr;
            }
            //self.cellButton.title = name;
}

-(void)setTitle:(NSString *)title
{
  
    //if(self.isOnsuperView){
        if(![_title isEqualToString:title]){
            [self setButtonColorAccordingTitle:title];
            _title = title;
            UIColor *textColor = [UIColor whiteColor]; //color of text
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
    
    NSString *fontName = nil;
    NSArray *famalyNames  =[UIFont familyNames];
    if([famalyNames containsObject:@"Helvetica Neue"]){
        NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
        if([fontNames containsObject:@"HelveticaNeue-Light"]){
            fontName = @"HelveticaNeue-Light";
        }
    }
    
    if(fontName){
        font = [UIFont fontWithName:fontName size:size];
    }else {
        font =[UIFont boldSystemFontOfSize:size];
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

-(void) drawTitle:(CGRect) rect
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
    neededRect.origin.x = (rect.size.width - neededRect.size.width) /2;
    
    [self.attrbutedTitle drawWithRect:neededRect options:NSStringDrawingUsesLineFragmentOrigin //
                              context:nil];
}


-(void) drawButtonViewInContext:(CGContextRef)context
{
    CGRect cornerRect;
    UIBezierPath *drawRectPath;
    CGPathRef pathOfRect;
    self.radiusCorner = self.frame.size.height/ 2.6;

    CGFloat borderWidth = self.radiusCorner / 3.2;

        //to states of buttons
    CGFloat x = borderWidth /2;
    CGFloat y = borderWidth /2;
    CGFloat width = self.bounds.size.width - borderWidth;
    CGFloat height = self.bounds.size.height - borderWidth;
    cornerRect = CGRectMake(x,y,width,height);
        
    drawRectPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect cornerRadius:(self.radiusCorner - borderWidth)];
    CGContextSetLineWidth(context, borderWidth);

    pathOfRect = drawRectPath.CGPath;
    CGContextAddPath(context, pathOfRect);
    if((self.buttonColor.r == 0.95) && (self.buttonColor.g == .95)&&(self.buttonColor.b == .95)){
        
    } else {
        CGContextSetRGBFillColor(context, .1, .1, .1, 0.5); //background of button
    }
    CGContextSetRGBStrokeColor(context, self.buttonColor.r, self.buttonColor.g, self.buttonColor.b, self.buttonColor.a);
    CGContextDrawPath(context, kCGPathFillStroke);
    

}

    
- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawButtonViewInContext:context];
    [self drawTitle:rect];
    

    //CALayer * viewLayer = self.layer;
    CGSize  shadowOffset;
   shadowOffset.height = 0;
    shadowOffset.width = 0;
    self.layer.shadowRadius = self.radiusCorner/3.0;
    if(self.isTaped){
            self.layer.shadowOpacity = 1.0;
    } else {
            self.layer.shadowOpacity = .0;
    }
   
}

@end
