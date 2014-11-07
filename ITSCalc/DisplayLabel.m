//
//  DisplayLabel.m
//  ACalcTry
//
//  Created by Serge Sychov on 19.11.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "DisplayLabel.h"
#define DIGITS_LIMIT 10.
#define BASE_LINE  0
#define BUTTON_HEIGHT 60.f
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@interface DisplayLabel()


@end

@implementation DisplayLabel

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
    
    self.attributedText = mutAttrString;
}
-(void) setup
{
    UIFont *font; //if there is no needed font
    CGFloat size;
    if(IS_IPAD){
        size = 93;
    } else {
        size = 50;
    }
    
    NSString *fontName = nil;
    NSString *fondBoldName = nil;
    
    NSArray *famalyNames  =[UIFont familyNames];
    if([famalyNames containsObject:@"Helvetica Neue"]){
        NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
        if([fontNames containsObject:@"HelveticaNeue-Thin"]){
            fontName = @"HelveticaNeue-Thin";
        }
        if([fontNames containsObject:@"HelveticaNeue-Light"]){
            fondBoldName = @"HelveticaNeue-Light" ;
        }
    }
    
    UIFont *system = [UIFont systemFontOfSize:size];
    // NSLog(@"Font sys: %@", system);
    if([system.fontName isEqualToString:@".HelveticaNeueInterface-Regular"]){
        if(fontName){
            font = [UIFont fontWithName:fontName size:size];
        }else {
            font =[UIFont systemFontOfSize:size];
        }
    } else if ([system.fontName isEqualToString:@".HelveticaNeueInterface-MediumP4"]){
        if(fondBoldName){
            font = [UIFont fontWithName:fondBoldName size:size];
        }else {
            font =[UIFont systemFontOfSize:size];
        }
        
    } else {
        font =[UIFont systemFontOfSize:size];
    }
    
    self.font = font;
    
    UILabel *decRadLabel;
    UILabel *firstMemoryLabel;
    UILabel *secondMemoryLabel;
    
    if(IS_IPAD){
        font = [UIFont systemFontOfSize:19.];
        decRadLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 48,22)];
        firstMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 27,22)];
        secondMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 0, 27,22)];
    } else {
        font = [UIFont systemFontOfSize:13.];
        decRadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 32,15)];
        firstMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 18,15)];
        secondMemoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 0, 18,15)];
    }
    
    
    
    
    [decRadLabel setTextColor:[UIColor whiteColor]];
    [decRadLabel setFont:font];
    [self addSubview:decRadLabel];
    self.decRadLabel = decRadLabel;
    
    
    [firstMemoryLabel setTextColor:[UIColor whiteColor]];
    [firstMemoryLabel setFont:font];
    [self addSubview:firstMemoryLabel];
    self.firstMemoryLabel = firstMemoryLabel;
    
    
    [secondMemoryLabel setTextColor:[UIColor whiteColor]];
    [secondMemoryLabel setFont:font];
    [self addSubview:secondMemoryLabel];
    self.secondMemoryLabel = secondMemoryLabel;
    
    
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
