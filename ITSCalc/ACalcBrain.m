//
//  ACalcBrain.m
//  ACalcTry
//
//  Created by Serge Sychov on 07.01.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "ACalcBrain.h"
#import "math.h"

@interface ACalcBrain()
//@property (nonatomic, strong) NSArray *programStacks;
@property (nonatomic, strong) NSArray *arguStack;
@property (nonatomic, strong) NSDictionary *variableValue;
@property (nonatomic) int numberOfOpenBrackets;

-(id) countWithStack:(id) stack;
@end

@implementation ACalcBrain

-(NSArray*) arrayToSaveBrain
{
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    [saveArray addObject:[self.deepProgram copy]];
    [saveArray addObject:[self.deepArgu copy]];
    [saveArray addObject:[NSNumber numberWithInt:self.numberOfOpenBrackets]];
    [saveArray addObject:[NSNumber numberWithBool:self.isStronglyArgu]];
    [saveArray addObject:self.countAttributeStr];
    
    return [saveArray copy];
}

+(ACalcBrain*) brainFromSavedArray:(NSArray*)array
{
    NSMutableArray *extractedArray = [array mutableCopy];
    NSArray *prog = [[NSArray alloc] init];
    NSArray *arg = [[NSArray alloc] init];
    int numBracets = 0;
    BOOL isStrongArgu = YES;
    NSString *countAttrStr = @"NO";
    id top = [extractedArray lastObject];
    if(top && [top isKindOfClass:[NSString class]]){
        countAttrStr = top;
        [extractedArray removeLastObject];
        top = [extractedArray lastObject];
    } else {
        // NSLog(@"not String paremaeter at extracting");
    }
    
    if(top && [top isKindOfClass:[NSNumber class]]){
        isStrongArgu = [top boolValue];
        [extractedArray removeLastObject];
        top = [extractedArray lastObject];
    } else {
       // NSLog(@"not BOOL paremaeter at extracting");
    }
    
    if(top && [top isKindOfClass:[NSNumber class]]){
        numBracets = [top intValue];
        [extractedArray removeLastObject];
         top = [extractedArray lastObject];
    } else {
       // NSLog(@"not INT paremaeter at extracting");
    }
    
    if(top && [top isKindOfClass:[NSArray class]]){
        arg = top;
        [extractedArray removeLastObject];
         top = [extractedArray lastObject];
    } else {
        //NSLog(@"not Array paremaeter at extracting");
    }
    
    if(top && [top isKindOfClass:[NSArray class]]){
        prog = top;
    } else {
        //NSLog(@"not Array paremaeter at extracting");
    }
    
    return [ACalcBrain initWithProgram:prog withArgu:arg withOpenBracets:numBracets andIsStrongluArgu:isStrongArgu countAttrStr:countAttrStr];
}

+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*) argu
{
    return [ACalcBrain initWithProgram:program withArgu:argu withOpenBracets:0 andIsStrongluArgu:YES countAttrStr:NO_COUNT_ATTR];
}

+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*)argu withOpenBracets:(int)openBracets andIsStrongluArgu:(BOOL)isStronglyArgu countAttrStr:(NSString*)countAttrStr
{
    //add from this
    //static ACalcBrain *newBrain = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
     ACalcBrain *newBrain = [[ACalcBrain alloc] init];
        // Do any other initialisation stuff here
    //});
    //to this
   // ACalcBrain *newBrain = [[ACalcBrain alloc ] init];
    
    newBrain.programStacks = program;
    newBrain.arguStack = argu;
    newBrain.isStronglyArgu = isStronglyArgu;
    newBrain.numberOfOpenBrackets = openBracets;
    newBrain.countAttributeStr = countAttrStr;
    
    return newBrain;
}

-(NSArray *) programStacks {
    if(!_programStacks){
        self.numberOfOpenBrackets = 0;
        NSArray *firstProgramStack = [[NSArray alloc] init];
        NSMutableArray *copyProg = [[NSMutableArray alloc] init];
        [copyProg addObject:firstProgramStack];
        _programStacks = [copyProg copy];
    }
    return _programStacks;
    
}

-(NSArray *) arguStack
{
    if(!_arguStack){
        _arguStack = [[NSArray alloc] init];
        
    }
    //NSLog(@"Argutack %@",_arguStack);
    return _arguStack;
}

-(NSDictionary *) variableValue
{
    if(!_variableValue){
        NSArray *keys = [NSArray arrayWithObjects:@"x",@"y",@"b", nil];
        NSNumber * value = [NSNumber numberWithDouble:1.00];
        NSArray *values = [NSArray arrayWithObjects:value, value, value, nil];
        _variableValue = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    }
    return _variableValue;
}

-(void) setIsStronglyArgu:(BOOL)isStronglyArgu
{
    _isStronglyArgu = isStronglyArgu;
}

-(void) setVariableValue:(NSArray *)values atKey:(NSArray *)keys
{
    NSDictionary * dictionaryOfValues = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    _variableValue = dictionaryOfValues;
}

-(BOOL) isOpenBracets
{
    return  self.numberOfOpenBrackets > 0? YES: NO;
}

-(int) openBracets
{
    return self.numberOfOpenBrackets;
}

-(void) setCountAttribute:(NSString*)attr{
    self.countAttributeStr = attr;
   // NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
   // [copyArgu addObject:attr];
   // self.arguStack = [copyArgu copy];
}

-(void) pushOperand:(id) operand
{
    /*
    if([operand isKindOfClass:[NSNumber class]]){
        NSLog(@"Push number class");
    } else if([operand isKindOfClass:[NSArray class]]){
        NSLog(@"Push array class");
    }else if([operand isKindOfClass:[NSString class]]){
        NSLog(@"Push string class");
    }
    */
    //available to piush operand only in argu stack
    //1. if insert operant to argu stack - stack need be cleared
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    [copyArgu removeAllObjects];

    if([operand isKindOfClass:[NSString class]]){
        if([operand isEqualToString:@"0."]){
            [copyArgu addObject:[NSNumber numberWithDouble:0.00]];
        } else if ([operand doubleValue] != 0.0){

            [copyArgu addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
        } else { //thin it's need for variables
            [copyArgu addObject:operand];
        }
    } else if([operand isKindOfClass:[NSNumber class]]){
        [copyArgu addObject:operand];
    } else if([operand isKindOfClass:[NSArray class]]){
        [copyArgu addObject:operand];
    } else if([operand isKindOfClass:[NSDictionary class]]){
        [copyArgu addObject:operand];
    }

    self.arguStack = [copyArgu copy];
    //NSLog(@"arguStack %@",self.arguStack);
}

-(id) performOperationInArgu:(id)operation
{
    NSInteger operationPriority;
    //NSLog(@"Operation %@",operation);
    //NSLog(@"self.arguStack before %@",self.arguStack);
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
   // NSString *stringOperation = (NSString*)operation;
    [copyArgu addObject:operation];
    self.arguStack = [copyArgu copy];
    //NSLog(@"brain argustack a: %@", self.arguStack);
    if([operation isKindOfClass:[NSString class]]){
        operationPriority = [ACalcBrain getPriorityOf:operation];
    } else {
        operationPriority = 3;
    }
    
    /*
    if([operation isKindOfClass:[NSString class]]){
        NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
        NSString *stringOperation = (NSString*)operation;
        [copyArgu addObject:stringOperation];
        self.arguStack = [copyArgu copy];
        operationPriority = [ACalcBrain getPriorityOf:stringOperation];
    } else if([operation isKindOfClass:[NSArray class]]){
        if([(NSArray*)operation count]==3 && [(NSArray*)operation[2] isKindOfClass:[NSNumber class]]){
            
        }
    }
    */
    //NSLog(@"performOperationInArgu self.argu %@", self.argu);
    
    return [ACalcBrain runProgram:self.argu usingVariableValue:self.variableValue withPriority:operationPriority withCountAttr:self.countAttributeStr];
        
}


-(id)perfomOperation: (NSString *)operation
{
    NSInteger operationPriority = [ACalcBrain getPriorityOf:operation];
    if(!self.isStronglyArgu){
        [self checkToExceptDoubleOperation]; //remove from stack last operation like @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"÷", @"×",@"-", @"+"
    } else {
        [self applyArgu];
    }
    //set result stack as new argument
    [self getResultAndPutAsArguByPriotiy:operationPriority];
    
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    [programCopy.lastObject addObject:operation];
    self.programStacks = [programCopy copy];
    
    return [ACalcBrain runProgram:self.program usingVariableValue:self.variableValue withPriority:operationPriority withCountAttr:self.countAttributeStr];
}

-(id) argu
{
    NSArray *arguCopy = [ACalcBrain deepArrayCopy:self.arguStack];
    return arguCopy;
}


-(void) clearArgu
{
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    [copyArgu removeAllObjects];
    self.arguStack = [copyArgu copy];
    //NSLog(@"self.arguStack from clear argu %@", self.arguStack);
}

-(void) pushArguForPerCent
{
    NSMutableArray *currentStack = [ACalcBrain deepArrayCopy:self.program];
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    id topOfStack = [currentStack lastObject];
    if(topOfStack && [topOfStack isKindOfClass:[NSString class]] && ([ACalcBrain getPriorityOf:topOfStack] == 0)){
        [currentStack removeLastObject];
        [copyArgu addObject:currentStack];
    } else {
        NSArray * arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1.0], nil];
        [copyArgu addObject:arr];
    }
    self.arguStack = [copyArgu copy];
}

//check @"∓" or @"¹/x" for exepting double the same operation
-(id) checkMinusOrDivideOperationOnDubble:(NSString*)operand
{
    id result;
    
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    id lastObjInArgStack = [copyArgu lastObject];
    if([lastObjInArgStack isKindOfClass:[NSString class]] && [lastObjInArgStack isEqualToString:operand]){
        [copyArgu removeLastObject];
        result =  [ACalcBrain runProgram:copyArgu usingVariableValue:self.variableValue withCountAttr:self.countAttributeStr];
    } else {
        [copyArgu addObject:operand];
        NSInteger operationPriority = [ACalcBrain getPriorityOf:operand];
        result = [ACalcBrain runProgram:copyArgu usingVariableValue:self.variableValue withPriority:operationPriority withCountAttr:self.countAttributeStr];
    }
    self.arguStack = [copyArgu copy];
    return result;
}

-(BOOL) deleteLastElement
{
    NSArray *operations = [NSArray arrayWithObjects:@"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", @"÷", @"×",@"-",@"+", nil];
    
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    NSMutableArray *copyPogram = [ACalcBrain deepArrayCopy:self.programStacks];
    
    if(self.isStronglyArgu && ([copyArgu count] >0)){
        
        id topOfArguStack = [copyArgu lastObject];
        if(topOfArguStack){
           
            if([topOfArguStack isKindOfClass:[NSArray class]]){
                if([(NSArray*)topOfArguStack count]==4 && [topOfArguStack[0] isKindOfClass:[NSString class]]&&[topOfArguStack[0] isEqualToString:@"$"]){
                    id last = [copyArgu lastObject];
                    [copyArgu removeLastObject];
                    self.arguStack = [copyArgu copy];
                    if([last isKindOfClass:[NSNumber class]]){
                        self.isStronglyArgu = NO;
                    } else {
                        
                        self.isStronglyArgu = YES;
                    }
                } else {
                    [copyArgu removeLastObject];
                
                    //divide array in argu on prog and argu
                    id topOfinnerArray = [topOfArguStack lastObject];
                    NSMutableArray * newArguStack = [[NSMutableArray alloc] init];
                    while(topOfinnerArray){
                        if([topOfinnerArray isKindOfClass:[NSString class]] && [operations containsObject:topOfinnerArray]){
                            break;
                        } else {
                            [topOfArguStack removeLastObject];
                            [newArguStack insertObject:topOfinnerArray atIndex:0];
                            topOfinnerArray = [topOfArguStack lastObject];
                        }
                    }
                
                    NSArray *testLasObjProg = [copyPogram.lastObject copy];
                    //check if last obj in prog is empty set as last obj
                    if([testLasObjProg count] == 0) {
                        [copyPogram removeLastObject];
                    } else {
                        self.numberOfOpenBrackets +=1;
                    }
                    //in other case set as new program array
                    [copyPogram addObject: topOfArguStack];
                    //set rest as new argu
                    copyArgu = newArguStack;
                
                    self.arguStack = [copyArgu copy];
                    self.programStacks = [copyPogram copy];
                    self.isStronglyArgu = YES;
                }
                
            } else {
                id last = [copyArgu lastObject];
                [copyArgu removeLastObject];
                self.arguStack = [copyArgu copy];
                if([last isKindOfClass:[NSNumber class]]){
                    self.isStronglyArgu = NO;
                } else {
               
                    self.isStronglyArgu = YES;
                }
               // }

            }
        }
    
    } else {
        
        if([copyArgu count] > 0) [copyArgu removeAllObjects];
        /* WAS
        id topOfProgStack = [copyPogram.lastObject lastObject];
        if(topOfProgStack){
         */
        id topOfProgStack = [copyPogram lastObject];
        if(topOfProgStack && [topOfProgStack isKindOfClass:[NSArray class]]&&([copyPogram count] >0) ){
            [copyPogram.lastObject removeLastObject];
            
            //chek next object and if its not operation set it as argu
            topOfProgStack = [copyPogram.lastObject lastObject];
            if(topOfProgStack){
                if([topOfProgStack isKindOfClass:[NSString class]] && [operations containsObject:topOfProgStack]){
                    self.isStronglyArgu = NO;
                } else {
                    [copyPogram.lastObject removeLastObject];
                    [copyArgu addObject:topOfProgStack];
                    self.isStronglyArgu = YES;
                }
            } else {
                if([copyPogram count] > 1){
                    [copyPogram removeLastObject];
                }
                self.isStronglyArgu = YES;
            }
        } else {
            if([copyPogram count] > 1){
                [copyPogram removeLastObject];
                if(self.numberOfOpenBrackets > 1){
                    self.numberOfOpenBrackets -=1;
                    
                }
                self.isStronglyArgu = NO;
            } else {
                self.isStronglyArgu = YES;
            }
            
        }
        self.arguStack = [copyArgu copy];
        self.programStacks = [copyPogram copy];

    }

    
    return  self.isStronglyArgu;
}

#pragma mark _HELPED FUNCTIOS___________________________________________________
+(NSString*) resultStringFromCountResult:(id) countResult{
    NSString *resultString = @" ";
    if(countResult && [countResult isKindOfClass:[NSNumber class]]){
        resultString = [ACalcBrain resultStringFromNumber:countResult];
    } else if(countResult && [countResult isKindOfClass:[NSArray class]] && [countResult containsObject:@"°"]){ //if it's grad array
        resultString = [ACalcBrain resultStringFromGradArray:countResult];
    }else if (countResult && [countResult isKindOfClass:[NSString class]]){
        resultString = countResult;
    }  else {
        //NSLog(@"ViewController getAttributedStringFromArray: result not number and not string");
        resultString = @" ";
    }
    return resultString;
}

+(NSString*)resultStringFromNumber:(NSNumber*)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setExponentSymbol:@"e"];
    [numberFormatter setZeroSymbol:@"0"];
    if (fabs([number doubleValue])>9e9 || fabs([number doubleValue])<9e-9) {
        [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        [numberFormatter setMaximumFractionDigits:7];
    }else{
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        double intPartLenght = log10(fabs([number doubleValue]));
        double intPart;//fractPart,
        modf(intPartLenght, &intPart);// fractPart =
        if(intPart <0) intPart = 0;
        [numberFormatter setMaximumFractionDigits:(9 - (int)intPart)];
    }
    return  [@" = " stringByAppendingString:[numberFormatter stringFromNumber:number]];
}

+(NSString*)resultStringFromGradArray:(NSArray*)countResult{
    NSString *resultString = @"";
    BOOL isNegativeNumber = NO;
    for(int i = 0; i < [(NSArray*)countResult count]; i++){
        if([countResult[i] isKindOfClass:[NSNumber class]]){
            if([countResult[i] compare:@0] == NSOrderedAscending) isNegativeNumber = YES;
            NSInteger intNumber = ABS([countResult[i] intValue]);
            
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%li",(long)intNumber]];
        } else if([countResult[i] isKindOfClass:[NSString class]]){
            resultString = [resultString stringByAppendingString:countResult[i]];
        }
    }
    
    if(isNegativeNumber) resultString = [@"-" stringByAppendingString:resultString];
    return [@" = " stringByAppendingString:resultString];
}

+(double)setPrecission:(double)prec toValue:(double)value {
    double precTen = pow(10, prec);    
    return round(value*precTen)/precTen;
}

+(NSArray*)gradArrayFromNumber:(NSNumber*)number withCountAttr:(NSString*)countAttr{
    NSMutableArray *resultGradArray = [[NSMutableArray alloc] init];
    double resultDouble = [number doubleValue];
    if(resultDouble<0) [resultGradArray addObject:@"-"];
    resultDouble = fabs(resultDouble);
    if([countAttr isEqualToString:RAD]){
        resultDouble = resultDouble * 180 / M_PI;
    }
    NSInteger wholeValue = round(resultDouble*3600);
    
    NSInteger grad = (wholeValue/3600)%360;
    [resultGradArray addObject:[NSNumber numberWithInteger:grad]];
    [resultGradArray addObject:@"°"];
    
    NSInteger restValue = wholeValue%3600;
    
    NSInteger minutes = restValue/60;
    [resultGradArray addObject:[NSNumber numberWithInteger:minutes]];
    [resultGradArray addObject:@"′"];
    
    NSInteger seconds =restValue%60;
    [resultGradArray addObject:[NSNumber numberWithInteger:seconds]];
    [resultGradArray addObject:@"″"];
    
    return [resultGradArray copy];
}

+(double) factorial: (double)n
{
    if(n < 0) {
        return NAN;
    } else {
        if(n > 200.) n = 200;
        return (n==0 ? 1 : n*[ACalcBrain factorial:(n-1)]);
    }
}

+(NSInteger) getPriorityOf:(NSString*) operand;
{
    NSInteger priority = 3;
    NSArray *zeroPriorityOperands = [NSArray arrayWithObjects:@"+",@"-", nil];
    NSArray *onePriorityOperands = [NSArray arrayWithObjects:@"÷", @"×", nil];
    NSArray *twoPriorityOperands = [NSArray arrayWithObjects:@"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", nil];
    if([zeroPriorityOperands containsObject:operand]){
        priority =0;
    } else if([onePriorityOperands containsObject:operand]){
        priority = 1;
    } else if([twoPriorityOperands containsObject:operand]){
        priority = 2;
    }
    return priority;
}


+(id) deepArrayCopy:(NSArray*) arrayToCopy
{
    NSMutableArray * deepCopy = [[NSMutableArray alloc] init];
    for(int i = 0; i < [arrayToCopy count]; i++){
        if([arrayToCopy[i] isKindOfClass:[NSArray class]]){
            //NSMutableArray * subArray = [[NSMutableArray alloc] init];
           // subArray = [ACalcBrain deepArrayCopy:arrayToCopy[i]];
           // [deepCopy addObject:subArray];
            [deepCopy addObject:[ACalcBrain deepArrayCopy:arrayToCopy[i]]];
        } else {
            [deepCopy addObject:[arrayToCopy[i] copy]];
        }
    }
    return deepCopy;
}
#pragma MARK CHECK AND STRING FUNCTION
+(NSArray*) checkForFunctionsInProgramm:(NSArray*)programm{
    NSArray* functionsArray = nil;

    NSMutableArray *mutableFunctionsArray = [[NSMutableArray alloc]init];
    for(id obj in programm){
        if([obj isKindOfClass:[NSDictionary class]]){
            
            NSString *key = [[obj allKeys]firstObject];
            id valueProg = [obj objectForKey:key];
            
            if([valueProg isKindOfClass:[NSNumber class]]){//if there is conctant
                [mutableFunctionsArray addObject:obj];
            } else if ([valueProg isKindOfClass:[NSArray class]]){
                if([valueProg containsObject:@"°"]){
                   //do nothing
                } else {
                     [mutableFunctionsArray addObject:obj];
                }
            }
        }else if([obj isKindOfClass:[NSArray class]]){
                if([ACalcBrain checkForFunctionsInProgramm:obj]){
                    [mutableFunctionsArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:obj]];
                }
        }
    }
    //if there is functions or constants
    if([mutableFunctionsArray lastObject]) functionsArray = [mutableFunctionsArray copy];
    
    return functionsArray;
}

+(NSAttributedString*)stringFunctionInProgram:(NSArray*)programm withAtrtributes:(NSDictionary*)atrbutes{
    NSAttributedString *returnString = nil;
    
    //if programm has currensies, get currencies array
    NSArray* functions = [ACalcBrain checkForFunctionsInProgramm:[programm copy]];
    
    //if currensies was, make string from each pair in array and add to currString
    if(functions){
        NSMutableAttributedString* descriptions = [[NSMutableAttributedString alloc] initWithString:@"" attributes:atrbutes];


        for(NSDictionary* func in functions){
            NSAttributedString * name = [[NSAttributedString alloc] initWithString:[[func allKeys]firstObject] attributes:atrbutes];
            [descriptions insertAttributedString:name atIndex:[descriptions length]];
            NSAttributedString * equalMark = [[NSAttributedString alloc] initWithString:@"=" attributes:atrbutes];
            [descriptions insertAttributedString:equalMark atIndex:[descriptions length]];
            NSAttributedString* description = [ACalcBrain descriptionOfProgram:[func objectForKey:[[func allKeys] firstObject]] withAttributes:atrbutes];
            [descriptions insertAttributedString:description atIndex:[descriptions length]];
            NSAttributedString * space = [[NSAttributedString alloc] initWithString:@"; " attributes:atrbutes];
            [descriptions insertAttributedString:space atIndex:[descriptions length]];

        }
       if([descriptions length]>0) returnString = [descriptions copy];
    }

    
    return returnString;
}

+(NSSet*) chekForVariablesInProgramm:(NSArray*)programm {
    
    NSMutableSet* variableSet = [[NSMutableSet alloc]init];

    for(id obj in programm){

        if([obj isKindOfClass:[NSArray class]]){
            if([ACalcBrain chekForVariablesInProgramm:obj]){
                [variableSet unionSet:[ACalcBrain chekForVariablesInProgramm:obj]];
            }
        } else if ([obj isKindOfClass:[NSString class]] && ([obj isEqualToString:@"x"] || [obj isEqualToString:@"y"])){
            [variableSet addObject:obj];
        }

    }

    return [variableSet copy];
}

+(NSAttributedString*)stringVariableInProgram:(NSArray*)programm withAtrtributes:(NSDictionary*)atrbutes{
    NSAttributedString *returnString = nil;
    
    //if programm has currensies, get currencies array
    NSSet* variables = [ACalcBrain chekForVariablesInProgramm:[programm copy]];
    
    //if currensies was, make string from each pair in array and add to currString
    if([variables count]>0){
        NSString *varStr = @"";
        for(NSString* var in variables){
            varStr = [varStr stringByAppendingString:[var capitalizedString]];
            varStr = [varStr stringByAppendingString:@"=1. "];

        }
        returnString = [[NSAttributedString alloc] initWithString:varStr attributes:atrbutes];
    }
    return returnString;
}


//check if programm has currencies array take it ans return currensies arrays:USD/EUR/Value othercase retun nil
+(NSArray*) chekForCurrensiesProgramm:(NSArray*)programm {

    NSArray* currenciesArray = nil;
    NSMutableArray *mutableCurrenciesArray = [[NSMutableArray alloc]init];
    for(id obj in programm){
        if([obj isKindOfClass:[NSArray class]]){
            
            if([[obj firstObject] isKindOfClass:[NSString class]] && [[obj firstObject] isEqualToString:@"$"]){
                
                [mutableCurrenciesArray addObject:obj];
            } else {
                if([ACalcBrain chekForCurrensiesProgramm:obj]){
                    [mutableCurrenciesArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:obj]];
                }
            }
        }
    }
    //if there is currencies
    if([mutableCurrenciesArray lastObject]) currenciesArray = [mutableCurrenciesArray copy];
    
    /*
    @autoreleasepool {
        NSMutableArray *mutableProgramm = [programm mutableCopy];

        NSMutableArray *mutableCurrenciesArray = [[NSMutableArray alloc]init];
        id top = [mutableProgramm lastObject];
        while(top) {
            [mutableProgramm removeLastObject];
        

            if([top isKindOfClass:[NSArray class]]){
           
                if([[top firstObject] isKindOfClass:[NSString class]] && [[top firstObject] isEqualToString:@"$"]){
                    
                    [mutableCurrenciesArray addObject:top];
                } else {
                    [mutableCurrenciesArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:top]];
                }
            }
            [mutableCurrenciesArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:[mutableProgramm copy]]];
       
            top = [mutableProgramm lastObject];
            if([mutableCurrenciesArray lastObject]) currenciesArray = [mutableCurrenciesArray copy];
        }
    }
    */

    return currenciesArray;
}

+(NSAttributedString*)stringCurrensiesInProgram:(NSArray*)programm withAtrtributes:(NSDictionary*)atrbutes{
    NSAttributedString *returnString = nil;
    
    //if programm has currensies, get currencies array
    NSArray* currensies = [ACalcBrain chekForCurrensiesProgramm:[programm copy]];

    //if currensies was, make string from each pair in array and add to currString
    if(currensies){
        NSString *currStr = @"";
        for(NSArray* currPair in currensies){
            currStr = [currStr stringByAppendingString:currPair[1]];
            currStr = [currStr stringByAppendingString:@"/"];
            currStr = [currStr stringByAppendingString:currPair[2]];
            currStr = [currStr stringByAppendingString:@"="];
            currStr = [currStr stringByAppendingString:[currPair[3] stringValue]];
            currStr = [currStr stringByAppendingString:@" "];
        }
        returnString = [[NSAttributedString alloc] initWithString:currStr attributes:atrbutes];
    }
    
    return returnString;
}

//replace arrays with currencies in program with new values of currencies exhange
//for each element chek if array
// if - currencies - replace, else - recrucive call
+(NSArray*) programm:(NSArray*)programm withReplaceWithCurrencies:(NSArray*)currensies{

    NSArray *retProgramm = nil;
    NSMutableArray *mutableProgramm = [programm mutableCopy];
    if(currensies ) {
        @autoreleasepool {

            for(NSInteger i = 0; i < mutableProgramm.count; i++){
                id obj = [mutableProgramm objectAtIndex:i];

                if([obj isKindOfClass:[NSArray class]]){

                    if([[obj firstObject] isKindOfClass:[NSString class]] && [[obj firstObject] isEqualToString:@"$"]){
                        
                        for(NSArray* currPair in currensies){ //check for each exchange pair
                            if([(NSString*)obj[1] isEqualToString:(NSString*)currPair[1]] && [(NSString*)obj[2] isEqualToString:(NSString*)currPair[2]] ){
                                [mutableProgramm replaceObjectAtIndex:i withObject:currPair];
                            }
                        }

                    } else {
                        [mutableProgramm replaceObjectAtIndex:i withObject:[ACalcBrain programm:obj withReplaceWithCurrencies:currensies]];
                    }
                } else {

                }
            }
            retProgramm = [mutableProgramm copy];
        }
    
    }
  
    return retProgramm;
}

+(BOOL) needBractesForStack: (NSMutableArray*) stack SymbYesArray: (NSArray*) plusOrMinuslySymbols SymbNOArray: (NSArray*)divideOrMultiplySymbols
{
    BOOL result = NO;
    NSMutableArray *workStack = [stack mutableCopy];
    id lastObject = [workStack lastObject];
    while (lastObject){
        if([lastObject isKindOfClass:[NSString class]]){
            if([plusOrMinuslySymbols containsObject:lastObject]) {
                result = YES;
                break;
            } else if([divideOrMultiplySymbols containsObject:lastObject]){
                result = NO;
                break;
            }
        }
        [workStack removeLastObject];
        lastObject = [workStack lastObject];
    }
    
    return  result;
}

+(NSMutableArray*) getNextArguInStack:(NSMutableArray*) stack accordingOperation:(NSArray*) operations
{
    NSMutableArray *arguArray = [[NSMutableArray alloc] init];
    NSMutableArray *backwardArguArray = [[NSMutableArray alloc] init];
    id nexTopOfStack = [stack lastObject];
    while (nexTopOfStack) {
        if([nexTopOfStack isKindOfClass:[NSString class]] && [operations containsObject:nexTopOfStack]){
            break;
        } else {
            [stack removeLastObject];
            [backwardArguArray addObject:nexTopOfStack];
            nexTopOfStack = [stack lastObject];
        }
    }
    
    id objFromBackwardArguArray = [backwardArguArray lastObject];
    while (objFromBackwardArguArray) {
        [arguArray addObject:objFromBackwardArguArray];
        [backwardArguArray removeLastObject];
        objFromBackwardArguArray = [backwardArguArray lastObject];
    }

    return arguArray;
}
#pragma mark _END_HELPED_FUNCTIONS_____________________________________________________

//open bracket makes new stack and add is as last obj to programStack, at close bracket remove this stack and added in previous stack like obj
-(void) insertBracket:(BOOL)isRigthOpen
{
    if(isRigthOpen){
        NSMutableArray *nextStack = [[NSMutableArray alloc] init];
        NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
        [programCopy addObject:nextStack];
        self.programStacks = [programCopy copy];
        [self clearArgu];
        self.numberOfOpenBrackets +=1;
    } else {
        if(self.numberOfOpenBrackets >0){
            self.numberOfOpenBrackets -=1;
        }
    }
}


-(void) clearOperation
{
    //fistly - clear arguments substack
    //second - dealloc arguments stav
    
    //add something to set history
    //and dealocc progrma stck
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    [copyArgu removeAllObjects];
    self.arguStack = [copyArgu copy];
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    [programCopy removeAllObjects];
    NSArray* newLast = [[NSArray alloc] init];
    [programCopy addObject:newLast];
    self.programStacks = [programCopy copy];
    self.countAttributeStr = NO_COUNT_ATTR;
}

//to exeprt double operation
-(void) checkToExceptDoubleOperation
{
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    NSArray * checkingArray = [NSArray arrayWithObjects:   @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"÷", @"×",@"-", @"+", nil];
    id lastObjInStack = [programCopy.lastObject lastObject];
    if(lastObjInStack){
        if([lastObjInStack isKindOfClass:[NSString class]] && [checkingArray containsObject:lastObjInStack]){
            [programCopy.lastObject removeLastObject];
        }
    }
    self.programStacks = [programCopy copy];
}

-(void) applyArgu
{
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    for(int i = 0; i < [copyArgu count]; i++){
        [programCopy.lastObject addObject:copyArgu[i]];
    }
    self.programStacks = [programCopy copy];
    self.arguStack = [copyArgu copy];
}


-(void) getResultAndPutAsArguByPriotiy:(NSInteger)priority
{
    [self clearArgu];
    
    NSMutableArray *newSubStackBackward = [[NSMutableArray alloc] init];
    NSMutableArray *newSubStack = [[NSMutableArray alloc] init];
    //was
    //NSMutableArray *copyCurrentStack = [self.program mutableCopy];
    NSMutableArray *copyCurrentStack = [[ACalcBrain deepArrayCopy:self.program] mutableCopy];
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    
    id lastObject = [copyCurrentStack lastObject];
    while (lastObject){
        if([lastObject isKindOfClass:[NSString class]] && ([ACalcBrain getPriorityOf:lastObject] < priority)) break;
        [copyCurrentStack removeLastObject];
        [newSubStackBackward addObject:lastObject];
        lastObject = [copyCurrentStack lastObject];
    }
    NSArray * testArray = [newSubStackBackward copy];
    NSUInteger lenghtNewStack = [testArray count];
    if(lenghtNewStack > 1){
        for(int i = 0; i < lenghtNewStack; i ++){
            [newSubStack addObject:[newSubStackBackward lastObject]];
            [newSubStackBackward removeLastObject];
        }
        [copyArgu addObject:newSubStack];
    } else if (lenghtNewStack == 1){
        [copyArgu addObject:[newSubStackBackward lastObject]];
    } else {
        [copyArgu addObject:[NSNumber numberWithDouble:0.0]];
    }
    self.arguStack = [copyArgu copy];
}


-(id) program
{
    NSArray *programCopy = [ACalcBrain deepArrayCopy:[self.programStacks lastObject]];
    return programCopy;
}


-(id) wholeProgram
{
    NSMutableArray *argArrayCopy = [ACalcBrain deepArrayCopy:self.argu];
    NSMutableArray *wholeProgramCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    id topOfArgArray = [argArrayCopy lastObject];
    //add arg as stack but not add argu as stack if it isn't strong argu
    if( topOfArgArray && [topOfArgArray isKindOfClass:[NSArray class]]){
        id topOfWhlPrgLastObj = [wholeProgramCopy lastObject];
        if([topOfWhlPrgLastObj lastObject]){
            if(self.isStronglyArgu){
                [wholeProgramCopy.lastObject addObject:topOfArgArray];
            }
        } else {
            for(id stc in topOfArgArray){
                [wholeProgramCopy.lastObject addObject:stc];
            }
        }
        
    } else if(([argArrayCopy count] > 0) && self.isStronglyArgu){
        // for(id stc in argArrayCopy){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
        //   [wholeProgramCopy.lastObject addObject:[stc mutableCopy]];
        //}
    } else if([argArrayCopy count] > 1){
        [wholeProgramCopy.lastObject addObjectsFromArray:argArrayCopy];
    }
    return wholeProgramCopy;
}
#pragma mark COUNT

-(id) count //possible return number value or grad array
{
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    [self applyArgu];
    //set result stack as new argument
    [self getResultAndPutAsArguByPriotiy:0];
    
    //IMPORTANT get only id no NSNumber
    id result =[self countWithStack:self.program];
    if([self.programStacks count] > 1){
        [programCopy removeLastObject];
    } else {
        [programCopy.lastObject removeAllObjects];
    }
    self.programStacks = [programCopy copy];
    
    return result;
}

-(id) countWithStack:(id) stack //possible return number value or grad array
{
    return [ACalcBrain runProgram:stack usingVariableValue:self.variableValue withCountAttr:self.countAttributeStr];
}


#pragma mark RUN PROGRAN

//keys return dictionary
#define NEED_SHOW_GRAD_KEY @"NedShowGrad"
#define VALUE @"Result"
//define if it's need to show Grad
#define POSSIBLE_TO_SHOW_GRAD @"PossibleToShgowGrad"
#define NOT_SHOW_GRAD @"NotShowGrad"
#define SHOW_GRAD @"ShowGrad"


+(id)runProgram:(id)program withCountAttr:(NSString*)attrStr //possible return number value or grad array
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
         stack = [ACalcBrain deepArrayCopy:program];
    }
    NSDictionary* dicRes = [ACalcBrain popOperandOfStack:stack withCountAttr:attrStr];
    if([[dicRes valueForKey:NEED_SHOW_GRAD_KEY] isEqualToString:SHOW_GRAD]){
        return [ACalcBrain gradArrayFromNumber:[dicRes valueForKey:VALUE] withCountAttr:attrStr];
    } else {
        return [dicRes valueForKey:VALUE];
    }
}

+(id)runProgram:(id)program usingVariableValue:(NSDictionary *)variableValues withCountAttr:(NSString*)attrStr
{
    return [self runProgram:program usingVariableValue:variableValues withPriority:0 withCountAttr:attrStr];
}

+(id) runProgram:(id)program usingVariableValue:(NSDictionary *)variableValues withPriority:(NSInteger)priority withCountAttr:(NSString*)attrStr
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [[ACalcBrain deepArrayCopy:program] mutableCopy];
    }

   // NSLog(@"runProgram stack %@", stack);
    stack = [ACalcBrain arrayFromArray:stack WithValueFromVariabledictionary:variableValues];
    // NSLog(@"runProgram second stack %@", stack);
    NSDictionary* dicRes = [ACalcBrain popOperandOfStack:stack accordingPriority:priority withCountAttr:attrStr];
    
    if([[dicRes valueForKey:NEED_SHOW_GRAD_KEY] isEqualToString:SHOW_GRAD]){
        return [ACalcBrain gradArrayFromNumber:[dicRes valueForKey:VALUE] withCountAttr:attrStr];
    } else {
        return [dicRes valueForKey:VALUE];
    }
}

+(NSMutableArray*) arrayFromArray:(NSMutableArray*)stack WithValueFromVariabledictionary:(NSDictionary*)vaiableValues
{
    NSMutableArray *workArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSArray *variablesArray = [vaiableValues allKeys];

        for(id obj in stack){
            if([obj isKindOfClass:[NSArray class]]){
                [workArray addObject:[self arrayFromArray:obj WithValueFromVariabledictionary:vaiableValues]];
            } else if ([variablesArray containsObject:obj]){
                [workArray addObject:[vaiableValues objectForKey:obj]];
            }else {
                [workArray addObject:obj];
            }
        }

    }

    return workArray;
}
#pragma mark POP OPERAND

+(NSDictionary*) popOperandOfStack:(NSMutableArray*)stack withCountAttr:(NSString*)attrStr //return
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0 withCountAttr:attrStr];
}

+(NSDictionary*) popOperandOfStack:(NSMutableArray*)stack accordingPriority:(NSInteger)priority withCountAttr:(NSString*)attrStr
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:priority withCountAttr:attrStr];
}

+(NSDictionary*) popOperandOfStack: (NSMutableArray*) stack withPreviousValue: (NSNumber*) value accordingPriority: (NSInteger) priority withCountAttr:(NSString*)attrStr
{
    double result = 0.0;
    NSString* showGrad = POSSIBLE_TO_SHOW_GRAD;
    NSDictionary* dicResult;
    id topOfStack = [stack lastObject];

    if(topOfStack){
        [stack removeLastObject];
        
    } else if (value){
        result = [value doubleValue];
    }
    if([topOfStack isKindOfClass:[NSDictionary class]]){
        //if it is constant or function
        //NSLog(@"there is constant or function in popOperandOfStack");
        NSString *key = [[topOfStack allKeys]firstObject];
        //NSLog(@"keyTitle: %@",key);
        id valueProg = [topOfStack objectForKey:key];
        if([valueProg isKindOfClass:[NSNumber class]]){//if there is conctant
            dicResult = [self popOperandOfStack:stack withPreviousValue:valueProg accordingPriority:priority withCountAttr:attrStr];
            result = [[dicResult valueForKey:VALUE] doubleValue];
            showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
        } else if ([valueProg isKindOfClass:[NSArray class]]){
            if([valueProg containsObject:@"°"]){
                NSDictionary *arguDict = [self popOperandOfStack:topOfStack withCountAttr:attrStr];
                NSString *arguShowGrad = [arguDict valueForKey:NEED_SHOW_GRAD_KEY];
                
                dicResult = [self popOperandOfStack:stack withPreviousValue:[[self popOperandOfStack:[valueProg mutableCopy]withCountAttr:attrStr] valueForKey:VALUE] accordingPriority:priority withCountAttr:attrStr];
                result =  [[dicResult valueForKey:VALUE] doubleValue];
                
                NSString *progShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                if([progShowGrad isEqualToString:NOT_SHOW_GRAD]|| [arguShowGrad isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = NOT_SHOW_GRAD;
                } else if ([progShowGrad isEqualToString:SHOW_GRAD]|| [arguShowGrad isEqualToString:SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                } else {
                    showGrad = POSSIBLE_TO_SHOW_GRAD;
                }

            } else {
                NSLog(@"valueProg %@", valueProg);
            }
        }
    }else if([topOfStack isKindOfClass:[NSArray class]]){
        
        
        if([(NSArray*)topOfStack count]==4 && [topOfStack[0] isKindOfClass:[NSString class]]&&[topOfStack[0] isEqualToString:@"$"]){
            //if there is exhange currency rate
            NSNumber *exchangeRate = (NSNumber*)[topOfStack lastObject];
            dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
            double arg = [[dicResult valueForKeyPath:VALUE] doubleValue];
            if(arg == 0.0) {
                dicResult = [self popOperandOfStack:stack withPreviousValue:exchangeRate accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKeyPath:VALUE] doubleValue];
            } else {
                double exchangeRateDouble = [exchangeRate doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * exchangeRateDouble)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKeyPath:VALUE] doubleValue];
            }
            NSString *resStr = [NSString stringWithFormat:@"%.2f",result];
            result = [resStr doubleValue];
            showGrad = NOT_SHOW_GRAD;
        } else {
            NSDictionary *arguDict = [self popOperandOfStack:topOfStack withCountAttr:attrStr];
            NSString *arguShowGrad = [arguDict valueForKey:NEED_SHOW_GRAD_KEY];
            
            dicResult = [self popOperandOfStack:stack withPreviousValue:[arguDict valueForKey:VALUE] accordingPriority:priority withCountAttr:attrStr];
            result = [[dicResult valueForKeyPath:VALUE] doubleValue];
            
            NSString *progShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            if([progShowGrad isEqualToString:NOT_SHOW_GRAD]|| [arguShowGrad isEqualToString:NOT_SHOW_GRAD]){
                showGrad = NOT_SHOW_GRAD;
            } else if ([progShowGrad isEqualToString:SHOW_GRAD]|| [arguShowGrad isEqualToString:SHOW_GRAD]){
                showGrad = SHOW_GRAD;
            } else {
                showGrad = POSSIBLE_TO_SHOW_GRAD;
            }
        }
    } else if([topOfStack isKindOfClass:[NSNumber class]]){
        dicResult = [self popOperandOfStack:stack withPreviousValue:topOfStack accordingPriority:priority withCountAttr:attrStr];
        result = [[dicResult valueForKey:VALUE] doubleValue];
        showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
    } else if([topOfStack isKindOfClass:[NSString class]]){
        
        NSString * operation = topOfStack;
        NSInteger operationPriority = [ACalcBrain getPriorityOf:operation];
        if(priority > operationPriority){
            if(value) result = [value doubleValue];
            //think if topOfstack dosn't use put it back to stack for next operation
            [stack addObject:topOfStack];
        } else {
            /*if([operation isEqualToString:@"X"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
               // NSNumber *valueOfVariable = [self.varia]
                if(arg == 0.0) {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_E] accordingPriority:priority];
                } else {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_E)] accordingPriority:priority];
                }
                
            } else */if([operation isEqualToString:@"e"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(arg == 0.0) {
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_E] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_E)] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                }
                showGrad = NOT_SHOW_GRAD;
                
            } else if([operation isEqualToString:@"π"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                NSString *arguShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                if(arg == 0.0) {
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_PI] accordingPriority:priority withCountAttr:attrStr];
                     result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_PI)] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                }
                NSString *progShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                if([progShowGrad isEqualToString:NOT_SHOW_GRAD]|| [arguShowGrad isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = NOT_SHOW_GRAD;
                } else if ([progShowGrad isEqualToString:SHOW_GRAD]|| [arguShowGrad isEqualToString:SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                } else {
                    showGrad = POSSIBLE_TO_SHOW_GRAD;
                }
            } else if ([operation isEqualToString:@"∓"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * -1.0)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            } else if ([operation isEqualToString:@"¹/x"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1/arg] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"x!"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                //make something toi exept not integer number
                arg = trunc(arg);
                double fac = [self factorial:arg];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:fac] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"x²"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,2)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"x³"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,3)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            }  else if ([operation isEqualToString:@"2ˣ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(2,arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"eˣ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(M_E,arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"10ˣ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(10.,arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"√x"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sqrt(arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"³√x"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cbrt(arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"lg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult= [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log10(arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"log₂"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log2(arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"ln"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg)] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"xʸ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,[value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"yˣ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],arg)] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"ʸ√x"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,1 / [value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"ˣ√y"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],1 / arg)] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"logʸ"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg) / log([value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"√x²+y²"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:hypot(arg,[value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result= [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad = NOT_SHOW_GRAD;
            } else if([operation isEqualToString:SHOW_GRAD_RESULT]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                if([[dicResult valueForKey:NEED_SHOW_GRAD_KEY] isEqualToString:POSSIBLE_TO_SHOW_GRAD]|| [[dicResult valueForKey:NEED_SHOW_GRAD_KEY] isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                } else {
                    showGrad = NOT_SHOW_GRAD;
                }
            } else if ([operation isEqualToString:@"D"] || [operation isEqualToString:@"R"]){
                double arg = 0;
                id nexTopOfStack = [stack lastObject];
                while (nexTopOfStack) {
                    [stack removeLastObject];
                    BOOL isNegativeNumber = NO;
                    if([nexTopOfStack isKindOfClass:[NSString class]]){
                        if([nexTopOfStack isEqualToString:@"-"]){
                            isNegativeNumber = YES;
                        } else if([nexTopOfStack isEqualToString:@"″"]){
                            nexTopOfStack = [stack lastObject];
                            if(nexTopOfStack && [nexTopOfStack isKindOfClass:[NSNumber class]]){
                                [stack removeLastObject];
                                arg += [nexTopOfStack doubleValue] / 3600.;
                            } else {
                                arg += 0;
                            }
                            
                        } else if([nexTopOfStack isEqualToString:@"′"]){
                            nexTopOfStack = [stack lastObject];
                            if(nexTopOfStack && [nexTopOfStack isKindOfClass:[NSNumber class]]){
                                [stack removeLastObject];
                                arg += [nexTopOfStack doubleValue] / 60.;
                            } else {
                                arg += 0;
                            }
                            
                        } else if([nexTopOfStack isEqualToString:@"°"]){
                            nexTopOfStack = [stack lastObject];
                            if(nexTopOfStack && [nexTopOfStack isKindOfClass:[NSNumber class]]){
                                [stack removeLastObject];
                                //if([nexTopOfStack doubleValue]<0) isNegativeNumber = YES;
                                arg += fabs([nexTopOfStack doubleValue]);
                            } else {
                                arg += 0;
                            }
                            
                        } else {
                            arg += 0; //for any case
                        }
                        arg +=0;
                    }
                    if(isNegativeNumber) arg = arg*(-1);
                    nexTopOfStack = [stack lastObject];
                }
                if([attrStr isEqualToString:RAD]){
                    arg = arg * M_PI / 180;
                }
                 dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:arg] accordingPriority:priority withCountAttr:attrStr];
                result= [[dicResult valueForKey:VALUE] doubleValue];
                if(![[dicResult valueForKey:NEED_SHOW_GRAD_KEY] isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                }

            } else if ([operation isEqualToString:@"cos"]){
                double arg;
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                
                if([attrStr isEqualToString:RAD]){
                    arg = [[dicResult valueForKey:VALUE] doubleValue];
                } else{
                    arg = [[dicResult valueForKey:VALUE] doubleValue] * M_PI / 180;
                }
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg)] accordingPriority:priority withCountAttr:attrStr];
                
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"sin"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg;
                if([attrStr isEqualToString:RAD]){
                    arg = [[dicResult valueForKey:VALUE] doubleValue];
                } else{
                    arg = [[dicResult valueForKey:VALUE] doubleValue] * M_PI / 180;
                }
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg)] accordingPriority:priority withCountAttr:attrStr];
                
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"tg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg;
                if([attrStr isEqualToString:RAD]){
                    arg = [[dicResult valueForKey:VALUE] doubleValue];
                } else{
                    arg = [[dicResult valueForKey:VALUE] doubleValue] * M_PI / 180;
                }
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"ctg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg;
                if([attrStr isEqualToString:RAD]){
                    arg = [[dicResult valueForKey:VALUE] doubleValue];
                } else{
                    arg = [[dicResult valueForKey:VALUE] doubleValue] * M_PI / 180;
                }
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"acos"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if([attrStr isEqualToString:RAD]){
                    dicResult=[self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg)]accordingPriority:priority withCountAttr:attrStr];
                } else{
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                }
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"asin"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if([attrStr isEqualToString:RAD]){
                    dicResult=[self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg)]accordingPriority:priority withCountAttr:attrStr];
                } else{
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                }
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            } else if ([operation isEqualToString:@"atg"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if([attrStr isEqualToString:RAD]){
                    dicResult=[self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg)]accordingPriority:priority withCountAttr:attrStr];
                } else{
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                }
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            } else if ([operation isEqualToString:@"actg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if([attrStr isEqualToString:RAD]){
                    dicResult=[self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(1/arg)]accordingPriority:priority withCountAttr:attrStr];
                } else{
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(1/arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                }
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            //!!!for old saved operands version 3.0
            } else if ([operation isEqualToString:@"rcos"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg)] accordingPriority:priority withCountAttr:attrStr];
                result =[ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"rsin"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"rtg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3  withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"rctg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"dsin"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg * M_PI / 180)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"dcos"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg * M_PI / 180)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"dtg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                //double integerPart, factorialPart;
                //factorialPart = modf(arg, &integerPart);
                //if(factorialPart == 0){
                //   if(
                
                // } else {
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg * M_PI / 180)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                // }
                
            } else if ([operation isEqualToString:@"dctg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg * M_PI / 180)] accordingPriority:priority withCountAttr:attrStr];
                result = [ACalcBrain setPrecission:15 toValue:[[dicResult valueForKey:VALUE] doubleValue]];
                showGrad = NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"racos"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];

                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            } else if ([operation isEqualToString:@"rasin"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"ratg"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"ractg"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(1/arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"dasin"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"dacos"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"datg"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg) * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
            } else if ([operation isEqualToString:@"dactg"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble: atan(1/arg)  * 180 / M_PI] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
            } else if ([operation isEqualToString:@"sinh"]){
                dicResult= [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sinh(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad =NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"cosh"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cosh(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad =NOT_SHOW_GRAD;
                
            } else if ([operation isEqualToString:@"tgh"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tanh(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad =NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@"ctgh"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tanh(arg)] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad =NOT_SHOW_GRAD;
            } else if([operation isEqualToString:@"×"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * [value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result = [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad =NOT_SHOW_GRAD;
            } else if([operation isEqualToString:@"÷"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg / [value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result = [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                showGrad =NOT_SHOW_GRAD;
            } else if([operation isEqualToString:@"+"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0 withCountAttr:attrStr];
                NSString *arguShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];

                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg +[value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result = [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                
                NSString *progShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                if([progShowGrad isEqualToString:NOT_SHOW_GRAD]|| [arguShowGrad isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = NOT_SHOW_GRAD;
                } else if ([progShowGrad isEqualToString:SHOW_GRAD]|| [arguShowGrad isEqualToString:SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                } else {
                    showGrad = POSSIBLE_TO_SHOW_GRAD;
                }
            }
            else if([operation isEqualToString:@"-"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0 withCountAttr:attrStr];
                 NSString *arguShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                if(value){
                    dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg - [value doubleValue])] accordingPriority:priority withCountAttr:attrStr];
                    result = [[dicResult valueForKey:VALUE] doubleValue];
                } else {
                    result = arg;
                }
                NSString *progShowGrad = [dicResult valueForKey:NEED_SHOW_GRAD_KEY];
                if([progShowGrad isEqualToString:NOT_SHOW_GRAD]|| [arguShowGrad isEqualToString:NOT_SHOW_GRAD]){
                    showGrad = NOT_SHOW_GRAD;
                } else if ([progShowGrad isEqualToString:SHOW_GRAD]|| [arguShowGrad isEqualToString:SHOW_GRAD]){
                    showGrad = SHOW_GRAD;
                } else {
                    showGrad = POSSIBLE_TO_SHOW_GRAD;
                }
            } else if([operation isEqualToString:@"%"]){
                id nextTop = [stack lastObject];
                double arg;
                if(nextTop && [nextTop isKindOfClass:[NSArray class]]){
                    dicResult = [self popOperandOfStack:nextTop withPreviousValue:nil accordingPriority:0 withCountAttr:attrStr];
                    arg = [[dicResult valueForKey:VALUE] doubleValue];
                    [stack removeLastObject];
                } else {
                    arg = 1.0;
                }
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double secondArg = [[dicResult valueForKey:VALUE] doubleValue];
                
                dicResult = [self popOperandOfStack:stack
                               withPreviousValue:[NSNumber numberWithDouble:(arg*secondArg/100.)]
                               accordingPriority:priority
                                   withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            } else if ([operation isEqualToString:@".00"]){
                dicResult = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3 withCountAttr:attrStr];
                double arg = [[dicResult valueForKey:VALUE] doubleValue];
                arg = round(arg *100) /100;
                dicResult = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:arg] accordingPriority:priority withCountAttr:attrStr];
                result = [[dicResult valueForKey:VALUE] doubleValue];
                showGrad = NOT_SHOW_GRAD;
            }
        }
    }
    return @{
             NEED_SHOW_GRAD_KEY : showGrad,
             VALUE: [NSNumber numberWithDouble:result],
             };
}


#pragma mark DESCRIPTION

-(NSAttributedString*)stringInBrainWithAtributes:(NSDictionary *)attributes
{
    return [ACalcBrain descriptionOfProgram:self.wholeProgram withAttributes:attributes];
}

+(NSAttributedString*) descriptionOfProgram:(id)program withAttributes:(NSDictionary*)atributes
{
    NSMutableAttributedString * atrStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:atributes];
    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:atributes];

    id topOfStacs = [program lastObject];
    
    if(topOfStacs && (![topOfStacs isKindOfClass:[NSArray class]])){
        [atrStr insertAttributedString:[self popStringOfStack:program withNextArguString:empty withAttributes:atributes] atIndex:[atrStr length]];
    } else if (topOfStacs){
        [program removeLastObject];
        [atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:[atrStr length]];
        topOfStacs = [program lastObject];

        while (topOfStacs) {
            NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:atributes];
            [atrStr insertAttributedString:bracet atIndex:0];
            [atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:0];
            [program removeLastObject];
            topOfStacs = [program lastObject];
        }
    }
   
    return  [atrStr copy];
}

+(NSAttributedString *) popStringOfStack:(NSMutableArray *)stack withNextArguString:(NSAttributedString*)argStr withAttributes:(NSDictionary*) attributes
{
    
    NSMutableAttributedString * resultStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
    
    //number formatter
    //NSLog(@"stack: %@", stack);
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setMaximumFractionDigits:9];
    [format setMinimumFractionDigits:0];
    [format setExponentSymbol:@"e"];
    [format setZeroSymbol:@"0"];
    
    CGFloat insertBaseLine = [[attributes valueForKey:NSBaselineOffsetAttributeName] floatValue];
    
    //makes attributes for top line text and ...
    UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
    UIFont *newfont = [UIFont fontWithName:wasFont.fontName size:(wasFont.pointSize / 1.5)];
    NSNumber *baseLineOffsetTop =[NSNumber numberWithFloat: insertBaseLine + wasFont.pointSize * 0.4];
    NSNumber *baseLineOffsetButtom =[NSNumber numberWithFloat:  insertBaseLine - (wasFont.pointSize * 0.4)];
    
    id topOfStack = [stack lastObject];
    if(topOfStack){
        [stack removeLastObject];
    } else {
        resultStr = [argStr mutableCopy];
    }

    //divide whole stack on argu and main part
    NSArray *operations = [NSArray arrayWithObjects:   @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²",@"÷", @"×",@"-",@"+", nil];
    NSArray *nextOperations = [NSArray arrayWithObjects: @"÷", @"×",@"-",@"+", nil];
   // NSLog(@"top of stack in pop %@", topOfStack);
    if([topOfStack isKindOfClass:[NSDictionary class]]){
        //if it is constant or function created by user
        NSString *key = [[topOfStack allKeys]firstObject];
        //NSLog(@"keyTitle: %@",key);
        id valueProg = [topOfStack objectForKey:key];
        if([valueProg isKindOfClass:[NSNumber class]]){//if there is conctant
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:key attributes:attributes];
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        } else {
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:key attributes:attributes];
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        }
    } else
    if([topOfStack isKindOfClass:[NSArray class]]){
//#pragma mark WORK with CURRENSIES
        if([(NSArray*)topOfStack count]==4 && [topOfStack[0] isKindOfClass:[NSString class]]&&[topOfStack[0] isEqualToString:@"$"]){
            NSString *fromCur = (NSString*)topOfStack[1];
            NSMutableAttributedString *fromCurAttrStr = [[NSMutableAttributedString alloc] initWithString:fromCur attributes:attributes];
            [fromCurAttrStr beginEditing];
            NSRange wholeRange = NSMakeRange(0, [fromCurAttrStr length]);
            [fromCurAttrStr addAttribute:NSFontAttributeName value:newfont range:wholeRange];
            [fromCurAttrStr endEditing];
            
            NSString *toCur = (NSString*)topOfStack[2];
            NSMutableAttributedString *toCurAttrStr = [[NSMutableAttributedString alloc] initWithString:toCur attributes:attributes];
            [toCurAttrStr beginEditing];
            wholeRange = NSMakeRange(0, [toCurAttrStr length]);
            [toCurAttrStr addAttribute:NSFontAttributeName value:newfont range:wholeRange];
            [toCurAttrStr endEditing];
            
            
            NSString *initStr =@"(";

            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:initStr attributes:attributes];

            
            id nextTopOfStack = [arguArray lastObject];
            if(nextTopOfStack && [nextTopOfStack isKindOfClass:[NSNumber class]] && ([nextTopOfStack doubleValue] == 0)){
                [arguArray removeLastObject];
            }

            NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
            [attArg insertAttributedString:[self popStringOfStack:arguArray
                                               withNextArguString:empty
                                                   withAttributes:attributes] atIndex:[attArg length]];
            
            [attArg insertAttributedString:fromCurAttrStr atIndex:[attArg length]];
            NSAttributedString *braket = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
            [attArg insertAttributedString:braket atIndex:[attArg length]];
            [attArg insertAttributedString:toCurAttrStr atIndex:[attArg length]];
            resultStr = [[self popStringOfStack:stack
                             withNextArguString:attArg
                                 withAttributes:attributes] mutableCopy];
            
            NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
            [attArg insertAttributedString:bracet atIndex:0];
            bracet = [bracet initWithString:@")" attributes:attributes];
            [attArg insertAttributedString:bracet atIndex:[attArg length]];
        } else {
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
            //for gradus view
            id topOfTopArray = [topOfStack lastObject];
            if(topOfTopArray && [topOfTopArray isKindOfClass:[NSString class]]){
                if([topOfTopArray isEqualToString:@"D"] || [topOfTopArray isEqualToString:@"R"]){
                    [topOfStack removeLastObject];
                    NSArray *copyGrad = [topOfStack copy];
                    BOOL isNegativeNumber = NO;
                    NSInteger initialIndex = [attArg length];
                    for(int i = 0; i < [copyGrad count]; i++){
                        if([copyGrad[i] isKindOfClass:[NSNumber class]]){
                            if([copyGrad[i] compare:@0] == NSOrderedAscending) isNegativeNumber = YES;
                            int intNumber = ABS([copyGrad[i] intValue]);
                            //result = [result stringByAppendingString:[NSString stringWithFormat:@"%i",intNumber]];
                            NSAttributedString * grad = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i",intNumber] attributes:attributes];
                            [attArg insertAttributedString:grad atIndex:[attArg length]];
                        } else if([copyGrad[i] isKindOfClass:[NSString class]]){
                            NSAttributedString * grad = [[NSAttributedString alloc] initWithString:copyGrad[i] attributes:attributes];
                            [attArg insertAttributedString:grad atIndex:[attArg length]];
                        }
                    }
                    if(isNegativeNumber){
                        NSAttributedString * negative = [[NSAttributedString alloc] initWithString:@"-" attributes:attributes];
                        [attArg insertAttributedString:negative atIndex:initialIndex];

                    }
                } else {
                    NSMutableArray *mutTopOfStack = [topOfStack mutableCopy];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:mutTopOfStack
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];

                }
            } else {
            
                NSMutableArray *mutTopOfStack = [topOfStack mutableCopy];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [attArg insertAttributedString:[self popStringOfStack:mutTopOfStack
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                bracet = [bracet initWithString:@")" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:[attArg length]];
            
            }
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        }
        
    } else if ([topOfStack isKindOfClass:[NSNumber class]]){
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
            if (fabs([topOfStack doubleValue])>9e9 || fabs([topOfStack doubleValue])<9e-9) {
                [format setNumberStyle:NSNumberFormatterScientificStyle];
                [format setMaximumFractionDigits:7];
            }
            else{
                [format setNumberStyle:NSNumberFormatterDecimalStyle];
                double intPartLenght = log10(fabs([topOfStack doubleValue]));
                double  intPart;//fractPart,
                modf(intPartLenght, &intPart);//fractPart =
                if(intPart <0) intPart = 0;
                [format setMaximumFractionDigits:(9 - (int)intPart)];
            }
            NSAttributedString *number = [[NSAttributedString alloc] initWithString:[format stringFromNumber:topOfStack] attributes:attributes];
            //NSString *arg = @"";
            if([topOfStack doubleValue] < 0){
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                [attArg insertAttributedString:number atIndex:0];
                bracet = [bracet initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                
            } else {
                [attArg insertAttributedString:number atIndex:0];
            }
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];

    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSArray * trigonometricsNew = [NSArray arrayWithObjects:
                                        @"sin",@"cos",@"tg",@"ctg",
                                        @"asin",@"acos",@"atg",@"actg",
                                        nil];
        NSArray * trigonometrics = [NSArray arrayWithObjects:
                                    @"dsin",@"dcos",@"dtg",@"dctg",
                                    @"dasin",@"dacos",@"datg",@"dactg",
                                    @"rsin",@"rcos",@"rtg",@"rctg",
                                    @"rasin",@"racos",@"ratg",@"ractg",
                                    nil];
        NSArray *hiperbolic = [NSArray arrayWithObjects:@"sinh",@"cosh",@"tgh",@"ctgh",nil];
       
            //
            //---------------inserted
            //
        if([topOfStack isEqualToString:SHOW_GRAD_RESULT]){
            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];

                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
           // }
            resultStr = [[self popStringOfStack:stack
                             withNextArguString:attArg
                                 withAttributes:attributes] mutableCopy];
        } else
            if([topOfStack isEqualToString:@"D"] || [topOfStack isEqualToString:@"R"]){
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                //[stack removeLastObject];
                NSArray *copyGrad = [stack copy];
                for(int i = 0; i < [copyGrad count]; i++){
                    if([copyGrad[i] isKindOfClass:[NSNumber class]]){
                        NSAttributedString * grad = [[NSAttributedString alloc] initWithString:[copyGrad[i] stringValue] attributes:attributes];
                        [attArg insertAttributedString:grad atIndex:[attArg length]];
                    } else if([copyGrad[i] isKindOfClass:[NSString class]]){
                        NSAttributedString * grad = [[NSAttributedString alloc] initWithString:copyGrad[i] attributes:attributes];
                        [attArg insertAttributedString:grad atIndex:[attArg length]];
                    }
                }
                [stack removeAllObjects];
                resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
            } else
                //
                //---------------------------
                ///
         
            if([topOfStack isEqualToString:@"+"] || [topOfStack isEqualToString:@"-"]){
                [resultStr insertAttributedString:argStr atIndex:0];
                NSAttributedString* spase = [[NSAttributedString alloc] initWithString:@" " attributes:attributes];
                [resultStr insertAttributedString:spase atIndex:0];
                NSAttributedString* attrTop = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                [resultStr insertAttributedString:attrTop atIndex:0];
                [resultStr insertAttributedString:spase atIndex:0];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if ([topOfStack isEqualToString:@"×"] || [topOfStack isEqualToString:@"÷"]){
                [resultStr insertAttributedString:argStr atIndex:0];
                NSAttributedString* spase = [[NSAttributedString alloc] initWithString:@" " attributes:attributes];
                [resultStr insertAttributedString:spase atIndex:0];
                NSAttributedString* attrTop = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                [resultStr insertAttributedString:attrTop atIndex:0];
                [resultStr insertAttributedString:spase atIndex:0];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];

            } else if([topOfStack isEqualToString:@"%"]){
                
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                NSAttributedString * attrTop = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                [attArg insertAttributedString:attrTop atIndex:0];
                //delete percent argu
                id nextTopOfStack = [arguArray lastObject];
                if(nextTopOfStack) [arguArray removeLastObject];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"∓"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@" × (-1)" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    
                } else {
                    id lastObj = [arguArray lastObject];
                    if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                        [arguArray removeLastObject];
                        double argDouble = trunc([lastObj doubleValue]);
                        [arguArray addObject:[NSNumber numberWithDouble:argDouble]];
                    }
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

                
            } else if([topOfStack isEqualToString:@"x!"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"!" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];

                } else {
                    id lastObj = [arguArray lastObject];
                    if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                        [arguArray removeLastObject];
                        double argDouble = trunc([lastObj doubleValue]);
                        [arguArray addObject:[NSNumber numberWithDouble:argDouble]];
                    }
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if ([topOfStack isEqualToString:@"¹/x"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                //NSString *arg = @"";
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                
                NSAttributedString * value = [[NSAttributedString alloc] initWithString:@"1/" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"x²"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"²" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"x³"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"³" attributes:attributes];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"2ˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];

                NSAttributedString *two = [[NSAttributedString alloc]initWithString:@"2" attributes:attributes];
                [attArg insertAttributedString:two atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"eˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];
                
                NSAttributedString *e = [[NSAttributedString alloc]initWithString:@"e" attributes:attributes];
                [attArg insertAttributedString:e atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            }  else if([topOfStack isEqualToString:@"10ˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];
                
                NSAttributedString *ten = [[NSAttributedString alloc]initWithString:@"10" attributes:attributes];
                [attArg insertAttributedString:ten atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"√x"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString *sqrt = [[NSAttributedString alloc]initWithString:@"√" attributes:attributes];
                [attArg insertAttributedString:sqrt atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

            } else if([topOfStack isEqualToString:@"³√x"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString *cqrt = [[NSAttributedString alloc]initWithString:@"³√" attributes:attributes];
                [attArg insertAttributedString:cqrt atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

            } else if([topOfStack isEqualToString:@"lg"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"lg" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"log₂"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"log₂" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"ln"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"ln" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

     
            } else if([hiperbolic containsObject: topOfStack]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:bracet atIndex:0];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
                
            } else if([topOfStack isEqualToString:@"xʸ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                NSMutableAttributedString *mutAttArg = [argStr mutableCopy];
                if([mutAttArg.string isEqualToString:@""]){
                    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [mutAttArg insertAttributedString:quesMark atIndex:0];
                }
                
                [mutAttArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [mutAttArg length]);
                [mutAttArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [mutAttArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [mutAttArg endEditing];
                
                [resultStr insertAttributedString:mutAttArg atIndex:0];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                
                 NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                 [resultStr insertAttributedString:[self popStringOfStack:stack
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"yˣ"]){
                //necessary get next argu from stack
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                [resultStr beginEditing];
                NSRange wholeRange = NSMakeRange(0, [resultStr length]);
                [resultStr addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [resultStr addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [resultStr endEditing];
                
                if([argStr.string isEqualToString:@""]){
                    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [resultStr insertAttributedString:quesMark atIndex:0];
                } else {
                    [resultStr insertAttributedString:argStr atIndex:0];
                }
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"ʸ√x"]){
                //necessary get next argu from stack
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                NSMutableAttributedString *mutAttArg = [argStr mutableCopy];
                if([mutAttArg.string isEqualToString:@""]){
                    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [mutAttArg insertAttributedString:quesMark atIndex:0];
                }
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];

                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                
                if([argStr.string isEqualToString:@""]){
                    NSMutableAttributedString * quesMark = [[NSMutableAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [quesMark beginEditing];
                    NSRange wholeRange = NSMakeRange(0, [quesMark length]);
                    [quesMark addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                    [quesMark addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                    [quesMark endEditing];
                    [resultStr insertAttributedString:quesMark atIndex:0];
                } else {
                    NSMutableAttributedString *mutArg = [argStr mutableCopy];
                    [mutArg beginEditing];
                    NSRange wholeRange = NSMakeRange(0, [mutArg length]);
                    [mutArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                    [mutArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                    [mutArg endEditing];
                    
                    [resultStr insertAttributedString:mutArg atIndex:0];
                }
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"ˣ√y"]){
                NSMutableAttributedString *mutAttArg = [argStr mutableCopy];
                if([mutAttArg.string isEqualToString:@""]){
                    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [mutAttArg insertAttributedString:quesMark atIndex:0];
                }
                [resultStr insertAttributedString:mutAttArg atIndex:0];
                
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                NSMutableAttributedString *arg = [[NSMutableAttributedString alloc] initWithString:@""];
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [arg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [arg insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [arg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [arg insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                
                [arg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [arg length]);
                [arg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [arg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [arg endEditing];
                
                [resultStr insertAttributedString:arg atIndex:0];

                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"logʸ"]){
                //necessary get next argu from stack
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                if([argStr.string isEqualToString:@""]){
                    NSAttributedString *questMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [attArg insertAttributedString:questMark atIndex:0];
                } else {
                    [attArg insertAttributedString:argStr atIndex:0];
                }

                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetButtom range:wholeRange];
                [attArg endEditing];
                
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"log" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                [resultStr insertAttributedString:attArg atIndex:0];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"√x²+y²"]){
                //necessary get next argu from stack
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"²)" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                if([argStr.string isEqualToString:@""]){
                    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
                    [resultStr insertAttributedString:quesMark atIndex:0];

                } else {
                    [resultStr insertAttributedString:argStr atIndex:0];
                }
                value = [value initWithString:@"² + " attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [resultStr insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                value = [value initWithString:@"√(" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([trigonometricsNew containsObject:topOfStack] || [trigonometrics containsObject:topOfStack]){
                //[stack removeLastObject];
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if(([testArray count] == 1) && [[arguArray lastObject] isKindOfClass:[NSArray class]] &&  ![testArray[0] containsObject:@"°"]){
                    //![testArray[0] containsObject:@"°"] - if it's not grad array - another way it need brackets
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                } else {
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                }

                NSString* str;
                if([trigonometrics containsObject:topOfStack]){
                    str =[topOfStack stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                } else {
                    str = topOfStack;
                }
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
                [attArg insertAttributedString:attrStr atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                withNextArguString:attArg
                                    withAttributes:attributes] mutableCopy];
                
            } else if ([topOfStack isEqualToString:@"π"] || [topOfStack isEqualToString:@"e"] || [topOfStack isEqualToString:@"x"] || [topOfStack isEqualToString:@"y"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                id nextTopOfStack = [arguArray lastObject];
                if(nextTopOfStack && [nextTopOfStack isKindOfClass:[NSNumber class]] && ([nextTopOfStack doubleValue] == 0)){
                    [arguArray removeLastObject];
                }
                NSAttributedString *attTopOfStack = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
                [attArg insertAttributedString:attTopOfStack atIndex:[attArg length]];
                resultStr = [[self popStringOfStack:stack
                                withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
            } else if([topOfStack isEqualToString:@".00"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:
                                                     [[self point] stringByAppendingString:@"00"]
                                                                                           attributes:attributes];
                
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetButtom range:wholeRange];
                [attArg endEditing];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {
                    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
            } /*else if ([topOfStack isEqualToString:@"X"] || [topOfStack isEqualToString:@"e"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                id nextTopOfStack = [arguArray lastObject];
                if(nextTopOfStack && [nextTopOfStack isKindOfClass:[NSNumber class]] && ([nextTopOfStack doubleValue] == 0)){
                    [arguArray removeLastObject];
                }
                NSAttributedString *attTopOfStack = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
                [attArg insertAttributedString:attTopOfStack atIndex:[attArg length]];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
            } else if ([topOfStack isEqualToString:@"π"] || [topOfStack isEqualToString:@"e"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                id nextTopOfStack = [arguArray lastObject];
                if(nextTopOfStack && [nextTopOfStack isKindOfClass:[NSNumber class]] && ([nextTopOfStack doubleValue] == 0)){
                    [arguArray removeLastObject];
                }
                NSAttributedString *attTopOfStack = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
                [attArg insertAttributedString:attTopOfStack atIndex:[attArg length]];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
            }
               */
        }
    return  [resultStr copy];
}

-(NSArray*) deepProgram
{
    
    return [[ACalcBrain deepArrayCopy:self.programStacks] copy];
}

-(NSArray*) deepArgu
{
    return [[ACalcBrain deepArrayCopy:self.argu] copy];

}

+(NSString *) point
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}

@end

