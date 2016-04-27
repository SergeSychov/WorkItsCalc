//
//  History.h
//  ACalcTry
//
//  Created by Serge Sychov on 11.03.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * program;
@property (nonatomic, retain) NSString *currensyRate;
@property (nonatomic, retain) NSString * variableDescription;

@end
