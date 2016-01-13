//
//  History+Maker.h
//  ACalcTry
//
//  Created by Serge Sychov on 21.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "History.h"

@interface History (Maker)
+(History *) storyWithProgram:(NSArray*)program atDate:(NSDate*)date currensyRate:(NSString*)currensyRate variabledescription:(NSString*)variableDescription inManageObjectContext:(NSManagedObjectContext*) context;
+(History *) storyWithProgram:(NSArray*)program atDate:(NSDate*)date inManageObjectContext:(NSManagedObjectContext*) context;
+(void) clearContext:(NSManagedObjectContext *)context;


@end
