//
//  Currensies.h
//  ITSCalc
//
//  Created by Serge Sychov on 05.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currensies;

@protocol GetPairCurrensiesProtocol <NSObject>
-(void) getCurrensiesFrom:(NSString*)firstSymbol To:(NSString*)secondSymbol AndValue:(NSNumber*)value;
-(void) getCurrensiesArray:(NSArray*)currensiesExhangeRates;
@end

@interface Currensies : NSObject


@property (nonatomic,strong) NSArray* listCurrensiesForPicker;//list of currensies for pickers, save inusers default
@property (strong,nonatomic) NSDictionary *mainPairsdictionary;//main curensies, local currency, geo currency,uses currensy, save in archive
@property (nonatomic,weak) id <GetPairCurrensiesProtocol> delegate;

-(void) askResultForm:(NSString*)fromCur To:(NSString*)toCur;
-(void) renewUsersCurrensies:(NSArray*)currArray;
-(void) askResultForCurrensiesArray:(NSArray*)curArray;
-(void) renewPairsDictionary;
-(void) makeNewCurrensiesList;

@end
