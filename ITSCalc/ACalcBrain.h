//
//  ACalcBrain.h
//  ACalcTry
//
//  Created by Serge Sychov on 07.01.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACalcBrain : NSObject
-(void) pushOperand:(id) operand; //think it's neded to be argu stack
-(id) performOperationInArgu:(id)operation;
-(void) applyArgu; //and may be this is need to be hiden
-(void) pushArguForPerCent; //especialy for perCent function, inserts arg for percent before % operand
-(id) checkMinusOrDivideOperationOnDubble:(NSString*)operand;
-(BOOL) deleteLastElement;


-(void) getResultAndPutAsArguByPriotiy:(int)priority; //may be its need to be hiden???
-(id) count;
-(id) perfomOperation:(NSString *) operation;
-(void) insertBracket: (BOOL) isRigthOpen;
-(void) clearOperation;
-(void) clearArgu;
-(void) checkToExceptDoubleOperation;
//-(NSString *) stringInBrain;
-(NSAttributedString*) stringInBrainWithAtributes:(NSDictionary*)attributes;
-(void) setVariableValue:(NSArray *)values atKey:(NSArray *)keys;
//function to save
-(NSArray*) arrayToSaveBrain;

//program is alweys guaranty to be a Property list
@property (nonatomic, strong) NSArray *programStacks;
@property (readonly) id program;
@property (readonly) id argu;
@property (readonly) id wholeProgram;
@property (nonatomic) BOOL isStronglyArgu; //the argument is strongly setted by use
@property(readonly) id deepProgram;
@property (readonly) id deepArgu;
@property (readonly) BOOL isOpenBracets;
@property (readonly) int openBracets;


+(id)runProgram:(id) program;
+(id)runProgram:(id)program usingVariableValue: (NSDictionary *) variableValues;
//+(NSString *)descriptionOfProgram:(id)program;
+(NSAttributedString*) descriptionOfProgram:(id)program withAttributes:(NSDictionary*)atributes;
+(id) deepArrayCopy:(NSArray*) arrayToCopy;

+(NSArray*) checkForFunctionsInProgramm:(NSArray*)programm;
+(NSAttributedString*)stringFunctionInProgram:(NSArray*)programm withAtrtributes:(NSDictionary*)atrbutes;

//check if programm has variables inside
+(NSSet*) chekForVariablesInProgramm:(NSArray*)programm;
+(NSAttributedString*)stringVariableInProgram:(NSArray*)programm withAtrtributes:(NSDictionary*)atrbutes;

//check if programm has currencies array take it ans return currensies arrays:USD/EUR/Value othercase retun nil
+(NSArray*) chekForCurrensiesProgramm:(NSArray*)programm;
+(NSAttributedString*)stringCurrensiesInProgram:(NSArray*)curArray withAtrtributes:(NSDictionary*)atrbutes;

//replace arrays with currencies in program with new values of currencies exhange
+(NSArray*) programm:(NSArray*)programm withReplaceWithCurrencies:(NSArray*)currensies;

+(ACalcBrain*) brainFromSavedArray:(NSArray*)array;
+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*)argu;
+(ACalcBrain*) initWithProgram:(NSArray*)program withArgu:(NSArray*)argu withOpenBracets:(int)openBracets andIsStrongluArgu:(BOOL)isStronglyArgu;

@end
