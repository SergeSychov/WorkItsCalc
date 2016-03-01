//
//  ButtonsStore.h
//  ITSCalc
//
//  Created by Serge Sychov on 13.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Buttons.h"
#import "Buttons+Buttons_Maker.h"
//#import "ButtonObject.h"

@class ButtonsStore;
@protocol ButtonsStoreProtocol <NSObject>
-(NSInteger)numberColumsInCollectionView;
-(void)buttonsArrayDidChangedWithReload:(BOOL)isNeedReload;
@end


@interface ButtonsStore : NSObject

@property (nonatomic,strong) NSManagedObjectContext *buttonManagedObjectContext;

@property (nonatomic,strong) NSArray* allButtonObj;
@property (nonatomic,strong) NSArray* changebleButtonObjs;
@property (nonatomic,strong) NSArray* delettedButtonObjs;
@property (nonatomic,strong) NSArray *workButtonsNames;

-(ButtonsStore*)initWithContext:(NSManagedObjectContext*) context;
-(void)setUpArrays;
-(void)setButtonsByDefault;
-(void)renewArryasAfterChanging;
-(void)renewArraysAccordingNewButtonsSize;
//-(void) resaveCoreButtons;
-(void)changeContext:(NSManagedObjectContext*)context;
//-(void)addNewButtonWithButtonObj:(NSArray*)butObjs;
-(void) checkButtonsArray;
-(void) moveButton:(Buttons*)btn fromPosition:(NSNumber*)posFrom toPosition:(NSNumber*)posTo;

-(BOOL)removeUsersButton:(Buttons*)usersButton;




@property (nonatomic,weak) id <ButtonsStoreProtocol> delegate;

@end
