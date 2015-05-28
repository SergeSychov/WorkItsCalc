//
//  TextEditController.h
//  ITSCalc
//
//  Created by Sychov Intencom on 09.09.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACalcBrain.h"

@interface TextEditController : NSObject

@property(nonatomic) NSRange rangeOut;//the place need set up cursor in current string
@property(nonatomic) NSArray* progFirstPart; //not changeble first part of program

-(NSAttributedString*)strForTextView; //returned string
-(NSAttributedString*)strForTextViewWithChangedProg:(NSArray*)progCurr;//returned string at prog changing

-(NSArray*) progFinal; //returned program at equal press
-(NSArray*) progFinalWithChangedProg:(NSArray*)progCurr; //returned program at equal press may be not necessary

+(TextEditController*) initWithProg:(NSArray*)prg WholeString:(NSAttributedString*)whlStr incomingRange:(NSRange)inRng withAttr:(NSDictionary*) atr;


@end
