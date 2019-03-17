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

@class AtrStrStore;
@protocol AtrStrStoreSourse <NSObject>

-(UIUserInterfaceSizeClass)currentInterfaceClassSize;

@end


@interface AtrStrStore : NSObject
@property (nonatomic, weak) id <AtrStrStoreSourse> delegate;
@property (nonatomic, weak) DesignObject * design;

-(NSDictionary*)mainAttributes;
-(NSAttributedString*)atrStrForButtonsFrom:(NSAttributedString*)inStr;
-(NSString *) point;
+(CGFloat) pointSizeOfAtrString:(NSAttributedString*)atrStr;
+(NSAttributedString*)resizeAttrString:(NSAttributedString*)inputStr withKoeff:(CGFloat)k;
+(NSAttributedString*)resizeAttrString:(NSAttributedString *)inputStr toPointSize:(CGFloat)pointSize;
+(NSAttributedString*)resizeAttrString:(NSAttributedString*)inputStr accordingBound:(CGSize)boundSize;
+(NSAttributedString*)resizeAttrString:(NSAttributedString*)inputStr WithInitPointSize:(CGFloat)pointSize accordingBound:(CGSize)boundSize byHeight:(BOOL)isForHeight;

@end
