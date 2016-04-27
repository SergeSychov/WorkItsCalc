//
//  LineView.h
//  ITSCalc
//
//  Created by Serge Sychov on 26.09.15.
//  Copyright © 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView
@property (nonatomic,weak) UIColor *color;
@property (nonatomic,weak) UIColor *shadowColor;
@property (nonatomic) CGSize shadowSize;
@property (nonatomic) CGFloat shadowBlur;
@end
