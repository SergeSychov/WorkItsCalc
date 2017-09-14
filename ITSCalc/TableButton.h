//
//  TableButton.h
//  CalcLayout
//
//  Created by Serge Sychov on 30.05.17.
//  Copyright © 2017 Serge Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableButton : UIButton
@property (nonatomic,weak) UIColor *shadowColor;
@property (nonatomic) CGSize shadowSize;
@property (nonatomic) CGFloat shadowBlur;
@end