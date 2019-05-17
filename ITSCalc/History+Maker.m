//
//  History+Maker.m
//  ACalcTry
//
//  Created by Serge Sychov on 21.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "History+Maker.h"

@implementation History (Maker)
+(History *) storyWithProgram:(NSArray*)program atDate:(NSDate*)date currensyRate:(NSString*)currensyRate variabledescription:(NSString*)variableDescription inManageObjectContext:(NSManagedObjectContext*) context
{
    History *history = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if(!matches || error || ([matches count] > 1)){
        
    } else if ([matches count]){
        //history = [matches firstObject];
    }
    else {
        history = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:context];
        NSError* errorArchove;
        history.program = [NSKeyedArchiver archivedDataWithRootObject:program requiringSecureCoding:YES error:&errorArchove];
        history.date = date;
        history.currensyRate = currensyRate;
        history.variableDescription = variableDescription;
    }
    
    return history;
}

+(History *) storyWithProgram:(NSArray*)program atDate:(NSDate*)date inManageObjectContext:(NSManagedObjectContext*) context
{
    History *history = [History storyWithProgram:program atDate:date currensyRate:nil variabledescription:nil inManageObjectContext:context];
    /*
    History *history = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if(!matches || error || ([matches count] > 1)){
        
    } else if ([matches count]){
        //history = [matches firstObject];
    }
    else {
        history = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:context];
        
        history.program = [NSKeyedArchiver archivedDataWithRootObject:program];
        history.date = date;
        history.currensyRate = nil;
        history.variableDescription = nil;
    }
    */
    return history;
}

+(void) clearContext:(NSManagedObjectContext *)context
{
     NSError *error;

        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
        
    
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        for(id button in matches){
            [context deleteObject:button];
        }
}
@end
