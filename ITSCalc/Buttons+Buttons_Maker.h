//
//  Buttons+Buttons_Maker.h
//  ACalcTry
//
//  Created by Serge Sychov on 13.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "Buttons.h"
#import "ButtonObject.h"

@interface Buttons (Buttons_Maker)
+(Buttons*) buttonWithName:(NSString*)name position:(NSNumber*)position alowDeletting:(BOOL)alowDelete dateDeleting:(NSDate*)delDate enabling:(BOOL)enabling Main:(BOOL)isMain Program:(NSArray*)program inManageObjectContext:(NSManagedObjectContext *)context;
//+(Buttons *) buttonWithObj:(ButtonObject*)obj inManageObjectContext:(NSManagedObjectContext *)context;
+(void) clearContext:(NSManagedObjectContext *)context;
//+(void) reSaveKeyboardWithArray:(NSArray*)objArray inManageObjectContext:(NSManagedObjectContext *)context;
+(void) insertButton:(Buttons*)button toPosition:(NSNumber*)position inManageObjectContext:(NSManagedObjectContext*)context;
+(void) moveButton:(Buttons*)button fromPosition:(NSNumber*)positionFrom toPosition:(NSNumber*)positionTo inManageObjectContext:(NSManagedObjectContext*)context;


@end
