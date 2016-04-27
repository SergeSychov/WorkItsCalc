//
//  TextEditController.m
//  ITSCalc
//
//  Created by Sychov Intencom on 09.09.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "TextEditController.h"

@interface TextEditController()

@property (nonatomic,strong) NSArray *progWhole;
@property (nonatomic,strong) NSAttributedString *strWholeIn;
@property (nonatomic) NSRange rngIn;
@property (nonatomic,strong) NSDictionary* attributes;

@property (nonatomic,strong) NSAttributedString* strLastPartArchive;
@property (nonatomic,strong) NSArray *progLastPartArchive;

@end

@implementation TextEditController

+(TextEditController*) initWithProg:(NSArray*)prg WholeString:(NSAttributedString*)whlStr incomingRange:(NSRange)inRng withAttr:(NSDictionary *)atr
{
    TextEditController *tec = [[TextEditController alloc] init];
    
    tec.progWhole = prg;
    tec.strWholeIn = whlStr;
    tec.rngIn = inRng;
    tec.attributes = atr;
    
    return tec;
}

-(NSRange)rangeOut
{
    NSRange range = self.rngIn;
    
    
    return range;
}

-(NSAttributedString*)strForTextViewWithChangedProg:(NSArray*)progCurr//returned string at prog changing
{
    NSMutableAttributedString *str = [[ACalcBrain descriptionOfProgram:progCurr withAttributes:self.attributes] mutableCopy];
    [str insertAttributedString:self.strLastPartArchive atIndex:str.length];
    return [str copy];
}


-(NSAttributedString*)strForTextView //returned string
{

    return [self strForTextViewWithChangedProg:self.progFirstPart];
}


-(NSArray*) progFinalWithChangedProg:(NSArray*)progCurr //returned program at equal press may be not necessary
{
    NSMutableArray *progFinal = [[NSMutableArray alloc] initWithArray:progCurr];
    [progFinal addObjectsFromArray:self.progLastPartArchive];
    
    return [progFinal copy];
}

-(NSArray*) progFinal //returned program at equal press
{
    return [self progFinalWithChangedProg:self.progFirstPart];
}




@end
