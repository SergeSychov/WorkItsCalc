//
//  designButtonView.h
//  ITSCalc
//
//  Created by Serge Sychov on 28.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"

@interface designButtonView : UIView
@property (nonatomic,weak) NSString* title;
@property (nonatomic) NSInteger designIndex;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;

@end
