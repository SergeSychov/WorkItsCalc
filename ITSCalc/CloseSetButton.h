//
//  CloseSetButton.h
//  ITSCalc
//
//  Created by Serge Sychov on 23.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloseSetButton : UIButton

@property (nonatomic) BOOL isClose;
@property (nonatomic) BOOL isRemoveButton;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;

@end
