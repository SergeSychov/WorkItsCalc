//
//  Buttons+Buttons_Maker.m
//  ACalcTry
//
//  Created by Serge Sychov on 13.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "Buttons+Buttons_Maker.h"

@implementation Buttons (Buttons_Maker)

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
        newButton.position = [NSNumber numberWithInt:obj.position];
        newButton.aloweToDelete = [NSNumber numberWithBool:obj.alowedTodelete];
        newButton.dateOfDeletting = obj.dateOfDeletting;
        newButton.enable = [NSNumber numberWithBool:obj.enable];
        newButton.isMain = [NSNumber numberWithBool:obj.isMain];
        newButton.program = nil;
    }
    return newButton;
}
+(void) reSaveKeyboardWithArray:(NSArray*)objArray inManageObjectContext:(NSManagedObjectContext *)context
{
    [Buttons clearContext:context];
    
    for(int i = 0; i < [objArray count]; i++){
        ButtonObject *butObj = objArray[i];
        [Buttons buttonWithObj:butObj inManageObjectContext:context];
    }
}

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

@end
