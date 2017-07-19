//
//  HistoryTableSviper.h
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"

@interface HistoryTableSviper : UIView
@property (nonatomic) CGFloat pathOfDown;
//@property (nonatomic) NSInteger design;
@property (nonatomic, weak) DesignObject *designObj;

@end
