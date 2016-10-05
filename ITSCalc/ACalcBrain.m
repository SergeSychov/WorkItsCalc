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
@property (nonatomic, strong) NSArray *programStacks;
@property (nonatomic, strong) NSArray *arguStack;
@property (nonatomic, strong) NSDictionary *variableValue;
@property (nonatomic) int numberOfOpenBrackets;

-(double) countWithStack:(id) stack;
@end

@implementation ACalcBrain

-(NSArray*) arrayToSaveBrain
{
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    [saveArray addObject:[self.deepProgram copy]];
    [saveArray addObject:[self.deepArgu copy]];
    [saveArray addObject:[NSNumber numberWithInt:self.numberOfOpenBrackets]];
    [saveArray addObject:[NSNumber numberWithBool:self.isStronglyArgu]];
    
    return [saveArray copy];
}

+(ACalcBrain*) brainFromSavedArray:(NSArray*)array
{
    NSMutableArray *extractedArray = [array mutableCopy];
    NSArray *prog = [[NSArray alloc] init];
    NSArray *arg = [[NSArray alloc] init];
    int numBracets = 0;
    BOOL isStrongArgu = YES;
    id top = [extractedArray lastObject];
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
    
    return [ACalcBrain initWithProgram:prog withArgu:arg withOpenBracets:numBracets andIsStrongluArgu:isStrongArgu];
}

+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*) argu
{
    return [ACalcBrain initWithProgram:program withArgu:argu withOpenBracets:0 andIsStrongluArgu:YES];
}

+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*)argu withOpenBracets:(int)openBracets andIsStrongluArgu:(BOOL)isStronglyArgu
{
    //add from this
    static ACalcBrain *newBrain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newBrain = [[ACalcBrain alloc] init];
        // Do any other initialisation stuff here
    });
    //to this
   // ACalcBrain *newBrain = [[ACalcBrain alloc ] init];
    
    newBrain.programStacks = program;
    newBrain.arguStack = argu;
    newBrain.isStronglyArgu = isStronglyArgu;
    newBrain.numberOfOpenBrackets = openBracets;
    
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

#pragma mark STATIC PROPERTIES
//static BOOL noStonglyArguForY;

-(void) pushOperand:(id) operand
{
    if([operand isKindOfClass:[NSNumber class]] && ([operand integerValue]==NSNotFound)){
        //it's was pressed Y but no strongly argu for that
        //noStonglyArguForY = YES;
        
        //NSLog(@"noStonglyArguForY self.argu = %@", self.argu);
        
        NSMutableArray *newMuttNotStronglyArrayForY = [NSMutableArray arrayWithArray:self.arguStack];
        [newMuttNotStronglyArrayForY addObject:operand];

        //NSArray* newArguWithNotStronglyForY = [NSArray arrayWithObjects:self.arguStack, operand, nil];
        self.arguStack = [newMuttNotStronglyArrayForY copy];
       // NSLog(@"after noStonglyArguForY self.argu = %@", self.argu);
    } else {
        
    //available to push operand only in argu stack
    //1. if insert operant to argu stack - stack need be cleared
    //NSLog(@"Push operand arguStack before %@",self.arguStack);
    
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    //if(![self waitingFor_Y_Argu]){ //if argu isn't function that waiting for next argu can remove all arrg
        //NSLog(@"Argu NOT waiting y");
        [copyArgu removeAllObjects];

    //} else {
    //    NSLog(@"Argu IS waiting y");
    //}

    if([operand isKindOfClass:[NSString class]]){
        if([operand isEqualToString:@"x"]||[operand isEqualToString:@"y"]){
            [copyArgu addObject:operand];
        } else if([operand isEqualToString:@"0."]){
            [copyArgu addObject:[NSNumber numberWithDouble:0.00]];
        } else if ([operand doubleValue] != 0.0){

            [copyArgu addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
        } else { //thin it's need for variables
            [copyArgu addObject:operand];
        }
    } else if([operand isKindOfClass:[NSNumber class]]){
        [copyArgu addObject:operand];
        if([operand integerValue]==NSNotFound){
            
        }
    } else if([operand isKindOfClass:[NSArray class]]){
        [copyArgu addObject:operand];
    } else if([operand isKindOfClass:[NSDictionary class]]){
        [copyArgu addObject:operand];
    }

    self.arguStack = [copyArgu copy];
    //NSLog(@"Push operand arguStack afterv%@",self.arguStack);
    //NSLog(@"Push operand programStack afterv%@",self.programStacks);
    }
    
}

-(BOOL)waitingFor_Y_Argu {
    BOOL isWaitingFor_Y_Argu = NO;
    //check
    id checkObj = nil; //obj for check if need Y argu
    //if argu stack not empty
   // if([self.argu lastObject]){
        checkObj = [self.argu lastObject];
    //otherwise check last obj from program
    //} else if([self.program lastObject]){
    if([self.program lastObject]){
        checkObj = [self.program lastObject];
    }
    //NSLog(@"checkObj %@", checkObj);
    //if last obj is String and its operation with two argument - return YES
    NSArray * operandwithTwoArguments = [NSArray arrayWithObjects:   @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", nil];
    if(checkObj && [checkObj isKindOfClass:[NSString class]] && [operandwithTwoArguments containsObject:checkObj]){
        isWaitingFor_Y_Argu = YES;
    }else if(checkObj && [checkObj isKindOfClass:[NSDictionary class]]){
        //check for y
        FuncArguments funcArgu = [ACalcBrain checkWichArgumentsHasFunc:checkObj];
        if((funcArgu==YOnlyArgu)||(funcArgu==X_and_Y_Argu)||(funcArgu==Y_and_Curr_Argu)){
            isWaitingFor_Y_Argu = YES;
        }
        
    }
            //if last obj dictionary and has Y argument - return YES
    
    return isWaitingFor_Y_Argu;
}
/*
typedef enum : NSInteger {
    NoArgument = 0,
    Only_X_Argu,
    Only_Y_Argu,
    Only_Curr_Argu,
    X_and_Y_Argu,
    X_and_Curr_Argu,
    Y_and_Curr_Argu,
    allArgues
} FuncArguments;
*/

/*
-(void)setProgramStacks:(NSArray *)programStacks{
    NSLog(@"setProgramStacks");
    self.programStacks = programStacks;
}
*/
-(double) performOperationInArgu:(id)operation
{
    NSInteger operationPriority;
    //NSLog(@"Operation %@",operation);
    //NSLog(@"self.arguStack before %@",self.arguStack);
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];

    [copyArgu addObject:operation];
    self.arguStack = [copyArgu copy];
    //NSLog(@"brain argustack after: %@", self.arguStack);
    if([operation isKindOfClass:[NSString class]]){
        operationPriority = [ACalcBrain getPriorityOf:operation]-1;
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
    //NSLog(@"performOperationInArgu  AFTER self.argu %@", self.argu);
    
    return [ACalcBrain runProgram:self.argu usingVariableValue:self.variableValue withPriority:operationPriority];
        
}


-(double)perfomOperation: (id)operation
{
    //NSLog(@"perfomOperation before self.program %@", self.program);
    //NSLog(@"perfomOperation before self.argu %@", self.argu);

    int operationPriority = [ACalcBrain getPriorityOf:operation];
    
    if(!self.isStronglyArgu){
        //NSLog(@"perfomOperation NO strongly argu");
        [self checkToExceptDoubleOperation]; //remove from stack last operation like @"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"÷", @"×",@"-", @"+"
    } else {
        //NSLog(@"perfomOperation IS strongly argu");
        /*
        if([self waitingFor_Y_Argu]){
            NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
            
            [copyArgu addObject:operation];
            self.arguStack = [copyArgu copy];
        }
        */
            [self applyArgu];
        
    }
    //NSLog(@"2 perfomOperation before self.program %@", self.program);
    //set result stack as new argument
    [self getResultAndPutAsArguByPriotiy:operationPriority];

    //if(![self waitingFor_Y_Argu]){
        NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
        [programCopy.lastObject addObject:operation];
        self.programStacks = [programCopy copy];
   // }
    //NSLog(@"3 perfomOperation before self.program %@", self.program);
    return [ACalcBrain runProgram:self.program usingVariableValue:self.variableValue withPriority:operationPriority];
}

-(NSArray*) argu
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
    if(topOfStack && [topOfStack isKindOfClass:[NSString class]] && ([ACalcBrain getPriorityOf:topOfStack] == 1)){ //may be zero
        [currentStack removeLastObject];
        [copyArgu addObject:currentStack];
    } else {
        NSArray * arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1.0], nil];
        [copyArgu addObject:arr];
    }
    self.arguStack = [copyArgu copy];
}

//check @"∓" or @"¹/x" for exepting double the same operation
-(double) checkMinusOrDivideOperationOnDubble:(NSString*)operand
{
    double result;
    
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    id lastObjInArgStack = [copyArgu lastObject];
    if([lastObjInArgStack isKindOfClass:[NSString class]] && [lastObjInArgStack isEqualToString:operand]){
        [copyArgu removeLastObject];
        result =  [ACalcBrain runProgram:self.argu usingVariableValue:self.variableValue];
    } else {
        [copyArgu addObject:operand];
        int operationPriority = [ACalcBrain getPriorityOf:operand];
        result = [ACalcBrain runProgram:copyArgu usingVariableValue:self.variableValue withPriority:operationPriority];
    }
    self.arguStack = [copyArgu copy];
    return result;
}

-(BOOL) deleteLastElement
{
    NSArray *operations = [NSArray arrayWithObjects:@"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", @"÷", @"×",@"-",@"+", nil];
    
    
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    NSMutableArray *copyPogram = [ACalcBrain deepArrayCopy:self.programStacks];
    NSLog(@"deleteLastElement before self.arguStack %@", self.arguStack);
    NSLog(@"deleteLastElement before self.programStacks %@", self.programStacks);
    
    
    if(self.isStronglyArgu && ([copyArgu count] >0)){
        //NSLog(@"Works with argu");
        
        id topOfArguStack = [copyArgu lastObject];
        if(topOfArguStack){
           
            if([topOfArguStack isKindOfClass:[NSArray class]]){
                //NSLog(@"Del isStronglyArgu last Array: %@", topOfArguStack);
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
                
                    //decide array in argu on prog and argu
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
                        //self.isStronglyArgu = NO;//was
                    self.isStronglyArgu = YES;
                    
                } else if(last && [last isKindOfClass:[NSString class]] && [last isEqualToString:@"%"]){
                    if([copyArgu lastObject]){
                        [copyArgu removeLastObject];

                    } else if([copyPogram lastObject] && [[copyPogram lastObject] isKindOfClass:[NSArray class]]){
                        id lastInLastProg = [[copyPogram lastObject] lastObject];
                        if(lastInLastProg){
                            [[copyPogram lastObject] removeLastObject];
                        }
                        
                        self.programStacks = [copyPogram copy];
                    }
                    self.arguStack = [copyArgu copy];
                    self.isStronglyArgu = YES;
                } else {// ([last isKindOfClass:[NSDictionary class]]){//if it's a function - may be it was not strongly argu
                    //lets check
                    id nextTopOfArguStack = [copyArgu lastObject];
                    if(nextTopOfArguStack && [nextTopOfArguStack isKindOfClass:[NSNumber class]] && ([nextTopOfArguStack integerValue]==NSNotFound)){//if there is not pushed by user argu - delete next element
                        [copyArgu removeLastObject];
                        
                        last = [copyArgu lastObject];
                        if(last){
                            [copyArgu removeLastObject];
                        }
                    }
                    
                    self.arguStack = [copyArgu copy];
                    self.programStacks = [copyPogram copy];
                    self.isStronglyArgu = YES;
                }
                /*
                else {
                    NSLog(@"Del isStronglyArgu last Some: %@", topOfArguStack);
                    self.isStronglyArgu = YES;
                }
                 */
               // }

            }
        }
    
    } else {
        
        if([copyArgu count] > 0) [copyArgu removeAllObjects];
        
        id topOfProgStack = [copyPogram.lastObject lastObject];
        
        //NSLog(@"Works with prog");

        
        if(topOfProgStack){
            
            [copyPogram.lastObject removeLastObject];
            
            id nextTopOfProgStack = [copyPogram.lastObject lastObject];
            
            //NSLog(@"Del NOt StnextTopOfProgStack: %@", nextTopOfProgStack);
            
            if(nextTopOfProgStack && [nextTopOfProgStack isKindOfClass:[NSNumber class]] && ([nextTopOfProgStack integerValue]==NSNotFound)){//if there is not pushed by user argu - delete next element
                [copyPogram.lastObject removeLastObject];
                
                topOfProgStack = [copyPogram.lastObject lastObject];
                if(topOfProgStack){
                    [copyPogram.lastObject removeLastObject];
                }
            }
            
            
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

    NSLog(@"deleteLastElement after self.arguStack: %@", self.arguStack);
    NSLog(@"deleteLastElement after self.programStacks: %@", self.programStacks);
    
    return  self.isStronglyArgu;
}

#pragma mark _HELPED FUNCTIOS___________________________________________________

+(NSAttributedString*) addQuestionMarkInString:(NSAttributedString*)inString WithAttributes:(NSDictionary*)attributes
{
    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
    NSAttributedString *closeBracket = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];

    NSMutableAttributedString* outString = [inString mutableCopy];
    
    if([outString.string isEqualToString:@""]){//if there is empty argument array
        [outString insertAttributedString:quesMark atIndex:0];//add question mark
    } else {
        
        NSString *firstSymbAtt = [[outString string] substringToIndex:1];
        NSString *lasSymbAtt = [[outString string] substringFromIndex:[outString length]-1];
        
        if([firstSymbAtt isEqualToString:@"("]&&(![lasSymbAtt isEqualToString:@")"])){
            //if there is an array add ques mark for argument and close bracket after
            [outString insertAttributedString:quesMark atIndex:[outString length]];
            [outString insertAttributedString:closeBracket atIndex:[outString length]];
        }
    }
    
    return [outString copy];
}

+(BOOL)isNeedBracketsForArgumentFromStack:(NSArray*)stack
{
    BOOL returnMark = NO;
    NSArray* needBracketsOperation = [NSArray arrayWithObjects:@"yˣ",@"ˣ√y",@"√x²+y²",@"logʸ", nil];
    
    id lastObjFromStack = [stack lastObject];
    
    if(lastObjFromStack && [lastObjFromStack isKindOfClass:[NSString class]] && [needBracketsOperation containsObject:lastObjFromStack]){
        returnMark = YES;
    }
    
    return returnMark;
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

+(int) getPriorityOf:(id) operand;
{
    int priority = 4;
    NSArray *zeroPriorityOperands = [NSArray arrayWithObjects:@"+",@"-", nil];
    NSArray *onePriorityOperands = [NSArray arrayWithObjects:@"÷", @"×", nil];
    NSArray *twoPriorityOperands = [NSArray arrayWithObjects:@"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",@"√x²+y²", nil];
    
    //if its string operand
    if([operand isKindOfClass:[NSString class]]){
        if([zeroPriorityOperands containsObject:operand]){
            priority =1;
        } else if([onePriorityOperands containsObject:operand]){
            priority = 2;
        } else if([twoPriorityOperands containsObject:operand]){
            priority = 3;
        }
    } else if([operand isKindOfClass:[NSDictionary class]]){
        FuncArguments funcArguments = [ACalcBrain checkWichArgumentsHasFunc:operand];
        if((funcArguments == XOnlyArgu)||(funcArguments == CurrOnlyArgu)||(funcArguments == X_and_Curr_Argu)){
            priority = 4;
        } else if((funcArguments == YOnlyArgu)||(funcArguments == AllArgues)||(funcArguments == X_and_Y_Argu)||(funcArguments == Y_and_Curr_Argu)){
            priority = 3;
        }
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

+(FuncArguments)checkWichArgumentsHasFunc:(NSDictionary*)func{
    NSString *keyTitle = [[func allKeys]firstObject];
    
    FuncArguments returnValue;
    //this is a function
    // check if there x or and y vriables and currency converter
    // check if key hase atributes another case it's konstant with array
    NSRange bracketOpenRange = [keyTitle rangeOfString:@"(" options:NSBackwardsSearch];
    //it's important search from and case user insert brackets in name
    NSRange bracketCloseRange = [keyTitle rangeOfString:@")" options:NSBackwardsSearch];
    
    if((bracketOpenRange.location != NSNotFound)&&(bracketCloseRange.location != NSNotFound)){ //ok maybe there is variables or currencies
        //make a work with they
        NSRange rangeOfPossibleVariables = NSMakeRange(bracketOpenRange.location+1, bracketCloseRange.location-bracketOpenRange.location -1);
        //check is there x,y, $ variables
        //possible big mistake if user for constasnt insert "(x)" at the end
        NSRange xRangeInStrBetwinBrackets = [keyTitle rangeOfString:@"x" options:NSLiteralSearch range:rangeOfPossibleVariables];
        NSRange yRangeInStrBetwinBrackets = [keyTitle rangeOfString:@"y" options:NSLiteralSearch range:rangeOfPossibleVariables];
        NSRange currensyRangeInStrBetwinBrackets = [keyTitle rangeOfString:@"$" options:NSLiteralSearch range:rangeOfPossibleVariables];
        //for more readable work make Bool properties
        BOOL xHereInFunc = (xRangeInStrBetwinBrackets.location != NSNotFound);
        BOOL yHereInFunc = (yRangeInStrBetwinBrackets.location != NSNotFound);
        BOOL currHereInFunc = (currensyRangeInStrBetwinBrackets.location != NSNotFound);
        
        //return
        if(xHereInFunc && yHereInFunc && currHereInFunc){
            returnValue = AllArgues;
        } else if(xHereInFunc && yHereInFunc && !currHereInFunc){
            returnValue = X_and_Y_Argu;
        } else if(xHereInFunc && !yHereInFunc && currHereInFunc){
            returnValue = X_and_Curr_Argu;
        } else if(!xHereInFunc && yHereInFunc && currHereInFunc){
            returnValue = Y_and_Curr_Argu;
        } else if(xHereInFunc && !yHereInFunc && !currHereInFunc){
            returnValue = XOnlyArgu;
        } else if(!xHereInFunc && yHereInFunc && !currHereInFunc){
            returnValue = YOnlyArgu;
        } else if(!xHereInFunc && !yHereInFunc && currHereInFunc){
            returnValue = CurrOnlyArgu;
        } else if(!xHereInFunc && !yHereInFunc && !currHereInFunc){
            returnValue = NoArgument;
        }
        
    } else {
        //this is not func with argu
        returnValue = NoArgument;
    }
    return returnValue;
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

//check if programm has currencies array take it ans return currensies arrays:USD/EUR/Value othercase retun nil
+(NSArray*) chekForCurrensiesProgramm:(id)programm {

    NSArray* currenciesArray = nil;
    NSArray* arrayProgramm = nil;
    if([programm isKindOfClass:[NSDictionary class]]){
        //if there is function or maybe constant
        NSString *keyTitle = [[programm allKeys]firstObject];
        id valueProg = [programm objectForKey:keyTitle];
        if([valueProg isKindOfClass:[NSArray class]]){
            arrayProgramm = valueProg;

        }
    } else  if ([programm isKindOfClass:[NSArray class]]){
                arrayProgramm = programm;
    }
    NSMutableArray *mutableCurrenciesArray = [[NSMutableArray alloc]init];

    if(arrayProgramm){
        for(id obj in arrayProgramm){
            if([obj isKindOfClass:[NSArray class]]){
            
                if([[obj firstObject] isKindOfClass:[NSString class]] && [[obj firstObject] isEqualToString:@"$"]){
                
                    [mutableCurrenciesArray addObject:obj];
                } else {
                    if([ACalcBrain chekForCurrensiesProgramm:obj]){
                        [mutableCurrenciesArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:obj]];
                    }
                }
            } else if([obj isKindOfClass:[NSDictionary class]]&&
               [ACalcBrain chekForCurrensiesProgramm:obj]){
                [mutableCurrenciesArray addObjectsFromArray:[ACalcBrain chekForCurrensiesProgramm:obj]];
            }
        }
    }
    //if there is currencies
    if([mutableCurrenciesArray lastObject]) currenciesArray = [mutableCurrenciesArray copy];

    return currenciesArray;
}
    
//replace arrays with currencies in program with new values of currencies exhange
//for each element chek if array
// if - yes - replace, else - recrucive call
+(NSArray*) programm:(NSArray *)programm replaceString:(NSString*)symb withObj:(id)repObj{
    NSArray *retProgramm = nil;
    NSMutableArray *mutableProgramm = [programm mutableCopy];
    if(repObj) {
        @autoreleasepool {

            for(NSInteger i = 0; i < mutableProgramm.count; i++){
                id obj = [mutableProgramm objectAtIndex:i];
                
                if([obj isKindOfClass:[NSString class]] && [obj isEqualToString:symb]){
                    [mutableProgramm replaceObjectAtIndex:i withObject:repObj];
                } else if([obj isKindOfClass:[NSArray class]]){
                    [mutableProgramm replaceObjectAtIndex:i withObject:[ACalcBrain programm:obj replaceString:symb withObj:repObj]];
                }
            }
            retProgramm = [mutableProgramm copy];
        }
    }
    return retProgramm;
}

+(id) programm:(id)programm withReplaceWithCurrencies:(NSArray*)currensies{

    id retProgramm = nil;
    NSMutableArray *mutableProgramm = nil;
    
    //first check for function (if its dictionary)
    BOOL isFunction = NO;
    if([programm isKindOfClass:[NSDictionary class]]){
        //if there is function or maybe constant
        //NSLog(@"Was dictionary");

        NSString *keyTitle = [[programm allKeys]firstObject];
        id valueProg = [programm objectForKey:keyTitle];
        if([valueProg isKindOfClass:[NSArray class]]){
            mutableProgramm = [valueProg mutableCopy];
            
            isFunction = YES;
        }
    } else  if ([programm isKindOfClass:[NSArray class]]){
        mutableProgramm = [programm mutableCopy];
    }
    
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
                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                    obj = [ACalcBrain programm:obj withReplaceWithCurrencies:currensies];
                    [mutableProgramm replaceObjectAtIndex:i withObject:obj];

                }
            }
            if(isFunction){
                NSString *keyTitle = [[programm allKeys]firstObject];
                NSDictionary *newFunc = [[NSDictionary alloc] initWithObjectsAndKeys:[mutableProgramm copy], keyTitle, nil];
                retProgramm = newFunc;
            } else {
                retProgramm = [mutableProgramm copy];
            }
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
    //NSLog(@"getNextArguInStack stack: %@",stack);
    
    NSMutableArray *arguArray = [[NSMutableArray alloc] init];
    NSMutableArray *backwardArguArray = [[NSMutableArray alloc] init];
    id nexTopOfStack = [stack lastObject];
    
    
    //chek if looking for whole list of operation including functions
    BOOL isLookForFunc = NO;
    id firstOfOperations = [operations firstObject];
    if(firstOfOperations && [firstOfOperations isKindOfClass:[NSString class]] && [firstOfOperations isEqualToString:@"xʸ"]){ //just first position in whole list of operation
        isLookForFunc = YES;
    }
    
    
    //NSLog(@"getNextArguInStack nextTop:%@", nexTopOfStack);
    while (nexTopOfStack) {
        if([nexTopOfStack isKindOfClass:[NSString class]] && [operations containsObject:nexTopOfStack]){
            break;
        } else if(isLookForFunc){//check for function and nextTopOfStack is function break too
            //check if nextTopOfStack is function
            if([nexTopOfStack isKindOfClass:[NSDictionary class]] && ([ACalcBrain checkWichArgumentsHasFunc:nexTopOfStack] != NoArgument)){
                break;
            } else {
                [stack removeLastObject];
                [backwardArguArray addObject:nexTopOfStack];
                nexTopOfStack = [stack lastObject];
            }
            
            
        } else {
            [stack removeLastObject];
            [backwardArguArray addObject:nexTopOfStack];
            nexTopOfStack = [stack lastObject];
        }
    }
    //NSLog(@"getNextArguInStack backwardArguArray: %@",backwardArguArray);

    id objFromBackwardArguArray = [backwardArguArray lastObject];
    while (objFromBackwardArguArray) {
        [arguArray addObject:objFromBackwardArguArray];
        [backwardArguArray removeLastObject];
        objFromBackwardArguArray = [backwardArguArray lastObject];
    }
    //NSLog(@"getNextArguInStack arguArray: %@",arguArray);


    return arguArray;
}
//change baseline and font size for mutable string
+(NSAttributedString*)changeForString:(NSAttributedString*)inputAttrStr fontSizeWith:(CGFloat)devider andBaseLine:(CGFloat)multiplier
//if need bottom baseline -  multiplier is minus value
{
    NSAttributedString *retStr;
    @autoreleasepool {
        NSMutableAttributedString* mutInStr = [inputAttrStr mutableCopy];
        [mutInStr beginEditing];
        //NSRange wholeRange = NSMakeRange(0, [mutAttArg length]);
        for(NSInteger i = 0;i < [mutInStr length]; i++){
            NSDictionary *wasAttributes = [mutInStr attributesAtIndex:i effectiveRange:NULL];
            UIFont *wasAttrFont = [wasAttributes valueForKey:NSFontAttributeName];
            UIFont *newAttrFont = [UIFont fontWithName:wasAttrFont.fontName size:(wasAttrFont.pointSize / devider)];
            
            CGFloat wasBaseLine = [[wasAttributes valueForKey:NSBaselineOffsetAttributeName] floatValue];
            NSNumber *newBaseLineOffsetTop =[NSNumber numberWithFloat: wasBaseLine + wasAttrFont.pointSize * multiplier];
            NSRange eachSymbolRange = NSMakeRange(i,1);
            [mutInStr addAttribute:NSFontAttributeName value:newAttrFont range:eachSymbolRange];
            [mutInStr addAttribute:NSBaselineOffsetAttributeName value:newBaseLineOffsetTop range:eachSymbolRange];
            
            
        }
        [mutInStr endEditing];
        retStr = [mutInStr copy];
    }
    
    return retStr;
}
#pragma mark _END_HELPED_FUNCTIONS_____________________________________________________

//open bracket makes new stack and add is as last obj to programStack, at close bracket remove this stack and added in previous stack like obj
-(void) insertBracket:(BOOL)isRigthOpen
{
    if(isRigthOpen){
        NSMutableArray *nextStack = [[NSMutableArray alloc] init];
        NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
        //NSLog(@"InsertBracet programStacks: %@",self.programStacks);
        [programCopy addObject:nextStack];
        self.programStacks = [programCopy copy];
        NSLog(@"InsertBracet programStacks: %@",self.programStacks);
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
}

//to exeprt double operation
-(void) checkToExceptDoubleOperation
{
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    NSArray * checkingArray = [NSArray arrayWithObjects:   /*@"xʸ",@"yˣ",@"ʸ√x",@"ˣ√y",@"logʸ",*/@"÷", @"×",@"-", @"+", nil];
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
    //NSLog(@"applyArgu programStack %@", self.programStacks);
    //NSLog(@"applyArgu arguStack %@", self.arguStack);
    
    //check if function is waiting for Y
    
    if([self waitingFor_Y_Argu]){//find argu before function and put its copy back after function
        /*
        NSMutableArray *nextCopyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
        id lastOfArgu = [nextCopyArgu lastObject];
        if(lastOfArgu){
            [nextCopyArgu removeLastObject];
            
            lastOfArgu = [nextCopyArgu lastObject];
            
            //if there is not strongly argu -
            if(lastOfArgu && [lastOfArgu isKindOfClass:[NSNumber class]] && ([lastOfArgu integerValue] == NSNotFound)){
                //remove mark of "not strolgly"
                //NSLog(@"remove mark of not strolgly");
                [nextCopyArgu removeLastObject];
                //and then get next
                lastOfArgu = [nextCopyArgu lastObject];
            } else {
                //NSLog(@"nothing was removed");
            }
        }
        
        if(lastOfArgu){
            [copyArgu addObject:[lastOfArgu copy]];
        } else {
            [copyArgu addObject:@0];
        }
        */
        
    }
    
    for(int i = 0; i < [copyArgu count]; i++){
        [programCopy.lastObject addObject:copyArgu[i]];
    }
    self.programStacks = [programCopy copy];
    self.arguStack = [copyArgu copy];
    
    //NSLog(@"After applyArgu programStack %@", self.programStacks);
    //NSLog(@"After applyArgu arguStack %@", self.arguStack);
    
}


-(void) getResultAndPutAsArguByPriotiy:(int)priority
{
    [self clearArgu];
    
    NSMutableArray *newSubStackBackward = [[NSMutableArray alloc] init];
    NSMutableArray *newSubStack = [[NSMutableArray alloc] init];
    NSMutableArray *copyCurrentStack = [self.program mutableCopy];
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

-(double) count
{
    
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    //NSLog(@"count programStack %@", self.programStacks);
    //NSLog(@"count program %@", self.program);
    [self applyArgu];
    //set result stack as new argument
    [self getResultAndPutAsArguByPriotiy:0];
    //NSLog(@"count program after applyArgu and getResult %@", self.program);
    double result = [self countWithStack:self.program];
    if([self.programStacks count] > 1){
        [programCopy removeLastObject];
    } else {
        [programCopy.lastObject removeAllObjects];
    }
    self.programStacks = [programCopy copy];
    //NSLog(@"count programCopy after %@", programCopy);
    
    return result;
}

-(double) countWithStack:(id) stack
{
    return [ACalcBrain runProgram:stack usingVariableValue:self.variableValue];
}


#pragma mark RUN PROGRAN
+(double) runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
         stack = [ACalcBrain deepArrayCopy:program];
    }
    return [self popOperandOfStack:stack];
}

+(double) runProgram:(id)program usingVariableValue:(NSDictionary *)variableValues
{
    return [self runProgram:program usingVariableValue:variableValues withPriority:0];
}

+(double) runProgram:(id)program usingVariableValue:(NSDictionary *)variableValues withPriority: (NSInteger) priority
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [[ACalcBrain deepArrayCopy:program] mutableCopy];
    }

    //NSLog(@"runProgram stack %@", stack);
    stack = [self arrayFromArray:stack WithValueFromVariabledictionary:variableValues];
    //NSLog(@"runProgram second stack %@", stack);

    return [self popOperandOfStack:stack accordingPriority:priority];
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

+(double) popOperandOfStack:(NSMutableArray*) stack
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0];
}

+(double) popOperandOfStack:(NSMutableArray*) stack accordingPriority:(int) priority
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:priority];
}

+(double) popOperandOfStack: (NSMutableArray*) stack withPreviousValue: (NSNumber*) value accordingPriority: (NSInteger) priority
{
    double result = 0.0;
    //NSLog(@"popOperandOfStack Stack:%@",  stack);
    //NSLog(@"popOperandOfStack Value:%@", value);
    
    if(![stack isKindOfClass:[NSMutableArray class]]){
        stack = [stack mutableCopy];
    }

    id topOfStack = [stack lastObject];
    //NSLog(@"popOperandOfStack topOfStack:%@",  topOfStack);

    if(topOfStack){
        [stack removeLastObject];
        
    } else if (value){
        result = [value doubleValue];
    }

    //NSLog(@"popOperandOfStack topOfStack:%@",  stack);
    if([topOfStack isKindOfClass:[NSDictionary class]]){
        //if it is constant or function
        //NSLog(@"there is constant or function in popOperandOfStack");
        NSString *key = [[topOfStack allKeys]firstObject];
        //NSLog(@"keyTitle: %@",key);
        id valueProg = [topOfStack objectForKey:key];
        if([valueProg isKindOfClass:[NSNumber class]]){//if there is conctant
            result = [self popOperandOfStack:stack withPreviousValue:valueProg accordingPriority:priority];
        } else if ([valueProg isKindOfClass:[NSArray class]]){
            if([valueProg containsObject:@"°"]){
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:[self popOperandOfStack:[valueProg mutableCopy]]] accordingPriority:priority];
            } else {
                id lastObj = [valueProg lastObject];
                if(lastObj && [lastObj isKindOfClass:[NSArray class]]){
                    
                    //may be it's a function
                    FuncArguments funcArguments = [ACalcBrain checkWichArgumentsHasFunc:topOfStack];
                    
                    //if no arguments may be it's no function
                    if(funcArguments == NoArgument){//this is just constant as array
                        result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:[self popOperandOfStack:topOfStack]] accordingPriority:priority];
                    } else {
                        //1. check for priority
                        int operationPriority = [ACalcBrain getPriorityOf:topOfStack];

                        if((priority <= 2) && (priority > operationPriority)){//for +,-,/,*
                            if(value){
                                result = [value doubleValue];
                                [stack addObject:topOfStack];
                            } else {
                                result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:(priority-1)];
                            }
                        } else if((priority > 2) && (priority >= operationPriority)){//for anothers operation and functions
                            if(value){
                                result = [value doubleValue];
                                [stack addObject:topOfStack];
                                
                            } else {
                                [stack addObject:topOfStack];
                                result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:(priority-1)];
                            }
                            
                        } else {

                        NSNumber *funcResult;
                        NSArray* replacedArray = lastObj;
                        //NSLog(@"pop argument %@",[NSNumber numberWithDouble:arg]);
                            
                        //if X argument
                        if ((funcArguments == XOnlyArgu)||(funcArguments == X_and_Curr_Argu)){
                            double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                            //NSLog(@"Argu to X %@", [NSNumber numberWithDouble:arg]);
                            replacedArray = [ACalcBrain programm:lastObj replaceString:@"x" withObj:[NSNumber numberWithDouble:arg]];
                            funcResult = [NSNumber numberWithDouble:[self popOperandOfStack:[replacedArray mutableCopy]]];
                         
                        //if X argument
                        } else if ((funcArguments==YOnlyArgu)||(funcArguments==Y_and_Curr_Argu)||(funcArguments==X_and_Y_Argu)||(funcArguments==AllArgues)){
                            if(!value){
                                //if no value just put previous argu as result
                                funcResult = [NSNumber numberWithDouble:[self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3]];
                                
                                
                                NSLog(@"there is no value for y!");
                            } else {
                                replacedArray = [ACalcBrain programm:lastObj replaceString:@"y" withObj:value];
                                //check if it was strongly argu
                                id topOfStack = [stack lastObject];
                                //NSLog(@"top of stack before Y: %@", topOfStack);
                                BOOL noStronglyArguBeforeY = NO;
                                
                                if(topOfStack && [topOfStack isKindOfClass:[NSNumber class]] && (
                                   ([topOfStack integerValue]==NSNotFound) ||
                                   ([topOfStack integerValue]==0)
                                   )){
                                        noStronglyArguBeforeY = YES;
                                    //[stack removeLastObject];
                                    NSLog(@"was no argu");

                                }
                                
                                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                                if(noStronglyArguBeforeY || arg == 0.0){
                                    funcResult = [NSNumber numberWithDouble:[self popOperandOfStack:[replacedArray mutableCopy]]];
                                } else {
                                    //if there is strongly argu before Y - multiply function on this arg

                                    funcResult = [NSNumber numberWithDouble:(arg * [self popOperandOfStack:[replacedArray mutableCopy]])];
                                }
                            }
                            
                        } else if (funcArguments == CurrOnlyArgu){
                            BOOL noStronglyArguBeforeY = NO;
                            
                            if(topOfStack && [topOfStack isKindOfClass:[NSNumber class]] && (
                                                                                             ([topOfStack integerValue]==NSNotFound) ||
                                                                                             ([topOfStack integerValue]==0)
                                                                                             )){
                                noStronglyArguBeforeY = YES;
                            }
                            
                            double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                            if(noStronglyArguBeforeY || arg == 0.0){
                                NSLog(@"Curr lastObj: %@", lastObj);
                                funcResult = [NSNumber numberWithDouble:[self popOperandOfStack:lastObj]];
                            } else {
                                //if there is strongly argu before Y - multiply function on this arg
                                funcResult = [NSNumber numberWithDouble:(arg * [self popOperandOfStack:lastObj])];
                            }
                        }
                        result = [self popOperandOfStack:stack
                                       withPreviousValue:funcResult
                                       accordingPriority:priority];

                        }
                    }
                }
            }
        }
        
        

    }else if([topOfStack isKindOfClass:[NSArray class]]){
        
        //if its not strongly argu for Y
        if([topOfStack lastObject] && [[topOfStack lastObject] isKindOfClass:[NSNumber class]] && ([[topOfStack lastObject] integerValue]==NSNotFound)){
            [topOfStack removeLastObject];
            result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:[self popOperandOfStack:topOfStack]] accordingPriority:priority];
        } else
        
        if([(NSArray*)topOfStack count]==4 && [topOfStack[0] isKindOfClass:[NSString class]]&&[topOfStack[0] isEqualToString:@"$"]){
            //if there is exhange currency rate
            NSNumber *exchangeRate = (NSNumber*)[topOfStack lastObject];
            double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
            if(arg == 0.0) {
                result = [self popOperandOfStack:stack withPreviousValue:exchangeRate accordingPriority:priority];
                NSLog(@"result from curr:%@",[NSNumber numberWithDouble:result]);
            } else {
                double exchangeRateDouble = [exchangeRate doubleValue];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * exchangeRateDouble)] accordingPriority:priority];
            }
            NSString *resStr = [NSString stringWithFormat:@"%.2f",result];
            result = [resStr doubleValue];
            
        } else {
            result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:[self popOperandOfStack:topOfStack]] accordingPriority:priority];
        }

    } else if([topOfStack isKindOfClass:[NSNumber class]]){
        
        if([topOfStack integerValue] == NSNotFound){//if there is not pushed by user argument
            
            topOfStack = [stack lastObject];
            //[stack removeLastObject];
            //NSLog(@"topOfStack %@",topOfStack);
            if(!topOfStack){
                result = 0;
                //NSLog(@"result - 0");
            } else {
                result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:priority];
               // NSLog(@"Result - next");
            }
            

        } else {
            result = [self popOperandOfStack:stack withPreviousValue:topOfStack accordingPriority:priority];
        }
    } else if([topOfStack isKindOfClass:[NSString class]]){
        
        NSString * operation = topOfStack;
        int operationPriority = [ACalcBrain getPriorityOf:operation];
       // NSLog(@"was_priority:%@, operation:%@, Priority: %@,  ",[NSNumber numberWithInteger:priority], operation,[NSNumber numberWithInteger:operationPriority]);
        //NSLog(@"Value: %@", value);
        if((priority <= 2) && (priority > operationPriority)){//for +,-,/,*
            if(value){
                result = [value doubleValue];
                //NSLog(@"Get result");
                [stack addObject:topOfStack];
                
            } else {

                result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:(priority-1)];
            }
        } else if((priority > 2) && (priority >= operationPriority)){//for anothers operation and functions
            if(value){
                result = [value doubleValue];
                //NSLog(@"Get result");
                [stack addObject:topOfStack];
                
            } else {
                 [stack addObject:topOfStack];
                result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:(priority-1)];
            }
            
            //think if topOfstack dosn't use put it back to stack for next operation
            //[stack addObject:topOfStack];
            //NSLog(@"AFTER %@",stack);
            //result = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:(priority-1)];
            
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
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                if(arg == 0.0) {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_E] accordingPriority:priority];
                } else {
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_E)] accordingPriority:priority];
                }
                
            } else if([operation isEqualToString:@"π"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                if(arg == 0.0) {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_PI] accordingPriority:priority];
                } else {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_PI)] accordingPriority:priority];
                }
                
            } else if ([operation isEqualToString:@"∓"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * -1.0)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"¹/x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1/arg] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x!"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                //make something toi exept not integer number
                arg = trunc(arg);
                double fac = [self factorial:arg];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:fac] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x²"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                NSLog(@"x² argu:%@",[NSNumber numberWithDouble:arg]);
                
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,2)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x³"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,3)] accordingPriority:priority];
                
            }  else if ([operation isEqualToString:@"2ˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(2,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"eˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(M_E,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"10ˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(10.,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"√x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sqrt(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"³√x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cbrt(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"lg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log10(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"log₂"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log2(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ln"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"xʸ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    //NSLog(@"there is VALUE for xy!");
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,[value doubleValue])] accordingPriority:priority];
                } else {
                   // NSLog(@"there is no value for xy!");

                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"yˣ"]){
                
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],arg)] accordingPriority:priority];
                } else {
                    result = arg;
                }
            } else if ([operation isEqualToString:@"ʸ√x"]){
                
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,1 / [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"ˣ√y"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],1 / arg)] accordingPriority:priority];
                } else {
                    result = arg;
                }
            } else if ([operation isEqualToString:@"logʸ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg) / log([value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"√x²+y²"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:hypot(arg,[value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
            } else if ([operation isEqualToString:@"D"] || [operation isEqualToString:@"R"]){
                double arg = 0;
                id nexTopOfStack = [stack lastObject];
                while (nexTopOfStack) {
                    [stack removeLastObject];
                    if([nexTopOfStack isKindOfClass:[NSString class]]){
                        if([nexTopOfStack isEqualToString:@"″"]){
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
                                arg += [nexTopOfStack doubleValue];
                            } else {
                                arg += 0;
                            }
                            
                        } else {
                            arg += 0; //for any case
                        }
                        arg +=0;
                    }
                    nexTopOfStack = [stack lastObject];
                }
                if([operation isEqualToString:@"R"]){
                    arg = arg * M_PI / 180;
                }
                 result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:arg] accordingPriority:priority];

            } else if ([operation isEqualToString:@"R"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1/arg] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rcos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rsin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rtg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rctg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dsin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg * M_PI / 180)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dcos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg * M_PI / 180)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dtg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                //double integerPart, factorialPart;
                //factorialPart = modf(arg, &integerPart);
                //if(factorialPart == 0){
                 //   if(
                    
               // } else {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg * M_PI / 180)] accordingPriority:priority];
               // }
                
            } else if ([operation isEqualToString:@"dctg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg * M_PI / 180)] accordingPriority:priority];

            } else if ([operation isEqualToString:@"racos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rasin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ratg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ractg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(1/arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dasin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dacos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"datg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dactg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble: atan(1/arg)  * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"sinh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sinh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"cosh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cosh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"tgh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tanh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ctgh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tanh(arg)] accordingPriority:priority];
                
            } else if([operation isEqualToString:@"×"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }

            } else if([operation isEqualToString:@"÷"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg / [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if([operation isEqualToString:@"+"]){
                
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg +[value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            }
            else if([operation isEqualToString:@"-"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg - [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if([operation isEqualToString:@"%"]){
                id nextTop = [stack lastObject];
                double arg;
                if(nextTop && [nextTop isKindOfClass:[NSArray class]]){
                    arg = [self popOperandOfStack:nextTop withPreviousValue:nil accordingPriority:1];
                    [stack removeLastObject];

                } else {
                    arg = 1.0;
                }
                double secondArg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                
                result = [self popOperandOfStack:stack
                               withPreviousValue:[NSNumber numberWithDouble:(arg*secondArg/100.)]
                               accordingPriority:priority];
            } else if ([operation isEqualToString:@".00"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:4];
                arg = round(arg *100) /100;
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:arg] accordingPriority:priority];
                
            }
        }
    }
    return result;
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
   // NSLog(@"Program in description: %@",program);
    id topOfStacs = [program lastObject];
    
    if(topOfStacs && (![topOfStacs isKindOfClass:[NSArray class]])){
        [atrStr insertAttributedString:[self popStringOfStack:program withNextArguString:empty withAttributes:atributes] atIndex:[atrStr length]];
    } else if (topOfStacs){
        [program removeLastObject];
        [atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:[atrStr length]];
        topOfStacs = [program lastObject];

        while (topOfStacs &&  [topOfStacs isKindOfClass:[NSArray class]]) {
            NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:atributes];
            [atrStr insertAttributedString:bracet atIndex:0];
            atrStr = [[self popStringOfStack:topOfStacs withNextArguString:atrStr withAttributes:atributes] mutableCopy];
            //[atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:0];
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
    //NSLog(@"argStr: %@", [argStr string]);

    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setMaximumFractionDigits:9];
    [format setMinimumFractionDigits:0];
    [format setExponentSymbol:@"e"];
    [format setZeroSymbol:@"0"];
    
    CGFloat insertBaseLine = [[attributes valueForKey:NSBaselineOffsetAttributeName] floatValue];
    
    //makes attributes for top line text and ...
    CGFloat fontDevider = 1.3;
    CGFloat baselineMultipier = 0.3;
    UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
    UIFont *newfont = [UIFont fontWithName:wasFont.fontName size:(wasFont.pointSize / fontDevider)];
    
    NSNumber *baseLineOffsetTop =[NSNumber numberWithFloat: insertBaseLine + wasFont.pointSize * baselineMultipier];
    NSNumber *baseLineOffsetButtom =[NSNumber numberWithFloat:  insertBaseLine - (wasFont.pointSize * baselineMultipier)];
    
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
    
    //works string with need attributes
    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes]; //helped string to solve several problem in next
    NSAttributedString *quesMark = [[NSAttributedString alloc] initWithString:@"?" attributes:attributes];
    NSAttributedString *closeBracket = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
    NSAttributedString *openBracket = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
    
    
    if([topOfStack isKindOfClass:[NSDictionary class]]){
        //if it is constant or function created by user
        NSString *key = [[topOfStack allKeys]firstObject];
        //NSLog(@"keyTitle: %@",key);
        id valueProg = [topOfStack objectForKey:key];
        //NSLog(@"valueProg: %@",valueProg);

        if([valueProg isKindOfClass:[NSNumber class]]){//if there is conctant
            //NSLog(@"but valueProg is recognized as number");
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:key attributes:attributes];
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        } else {
            //make mutableAttributed name of function or constant
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:key attributes:attributes];
            //1. check if key hase atributes another case it's konstant with array
            NSRange bracketOpenRange = [key rangeOfString:@"(" options:NSBackwardsSearch];
            //it's important search from and case user insert brackets in name
            NSRange bracketCloseRange = [key rangeOfString:@")" options:NSBackwardsSearch];
            
            if((bracketOpenRange.location != NSNotFound)&&(bracketCloseRange.location != NSNotFound)){ //ok maybe there is variables
                NSRange rangeOfPossibleVariables = NSMakeRange(bracketOpenRange.location+1, bracketCloseRange.location-bracketOpenRange.location -1);
                //check is there x,y, $ variables
                //possible big mistake if user for constasnt insert "(x)" at the end
                NSRange xRangeInStrBetwinBrackets = [key rangeOfString:@"x" options:NSLiteralSearch range:rangeOfPossibleVariables];
                NSRange yRangeInStrBetwinBrackets = [key rangeOfString:@"y" options:NSLiteralSearch range:rangeOfPossibleVariables];
                NSRange currensyRangeInStrBetwinBrackets = [key rangeOfString:@"$" options:NSLiteralSearch range:rangeOfPossibleVariables];
                //if there is no variables betwin final brackets
                if((xRangeInStrBetwinBrackets.location == NSNotFound) && (yRangeInStrBetwinBrackets.location == NSNotFound) && (currensyRangeInStrBetwinBrackets.location == NSNotFound)){
                    //there is no variables
                    
                    resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                    
                } else {
                    //if there is x beetwin last brackets
                    if(xRangeInStrBetwinBrackets.location != NSNotFound){
                        //find argu of function
                        NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                        //replace 'x' with argument
                        id lastObjInArgu = [arguArray lastObject];
                        if(lastObjInArgu && [lastObjInArgu isKindOfClass:[NSNumber class]] &&([lastObjInArgu integerValue]==NSNotFound)){
                            [arguArray removeLastObject];
                            if([arguArray count]==0){
                                arguArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0.0], nil];
                            }
                            
                        }
                        
                        NSMutableAttributedString * mutArgStr = [[self popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes] mutableCopy];
                        
                        //if there is array with open and close brackets - delete brackets
                        NSRange firstCharacterRange = NSMakeRange(0, 1);
                        NSString *firstCharacterArgu = [mutArgStr.string substringWithRange:firstCharacterRange];
                        NSRange lastCharacterRange = NSMakeRange([mutArgStr.string length]-1, 1);
                        NSString *lastCharacterArgu = [mutArgStr.string substringWithRange:lastCharacterRange];
                        if([firstCharacterArgu isEqualToString:@"("] && [lastCharacterArgu isEqualToString:@")"]){
                            //first delete last element another case it'll be not right range
                            [mutArgStr deleteCharactersInRange:lastCharacterRange];
                            [mutArgStr deleteCharactersInRange:firstCharacterRange];
                        }
                        
                        
                        [attArg replaceCharactersInRange:xRangeInStrBetwinBrackets withAttributedString:[mutArgStr copy]];
                        
                        //check the lenght of argu stack if more then one add brackets
                        NSArray *testArray = [[NSArray alloc] init];
                        testArray = [arguArray copy];
                        if([testArray count] > 1){
                            [attArg insertAttributedString:closeBracket atIndex:0];
                            [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                               withNextArguString:empty
                                                                   withAttributes:attributes] atIndex:0];
                            [attArg insertAttributedString:openBracket atIndex:0];
                        } else {
                            [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                               withNextArguString:empty
                                                                   withAttributes:attributes] atIndex:0];
                        }
                        //if next top of stack is waiting as argu - insert brackets
                        if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                            [attArg insertAttributedString:openBracket atIndex:0];
                            [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                        }
                        
                        resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                        
                        
                    }
                    
                    if(yRangeInStrBetwinBrackets.location != NSNotFound){
                        
                    
                        NSMutableAttributedString* mutAttArg = [argStr mutableCopy];

                        if([argStr.string isEqualToString:@""]){//if there is empty argument array
                            [mutAttArg insertAttributedString:quesMark atIndex:0];//add question mark
                        }
                        
                        //if there is array with open and close brackets - delete brackets
                        NSRange firstCharacterRange = NSMakeRange(0, 1);
                        NSString *firstCharacterArgu = [mutAttArg.string substringWithRange:firstCharacterRange];
                        NSRange lastCharacterRange = NSMakeRange([mutAttArg.string length]-1, 1);
                        NSString *lastCharacterArgu = [mutAttArg.string substringWithRange:lastCharacterRange];
                        if([firstCharacterArgu isEqualToString:@"("] && [lastCharacterArgu isEqualToString:@")"]){
                            //first delete last element another case it'll be not right range
                            [mutAttArg deleteCharactersInRange:lastCharacterRange];
                            [mutAttArg deleteCharactersInRange:firstCharacterRange];
                        }
                        
                        //if next top of stack is waiting as argu - insert brackets
                        if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                            [mutAttArg insertAttributedString:openBracket atIndex:0];
                            [mutAttArg insertAttributedString:closeBracket atIndex:[mutAttArg length]];
                        }

                        [attArg replaceCharactersInRange:yRangeInStrBetwinBrackets withAttributedString:[mutAttArg copy]];
                       
                        id topArgu = [stack lastObject];
                        NSAttributedString *topArguString;
                        if(topArgu){
                            
                            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                            topArguString = [ACalcBrain popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes];
                             //NSLog(@"2PopStr topArguString %@", [topArguString string]);
                            if(![[topArguString string] isEqual:@"0"]){
                                [attArg insertAttributedString:topArguString atIndex:0];
                            }
                        }
                        //[attArg insertAttributedString:multiplyString atIndex:0];
                        resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                        
                        
                    }
                    
                    if(currensyRangeInStrBetwinBrackets.location != NSNotFound){
                        
                        NSString *currensiesString = @"";
                        //find all currensies exchange and make new string for it
                        NSMutableArray* currArray = [[ACalcBrain chekForCurrensiesProgramm:topOfStack] mutableCopy];
                        while ([currArray firstObject]) {
                            
                        
                            id elementCurrArray = [currArray firstObject];
                            [currArray removeObjectAtIndex:0];
                            if(elementCurrArray && [elementCurrArray isKindOfClass:[NSArray class]]){
                            //check if we talk about currensies
                                id first = [elementCurrArray firstObject];
                                if(first && [first isKindOfClass:[NSString class]]&&[first isEqualToString:@"$"]){
                                    currensiesString = [currensiesString stringByAppendingString:elementCurrArray[1]];
                                    currensiesString = [currensiesString stringByAppendingString:@"/"];
                                    currensiesString = [currensiesString stringByAppendingString:elementCurrArray[2]];
                                }
                            }
                            
                            //if more then one pair
                            if([currArray firstObject]){
                                currensiesString = [currensiesString stringByAppendingString:@","];
                            }
                        }
                        

                        // NSLog(@"currString %@",currensiesString);
                        NSAttributedString *curAtrStr = [[NSAttributedString alloc] initWithString:currensiesString attributes:attributes];
                        
                        [attArg replaceCharactersInRange:currensyRangeInStrBetwinBrackets withAttributedString:curAtrStr];
                        
                        //insert previous argu
                        id topArgu = [stack lastObject];
                        NSAttributedString *topArguString;
                        if(topArgu){
                            
                            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                            topArguString = [ACalcBrain popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes];
                            //NSLog(@"2PopStr topArguString %@", [topArguString string]);
                            if(![[topArguString string] isEqual:@"0"]){
                                [attArg insertAttributedString:topArguString atIndex:0];
                            }
                        }
                        
                        resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                    }
                }

                
            } else { //this is just constant as array
                resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
            }



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
            
            
            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
            NSMutableAttributedString *attArg = [openBracket mutableCopy];

            
            id nextTopOfStack = [arguArray lastObject];
            if(nextTopOfStack && [nextTopOfStack isKindOfClass:[NSNumber class]] && ([nextTopOfStack doubleValue] == 0)){
                [arguArray removeLastObject];
            }

            //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
            [attArg insertAttributedString:[self popStringOfStack:arguArray
                                               withNextArguString:empty
                                                   withAttributes:attributes] atIndex:[attArg length]];
            
            [attArg insertAttributedString:fromCurAttrStr atIndex:[attArg length]];
            [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
            [attArg insertAttributedString:toCurAttrStr atIndex:[attArg length]];
            resultStr = [[self popStringOfStack:stack
                             withNextArguString:attArg
                                 withAttributes:attributes] mutableCopy];
            
        } else {
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
            //for gradus view
            id topOfTopArray = [topOfStack lastObject];
            if(topOfTopArray && [topOfTopArray isKindOfClass:[NSString class]]){
                if([topOfTopArray isEqualToString:@"D"] || [topOfTopArray isEqualToString:@"R"]){
                    [topOfStack removeLastObject];
                    NSArray *copyGrad = [topOfStack copy];
                    for(int i = 0; i < [copyGrad count]; i++){
                        if([copyGrad[i] isKindOfClass:[NSNumber class]]){
                            NSAttributedString * grad = [[NSAttributedString alloc] initWithString:[copyGrad[i] stringValue] attributes:attributes];
                            [attArg insertAttributedString:grad atIndex:[attArg length]];
                        } else if([copyGrad[i] isKindOfClass:[NSString class]]){
                            NSAttributedString * grad = [[NSAttributedString alloc] initWithString:copyGrad[i] attributes:attributes];
                            [attArg insertAttributedString:grad atIndex:[attArg length]];
                        }
                    }
                } else {
                    NSMutableArray *mutTopOfStack = [topOfStack mutableCopy];
                    [attArg insertAttributedString:[self popStringOfStack:mutTopOfStack
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];

                }
            } else {
            
                NSMutableArray *mutTopOfStack = [topOfStack mutableCopy];
                [attArg insertAttributedString:[self popStringOfStack:mutTopOfStack
                                                   withNextArguString:empty
                                                       withAttributes:attributes] atIndex:0];
            
            }
            [attArg insertAttributedString:openBracket atIndex:0];
            [attArg insertAttributedString:closeBracket atIndex:[attArg length]];

            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        }
        
    } else if ([topOfStack isKindOfClass:[NSNumber class]]){

        if([topOfStack integerValue]==NSNotFound){
            if([stack count] == 0){
                NSAttributedString *zeroNumber = [[NSAttributedString alloc] initWithString:@"0" attributes:attributes];
                resultStr = [[self popStringOfStack:stack withNextArguString:zeroNumber withAttributes:attributes] mutableCopy];
            } else {
                resultStr = [[self popStringOfStack:stack withNextArguString:empty withAttributes:attributes]mutableCopy];
            }
            
        } else {
            NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];

            
            /*
            NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
             //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
             //replace 'x' with argument
             id lastObjInArgu = [arguArray lastObject];
             if(lastObjInArgu && [lastObjInArgu isKindOfClass:[NSNumber class]] &&([lastObjInArgu integerValue]==NSNotFound)){
            [arguArray removeLastObject];
            if([arguArray count]==0){
                arguArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0.0], nil];
            }
            
             }
             [attArg replaceCharactersInRange:xRangeInStrBetwinBrackets withAttributedString:[self popStringOfStack:arguArray
                                                                                            withNextArguString:empty
                                                                                                withAttributes:attributes]];
        
             resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
            */

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
                [attArg insertAttributedString:closeBracket atIndex:0];
                [attArg insertAttributedString:number atIndex:0];
                [attArg insertAttributedString:openBracket atIndex:0];
                
            } else {
                [attArg insertAttributedString:number atIndex:0];
            }
            resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        }

    } else if ([topOfStack isKindOfClass:[NSString class]]) {
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
                //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
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
                //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
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
                
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
               // }
                resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"∓"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@" × (-1)" attributes:attributes];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    [attArg insertAttributedString:closeBracket atIndex:0];

                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                    
                } else {
                    id lastObj = [arguArray lastObject];
                    if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                        [arguArray removeLastObject];
                        double argDouble = trunc([lastObj doubleValue]);
                        [arguArray addObject:[NSNumber numberWithDouble:argDouble]];
                    }

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
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];

                } else {
                    id lastObj = [arguArray lastObject];
                    if(lastObj && [lastObj isKindOfClass:[NSNumber class]]){
                        [arguArray removeLastObject];
                        double argDouble = trunc([lastObj doubleValue]);
                        [arguArray addObject:[NSNumber numberWithDouble:argDouble]];
                    }
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
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else { */
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                
                NSAttributedString * value = [[NSAttributedString alloc] initWithString:@"1/" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"x²"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"2" attributes:attributes];
                //change font size and baseline for arg string
                attArg = [[ACalcBrain changeForString:[attArg copy]
                                            fontSizeWith:fontDevider
                                             andBaseLine:baselineMultipier] mutableCopy];
                
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                } else {
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }
                
                
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"x³"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
               // NSLog(@"yˣ stack:%@", stack);
               // NSLog(@"yˣ arguArray:%@", arguArray);
                //NSLog(@"yˣ argstr:%@", [argStr string]);

                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"3" attributes:attributes];
                //change font size and baseline for arg string
                attArg = [[ACalcBrain changeForString:[attArg copy]
                                         fontSizeWith:fontDevider
                                          andBaseLine:baselineMultipier] mutableCopy];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                } else {
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }

                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"2ˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];

                NSAttributedString *two = [[NSAttributedString alloc]initWithString:@"2" attributes:attributes];
                [attArg insertAttributedString:two atIndex:0];
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }

                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"eˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];
                
                NSAttributedString *e = [[NSAttributedString alloc]initWithString:@"e" attributes:attributes];
                [attArg insertAttributedString:e atIndex:0];
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }

                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            }  else if([topOfStack isEqualToString:@"10ˣ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                [attArg beginEditing];
                NSRange wholeRange = NSMakeRange(0, [attArg length]);
                [attArg addAttribute:NSFontAttributeName value:newfont range:wholeRange];
                [attArg addAttribute:NSBaselineOffsetAttributeName value:baseLineOffsetTop range:wholeRange];
                [attArg endEditing];
                
                NSAttributedString *ten = [[NSAttributedString alloc]initWithString:@"10" attributes:attributes];
                [attArg insertAttributedString:ten atIndex:0];
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }

                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"√x"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                NSAttributedString *sqrt = [[NSAttributedString alloc]initWithString:@"√" attributes:attributes];
                [attArg insertAttributedString:sqrt atIndex:0];
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }
                
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

            } else if([topOfStack isEqualToString:@"³√x"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@")" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    bracet = [bracet initWithString:@"(" attributes:attributes];
                    [attArg insertAttributedString:bracet atIndex:0];
                } else {*/
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                //}
                NSMutableAttributedString *cqrtMut = [[NSMutableAttributedString alloc]initWithString:@"3" attributes:attributes];
                //change font size and baseline for arg string
                cqrtMut = [[ACalcBrain changeForString:[cqrtMut copy]
                                            fontSizeWith:fontDevider
                                             andBaseLine:baselineMultipier] mutableCopy];
                //add root mark
                NSAttributedString *rootMark = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                [cqrtMut insertAttributedString:rootMark atIndex:[cqrtMut length]];
                
                [attArg insertAttributedString:[cqrtMut copy] atIndex:0];
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }
                
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

            } else if([topOfStack isEqualToString:@"lg"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSAttributedString *arguArrayString =[self popStringOfStack:arguArray
                                                         withNextArguString:empty
                                                             withAttributes:attributes];
                
                NSRange bracketOpenRange = [[arguArrayString string] rangeOfString:@"(" options:0];
                //it's important search from and case user insert brackets in name
                NSRange bracketCloseRange = [[arguArrayString string] rangeOfString:@")" options:NSBackwardsSearch];
                
                NSMutableAttributedString *attArg = [empty mutableCopy];
                
                if(bracketOpenRange.location == 0 && bracketCloseRange.location == ([arguArrayString length]-1)){//if there is array - not put brackets
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                } else {
                    
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];

                }
                
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"lg" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"log₂"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSAttributedString *arguArrayString =[self popStringOfStack:arguArray
                                                         withNextArguString:empty
                                                             withAttributes:attributes];
                
                NSRange bracketOpenRange = [[arguArrayString string] rangeOfString:@"(" options:0];
                //it's important search from and case user insert brackets in name
                NSRange bracketCloseRange = [[arguArrayString string] rangeOfString:@")" options:NSBackwardsSearch];
                
                NSMutableAttributedString *attArg = [empty mutableCopy];
                
                if(bracketOpenRange.location == 0 && bracketCloseRange.location == ([arguArrayString length]-1)){//if there is array - not put brackets
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                } else {
                    
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                    
                }
                
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"log₂" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
                
            } else if([topOfStack isEqualToString:@"ln"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSAttributedString *arguArrayString =[self popStringOfStack:arguArray
                                                         withNextArguString:empty
                                                             withAttributes:attributes];
                
                NSRange bracketOpenRange = [[arguArrayString string] rangeOfString:@"(" options:0];
                //it's important search from and case user insert brackets in name
                NSRange bracketCloseRange = [[arguArrayString string] rangeOfString:@")" options:NSBackwardsSearch];
                
                NSMutableAttributedString *attArg = [empty mutableCopy];
                
                if(bracketOpenRange.location == 0 && bracketCloseRange.location == ([arguArrayString length]-1)){//if there is array - not put brackets
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                } else {
                    
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:arguArrayString atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                    
                }
                
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"ln" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];

     
            } else if([hiperbolic containsObject: topOfStack]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [closeBracket mutableCopy];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    
                } else {
                    //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                }
                //NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
                [attArg insertAttributedString:openBracket atIndex:0];
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:topOfStack attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
                
            } else if([topOfStack isEqualToString:@"xʸ"]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                //NSLog(@"xʸ arguArray %@",arguArray);
                
                //if there is no comples argu - add question mark
                NSMutableAttributedString* mutAttArg = [[ACalcBrain addQuestionMarkInString:argStr
                                                                             WithAttributes:attributes] mutableCopy];
                //change font size and baseline for arg string
                mutAttArg = [[ACalcBrain changeForString:[mutAttArg copy]
                                           fontSizeWith:fontDevider
                                             andBaseLine:baselineMultipier] mutableCopy];
                
                NSMutableAttributedString *attArg = [empty mutableCopy];
                [attArg insertAttributedString:mutAttArg atIndex:0];
                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                
                if([testArray count] > 1){

                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];

                    [attArg insertAttributedString:openBracket atIndex:0];
                } else {

                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }

                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:attArg
                                     withAttributes:attributes] mutableCopy];
                
            } else if([topOfStack isEqualToString:@"yˣ"]){
                
                //if there is no comples argu - add question mark to argu string
                NSMutableAttributedString* mutAttArg = [[ACalcBrain addQuestionMarkInString:argStr
                                                                             WithAttributes:attributes] mutableCopy];
                //NSLog(@"yˣ argStr:%@", [mutAttArg string]);
                //NSLog(@"yˣ topArgu:%@", [stack lastObject]);
                
                //get top pow
                id topArgu = [stack lastObject];
                //NSArray *topArguArray;
                NSAttributedString *topArguString;
                if(topArgu){
                    //topArguArray = [NSArray arrayWithObject:topArgu];
                    //topArguString = [ACalcBrain popStringOfStack:[topArguArray mutableCopy] withNextArguString:empty withAttributes:attributes];
                    
                    NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                    topArguString = [ACalcBrain popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes];
                    //set font for argu
                    //NSLog(@"yˣ topArguString:%@", [topArguString string]);
                    topArguString = [ACalcBrain changeForString:topArguString
                                                    fontSizeWith:fontDevider
                                                     andBaseLine:baselineMultipier];
                    

                    //insert at the end
                    [mutAttArg insertAttributedString:topArguString atIndex:[mutAttArg length]];
                    
                   // NSLog(@"yˣ mutArgStr after inserting:%@", [mutAttArg string]);
                    
                    //delte next argu
                    //[stack removeLastObject]; //remove lastArgu
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [mutAttArg insertAttributedString:openBracket atIndex:0];
                    [mutAttArg insertAttributedString:closeBracket atIndex:[mutAttArg length]];
                }
                
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:[mutAttArg copy]
                                                          withAttributes:attributes] atIndex:0];
                
                
            } else if([topOfStack isEqualToString:@"ʸ√x"]){
               
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                
                //if there is no comples argu - add question mark
                NSMutableAttributedString* mutAttArg = [[ACalcBrain addQuestionMarkInString:argStr
                                                                             WithAttributes:attributes] mutableCopy];
                //change font size and baseline for arg string
                mutAttArg = [[ACalcBrain changeForString:[mutAttArg copy]
                                            fontSizeWith:fontDevider
                                             andBaseLine:baselineMultipier] mutableCopy];
                
                //add root mark
                NSAttributedString *rootMark = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                [mutAttArg insertAttributedString:rootMark atIndex:[mutAttArg length]];

                
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                
                if([testArray count] > 1){
                    
                    [mutAttArg insertAttributedString:closeBracket atIndex:0];
                    [mutAttArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:[mutAttArg length]];
                    
                    [mutAttArg insertAttributedString:openBracket atIndex:0];
                } else {
                    
                    [mutAttArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:[mutAttArg length]];
                    
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [mutAttArg insertAttributedString:openBracket atIndex:0];
                    [mutAttArg insertAttributedString:closeBracket atIndex:[mutAttArg length]];
                }
                
                resultStr = [[self popStringOfStack:stack
                                 withNextArguString:mutAttArg
                                     withAttributes:attributes] mutableCopy];

                
            } else if([topOfStack isEqualToString:@"ˣ√y"]){

                //if there is no comples argu - add question mark to argu string
                NSMutableAttributedString* mutAttArg = [[ACalcBrain addQuestionMarkInString:argStr
                                                                             WithAttributes:attributes] mutableCopy];
                
                //get top pow
                id topArgu = [stack lastObject];
                //NSArray *topArguArray;
                NSAttributedString *topArguString;
                if(topArgu){
                    NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                    topArguString = [ACalcBrain popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes];
                    //set font for argu
                    //NSLog(@"yˣ topArguString:%@", [topArguString string]);
                    topArguString = [ACalcBrain changeForString:topArguString
                                                   fontSizeWith:fontDevider
                                                    andBaseLine:baselineMultipier];
                    //add root mark
                    @autoreleasepool {
                        NSAttributedString *rootMark = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                        NSMutableAttributedString *topStringMutable = [topArguString mutableCopy];
                        [topStringMutable insertAttributedString:rootMark atIndex:[topStringMutable length]];
                        topArguString = [topStringMutable copy];
                    }
                    
                    
                    //insert at the end
                    [mutAttArg insertAttributedString:topArguString atIndex:0];
                    
                    //delte next argu
                    //[stack removeLastObject]; //remove lastArgu
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [mutAttArg insertAttributedString:openBracket atIndex:0];
                    [mutAttArg insertAttributedString:closeBracket atIndex:[mutAttArg length]];
                }
                
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:[mutAttArg copy]
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"logʸ"]){
                //necessary get next argu from stack
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];

                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){
                    [resultStr insertAttributedString:closeBracket atIndex:0];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    [resultStr insertAttributedString:openBracket atIndex:0];
                } else {
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                
                //if there is no comples argu - add question mark
                argStr = [[ACalcBrain addQuestionMarkInString:argStr WithAttributes:attributes] mutableCopy];
                [attArg insertAttributedString:argStr atIndex:0];

                //change font size and baseline for arg string
                attArg = [[ACalcBrain changeForString:[attArg copy]
                                            fontSizeWith:fontDevider
                                             andBaseLine:(-baselineMultipier)] mutableCopy];

                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"log" attributes:attributes];
                [attArg insertAttributedString:value atIndex:0];
                [resultStr insertAttributedString:attArg atIndex:0];
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [attArg insertAttributedString:openBracket atIndex:0];
                    [attArg insertAttributedString:closeBracket atIndex:[attArg length]];
                }
                
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([topOfStack isEqualToString:@"√x²+y²"]){
                //necessary get next argu from stack
                //NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:nextOperations];
                
                NSAttributedString *plusMark = [[NSAttributedString alloc] initWithString:@" + " attributes:attributes];
                NSAttributedString *rootMark = [[NSAttributedString alloc] initWithString:@"√" attributes:attributes];
                NSAttributedString *twoNumber = [[NSAttributedString alloc] initWithString:@"2" attributes:attributes];
                twoNumber = [ACalcBrain changeForString:[twoNumber copy]
                                                      fontSizeWith:fontDevider
                                                       andBaseLine:baselineMultipier];
                
                NSAttributedString *yArguString = [ACalcBrain addQuestionMarkInString:argStr
                                                                        WithAttributes:attributes];
                
                NSMutableAttributedString *returnStr = [yArguString mutableCopy];
                [returnStr insertAttributedString:twoNumber atIndex:[returnStr length]];
                [returnStr insertAttributedString:closeBracket atIndex:[returnStr length]];
                [returnStr insertAttributedString:plusMark atIndex:0];
                [returnStr insertAttributedString:twoNumber atIndex:0];
                
                /*
                NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"²)" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                if([argStr.string isEqualToString:@""]){
                    [resultStr insertAttributedString:quesMark atIndex:0];

                } else {
                    [resultStr insertAttributedString:argStr atIndex:0];
                }
                
                value = [value initWithString:@"² + " attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                 */
                //get top xArgu
                id xArgu = [stack lastObject];
                NSAttributedString *xArguString;
                if(xArgu){
                    NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                    xArguString = [ACalcBrain popStringOfStack:arguArray withNextArguString:empty withAttributes:attributes];

                    //insert at the end
                    [returnStr insertAttributedString:xArguString atIndex:0];
                    [returnStr insertAttributedString:openBracket atIndex:0];
                    [returnStr insertAttributedString:rootMark atIndex:0];
                    
                    //delte next argu
                    //[stack removeLastObject]; //remove lastArgu
                }
                
                //if next top of stack is waiting as argu - insert brackets
                if([ACalcBrain isNeedBracketsForArgumentFromStack:[stack copy]]){
                    [returnStr insertAttributedString:openBracket atIndex:0];
                    [returnStr insertAttributedString:closeBracket atIndex:[returnStr length]];
                }
                /*
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if([testArray count] > 1){

                    [resultStr insertAttributedString:closeBracket atIndex:0];
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                    [resultStr insertAttributedString:openBracket atIndex:0];
                } else {
                    [resultStr insertAttributedString:[self popStringOfStack:arguArray
                                                          withNextArguString:empty
                                                              withAttributes:attributes] atIndex:0];
                }
                value = [value initWithString:@"√(" attributes:attributes];
                [resultStr insertAttributedString:value atIndex:0];
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:empty
                                                          withAttributes:attributes] atIndex:0];
                 */
                
                [resultStr insertAttributedString:[self popStringOfStack:stack
                                                      withNextArguString:[returnStr copy]
                                                          withAttributes:attributes] atIndex:0];
                
            } else if([trigonometrics containsObject:topOfStack]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [empty mutableCopy];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if(([testArray count] == 1) && [[arguArray lastObject] isKindOfClass:[NSArray class]]){
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                } else {

                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                }

                NSString* str = [topOfStack stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
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
                //NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
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
                    [attArg insertAttributedString:closeBracket atIndex:0];
                    [attArg insertAttributedString:[self popStringOfStack:arguArray
                                                       withNextArguString:empty
                                                           withAttributes:attributes] atIndex:0];
                    [attArg insertAttributedString:openBracket atIndex:0];
                } else {
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

