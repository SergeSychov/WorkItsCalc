//
//  DisplayRam.h
//  ACalcTry
//
//  Created by Serge Sychov on 11.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DisplayRam;

@protocol DisplayRamDelegate <NSObject>
-(void) errorAction;

@end

@interface DisplayRam : NSObject
//for user default
@property (nonatomic, strong) NSArray* firstMemoryStack;
@property (nonatomic, strong) NSArray* secondMemoryStack;
@property (nonatomic, strong) NSArray* gradArray;
@property (nonatomic,strong) NSNumber* resultNumber;
@property (nonatomic,strong) NSDictionary* resDictionary;

@property (nonatomic) NSInteger isGradMinutesSecons;//if isn't - 0, if grad - 1, if min - 2, if sec - 3
//

@property (nonatomic, strong) NSNumberFormatter* formatter;

@property (nonatomic) BOOL isIpadPortraitView;


-(NSString*) addSymbol:(id) symbol;
-(NSString*) setResult: (id)result;
-(id) getResult;
-(void) clearRam;
-(NSString*) deleteLastSymbol;
-(void) addResToMemory:(BOOL)isFirst inRadians:(BOOL)isRadCounting;
-(void) addRes:(id)res toMemory:(BOOL)isFirst inRadians:(BOOL)isRadCounting;
-(void) substractResFromMemory: (BOOL) isFirst inRadians:(BOOL)isRadCounting;
-(void) substractRes:(id)res fromMemory: (BOOL) isFirst inRadians:(BOOL)isRadCounting;
-(NSString*) getResultFromMemory:(BOOL)isFirst;
-(void) clearMemory:(BOOL)isFirst;
-(BOOL) isGradValue;
-(DisplayRam*)copyDisplayRamForCount;


@property (nonatomic,weak) id <DisplayRamDelegate> delegate;

@end
