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
+(Buttons *) buttonWithObj:(ButtonObject*)obj inManageObjectContext:(NSManagedObjectContext *)context;
+(void) clearContext:(NSManagedObjectContext *)context;
+(void) reSaveKeyboardWithArray:(NSArray*)objArray inManageObjectContext:(NSManagedObjectContext *)context;

@end
