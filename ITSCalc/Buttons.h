//
//  Buttons.h
//  ACalcTry
//
//  Created by Serge Sychov on 13.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buttons : NSManagedObject

@property (nonatomic, retain) NSNumber * enable;
@property (nonatomic, retain) NSNumber * isMain;
@property (nonatomic, retain) NSNumber * aloweToDelete;
@property (nonatomic, retain) NSString * nameButton;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSDate * dateOfDeletting;
@property (nonatomic, retain) NSData * program;

@end
