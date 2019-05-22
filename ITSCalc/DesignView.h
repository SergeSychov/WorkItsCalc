//
//  DesignView.h
//  DesignView
//
//  Created by Serge Sychov on 22.04.15.
//  Copyright (c) 2015 Serge Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignView : UIView
@property (nonatomic,weak) UIColor *storkeColor;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;

@end
