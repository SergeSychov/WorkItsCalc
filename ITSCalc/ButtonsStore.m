//
//  ButtonsStore.m
//  ITSCalc
//
//  Created by Serge Sychov on 13.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//


#import "ButtonsStore.h"
#import "CreateNewButtonViewController.h"

#define DEBUG_MODE NO

@interface ButtonsStore() <CreateNewButtonController>


@property (nonatomic,strong) NSDictionary *mainButtonsStartWithPosition;
@property (nonatomic, strong) NSArray *mainButtonObjs;

@end

@implementation ButtonsStore

#pragma mark INIT
-(ButtonsStore*)init {
    self = [super init];
    if(self){
        self.buttonManagedObjectContext = nil;
        //self.mainButtonsStartWithPosition = nil; //need set be at neel at stronge setuo
    }
    return self;
}

#pragma mark CORE DATA SET
#pragma mark SET MANAGED CONTEXT
-(void)setButtonManagedObjectContext:(NSManagedObjectContext *)buttonManagedObjectContext{
    _buttonManagedObjectContext = buttonManagedObjectContext;
    if(_buttonManagedObjectContext){
        [self setUpArrays];
    }
}

#pragma mark RENEW BUTTONS ARRAYS
//renew works buttons aaray
//only names - string
-(void) renewWorksButtonsArrayAfterSizeChanging{
    [self setUpMainButtonsPosition];
    self.workButtonsNames = [self renewedNamesArray];
    [self.delegate buttonsArrayDidChangedWithReload:YES];
    
    if(self.buttonManagedObjectContext){
        //renew all buttons array in other thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *copyAllObjs = [self renewedAllButtonsArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.allButtonObj = copyAllObjs;
            });
        });
    }
}

//renew all arrays
//obj arrays for under changins mode of main controller
-(void) renewArraysAccordingNewButtonsSize
{
    [self setUpMainButtonsPosition];
    self.allButtonObj = [self renewedAllButtonsArray];
    [self.delegate buttonsArrayDidChangedWithReload:YES];
    
    //renew work names buttons array in other thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *copyWorkNames = [self renewedNamesArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.workButtonsNames = copyWorkNames;
        });
    });
}

-(void)setUpMainButtonsPosition{
    NSInteger columsNumber = [self.delegate numberColumsInCollectionView];
    NSMutableArray* mutArray = [[NSMutableArray alloc] init];
    
    [mutArray addObject:[NSNumber numberWithInteger:(columsNumber - 1 - 1)]];//@"∓"
    [mutArray addObject:[NSNumber numberWithInteger:(columsNumber - 1)]];//@"C"
    
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 3)]];//@"7"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 2)]];//@"8"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1 - 1)]];//@"9"
    [mutArray addObject:[NSNumber numberWithInteger:(2*columsNumber - 1)]];//@"÷"
    
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 3)]];//@"4"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 2)]];//@"5"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1 - 1)]];//@"6"
    [mutArray addObject:[NSNumber numberWithInteger:(3*columsNumber - 1)]];//@"×"
    
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 3)]];//@"1"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 2)]];//@"2"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1 - 1)]];//@"3"
    [mutArray addObject:[NSNumber numberWithInteger:(4*columsNumber - 1)]];//@"-"
    
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 3)]];//@"0"
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 2)]];//@"."
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1 - 1)]];//@"⌫"
    [mutArray addObject:[NSNumber numberWithInteger:(5*columsNumber - 1)]];//@"+"
    
    [mutArray addObject:[NSNumber numberWithInteger:(6*columsNumber - 1)]];//@"="
    /*if(DEBUG_MODE){
        NSLog(@"colums number: %@", [NSNumber numberWithInteger: columsNumber]);
        NSLog(@"_mainButtonsStarPosition: %@",mutArray);
    }*/
    
    
    _mainButtonsStartWithPosition = [[NSDictionary alloc] initWithObjects:[mutArray copy]forKeys:[self mainButtonNames]];
    
}

-(NSArray*)renewedNamesArray{
    NSArray *mainButtonsNames = [self mainButtonNames];
    
    NSMutableArray *workNamesMutable = [[NSMutableArray alloc]init];
    
    if(!self.workButtonsNames){
        workNamesMutable = [[self startArray]mutableCopy];
    } else {
        for(NSString *name in self.workButtonsNames){
            if(![mainButtonsNames containsObject:name]){
                [workNamesMutable addObject:name];
            }
        }
    }
    //insert main buttons acording its positiom
    for(NSInteger i=0; i< [mainButtonsNames count]; i++){
        [workNamesMutable insertObject:mainButtonsNames[i] atIndex:[[self.mainButtonsStartWithPosition objectForKey:mainButtonsNames[i]] integerValue]];
    }
    return [workNamesMutable copy];
}

-(NSArray*)renewedAllButtonsArray {
    NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
    //1. add to allButtons changeble
    [allButtonsArray addObjectsFromArray:self.changebleButtonObjs];

    //2. insert Main buttons according right position
    for(Buttons *btn in self.mainButtonObjs){
        if(DEBUG_MODE){
            NSLog(@"renewedAllButtonsArray Buttons name: %@, and position: %@", btn.nameButton, btn.position);
        }
        [allButtonsArray insertObject:btn atIndex:[[self.mainButtonsStartWithPosition objectForKey:btn.nameButton] integerValue]];
    }
    [allButtonsArray addObjectsFromArray:self.delettedButtonObjs];
    
    return [allButtonsArray copy];
}

/*
//make workbuttons array and names array together
-(void) makeTwoArraysWithReload:(BOOL)isNeedreload;
{
    // self.buttonsCollection.scrollEnabled = NO;
    // NSLog(@"makeTwoArraysWithReload");
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
    NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
    
    //1. add to allButtons changeble
    [allButtonsArray addObjectsFromArray:self.changebleButtonObjs];
    
    //2. insert Main buttons according right position
    for(Buttons *btn in self.mainButtonObjs){
        if(DEBUG_MODE){
            NSLog(@"makeTwoArraysWithReload Buttons name: %@, and position: %@", btn.nameButton, btn.position);
        }
        [allButtonsArray insertObject:btn atIndex:[[self.mainButtonsStartWithPosition objectForKey:btn.nameButton] integerValue]];
    }
    
    //3.make string array for work condition of buttoncollectionView
    //workButtonNames
    for(Buttons *btn in allButtonsArray){
        
        [workButtonNames addObject:btn.nameButton];
    }
    self.workButtonsNames = [workButtonNames copy];
    
    //4. compleet all buttons array with deleted (not enabled) buttons
    [allButtonsArray addObjectsFromArray:self.delettedButtonObjs];
    self.allButtonObj = [allButtonsArray copy];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.delegate buttonsArrayDidChangedWithReload:isNeedreload];
    
    //});
    //});
}
*/
#pragma mark WORKS BUTTON ARRAY
-(NSArray*)workButtonsNames{
    if(!_workButtonsNames){
        NSArray *mainButtonsNames = [self mainButtonNames];
        NSMutableArray *workNamesMutable = [[self startArray]mutableCopy];
        //insert main buttons acording its positiom
        for(NSInteger i=0; i< [mainButtonsNames count]; i++){
            [workNamesMutable insertObject:mainButtonsNames[i] atIndex:[[self.mainButtonsStartWithPosition objectForKey:mainButtonsNames[i]] integerValue]];
        }
        _workButtonsNames = [workNamesMutable copy];
    }
    return _workButtonsNames;
}

/*
-(void) makeWorkButoonNamesArray
{
    //self.buttonsCollection.scrollEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
        NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
        
        //1. add to allButtons changeble
        [allButtonsArray addObjectsFromArray:self.changebleButtonObjs];
        
        //2. insert Main buttons according right position
        for(Buttons *btn in self.mainButtonObjs){
            [allButtonsArray insertObject:btn atIndex:[btn.position integerValue]];
        }
        
        //3.make string array for work condition of buttoncollectionView
        //workButtonNames
        for(Buttons *btn in allButtonsArray){
            [workButtonNames addObject:btn.nameButton];
        }
        self.workButtonsNames = [workButtonNames copy];
        
        //self.buttonsCollection.scrollEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate buttonsArrayDidChangedWithReload:YES];
        });
    });
}
*/

/*
-(ButtonsStore*) initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if(self){
        self.buttonManagedObjectContext = context;
        self.mainButtonsStartWithPosition = nil; //need set be at neel at stronge setuo
    }
    return self;
}
*/

-(void) setUpArrays
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(_buttonManagedObjectContext){
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
            NSError *error;
            NSArray *buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
            
            if(!buttonsFromCoreData || (buttonsFromCoreData.count < 65)){//if array empty or wrong quantity
                self.changebleButtonObjs = nil;
                self.mainButtonObjs = nil;
                self.delettedButtonObjs = nil;
            } else {
                
                //1. find changable and enable buttons
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
                request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]; //hope it will work
                request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
                NSArray *buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
                if(error){
                    NSLog(@"Error %@", error);
                } else {
                    self.changebleButtonObjs = buttonsFromCoreData;
                }
                
                //2. check Main buttons 1,2,3... +,-,=... and resetPositionValue according screen
                request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@", [NSNumber numberWithBool:YES]];
                request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
                buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
                for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
                    Buttons *btn = buttonsFromCoreData[i];
                    btn.position = [self.mainButtonsStartWithPosition objectForKey:btn.nameButton];
                }
                
                self.mainButtonObjs = buttonsFromCoreData;
                
                //3. make "deleted@ buttons array ascending according deleting date
                request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
                request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO]];
                request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateOfDeletting" ascending:NO]];
                buttonsFromCoreData = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
                self.delettedButtonObjs = buttonsFromCoreData;
                
            }
        }
        NSArray *copyAllObjs = [self renewedAllButtonsArray];
        NSArray *copyWorkNames = [self renewedNamesArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allButtonObj = copyAllObjs;
            self.workButtonsNames = copyWorkNames;
            [self.delegate buttonsArrayDidChangedWithReload:YES];
        });
    });
}

-(void)setButtonsByDefault
{
    [Buttons clearContext:self.buttonManagedObjectContext];
    [self setUpArrays];
}

#pragma mark CHECK BUTTONS ARRAY
//does buttons array contain all initial button
/*
-(void) checkButtonsArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL needToReloadArrays = NO;
        //firat make array from all buttons names
        NSMutableArray *mutNames = [[NSMutableArray alloc] init];
        for(Buttons* butObj in self.allButtonObj){
            [mutNames addObject:butObj.nameButton];
        }
        NSArray *startArray = [self startArray];
        for(NSString *stArrStr in startArray){
            if(![mutNames containsObject:stArrStr]){
                
                needToReloadArrays = YES;
                NSNumber *position = [NSNumber numberWithInteger:[startArray indexOfObject:stArrStr]];
                Buttons *newBtn = [Buttons buttonWithName:stArrStr
                                                 position:position
                                            alowDeletting:YES
                                             dateDeleting:[NSDate distantFuture]
                                                 enabling:YES
                                                     Main:NO
                                                  Program:nil
                                    inManageObjectContext:self.buttonManagedObjectContext];
                
                //need to reset positions property fro all buttons
                [Buttons insertButton:newBtn toPosition:position inManageObjectContext:self.buttonManagedObjectContext];

            }
        }
        //NSLog(@"NewButtonObj %@", newButtonsObjs);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(needToReloadArrays){
                [self setUpArrays];
            }
            
        });
    });
}
*/
#pragma mark BUTTONS ARRAYS

-(NSArray*)mainButtonNames
{
    NSArray *names = [[NSArray alloc] initWithObjects: @"∓",@"C",
                      @"7",@"8",@"9",@"÷",
                      @"4",@"5",@"6",@"×",
                      @"1",@"2",@"3",@"-",
                      @"0",@".",@"⌫",@"+",
                      @"=",
                      nil];
    return names;
}

//initial array of function for star
-(NSArray*) startArray
{
    NSArray* startArray = [[NSArray alloc] initWithObjects:
                           @"(",@")",@"rad",
                           @"¹/x",
                           @"%",
                           @"M+",
                           @"M-",
                           @"Mr",@"Mc",
                           @"X",@"Y",//added two variables
                           @"° ′″",@".00",
                           @"e",@"π",@"x²",@"x³",@"xʸ",
                           @"yˣ",@"2ˣ",@"10ˣ",@"eˣ",@"x!",
                           @"√x",@"³√x",@"ʸ√x",@"ˣ√y",@"√x²+y²",
                           @"lg",@"log₂",@"logʸ",@"ln",
                           @"sin",@"cos",@"tg",@"ctg",
                           @"asin",@"acos",@"atg",@"actg",
                           @"sinh",@"cosh",@"tgh",@"ctgh",
                           @"MIc",@"MIr",@"MI+",@"MI-",
                           nil];
    return startArray;
}

//setup position for main button according numbers of colums
//need be setted at start with init function initWithNumberOfColums:(NSInteger)colums

/*
-(void) setUpMainButtonsStartWithPosition
{
    NSArray *names = [self mainButtonNames];
    _mainButtonsStartWithPosition = [[NSDictionary alloc] initWithObjects:[self mainButtonsPositions]forKeys:names];
    
    if(self.mainButtonObjs){
        for(Buttons *btn in self.mainButtonObjs){
            btn.position = [self.mainButtonsStartWithPosition objectForKey:btn.nameButton];
        }
    }
}
*/


//set start arrays work and main
/*
-(NSDictionary*) mainButtonsStartWithPosition
{
    if(!_mainButtonsStartWithPosition){

        NSArray *names = [self mainButtonNames];
        _mainButtonsStartWithPosition = [[NSDictionary alloc] initWithObjects:[self mainButtonsPositions]forKeys:names];
    }
    
    return _mainButtonsStartWithPosition;
}
*/

/*
-(void) setAllButtonObj:(NSArray *)allButtonObj
{
    _allButtonObj = allButtonObj;
}
*/
-(NSArray*) changebleButtonObjs
{
    if(!_changebleButtonObjs){
        //1. find changable and enable buttons
        NSMutableArray* changebleButtonsArray = [[NSMutableArray alloc] init];
        for(NSString *name in self.startArray){
            Buttons *newButton = [Buttons buttonWithName:name
                                                position:[NSNumber numberWithInteger:[self.startArray indexOfObject:name]]
                                           alowDeletting:YES
                                            dateDeleting:[NSDate distantFuture]
                                                enabling:YES
                                                    Main:NO
                                                 Program:nil
                                   inManageObjectContext:self.buttonManagedObjectContext];
            
            [changebleButtonsArray addObject:newButton];
        }
        _changebleButtonObjs = [changebleButtonsArray copy];
    }
    return _changebleButtonObjs;
}


-(NSArray*) mainButtonObjs
{
    if(!_mainButtonObjs){
        //2. make Main buttons 1,2,3... +,-,=...
        NSMutableArray* mainButtonsArray = [[NSMutableArray alloc] init];
        NSArray *mainNames = [self mainButtonNames];
        for(NSString *name in mainNames){
            Buttons *newButton = [Buttons buttonWithName:name
                                                position:[self.mainButtonsStartWithPosition objectForKey:name]
                                           alowDeletting:NO
                                            dateDeleting:[NSDate distantFuture]
                                                enabling:YES
                                                    Main:YES
                                                 Program:nil
                                   inManageObjectContext:self.buttonManagedObjectContext];
            [mainButtonsArray addObject:newButton];
        }
        _mainButtonObjs = [mainButtonsArray copy];
    }
    return _mainButtonObjs;
}

-(NSArray*) delettedButtonObjs
{
    if(!_delettedButtonObjs){
        _delettedButtonObjs = [[NSArray alloc] init];
    }
    return _delettedButtonObjs;
}

#pragma mark RESET ARRAYS AND CALLDELEGATE

#define INSERT_BUTTON 1
#define DELETE_BUTTON 2
#define CHANGE_BUTTON_POISTION 3
#define MOVE_TO_ENABLE 4
#define MOVE_TO_DISABLE 5
#define RELOAD 0


-(void) makeTwoArraysWithReloadOperation:(NSInteger)operation;
{
    // self.buttonsCollection.scrollEnabled = NO;
    if(DEBUG_MODE){
        NSLog(@"makeTwoArraysWithReload");
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
        NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
        
        //1. add to allButtons changeble
        [allButtonsArray addObjectsFromArray:self.changebleButtonObjs];
        
        //2. insert Main buttons according right position
        for(Buttons *btn in self.mainButtonObjs){
            [allButtonsArray insertObject:btn atIndex:[[self.mainButtonsStartWithPosition objectForKey:btn.nameButton] integerValue]];
        }
        
        //3.make string array for work condition of buttoncollectionView
        //workButtonNames
        for(Buttons *btn in allButtonsArray){
            [workButtonNames addObject:btn.nameButton];
        }
        self.workButtonsNames = [workButtonNames copy];
        
        //4. compleet all buttons array with deleted (not enabled) buttons
        [allButtonsArray addObjectsFromArray:self.delettedButtonObjs];
        self.allButtonObj = [allButtonsArray copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate buttonsArrayDidChangedWithReloadOperation:operation];
            
        });
    });
}


#pragma mark DELEGATE CreateNewButtonController
-(BOOL)createNewButtonWith:(NSString*)name andProgramm:(NSArray*)programm {
    
    if(DEBUG_MODE){
        NSLog(@"createNewButtonWith Assking to make new button with name:%@ and program: %@", name, programm);
    }

    Buttons *newButton = [Buttons buttonWithName:name
                                        position:[NSNumber numberWithInteger:[self.changebleButtonObjs count]]
                                   alowDeletting:YES
                                    dateDeleting:[NSDate distantFuture]
                                        enabling:YES
                                            Main:NO
                                         Program:programm
                           inManageObjectContext:self.buttonManagedObjectContext];
    if(newButton){
        NSMutableArray *mutableChangebleButtonsArray = [self.changebleButtonObjs mutableCopy];
        [mutableChangebleButtonsArray addObject:newButton];
        self.changebleButtonObjs = [mutableChangebleButtonsArray copy];
    
        [self makeTwoArraysWithReloadOperation:INSERT_BUTTON];
    }
    
    return newButton?YES:NO;
}
-(NSString*)getPossibleButtonNameWithInitial:(NSString*)initStr {
    NSString *retStr = initStr;

    while ([self isEntity:@"Buttons" HasName:retStr]) {
        retStr = [self increasedStringWithSubSymbols:retStr];
    }
    return retStr;
}

-(BOOL) isEntity:(NSString*)entityName HasName:(NSString*)str
{
    NSFetchRequest *request;
    
    request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"nameButton = %@", str];
    
    NSError *error;
    NSArray *matches = [self.buttonManagedObjectContext executeFetchRequest:request error:&error];
    if([matches count]>0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark MOVE BUTTONS

/*
-(void) renewArryasAfterChanging
{
    [self makeTwoArraysWithReload:YES];
}
*/

-(void) moveButton:(Buttons *)btn fromPosition:(NSNumber *)posFrom toPosition:(NSNumber *)posTo
{
    if(DEBUG_MODE){
       NSLog(@"moveButton:(Buttons *)btn fromPosition:");
    }
    [Buttons moveButton:btn fromPosition:posFrom toPosition:posTo inManageObjectContext:self.buttonManagedObjectContext];
    [self makeTwoArraysWithReloadOperation:CHANGE_BUTTON_POISTION];
}

-(void) setEnablingForButton:(Buttons*)button{
    NSMutableArray *mutableChangebleButtonObjs = [self.changebleButtonObjs mutableCopy];
    NSMutableArray *mutableDeletedButtonObjs = [self.delettedButtonObjs mutableCopy];
    if(DEBUG_MODE){
        NSLog(@"setEnablingForButton Changeble buttons count %lu, deleted button count %lu", (unsigned long)self.changebleButtonObjs.count, (unsigned long)self.delettedButtonObjs.count);
    }

    
    [mutableDeletedButtonObjs removeObject:button];

    //find neede position in short array
    NSInteger i = 0;
    while (i  < mutableChangebleButtonObjs.count){
        Buttons *butObj = mutableChangebleButtonObjs[i];
        if([butObj.position integerValue] > [button.position integerValue]) break;
        i++;
    }
    button.enable = [NSNumber numberWithBool:![button.enable boolValue]];
    button.dateOfDeletting = [NSDate distantFuture];
    
    [mutableChangebleButtonObjs insertObject:button atIndex:i];
    
    
    self.changebleButtonObjs = [mutableChangebleButtonObjs copy];
    self.delettedButtonObjs = [mutableDeletedButtonObjs copy];

    if(DEBUG_MODE){
        NSLog(@"Changeble buttons count %lu, deleted button count %lu", (unsigned long)self.changebleButtonObjs.count, (unsigned long)self.delettedButtonObjs.count);
    }
    
    [self makeTwoArraysWithReloadOperation:MOVE_TO_ENABLE];
}

-(void) setDisablingForButton:(Buttons*)button{
    NSMutableArray *mutableChangebleButtonObjs = [self.changebleButtonObjs mutableCopy];
    NSMutableArray *mutableDeletedButtonObjs = [self.delettedButtonObjs mutableCopy];
    
    button.enable = [NSNumber numberWithBool:![button.enable boolValue]];
    button.dateOfDeletting = [NSDate date];
    
    [mutableChangebleButtonObjs removeObject:button];
    [mutableDeletedButtonObjs insertObject:button atIndex:0];
    
    self.changebleButtonObjs = [mutableChangebleButtonObjs copy];
    self.delettedButtonObjs = [mutableDeletedButtonObjs copy];
    [self makeTwoArraysWithReloadOperation:MOVE_TO_DISABLE];
}

#pragma mark DELETE USERS BUTTON

-(BOOL)removeUsersButton:(Buttons*)usersButton {
    NSMutableArray *mutableDeleteButtonsArray = [self.delettedButtonObjs mutableCopy];
    [mutableDeleteButtonsArray removeObject:usersButton];
    self.delettedButtonObjs = [mutableDeleteButtonsArray copy];
    
    [self.buttonManagedObjectContext deleteObject:usersButton];
    
    [self makeTwoArraysWithReloadOperation:DELETE_BUTTON];
    
    return YES;

}
#pragma mark WORK WITH STRING
-(NSString*)increasedStringWithSubSymbols:(NSString*)str{
    NSArray* strAndNumber = [self stringAndNumberFromStringWithSubSymbols:str];
    NSString* mainPart = [strAndNumber firstObject];
    NSInteger num = [[strAndNumber lastObject] integerValue];
    NSString* lastPart = strAndNumber[1];
    
    num++;
    NSString* subNumber = @"";
    while (num >0){
        //add rest of deviding on 10 to sub "1" unichar
        const unichar numChar[] = {[@"\u2080" characterAtIndex:0]+num % 10};
        subNumber = [[NSString stringWithCharacters:numChar length:1] stringByAppendingString:subNumber];
        num = num/10;
    }
    return [[mainPart stringByAppendingString:subNumber] stringByAppendingString:lastPart];
    
}
-(NSArray*)stringAndNumberFromStringWithSubSymbols:(NSString*)str{
    //return an array:
    //first object - mainPart ofString
    //second object - last part of string (example: (x,y))
    //last object - number value of subCript symbols
    
    NSString *mainName = @"";
    NSString *lastPart = @"";
    NSInteger strNumber = 0;
    //definde explisit symbols
    NSSet *closureSet = [[NSSet alloc]initWithObjects:@"(",@")",/*@"x",@"X",@"y",@"Y",*/ nil];
    
    NSInteger index = 0;
    while (index<str.length){
        //while symbols is not subscript and not contained in clouser set
        while((index<str.length) &&
              (([str characterAtIndex:index]<[@"\u2080" characterAtIndex:0]) ||
               ([str characterAtIndex:index]>[@"\u2089" characterAtIndex:0]))
              && (![closureSet containsObject:[str substringWithRange:NSMakeRange(index, 1)]])
              ){
            mainName = [mainName stringByAppendingString:[str substringWithRange:NSMakeRange(index, 1)]];
            index++;
        }
        //make number with subscript string
        while ((index<str.length)&&
               ([str characterAtIndex:index]>=[@"\u2080" characterAtIndex:0]) &&
               ([str characterAtIndex:index]<=[@"\u2089" characterAtIndex:0])) {
            strNumber = strNumber*10+ ([str characterAtIndex:index]- [@"\u2080" characterAtIndex:0]);
            index++;
        }
        //add the rest
        while (index<str.length){
            lastPart = [lastPart stringByAppendingString:[str substringWithRange:NSMakeRange(index, 1)]];
            index++;
        }
        
    }
    return [[NSArray alloc] initWithObjects:mainName,
            lastPart,
            [NSNumber numberWithInteger:strNumber],
            nil];
}


@end
