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
    ACalcBrain *newBrain = [[ACalcBrain alloc ] init];
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
        NSArray *keys = [NSArray arrayWithObjects:@"x",@"a",@"b", nil];
        NSNumber * value = [NSNumber numberWithDouble:0.00];
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

-(void) pushOperand:(id) operand
{
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
    }
    self.arguStack = [copyArgu copy];
}

-(double) performOperationInArgu:(NSString *)operation
{
    NSMutableArray *copyArgu = [ACalcBrain deepArrayCopy:self.arguStack];
    [copyArgu addObject:operation];
    self.arguStack = [copyArgu copy];
    int operationPriority = [ACalcBrain getPriorityOf:operation];
    return [ACalcBrain runProgram:self.argu usingVariableValue:self.variableValue withPriority:operationPriority];
}


-(double)perfomOperation: (NSString *)operation
{
    int operationPriority = [ACalcBrain getPriorityOf:operation];
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
    
    return [ACalcBrain runProgram:self.program usingVariableValue:self.variableValue withPriority:operationPriority];
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
    
    if(self.isStronglyArgu && ([copyArgu count] >0)){
        
        id topOfArguStack = [copyArgu lastObject];
        if(topOfArguStack){
           
            if([topOfArguStack isKindOfClass:[NSArray class]]){
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
        
        id topOfProgStack = [copyPogram.lastObject lastObject];
        if(topOfProgStack){
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

+(double) factorial: (double)n
{
    if(n < 0) {
        return NAN;
    } else {
        return (n==0 ? 1 : n*[ACalcBrain factorial:(n-1)]);
    }
}

+(int) getPriorityOf:(NSString*) operand;
{
    int priority = 3;
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

-(double) count
{
    NSMutableArray *programCopy = [ACalcBrain deepArrayCopy:self.programStacks];
    [self applyArgu];
    //set result stack as new argument
    [self getResultAndPutAsArguByPriotiy:0];
    
    double result = [self countWithStack:self.program];
    if([self.programStacks count] > 1){
        [programCopy removeLastObject];
    } else {
        [programCopy.lastObject removeAllObjects];
    }
    self.programStacks = [programCopy copy];
    return result;
}

-(double) countWithStack:(id) stack
{
    return [ACalcBrain runProgram:stack usingVariableValue:self.variableValue];
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

+(double) runProgram:(id)program usingVariableValue:(NSDictionary *)variableValues withPriority: (int) priority
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [ACalcBrain deepArrayCopy:program];
    }
    NSArray *variablesArray = [variableValues allKeys];
    for (NSInteger i = 0; i < [stack count]; i++){
        id anObject = [stack objectAtIndex:i];
        if([variablesArray containsObject:anObject])
            [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:anObject]];
    }
    return [self popOperandOfStack:stack accordingPriority:priority];
}


+(double) popOperandOfStack:(NSMutableArray*) stack
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0];
}

+(double) popOperandOfStack:(NSMutableArray*) stack accordingPriority:(int) priority
{
    return [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:priority];
}

+(double) popOperandOfStack: (NSMutableArray*) stack withPreviousValue: (NSNumber*) value accordingPriority: (int) priority
{
    double result = 0.0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack){
        [stack removeLastObject];
    } else if (value){
        result = [value doubleValue];
    }
    
    if([topOfStack isKindOfClass:[NSArray class]]){
        result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:[self popOperandOfStack:topOfStack]] accordingPriority:priority];

    } else if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [self popOperandOfStack:stack withPreviousValue:topOfStack accordingPriority:priority];
    } else if([topOfStack isKindOfClass:[NSString class]]){
        
        NSString * operation = topOfStack;
        int operationPriority = [ACalcBrain getPriorityOf:operation];
        if(priority > operationPriority){
            if(value) result = [value doubleValue];
            //think if topOfstack dosn't use put it back to stack for next operation
            [stack addObject:topOfStack];
        } else {
            if([operation isEqualToString:@"e"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(arg == 0.0) {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_E] accordingPriority:priority];
                } else {
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_E)] accordingPriority:priority];
                }
                
            } else if([operation isEqualToString:@"π"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                if(arg == 0.0) {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:M_PI] accordingPriority:priority];
                } else {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * M_PI)] accordingPriority:priority];
                }
                
            } else if ([operation isEqualToString:@"∓"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * -1.0)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"¹/x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1/arg] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x!"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                //make something toi exept not integer number
                arg = trunc(arg);
                double fac = [self factorial:arg];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:fac] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x²"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,2)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"x³"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,3)] accordingPriority:priority];
                
            }  else if ([operation isEqualToString:@"2ˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(2,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"eˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(M_E,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"10ˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(10.,arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"√x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sqrt(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"³√x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cbrt(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"lg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log10(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"log₂"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log2(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ln"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"xʸ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,[value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"yˣ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],arg)] accordingPriority:priority];
                } else {
                    result = arg;
                }
            } else if ([operation isEqualToString:@"ʸ√x"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow(arg,1 / [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"ˣ√y"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:pow([value doubleValue],1 / arg)] accordingPriority:priority];
                } else {
                    result = arg;
                }
            } else if ([operation isEqualToString:@"logʸ"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:log(arg) / log([value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if ([operation isEqualToString:@"√x²+y²"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:2];
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
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1/arg] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rcos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rsin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rtg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rctg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dsin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sin(arg * M_PI / 180)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dcos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cos(arg * M_PI / 180)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dtg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                //double integerPart, factorialPart;
                //factorialPart = modf(arg, &integerPart);
                //if(factorialPart == 0){
                 //   if(
                    
               // } else {
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tan(arg * M_PI / 180)] accordingPriority:priority];
               // }
                
            } else if ([operation isEqualToString:@"dctg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tan(arg * M_PI / 180)] accordingPriority:priority];

            } else if ([operation isEqualToString:@"racos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"rasin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ratg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ractg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(1/arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dasin"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:asin(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dacos"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:acos(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"datg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:atan(arg) * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"dactg"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble: atan(1/arg)  * 180 / M_PI] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"sinh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:sinh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"cosh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:cosh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"tgh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:tanh(arg)] accordingPriority:priority];
                
            } else if ([operation isEqualToString:@"ctgh"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:1 / tanh(arg)] accordingPriority:priority];
                
            } else if([operation isEqualToString:@"×"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg * [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }

            } else if([operation isEqualToString:@"÷"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:1];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg / [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if([operation isEqualToString:@"+"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg +[value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            }
            else if([operation isEqualToString:@"-"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:0];
                if(value){
                    result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:(arg - [value doubleValue])] accordingPriority:priority];
                } else {
                    result = arg;
                }
                
            } else if([operation isEqualToString:@"%"]){
                id nextTop = [stack lastObject];
                double arg;
                if(nextTop && [nextTop isKindOfClass:[NSArray class]]){
                    arg = [self popOperandOfStack:nextTop withPreviousValue:nil accordingPriority:0];
                    [stack removeLastObject];

                } else {
                    arg = 1.0;
                }
                double secondArg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                
                result = [self popOperandOfStack:stack
                               withPreviousValue:[NSNumber numberWithDouble:(arg*secondArg/100.)]
                               accordingPriority:priority];
            } else if ([operation isEqualToString:@".00"]){
                double arg = [self popOperandOfStack:stack withPreviousValue:nil accordingPriority:3];
                arg = round(arg *100) /100;
                result = [self popOperandOfStack:stack withPreviousValue:[NSNumber numberWithDouble:arg] accordingPriority:priority];
                
            }
        }
    }
    return result;
}



-(NSAttributedString*)stringInBrainWithAtributes:(NSDictionary *)attributes
{
    return [ACalcBrain descriptionOfProgram:self.wholeProgram withAttributes:attributes];
}

+(NSAttributedString*) descriptionOfProgram:(id)program withAttributes:(NSDictionary*)atributes
{
    NSMutableAttributedString * atrStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:atributes];
    
    id topOfStacs = [program lastObject];
    if(topOfStacs) [program removeLastObject];
    NSAttributedString* empty = [[NSAttributedString alloc] initWithString:@"" attributes:atributes];
    [atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:[atrStr length]];
    
    topOfStacs = [program lastObject];
    while (topOfStacs) {
        NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:atributes];
        [atrStr insertAttributedString:bracet atIndex:0];
        [atrStr insertAttributedString:[self popStringOfStack:topOfStacs withNextArguString:empty withAttributes:atributes] atIndex:0];
        [program removeLastObject];
        topOfStacs = [program lastObject];
    }
    return  [atrStr copy];
}

+(NSAttributedString *) popStringOfStack:(NSMutableArray *)stack withNextArguString:(NSAttributedString*)argStr withAttributes:(NSDictionary*) attributes
{
    NSMutableAttributedString * resultStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
    
    //number formatter
    
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
    
    if([topOfStack isKindOfClass:[NSArray class]]){
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
            
        }
        NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
        [attArg insertAttributedString:bracet atIndex:0];
        bracet = [bracet initWithString:@")" attributes:attributes];
        [attArg insertAttributedString:bracet atIndex:[attArg length]];
        resultStr = [[self popStringOfStack:stack withNextArguString:attArg withAttributes:attributes] mutableCopy];
        
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
                    NSAttributedString* bracet = [[NSAttributedString alloc] initWithString:@"(" attributes:attributes];
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
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSAttributedString* attrVal = [[NSAttributedString alloc] initWithString:@" × (-1)" attributes:attributes];
                [attArg insertAttributedString:attrVal atIndex:0];
                
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
                    resultStr = [[self popStringOfStack:arguArray
                                     withNextArguString:empty withAttributes:attributes] mutableCopy];
                    [resultStr insertAttributedString:attArg atIndex:[resultStr length]];
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
                
                NSAttributedString * value = [[NSAttributedString alloc] initWithString:@"¹/" attributes:attributes];
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
                
            } else if([trigonometrics containsObject:topOfStack]){
                NSMutableArray *arguArray = [self getNextArguInStack:stack accordingOperation:operations];
                NSMutableAttributedString *attArg = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
                //check the lenght of argu stack if more then one add brackets
                NSArray *testArray = [[NSArray alloc] init];
                testArray = [arguArray copy];
                if(([testArray count] == 1) && [[arguArray lastObject] isKindOfClass:[NSArray class]]){
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

                NSString* str = [topOfStack stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
                [attArg insertAttributedString:attrStr atIndex:0];
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
            }
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

