//
//  DisplayLabel.m
//  ACalcTry
//
//  Created by Serge Sychov on 19.11.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "DisplayLabel.h"
#import "Clr.h"

#define DIGITS_LIMIT 10.
#define BASE_LINE  0
#define BUTTON_HEIGHT 60.f
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4


@interface DisplayLabel()


@end

@implementation DisplayLabel

-(void) setDesign:(NSInteger)design
{
    _design = design;
    UIColor *textColor;
    
    switch (self.design) {
        case DESIGN_PHOTO:
            //mainFont =[UIFont systemFontOfSize:size weight:UIFontWeightBold];
            textColor = [UIColor whiteColor];
            break;
            
        case DESIGN_CLASSIC:
            //mainFont =[UIFont systemFontOfSize:size weight:UIFontWeightLight ];
            textColor = [UIColor colorWithWhite:0.95 alpha:1];
            break;
            
        case DESIGN_PAPER:
            //mainFont =[UIFont systemFontOfSize:size weight:UIFontWeightLight ];
            textColor = [Clr paperButton];
            break;
            
        default:
            //mainFont =[UIFont systemFontOfSize:size weight:UIFontWeightLight ];
            textColor = [UIColor colorWithWhite:0.95 alpha:1];
            break;
            
    }
    
    [self.decRadLabel setTextColor:textColor];
    [self.firstMemoryLabel setTextColor:textColor];
    [self.secondMemoryLabel  setTextColor:textColor];
    
    [self showString:self.attributedText.string];
    
}

-(void) showString:(NSString *)str
{
    NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithString:str];
    //all kernels to -2
    if([mutAttrString length] > 0){
        [mutAttrString addAttribute:NSKernAttributeName
                              value:@-2
                              range:NSMakeRange(0, mutAttrString.length -1)];
        [mutAttrString addAttribute:NSKernAttributeName
                              value:@5
                              range:NSMakeRange(mutAttrString.length -1, 1)];
    }
    
    //set need ker to "1" and others non numbers symbols
    NSString *point = [self point];
    NSArray* strArray = [[NSArray alloc] initWithObjects:point,@"1",@" ",@".",@",", nil];
    for(int i = 0; i < mutAttrString.length; i++){
        
        if([strArray containsObject:[mutAttrString.string substringWithRange:NSMakeRange(i, 1)]]){
            NSDictionary *attr = [mutAttrString attributesAtIndex:i effectiveRange:nil];
            NSNumber * kernel  = [attr objectForKey:NSKernAttributeName];
            if(kernel){
                int intKern = [kernel intValue] - 4;
                [mutAttrString addAttribute:NSKernAttributeName
                                      value:[NSNumber numberWithInt:intKern]
                                      range:NSMakeRange(i,1)];
                
            }
            if(i > 0){
                attr = [mutAttrString attributesAtIndex:i-1 effectiveRange:nil];
                kernel  = [attr objectForKey:NSKernAttributeName];
                if(kernel){
                    int intKern = [kernel intValue] - 2;
                    [mutAttrString addAttribute:NSKernAttributeName
                                          value:[NSNumber numberWithInt:intKern]
                                          range:NSMakeRange(i -1,1)];
                    
                }
            }
        }
    }
    //set textcolor aacroding design
    UIColor *textColor;
    switch (self.design) {
        case DESIGN_PAPER:
            textColor = [Clr paperButton];
            [mutAttrString addAttribute:NSForegroundColorAttributeName
                                  value:textColor
                                  range:NSMakeRange(0, mutAttrString.length)];
            [mutAttrString addAttribute:NSTextEffectAttributeName
                                  value:NSTextEffectLetterpressStyle
                                  range:NSMakeRange(0, mutAttrString.length)];

            
            break;
            
        default:
            break;
    }
    
    self.attributedText = [mutAttrString copy];
}
-(void) setup
{
    UIFont *font; //if there is no needed font
    CGFloat size;
    
    UILabel *decRadLabel;
    UILabel *firstMemoryLabel;
    UILabel *secondMemoryLabel;
    UIColor *textColor;
    
    if(IS_IPAD){
        size = 93;
        font = [UIFont systemFontOfSize:19.];
        decRadLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 48,22)];
        firstMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 27,22)];
        secondMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 0, 27,22)];
    } else {
        size = 50;
        font = [UIFont systemFontOfSize:13.];
        decRadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 32,15)];
        firstMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 18,15)];
        secondMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 0, 18,15)];
    }
    

    
    self.font = [UIFont systemFontOfSize:size weight:UIFontWeightLight ];
    
    textColor = [UIColor whiteColor];
    
    [decRadLabel setTextColor:textColor];
    [decRadLabel setFont:font];
    [self addSubview:decRadLabel];
    self.decRadLabel = decRadLabel;
    
    
    [firstMemoryLabel setTextColor:textColor];
    [firstMemoryLabel setFont:font];
    [self addSubview:firstMemoryLabel];
    self.firstMemoryLabel = firstMemoryLabel;
    
    
    [secondMemoryLabel setTextColor:textColor];
    [secondMemoryLabel setFont:font];
    [self addSubview:secondMemoryLabel];
    self.secondMemoryLabel = secondMemoryLabel;
    
    self.adjustsFontSizeToFitWidth = YES;
    
    
}


-(id) initWithFrame:(CGRect)frame
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


/*

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   // [self addMaskLayerWithRect: rect];
}
*/
#pragma mark HELPED FUNCTIONS______________________
//return point according localisation
-(NSString *) point
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}


@end
