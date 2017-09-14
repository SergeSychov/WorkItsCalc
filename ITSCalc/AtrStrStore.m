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

+(NSAttributedString*)changeFontSizeFrom:(NSAttributedString*)inStr toSize:(CGSize)size{
    NSMutableAttributedString *atrOutStr = [inStr mutableCopy];
    //for each char set point size according ratio and needFontName
    [atrOutStr beginEditing];
    
    for (NSInteger index = 0; index < [atrOutStr length]; index++){
        NSDictionary * attributes = [atrOutStr attributesAtIndex:index effectiveRange:NULL];
        CGFloat newPointSize = size.height*BUTTON_TITLE_INSET;
        
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        
        UIFont *newFont = [UIFont fontWithName:font.fontName size:newPointSize];
        
        NSRange charRange = NSMakeRange(index, 1);
        
        [atrOutStr addAttribute:NSFontAttributeName value:newFont range:charRange];
    }
    
    [atrOutStr endEditing];
    
    return [atrOutStr copy];
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
