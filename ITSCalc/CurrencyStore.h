//
//  CurrencyStore.h
//  YahooApiTest
//
//  Created by Serge Sychov on 13.11.15.
//  Copyright © 2015 Serge Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyStore : NSObject
@property (nonatomic) NSArray *sortedCurrencyList;
@property (nonatomic) NSDictionary *currensyWithDescription;

+(NSArray*) initialCurrensiesList;
+(NSSet*) initialCurrensiesSet;
+(NSArray*) initialMainCurensies;
@end
