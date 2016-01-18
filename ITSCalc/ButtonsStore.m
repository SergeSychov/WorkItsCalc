//
//  ButtonsStore.m
//  ITSCalc
//
//  Created by Serge Sychov on 13.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//


#import "ButtonsStore.h"


@interface ButtonsStore()


@property (nonatomic,strong) NSDictionary *mainButtonsStartWithPosition;
@property (nonatomic, strong) NSArray *mainButtonObjs;

@end

@implementation ButtonsStore

-(ButtonsStore*) initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if(self){
        self.buttonManagedObjectContext = context;
        [self setUpArrays];
    }
    return self;
}


-(void) renewArryasAfterChanging
{
    [self makeTwoArraysWithReload:NO];
}

-(void) renewArraysAccordingNewButtonsSize
{
    //1 Finf new positions for main button
    [self setUpMainButtonsStartWithPosition];
    [self makeTwoArraysWithReload:YES];
}

-(void) resaveCoreButtons
{
    // NSManagedObjectContext *context = self.buttonManagedObjectContext;
    
    [Buttons reSaveKeyboardWithArray:self.allButtonObj inManageObjectContext:self.buttonManagedObjectContext];
    // NSError *error;
    // [context save:&error];
    
}

-(void)changeContext:(NSManagedObjectContext *)context
{
    self.buttonManagedObjectContext = context;
    [self setUpArrays];
}

-(void)addNewButtonWithButtonObj:(NSArray *)butObjs
{
   NSMutableArray *mutableAllButtons = [self.allButtonObj mutableCopy];
    for(ButtonObject *butObj in butObjs){
        if(butObj.position != 0){
            [mutableAllButtons insertObject:butObj atIndex:butObj.position];
        } else {
            NSUInteger newPosition = [mutableAllButtons count];
            butObj.position = newPosition;
            [mutableAllButtons addObject:butObj];
        }
    }
    self.allButtonObj = [mutableAllButtons copy];
    [self resaveCoreButtons];
    [self changeContext:self.buttonManagedObjectContext];
    //[self makeTwoArraysWithReload:YES];
}

#pragma mark CHECK BUTTONS ARRAY
//does buttons array contain all initial button
-(void) checkButtonsArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //firat make array from all buttons names
        NSMutableArray *mutNames = [[NSMutableArray alloc] init];
        for(ButtonObject* butObj in self.allButtonObj){
            [mutNames addObject:butObj.nameButton];
        }
        NSArray *startArray = [self startArray];
        NSMutableArray *newButtonsObjs = [[NSMutableArray alloc] init];
        
        for(NSString *stArrStr in startArray){
            if(![mutNames containsObject:stArrStr]){
                ButtonObject *btnObj = [[ButtonObject alloc] init];
                
                btnObj.enable = YES;
                btnObj.isMain = NO;
                btnObj.alowedTodelete = YES;
                btnObj.nameButton = stArrStr;
                btnObj.position = [startArray indexOfObject:stArrStr];
                btnObj.dateOfDeletting = [NSDate distantFuture];
                
                [newButtonsObjs addObject:btnObj];
                if([stArrStr isEqualToString:@"X"] || [stArrStr isEqualToString:@"Z"]){
                    NSLog(@" %@ position is %ul",stArrStr,btnObj.position);
                }

            }
        }
        NSLog(@"NewButtonObj %@", newButtonsObjs);
        dispatch_async(dispatch_get_main_queue(), ^{
            if([newButtonsObjs count]>0){
                [self addNewButtonWithButtonObj:[newButtonsObjs copy]];
            }
            
        });
    });
}

#pragma mark BUTTONS ARRAYS

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
                           //@"X",@"Z",//added two variables
                           @"° ′″",@".00",
                           @"e",@"π",@"x²",@"x³",@"xʸ",
                           @"yˣ",@"2ˣ",@"10ˣ",@"eˣ",@"x!",
                           @"√x",@"³√x",@"ʸ√x",@"ˣ√y",@"√x²+y²",
                           @"lg",@"log₂",@"logʸ",@"ln",
                           @"sin",@"cos",@"tg",@"ctg",
                           @"asin",@"acos",@"atg",@"actg",
                           @"sinh",@"cosh",@"tgh",@"ctgh",
                           //@"X",@"A",@"Tab",@"Grph",@"+f(x)",
                           @"MIc",@"MIr",@"MI+",@"MI-",
                           nil];
    return startArray;
}

//initial array for main buttons for start
-(NSArray*) mainButtonsStartArray
{
    NSArray* mainArray = [[NSArray alloc] initWithObjects:@"∓",@"C",
                          @"7",@"8",@"9",@"÷",
                          @"4",@"5",@"6",@"×",
                          @"1",@"2",@"3",@"-",
                          @"0",@".",@"⌫",@"+",
                          @"=",
                          nil];
    return mainArray;
}

//setup position for main button according numbers of colums
//need be setted at start with init function initWithNumberOfColums:(NSInteger)colums


-(void) setUpMainButtonsStartWithPosition
{
    NSArray *names = [[NSArray alloc] initWithObjects: @"∓",@"C",
                      @"7",@"8",@"9",@"÷",
                      @"4",@"5",@"6",@"×",
                      @"1",@"2",@"3",@"-",
                      @"0",@".",@"⌫",@"+",
                      @"=",
                      nil];
    _mainButtonsStartWithPosition = [[NSDictionary alloc] initWithObjects:[self mainButtonsPositions]forKeys:names];
    
}

-(NSArray*) mainButtonsPositions
{
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
    
    return [mutArray copy];
}

//set start arrays work and main
-(NSDictionary*) mainButtonsStartWithPosition
{
    if(!_mainButtonsStartWithPosition){
        [self setUpMainButtonsStartWithPosition];
    }
    return _mainButtonsStartWithPosition;
}

-(void) setAllButtonObj:(NSArray *)allButtonObj
{
    _allButtonObj = allButtonObj;
    //[self resaveCoreButtons];
}



-(void) setUpArrays
{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSManagedObjectContext *context = self.buttonManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    
    NSError *error;
    NSArray *buttonsFromCoreData = [context executeFetchRequest:request error:&error];
    if(!buttonsFromCoreData || (buttonsFromCoreData.count < 65)){
        if(buttonsFromCoreData){
            [Buttons clearContext:context];
        }
        
        
        NSMutableArray *buttonsObjs = [[NSMutableArray alloc] init]; //array from obj not from core data
        for(NSInteger i = 0; i < self.startArray.count; i++){
            ButtonObject *btnObj = [[ButtonObject alloc] init];
            
            btnObj.enable = YES;
            btnObj.isMain = NO;
            btnObj.alowedTodelete = YES;
            btnObj.nameButton = self.startArray[i];
            btnObj.position = i;
            btnObj.dateOfDeletting = [NSDate distantFuture];
            
            [buttonsObjs addObject:btnObj];
            
        }
        self.changebleButtonObjs = [buttonsObjs copy];
        //clear deletted button objs
        //---
        self.delettedButtonObjs = [[NSArray alloc] init];
        //---
        //
        NSMutableArray *mainButtonObjs = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0; i < self.mainButtonsStartArray.count; i++){
            NSString *name = self.mainButtonsStartArray[i];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:name] integerValue];
            ButtonObject *btnObj = [[ButtonObject alloc] init];
            
            btnObj.nameButton =  name;
            btnObj.enable = YES;
            btnObj.isMain = YES;
            btnObj.alowedTodelete = NO;
            btnObj.position = index;
            btnObj.dateOfDeletting = [NSDate distantFuture];
            
            [mainButtonObjs addObject:btnObj];
        }
        
        self.mainButtonObjs = [mainButtonObjs copy];
        
        //[self makeTwoArrays];
    }
    else {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
        //NSError *error;
        NSMutableArray *allButtons = [[NSMutableArray alloc] init];
        NSArray *buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = [button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [allButtons addObject:butObj];
        }
        self.changebleButtonObjs = [allButtons copy];
        
        
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@", [NSNumber numberWithBool:YES]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
        
        NSMutableArray *mainButtons = [[NSMutableArray alloc] init];
        buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        //NSLog(@"Fetched Main objs %@", buttonsFromCoreData);
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:button.nameButton] integerValue];
            
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = index;//[button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [mainButtons addObject:butObj];
        }
        self.mainButtonObjs = [mainButtons copy];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and enable = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO]]; //hope it will work
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateOfDeletting" ascending:NO]];
        //NSError *error;
        NSMutableArray *delettedButtonObjs = [[NSMutableArray alloc] init];
        buttonsFromCoreData = [context executeFetchRequest:request error:&error];
        for(NSInteger i = 0; i < buttonsFromCoreData.count; i++){
            Buttons *button = buttonsFromCoreData[i];
            ButtonObject *butObj = [[ButtonObject alloc] init];
            butObj.nameButton = button.nameButton;
            butObj.dateOfDeletting = button.dateOfDeletting;
            butObj.alowedTodelete = [button.aloweToDelete boolValue];
            butObj.isMain = [button.isMain boolValue];
            butObj.position = [button.position integerValue];
            butObj.enable = [button.enable boolValue];
            
            [delettedButtonObjs addObject:butObj];
        }
        self.delettedButtonObjs = [delettedButtonObjs copy];
        
        //[self makeTwoArrays];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makeTwoArraysWithReload:YES];
        
    });
});
    //if main array from core dont equal main buttons obj from brog/ reload core
}

-(NSArray*) changebleButtonObjs
{
    if(!_changebleButtonObjs){
        _changebleButtonObjs = [[NSArray alloc] init];
        [self setUpArrays];
    }
    return _changebleButtonObjs;
}

-(NSArray*) delettedButtonObjs
{
    if(!_delettedButtonObjs){
        _delettedButtonObjs = [[NSArray alloc] init];
    }
    return _delettedButtonObjs;
}

-(NSArray*) mainButtonObjs
{
    if(!_mainButtonObjs){
        _mainButtonObjs = [[NSArray alloc] init];
        [self setUpArrays];
    }
    
    return _mainButtonObjs;
}

-(void) makeAllButtonObjsArray
{
    //self.buttonsCollection.scrollEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
    
        //make initial array from enable changeble button objects
        for (int i = 0; i < self.changebleButtonObjs.count; i++){
            [allButtonsArray addObject:self.changebleButtonObjs[i]];
        }
        //insert main button objects att position according mainButtonWithStartPosition dictionary
        for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
            ButtonObject *buttonObj = self.mainButtonObjs[i];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
            buttonObj.position = index;
            [allButtonsArray insertObject:self.mainButtonObjs[i] atIndex:index];
        }
        //add deleted buttons
        for (int i = 0; i < self.delettedButtonObjs.count; i++){
            [allButtonsArray addObject:self.delettedButtonObjs[i]];
        }
    
        self.allButtonObj = [allButtonsArray copy];
        //self.buttonsCollection.scrollEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate buttonsArrayDidChanged];
        });
    });

}

-(void) makeWorkButoonNamesArray
{
    //self.buttonsCollection.scrollEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
    
        //set up initial array from changeble buttons arrays names
        for(int i = 0; i < self.changebleButtonObjs.count; i++){
            ButtonObject *buttonObj = self.changebleButtonObjs[i];
            [workButtonNames addObject:buttonObj.nameButton];
        }
        //insert mainButtons as names
        for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
            ButtonObject *buttonObj = self.mainButtonObjs[i];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
        
            [workButtonNames insertObject:buttonObj.nameButton atIndex:index];
        }
    
        self.workButtonsNames = [workButtonNames copy];
    
    //self.buttonsCollection.scrollEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate buttonsArrayDidChanged];
        });
    });
}


//make workbuttons array and names array together
-(void) makeTwoArraysWithReload:(BOOL)isNeedreload;
{
   // self.buttonsCollection.scrollEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *allButtonsArray = [[NSMutableArray alloc] init];
        NSMutableArray *workButtonNames = [[NSMutableArray alloc] init];
    
        //make initial array from enable changeble button objects
        for (int i = 0; i < self.changebleButtonObjs.count; i++){
            ButtonObject *buttonObj = self.changebleButtonObjs[i];
            [workButtonNames addObject:buttonObj.nameButton];
            [allButtonsArray addObject:self.changebleButtonObjs[i]];
        
        }
        //insert main button objects att position according mainButtonWithStartPosition dictionary
        for(NSUInteger i = 0; i < self.mainButtonObjs.count; i++){
            ButtonObject *buttonObj = self.mainButtonObjs[i];
            NSInteger index = [[self.mainButtonsStartWithPosition objectForKey:buttonObj.nameButton] integerValue];
        
            [workButtonNames insertObject:buttonObj.nameButton atIndex:index];
            [allButtonsArray insertObject:self.mainButtonObjs[i] atIndex:index];
        }
        self.workButtonsNames = [workButtonNames copy];
    
        //add deleted buttons
        for (int i = 0; i < self.delettedButtonObjs.count; i++){
            [allButtonsArray addObject:self.delettedButtonObjs[i]];
        }
    
        self.allButtonObj = [allButtonsArray copy];
        
    //self.buttonsCollection.scrollEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isNeedreload){
                
                [self.delegate buttonsArrayDidChanged];
                
                //IMPORTANT ADD HEERE BUT IT MUST BE EXTERNAL FUNCTIONS
                //CHECK BUTTONS ARREY AFTER RENEW Version
               // [self checkButtonsArray];
            }
        });
    });
}

-(NSArray*) workButtonsNames
{
    if(!_workButtonsNames){
        _workButtonsNames = [[NSArray alloc] init];
        [self makeWorkButoonNamesArray];
    }
    return _workButtonsNames;
}



@end
