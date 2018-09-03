//
//  Buttons+Buttons_Maker.m
//  ACalcTry
//
//  Created by Serge Sychov on 13.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "Buttons+Buttons_Maker.h"

@implementation Buttons (Buttons_Maker)

+(Buttons*) buttonWithName:(NSString*)name position:(NSNumber*)position alowDeletting:(BOOL)alowDelete dateDeleting:(NSDate*)delDate enabling:(BOOL)enabling Main:(BOOL)isMain Program:(NSArray*)program inManageObjectContext:(NSManagedObjectContext *)context
{
    Buttons *newButton = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.predicate = [NSPredicate predicateWithFormat:@"nameButton = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if(!matches || error){
        
    } else if([matches count] > 0){
        Buttons* existingButton = matches[0];
        
        existingButton.position = position;
        existingButton.aloweToDelete = [NSNumber numberWithBool:alowDelete];
        existingButton.dateOfDeletting = delDate;
        existingButton.enable = [NSNumber numberWithBool:enabling];
        existingButton.isMain = [NSNumber numberWithBool:isMain];
        if(program){
            NSData* dataProgram = [NSKeyedArchiver archivedDataWithRootObject:program];
            existingButton.program = dataProgram;
        } else {
            existingButton.program = nil;
        }
        newButton = existingButton;
    } else {
        newButton = [NSEntityDescription insertNewObjectForEntityForName:@"Buttons" inManagedObjectContext:context];
        newButton.nameButton = name;
        newButton.position = position;
        newButton.aloweToDelete = [NSNumber numberWithBool:alowDelete];
        newButton.dateOfDeletting = delDate;
        newButton.enable = [NSNumber numberWithBool:enabling];
        newButton.isMain = [NSNumber numberWithBool:isMain];
        if(program){
            NSData* dataProgram = [NSKeyedArchiver archivedDataWithRootObject:program];
            newButton.program = dataProgram;
        } else {
        newButton.program = nil;
        }
    }
    return newButton;
}

/*
+(Buttons *) buttonWithObj:(ButtonObject *)obj inManageObjectContext:(NSManagedObjectContext *)context
{
    Buttons *newButton = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.predicate = [NSPredicate predicateWithFormat:@"nameButton = %@", obj.nameButton];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if(!matches || error || ([matches count] > 0)){
    } else {
        newButton = [NSEntityDescription insertNewObjectForEntityForName:@"Buttons" inManagedObjectContext:context];
        newButton.nameButton = obj.nameButton;
        newButton.position = [NSNumber numberWithInteger:obj.position];
        newButton.aloweToDelete = [NSNumber numberWithBool:obj.alowedTodelete];
        newButton.dateOfDeletting = obj.dateOfDeletting;
        newButton.enable = [NSNumber numberWithBool:obj.enable];
        newButton.isMain = [NSNumber numberWithBool:obj.isMain];
        newButton.program = nil;
    }
    return newButton;
}
*/

/*
+(void) reSaveKeyboardWithArray:(NSArray*)objArray inManageObjectContext:(NSManagedObjectContext *)context
{
    [Buttons clearContext:context];
    
    for(int i = 0; i < [objArray count]; i++){
        ButtonObject *butObj = objArray[i];
        
        //if(!butObj.isMain)
        //NSLog(@"Button to coreData: %@, %ld", butObj.nameButton, (long)butObj.position);
        
        [Buttons buttonWithObj:butObj inManageObjectContext:context];
    }
    //
    //
    NSError *error;
    [context save:&error];
    //
    //
}
*/

+(void) clearContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for(id button in matches){
        [context deleteObject:button];
    }
    
}

+(Buttons *) storyWithProgram:(NSArray*)program atDate:(NSDate*)date inManageObjectContext:(NSManagedObjectContext*) context
{
    return nil;
}

+(void) insertButton:(Buttons*)button toPosition:(NSNumber*)position inManageObjectContext:(NSManagedObjectContext*)context
{
    
    //reques not this button, not mains buttons with position more or equal button.position
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];
    request.predicate = [NSPredicate predicateWithFormat:@"nameButton != %@ and isMain = %@ and position >= %@", button.nameButton, [NSNumber numberWithBool:NO], position];
    
    NSError *error;
    NSArray *buttonsWithIndexMore = [context executeFetchRequest:request error:&error];
    
    //set for each button position to +1
    for(Buttons *btn in buttonsWithIndexMore){
        btn.position = [NSNumber numberWithInteger:[btn.position integerValue]+1];
    }

    [context save:&error];
    
}

+(void) moveButton:(Buttons*)button fromPosition:(NSNumber*)positionFrom toPosition:(NSNumber*)positionTo inManageObjectContext:(NSManagedObjectContext*)context
{
    //reques not this button,
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buttons"];

    if(positionFrom.integerValue > positionTo.integerValue){
        //not mains buttons with position more or equal button.position
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and position < %@ and position >= %@",[NSNumber numberWithBool:NO], positionFrom, positionTo];
        NSError *error;
        NSArray *buttonsArray = [context executeFetchRequest:request error:&error];
        //NSLog(@"But array %@", buttonsArray);

        for(Buttons *btn in buttonsArray){
           // NSLog(@"buton :%@ position from:%@", btn.nameButton, btn.position);
            btn.position = [NSNumber numberWithInteger:[btn.position integerValue]+1];
           // NSLog(@"buton :%@,set position to:%@", btn.nameButton, btn.position);
        }
        
    } else if(positionFrom.integerValue < positionTo.integerValue){
        //not mains buttons with position more or equal button.position
        request.predicate = [NSPredicate predicateWithFormat:@"isMain = %@ and position > %@ and position <= %@",[NSNumber numberWithBool:NO], positionFrom, positionTo];
        NSError *error;
        NSArray *buttonsArray = [context executeFetchRequest:request error:&error];

        for(Buttons *btn in buttonsArray){
           // NSLog(@"buton :%@ position from:%@", btn.nameButton, btn.position);
            btn.position = [NSNumber numberWithInteger:[btn.position integerValue]-1];
           // NSLog(@"buton :%@,set position to:%@", btn.nameButton, btn.position);
        }
    }
    //NSLog(@"Position from:%@, position to:%@", positionFrom, positionTo);
    button.position = positionTo;
    NSError *error;
    [context save:&error];
}

@end
