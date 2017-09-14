//
//  AtrStrStore.h
//  CalcLayout
//
//  Created by Serge Sychov on 13.04.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DesignObject.h"

#define CHOOSE_STORAGE NSLocalizedStringFromTable(@"CHOOSE_STORAGE",@"ACalcTryViewControllerTableTwo", @"CHOOSE_STORAGE")
#define SHOUD_STORAGE_BE_IN_ICLOUD NSLocalizedStringFromTable(@"SHOUD_STORAGE_BE_IN_ICLOUD",@"ACalcTryViewControllerTableTwo", @"SHOUD_STORAGE_BE_IN_ICLOUD")
#define LOCAL_ONLY NSLocalizedStringFromTable(@"LOCAL_ONLY",@"ACalcTryViewControllerTableTwo", @"LOCAL_ONLY")
#define USE_ICLOUD NSLocalizedStringFromTable(@"USE_ICLOUD",@"ACalcTryViewControllerTableTwo", @"USE_ICLOUD")

//DELET and SET BUTTONS
#define DELETE_BUTTON_REQUEST NSLocalizedStringFromTable(@"DELETE_BUTTON_REQUEST",@"ACalcTryViewControllerTableNew", @"DELETE_BUTTON_REQUEST")
#define CANCEL NSLocalizedStringFromTable(@"CANCEL",@"ACalcTryViewControllerTableNew", @"CANCEL")
#define CONFIRM NSLocalizedStringFromTable(@"CONFIRM",@"ACalcTryViewControllerTableNew", @"CONFIRM")

@class AtrStrStore;
@protocol AtrStrStoreSourse <NSObject>

-(UIUserInterfaceSizeClass)currentInterfaceClassSize;

@end


@interface AtrStrStore : NSObject
@property (nonatomic, weak) id <AtrStrStoreSourse> delegate;
@property (nonatomic, weak) DesignObject * design;

-(NSDictionary*)mainAttributes;
-(NSAttributedString*)atrStrForButtonsFrom:(NSAttributedString*)inStr;
+(NSAttributedString*)changeFontSizeFrom:(NSAttributedString*)inStr toSize:(CGSize)size;
-(NSString *) point;

@end
