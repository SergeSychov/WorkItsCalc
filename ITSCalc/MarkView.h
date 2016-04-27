//
//  MarkView.h
//  Mark
//
//  Created by Serge Sychov on 03.09.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkView : UIView

@property (nonatomic) CGFloat lineWidht;
@property (nonatomic,weak) UIColor *markColor;
@property (nonatomic,weak) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) BOOL isShadow;
@end
