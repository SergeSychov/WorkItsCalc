//
//  SettingButton.h
//  ITSCalc
//
//  Created by Serge Sychov on 17.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingButton : UIButton
@property (nonatomic,weak) UIColor *shadowColor;
@property (nonatomic) CGSize shadowSize;
@property (nonatomic) CGFloat shadowBlur;

@end
