//
//  AtrStrStore.m
//  CalcLayout
//
//  Created by Serge Sychov on 13.04.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import "AtrStrStore.h"

#define BUTTON_TITLE_INSET 0.8

@implementation AtrStrStore

-(NSDictionary*)mainAttributes{
    //get current class size
    UIUserInterfaceSizeClass curentClassSize = [self.delegate currentInterfaceClassSize];

    UIColor *textColor;
    textColor = [UIColor darkGrayColor];
    
    //change font size
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.s
    UIFont *font;
    if (curentClassSize == UIUserInterfaceSizeClassCompact) {
        font  = [UIFont preferredFontForTextStyle:self.design.compactTextStyle];
        style.alignment = NSTextAlignmentLeft;
    }else {
        font  = [UIFont preferredFontForTextStyle:self.design.regularTextStyle];
        style.alignment = NSTextAlignmentRight;
    }
    NSDictionary* attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    return attributes;

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
#pragma mark EXTERNAL FUNCTIONS
+(CGFloat) pointSizeOfAtrString:(NSAttributedString*)atrStr{
    CGFloat retPointSize = 0.;
    //find the bigest point size attribute and return this value
    for(NSInteger index = 0; index < [atrStr length]; index++){
        NSDictionary * attributes = [atrStr attributesAtIndex:index effectiveRange:NULL];
        UIFont *font = [attributes valueForKey:NSFontAttributeName];
        CGFloat fontPointSize = font.pointSize;
        retPointSize = (fontPointSize>retPointSize)? fontPointSize: retPointSize;
    }
    return retPointSize;
}

+(NSAttributedString*)resizeAttrString:(NSAttributedString*)inputStr withKoeff:(CGFloat)k{
    NSMutableAttributedString* resultString = [inputStr mutableCopy];
    
    //set the new value for all of symbols according new k
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        NSNumber *wasOffset = [attributes valueForKey:NSBaselineOffsetAttributeName];
        UIFont *font = [UIFont fontWithName:wasFont.familyName size:wasFont.pointSize * k];
        [symbolString beginEditing];
        NSRange wholeRange = NSMakeRange(0, [symbolString length]);
        [symbolString addAttribute:NSFontAttributeName value:font range:wholeRange];
        [symbolString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:[wasOffset floatValue]* k] range:wholeRange];
        [symbolString endEditing];
        [resultString replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:symbolString];
    }
    return [resultString copy];
}
+(NSAttributedString*)resizeAttrString:(NSAttributedString *)inputStr toPointSize:(CGFloat)pointSize{
    //1. find the initial string point size
    CGFloat initSize = [AtrStrStore pointSizeOfAtrString:inputStr];
    //2. find the multiplyer
    CGFloat koeff = pointSize/initSize;
    //3. return string with koeff
    return [AtrStrStore resizeAttrString:inputStr withKoeff:koeff];
}

+(NSAttributedString*)resizeAttrString:(NSAttributedString*)inputStr accordingBound:(CGSize)boundSize{
    NSAttributedString *retAtrStr = inputStr;
    //solve only according heigth. Wight  is a constant
    CGSize bigHeightsize = CGSizeMake(boundSize.width, 10000.f);
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    //1. check if input string bounding with rect if YES return initial string
    while ([retAtrStr boundingRectWithSize:bigHeightsize options:NSStringDrawingUsesLineFragmentOrigin
                                       context:drawContext].size.height > boundSize.height) {
        //3. while not bounding rect multiply point size for 0.9f return rect
        retAtrStr = [AtrStrStore resizeAttrString:retAtrStr withKoeff:0.9];
        if([AtrStrStore pointSizeOfAtrString:retAtrStr] < 7.){
            retAtrStr = [[NSAttributedString alloc]initWithString:@":)"];
            break;
        }
    }
    return retAtrStr;
}
+(NSAttributedString*)resizeAttrString:(NSAttributedString *)inputStr WithInitPointSize:(CGFloat)pointSize accordingBound:(CGSize)boundSize byHeight:(BOOL)isForHeight{

    NSAttributedString *retAtrStr = [AtrStrStore resizeAttrString:inputStr toPointSize:pointSize];
    
    if(isForHeight){
        CGSize bigHeightsize = CGSizeMake(boundSize.width*0.7f, 10000.f);
        NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
        //1. check if input string bounding with rect if YES return initial string
        while ([retAtrStr boundingRectWithSize:bigHeightsize options:NSStringDrawingUsesLineFragmentOrigin
                                       context:drawContext].size.height > boundSize.height) {
            

            //3. while not bounding rect multiply point size for 0.9f return rect
            retAtrStr = [AtrStrStore resizeAttrString:retAtrStr withKoeff:0.9];
            
            if([AtrStrStore pointSizeOfAtrString:retAtrStr] < 5.){
                retAtrStr = [[NSAttributedString alloc]initWithString:@":)"];
                break;
            }
        }
    } else {
        CGSize bigWidthtsize = CGSizeMake(10000.f, boundSize.height);
        NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
        //1. check if input string bounding with rect if YES return initial string
        while ([retAtrStr boundingRectWithSize:bigWidthtsize options:NSStringDrawingUsesLineFragmentOrigin
                                       context:drawContext].size.width > boundSize.width) {
            //3. while not bounding rect multiply point size for 0.9f return rect
            retAtrStr = [AtrStrStore resizeAttrString:retAtrStr withKoeff:0.9];
            if([AtrStrStore pointSizeOfAtrString:retAtrStr] < 5.){
                retAtrStr = [[NSAttributedString alloc]initWithString:@":)"];
                break;
            }
        }
    }
    
    return retAtrStr;
}
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
