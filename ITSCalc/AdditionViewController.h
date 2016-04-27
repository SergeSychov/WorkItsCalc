//
//  AdditionViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 11.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearedViewController.h"


@interface AdditionViewController : AppearedViewController <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController* pageController;

@end
