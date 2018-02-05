//
//  DisplayRam.m
//  ACalcTry
//
//  Created by Serge Sychov on 11.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "DisplayRam.h"
#import "ACalcBrain.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@interface DisplayRam()

@property (nonatomic, strong) NSString* resultString;
@property (nonatomic) BOOL isFloat;
@property (nonatomic) NSInteger displayLenght;



@end

@implementation DisplayRam

#define ERROR_STRING NSLocalizedStringFromTable(@"ERROR_STRING",@"ACalcTryViewControllerTable", @"ERROR")
-(void) setup
{
    self.isFloat = NO;
    if(IS_IPAD){
        if(self.isIpadPortraitView){
            self.displayLenght = 12;
        } else {
            self.displayLenght = 15;
        }
    } else {
       self.displayLenght = 10;
    }
    //self.displayLenght = 10;
    self.isGradMinutesSecons = 0;
    self.resDictionary = nil;
    
}


-(void) setIsIpadPortraitView:(BOOL)isIpadPortraitView
{
    _isIpadPortraitView = isIpadPortraitView;
    if(isIpadPortraitView){
        self.displayLenght = 11;
    } else {
        self.displayLenght = 15;
    }
}


-(NSNumberFormatter*) formatter
{
    if(!_formatter){
        _formatter = [[NSNumberFormatter alloc] init];
        //_formatter.usesSignificantDigits = YES;
        
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        if(IS_IPAD ) {
            if(self.isIpadPortraitView){
                [_formatter setMaximumFractionDigits:14];
            } else {
                [_formatter setMaximumFractionDigits:20];
                //[_formatter setMaximumSignificantDigits:20];
            }
            //[_formatter setMaximumFractionDigits:18];
        } else {
            [_formatter setMaximumFractionDigits:12];
        }
        //[_formatter setMaximumFractionDigits:12];
        [_formatter setMinimumFractionDigits:0];
        [_formatter setExponentSymbol:@"e"];
        [_formatter setZeroSymbol:@"0"];
    }
    return _formatter;
}

-(NSArray*) gradArray
{
    if(!_gradArray){
        _gradArray = [[NSArray alloc] init];
    }
    return _gradArray;
}

-(NSArray*) firstMemoryStack
{
    if(!_firstMemoryStack){
        _firstMemoryStack = [[NSArray alloc] init];
    }
    return  _firstMemoryStack;
}

-(NSArray*) secondMemoryStack
{
    if(!_secondMemoryStack){
        _secondMemoryStack = [[NSArray alloc] init];
    }
    return _secondMemoryStack;
}

-(NSNumber*) resultNumber
{
    if(!_resultNumber){
        _resultNumber = @0.0;
    }
    return _resultNumber;
}

-(NSString*) resultString
{
    if(!_resultString){
        _resultString = @"0";
    }
    return _resultString;
}

-(NSInteger) displayLenght{
    
    if(IS_IPAD){
        if(self.isIpadPortraitView){
            return self.isFloat ? 12 : 11;
        } else {
            return self.isFloat ? 16 : 15;
        }
        //return self.isFloat ? 17 : 16;
    } else {
        return self.isFloat ? 11 : 10;
    }
    //return self.isFloat ? 11 : 10;
}

-(void)setIsFloat:(BOOL)isFloat
{
    _isFloat = isFloat;
    if(isFloat){
        if(IS_IPAD){
            if(self.isIpadPortraitView){
                self.displayLenght = 12;
            } else {
                self.displayLenght = 16;
            }
            //self.displayLenght = 17;
        } else {
            self.displayLenght = 11;
        }
       // self.displayLenght = 11;
    } else {
        if(IS_IPAD){
            if(self.isIpadPortraitView){
                self.displayLenght = 11;
            } else {
                self.displayLenght = 15;
            }
            //self.displayLenght = 16;
        } else {
            self.displayLenght = 10;
        }
       // self.displayLenght = 10;
    }
}

-(BOOL) isGradValue
{
    return self.isGradMinutesSecons == 0 ? NO : YES;
}

-(NSString*) addSymbol:(id) symbol
{
    NSString * str = @"0";
    

    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if(self.isFloat){
        if(IS_IPAD){
            if(self.isIpadPortraitView){
                [self.formatter setMaximumFractionDigits:14];
            } else {
                [self.formatter setMaximumFractionDigits:18];
            }
            //[self.formatter setMaximumFractionDigits:18];
        } else {
            [self.formatter setMaximumFractionDigits:12];
        }
        //[self.formatter setMaximumFractionDigits:12];
    } else {
        if(IS_IPAD){
            if(self.isIpadPortraitView){
                [self.formatter setMaximumFractionDigits:13];
            } else {
                [self.formatter setMaximumFractionDigits:17];
                //[self.formatter setMaximumIntegerDigits:17];
            }
            //[self.formatter setMaximumFractionDigits:17];
        } else {
            [self.formatter setMaximumFractionDigits:11];
        }
        //[self.formatter setMaximumFractionDigits:11];
    }
    if([symbol isKindOfClass:[NSNumber class]]){
        if(self.isGradMinutesSecons == 0){
           // NSLog(@"symbol %@",symbol);
            if([self.resultString length] < self.displayLenght){

                if(([symbol doubleValue] == 0) && self.isFloat){
                    self.resultString = [self.resultString stringByAppendingString:@"0"];
                    //here ned to get trunc as formated str and than add zeros
                    NSNumber *truncNumber = [NSNumber numberWithDouble:trunc([self.resultNumber doubleValue])];
                    NSString *truncPart = [self.formatter stringFromNumber:truncNumber];
                    
                    NSRange pointRange = [self.resultString rangeOfString:@"."];
                    NSString *otherPart = [[NSString alloc] initWithString:self.resultString];
                    otherPart = [otherPart substringFromIndex:pointRange.location];
                    truncPart = [truncPart stringByAppendingString:otherPart];

                    str = [self replasePointinString:truncPart];

                } else if ([symbol doubleValue] == 0 && (! self.isFloat) && ([self.resultNumber doubleValue]==0)) {
                    str = [self.formatter stringFromNumber:self.resultNumber];
                } else {
                    if([self.resultString isEqualToString:@"0"]){
                        self.resultString = [symbol stringValue];
                    } else {
                        self.resultString = [self.resultString stringByAppendingString:[symbol stringValue]];
                    }
                    
                    
                     long double test = [self.resultString doubleValue];
                   
                    
                    self.resultNumber = [NSNumber numberWithDouble:test];// [self.resultString doubleValue]
                   // self.resultNumber = [self.formatter numberFromString:self.resultString];
                    //self.resultNumber = [NSNumber numberWithDouble:test];
                    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    str = [self.formatter stringFromNumber:self.resultNumber];
                   // }

                }

            } else {
                
                str = [self.formatter stringFromNumber:self.resultNumber];
            }
            //for minutes and secons
        } else if((self.isGradMinutesSecons == 1) || (self.isGradMinutesSecons == 2)){
            NSMutableArray *copyGradArray = [self.gradArray mutableCopy];
            id lastObj = [copyGradArray lastObject];
            if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                [copyGradArray removeLastObject];
            } else {
                lastObj = @0;
            }
            NSString* minutStr = [lastObj stringValue];
            minutStr = [minutStr stringByAppendingString:[symbol stringValue]];
            if([minutStr length] > 2){
                minutStr = [minutStr substringFromIndex:1];
                lastObj = [NSNumber numberWithDouble:[minutStr doubleValue]];
            } else {
                lastObj = [NSNumber numberWithDouble:[minutStr doubleValue]];
            }
            [copyGradArray addObject:lastObj];
            self.gradArray = [copyGradArray copy];
            str = [self stringFromGrad:self.gradArray];

        } else {
            str = [self stringFromGrad:self.gradArray];
        }
    } else if([symbol isKindOfClass:[NSString class]]){
        if([symbol isEqualToString:@"."] && (self.isGradMinutesSecons == 0)){
            if(!self.isFloat){
                self.resultString = [self.resultString stringByAppendingString:symbol];
                str = [[self.formatter stringFromNumber:self.resultNumber] stringByAppendingString:[self point]];
                self.isFloat = YES;
            } else {
                if([self.resultNumber doubleValue] != 0){
                    NSNumber *truncNumber = [NSNumber numberWithDouble:trunc([self.resultNumber doubleValue])];
                    NSString *truncPart = [self.formatter stringFromNumber:truncNumber];
                    
                    NSRange pointRange = [self.resultString rangeOfString:@"."];
                    NSString *otherPart = [[NSString alloc] initWithString:self.resultString];
                    otherPart = [otherPart substringFromIndex:pointRange.location];
                    truncPart = [truncPart stringByAppendingString:otherPart];
                    str = [self replasePointinString:truncPart];
                    //str = [self.formatter stringFromNumber:self.resultNumber];
                } else {
                    str = [self replasePointinString:self.resultString];
                }
            }
        } else if ([symbol isEqualToString:@"-"] && ([self.resultNumber doubleValue] == 0)){
            NSRange minusRange = [self.resultString rangeOfString:@"-"];
            if(minusRange.location == NSNotFound){
                self.resultString = [@"-" stringByAppendingString:self.resultString];
            } else {
                self.resultString = [self.resultString substringFromIndex:minusRange.location +1];
            }
            str = [self replasePointinString:self.resultString];
        } else if ([symbol isEqualToString:@"° ′″"]){
            if(self.isGradMinutesSecons ==0){
                double grad = floor([self.resultNumber doubleValue]);
                NSMutableArray *copyGrad = [self.gradArray mutableCopy];
                [copyGrad addObject:[NSNumber numberWithDouble: fmod(grad, 360)]];
                [copyGrad addObject:@"°"];
                self.gradArray = [copyGrad copy];
                self.isGradMinutesSecons = 1;
            } else if(self.isGradMinutesSecons == 1) {
                double minutes;
                NSMutableArray* copyGradArray = [self.gradArray mutableCopy];
                id lastObj = [copyGradArray lastObject];
                if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                    [copyGradArray removeLastObject];
                    minutes = [lastObj doubleValue];
                } else {
                    minutes = 0;
                }
                minutes = fmod(minutes,60);

                [copyGradArray addObject:[NSNumber numberWithDouble:minutes]];
                [copyGradArray addObject:@"′"];
                self.gradArray = [copyGradArray copy];
                
                self.isGradMinutesSecons = 2;
            } else if (self.isGradMinutesSecons == 2){
                double minutes;
                NSMutableArray* copyGradArray = [self.gradArray mutableCopy];
                id lastObj = [copyGradArray lastObject];
                if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                    [copyGradArray removeLastObject];
                    minutes = [lastObj doubleValue];
                } else {
                    minutes = 0;
                }
                minutes = fmod(minutes,60);
                
                [copyGradArray addObject:[NSNumber numberWithDouble:minutes]];
                [copyGradArray addObject:@"″"];
                self.gradArray = [copyGradArray copy];
                
                self.isGradMinutesSecons = 3;
            } else {
                
            }
            str = [self stringFromGrad:self.gradArray];
            
        }  else if([symbol isEqualToString:@"∓°"]){
            NSMutableArray * copyGradArray = [self.gradArray mutableCopy];
            id firstObj = [copyGradArray objectAtIndex:0];
            if(firstObj && [firstObj isKindOfClass:[NSNumber class]]){
                [copyGradArray removeObjectAtIndex:0];
                firstObj = [NSNumber numberWithDouble:[firstObj doubleValue]* (-1)];
                [copyGradArray insertObject:firstObj atIndex:0];
                self.gradArray = [copyGradArray copy];
                str = [self stringFromGrad:self.gradArray];
            }
        } else if([symbol isEqualToString:@"x"] || [symbol isEqualToString:@"y"]){
            str = symbol;
        } else {
            if(self.isGradMinutesSecons ==0){
                str = [self.formatter stringFromNumber:self.resultNumber];
            } else {
                str = [self stringFromGrad:self.gradArray];
            }
        }

        
    } else if ([symbol isKindOfClass:[NSDictionary class]]){
        str = [[symbol allKeys]firstObject];
        self.resDictionary = symbol;
    }else {
        if(self.isGradMinutesSecons ==0){
        str = [self.formatter stringFromNumber:self.resultNumber];
        } else {
            str = [self stringFromGrad:self.gradArray];
        }
        
    }
    return str;
}

-(void) clearRam
{
    self.resultNumber = @0.0;
    self.resultString = @"0";
    self.isFloat = NO;
    self.isGradMinutesSecons = 0;
    self.resDictionary = nil;
    self.gradArray  = [NSArray array];
}

-(NSString*) deleteLastSymbol
{
    NSString* str;
    if(self.isGradMinutesSecons > 0){
        //to removing step by step in grad array and chnge value of prefix
        NSMutableArray *copyCradArray = [self.gradArray mutableCopy];
        id lastObj = [copyCradArray lastObject];
        if([lastObj isKindOfClass:[NSString class]]){
            [copyCradArray removeLastObject];
            if([lastObj isEqualToString:@"″"]){
                _isGradMinutesSecons = 2;
                //self.isGradMinutesSecons = 2;
                //return previous value
                _gradArray = [copyCradArray copy];
                //self.gradArray = [copyCradArray copy];
                str = [self stringFromGrad:self.gradArray];
            } else if ([lastObj isEqualToString:@"′"]){
                self.isGradMinutesSecons = 1;
                //return previous value
                self.gradArray = [copyCradArray copy];
                str = [self stringFromGrad:self.gradArray];
            } else if ([lastObj isEqualToString:@"°"]){
                self.isGradMinutesSecons = 0;
                self.resultNumber = [copyCradArray lastObject];
                [copyCradArray removeLastObject];
                self.gradArray = [copyCradArray copy];
                self.resultString = [self.resultNumber stringValue];
                str = self.resultString;
            }
        } else if([lastObj isKindOfClass:[NSNumber class]]){
            NSString* strInArray = [lastObj stringValue];
            if([strInArray length] > 1){
                [copyCradArray removeLastObject];
                strInArray = [strInArray substringToIndex:[strInArray length]-1];
                lastObj = [NSNumber numberWithDouble:[strInArray doubleValue]];
                [copyCradArray addObject:lastObj];
            } else {
                [copyCradArray removeLastObject];
            }
            self.gradArray = [copyCradArray copy];
            str = [self stringFromGrad:self.gradArray];
        }
        
        
    } else {
        if(([self.resultString length]== 1) || ([self.resultString length]== 0)){
            [self clearRam];
            str = @"0";
        } else {
            if([[self.resultString substringFromIndex:[self.resultString length]-1] isEqualToString:@"."]) self.isFloat = NO;
            NSRange beforeLastRange = NSMakeRange([self.resultString length]-2, 1);
            if(self.isFloat && ([[self.resultString substringWithRange:beforeLastRange] isEqualToString:@"0"])){
                self.resultString = [self.resultString substringToIndex:[self.resultString length]-1];
                NSNumber *truncNumber = [NSNumber numberWithDouble:trunc([self.resultNumber doubleValue])];
                NSString *truncPart = [self.formatter stringFromNumber:truncNumber];
                
                NSRange pointRange = [self.resultString rangeOfString:@"."];
                NSString *otherPart = [[NSString alloc] initWithString:self.resultString];
                otherPart = [otherPart substringFromIndex:pointRange.location];
                truncPart = [truncPart stringByAppendingString:otherPart];
                str = [self replasePointinString:truncPart];
            } else {
                self.resultString = [self.resultString substringToIndex:[self.resultString length]-1];
                self.resultNumber = [NSNumber numberWithDouble:[self.resultString doubleValue]];
                str = [self.formatter stringFromNumber:self.resultNumber];
            }
            
        //need to ste up right value of point
            if([[self.resultString substringFromIndex:[self.resultString length]-1] isEqualToString:@"."]) {
                str = [str stringByAppendingString:[self point]];
            }
        }
    }
    return str;
}

-(NSString*) setResult:(id)result
{
    NSString* str = @"";
    if([result isKindOfClass:[NSNumber class]]){
        str = [(NSNumber*)result stringValue];
        //work with erreor
        double test = [result doubleValue];
        if((test == INFINITY) || [str isEqualToString:@"nan"] || ((test *(-1)) == INFINITY)){

            [self.delegate errorAction];
            str = ERROR_STRING;
        } else {
            self.resultString = [(NSNumber*)result stringValue]; ;

            self.resultNumber = (NSNumber*) result;//[NSNumber numberWithDouble:[self.resultString doubleValue]];

                //self.resultString = [result stringValue];
            double maxNum;
            double minNum;
            NSInteger fraction;
            if(IS_IPAD){
                if(self.isIpadPortraitView){
                    maxNum = 9e10;
                    minNum = 9e-10;
                    fraction = 8;
                } else {
                    maxNum = 9e15;
                    minNum = 9e-15;
                    fraction = 13;
                }
                //self.displayLenght = 17;
            } else {
                maxNum = 9e9;
                minNum = 9e-9;
                fraction = 7;
            }
            if (fabs([result doubleValue])>maxNum|| fabs([result doubleValue])<minNum) {
                [self.formatter setNumberStyle:NSNumberFormatterScientificStyle];
                [self.formatter setMaximumFractionDigits:fraction];
            }
            else{
                [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                NSRange pointRange = [self.resultString rangeOfString:@"."];
                if(pointRange.location == NSNotFound){
                    self.isFloat = NO;
                } else {
                    self.isFloat = YES;
                }
                
                double intPartLenght = log10(fabs([result doubleValue]));
                double intPart;
                modf(intPartLenght, &intPart);
                if(intPart <0) intPart = 0;
                
                [self.formatter setMaximumFractionDigits:(self.displayLenght - 2 - (int)intPart)];
                //[self.formatter setMaximumFractionDigits:(9 - (int)intPart)];
            
            }
            
            //NSString *resultString = [self.resultNumber stringValue];
           // if([resultString length] > self.displayLenght){
            //    resultString = [resultString substringToIndex:self.displayLenght -1];
             //   str = [self.formatter stringFromNumber:[NSNumber numberWithDouble:[resultString doubleValue]]];
            //} else {
                str = [self.formatter stringFromNumber:(NSNumber*)result];
           // }
        }
    } else if ([result isKindOfClass:[NSString class]]){
        if([result isEqualToString:@"D"] || [result isEqualToString:@"R"]){
            NSMutableArray *resultGradArray = [[NSMutableArray alloc] init];
            double resultDouble;
            if([result isEqualToString:@"R"]){
                resultDouble = [self.resultNumber doubleValue] * 180 / M_PI;
            } else {
                resultDouble = [self.resultNumber doubleValue];
            }
           
            double grad = trunc(resultDouble);
            resultDouble = (resultDouble - grad) * 60;
            grad = fmod(grad, 360);
            [resultGradArray addObject:[NSNumber numberWithDouble:grad]];
            [resultGradArray addObject:@"°"];
            
            
            double minutes = trunc(resultDouble);
            [resultGradArray addObject:[NSNumber numberWithDouble:minutes]];
            [resultGradArray addObject:@"′"];
            
            resultDouble = (resultDouble - minutes) * 60;
            double seconds = trunc(resultDouble);
            [resultGradArray addObject:[NSNumber numberWithDouble:seconds]];
            [resultGradArray addObject:@"″"];
            
            str = [self stringFromGrad:[resultGradArray copy]];
        } else {
            NSString* resStr = (NSString*)result;
            NSString *substractedString = [resStr substringToIndex:resStr.length -3];
            NSString *restNameOfCurrency = [@" " stringByAppendingString:[resStr substringFromIndex:resStr.length -3]];
            NSNumber* substractedCurrency = [NSNumber numberWithDouble:[substractedString doubleValue]];
            
            NSLog(@"restCurrency str %@", restNameOfCurrency);
            str = [[self setResult:substractedCurrency] stringByAppendingString:restNameOfCurrency];
            
        }
    }
    //if([str length] > self.displayLenght){
    //    str = [str substringToIndex:self.displayLenght];
    //}
    return str;
}

-(id) getResult
{
    id result;
    if(self.resDictionary){
        result = self.resDictionary;
    } else if(self.isGradMinutesSecons == 0){
        result = self.resultNumber;
    } else {
        if(![[self.gradArray lastObject] isKindOfClass:[NSString class]]){
            [self addSymbol:@"° ′″"];
        }
        result = self.gradArray;
    }
    return result;
}

-(void) addResToMemory:(BOOL)isFirst inRadians:(BOOL)isRadCounting
{
    [self addRes:[self getResult] toMemory:isFirst inRadians: isRadCounting]; //was self.resultNumber instead on [self getResult]
}

-(void) addRes:(id)res toMemory:(BOOL)isFirst inRadians:(BOOL)isRadCounting
{
    NSMutableArray * copyMemory = isFirst? [self.firstMemoryStack mutableCopy] : [self.secondMemoryStack mutableCopy];
    [copyMemory addObject:@"+"];
    [copyMemory addObject:res];
    if(!(self.isGradMinutesSecons == 0)){
        NSMutableArray *copyGradArray = [[copyMemory lastObject] mutableCopy];
        [copyMemory removeLastObject];
        [copyGradArray addObject: isRadCounting ? @"R" : @"D"];
        [copyMemory addObject:[copyGradArray copy]];
    }
    
    isFirst ? (self.firstMemoryStack = [copyMemory copy]) : (self.secondMemoryStack = [copyMemory copy]);
    
}

-(void) substractResFromMemory:(BOOL)isFirst inRadians:(BOOL)isRadCounting
{
    [self substractRes:[self getResult] fromMemory:isFirst inRadians:isRadCounting]; //was self.resultNumber instead on [self getResult]
}

-(void) substractRes:(id)res fromMemory: (BOOL) isFirst inRadians:(BOOL)isRadCounting
{
    NSMutableArray * copyMemory = isFirst? [self.firstMemoryStack mutableCopy] : [self.secondMemoryStack mutableCopy];
    [copyMemory addObject:@"-"];
    [copyMemory addObject:res];
    if(!(self.isGradMinutesSecons == 0)){
        NSMutableArray *copyGradArray = [[copyMemory lastObject] mutableCopy];
        [copyMemory removeLastObject];
        [copyGradArray addObject: isRadCounting ? @"R" : @"D"];
        [copyMemory addObject:[copyGradArray copy]];
    }
    isFirst ? (self.firstMemoryStack = [copyMemory copy]) : (self.secondMemoryStack = [copyMemory copy]);
}

-(NSString*) getResultFromMemory:(BOOL)isFirst
{
    [self clearRam];
    NSMutableArray * copyMemory = isFirst? [self.firstMemoryStack mutableCopy] : [self.secondMemoryStack mutableCopy];
    
    return [self setResult:[NSNumber numberWithDouble:[ACalcBrain runProgram:copyMemory]]];
}

-(void) clearMemory:(BOOL)isFirst
{
    NSMutableArray * copyMemory = isFirst? [self.firstMemoryStack mutableCopy] : [self.secondMemoryStack mutableCopy];
    [copyMemory removeAllObjects];
    isFirst ? (self.firstMemoryStack = [copyMemory copy]) : (self.secondMemoryStack = [copyMemory copy]);
}


#pragma marks ______HELPED_FUNCTIONS_______________
-(NSString *) point
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}

-(NSString*) replasePointinString: (NSString*) str
{
    NSString* result = str;
    
    NSRange pointLocation = [str rangeOfString:@"."];
    if(!(pointLocation.location == NSNotFound)){
        NSString *heplStr = [[str substringToIndex:pointLocation.location] stringByAppendingString:[self point]];
        result = [str substringFromIndex:pointLocation.location + 1] ;
        result = [heplStr stringByAppendingString:result];
    }
    return result;
}

-(NSString*) stringFromGrad:(NSArray*) gradArray
{
    NSString *result = @"";
    NSMutableArray *copyGrad = [gradArray mutableCopy];
    for(int i = 0; i < [gradArray count]; i++){
        if([copyGrad[i] isKindOfClass:[NSNumber class]]){
            result = [result stringByAppendingString:[copyGrad[i] stringValue]];
        } else if([copyGrad[i] isKindOfClass:[NSString class]]){
            result = [result stringByAppendingString:copyGrad[i]];
        }
        
    }
    return result;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(id) init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}
@end
