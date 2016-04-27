//
//  ThirdController.h
//  TransitionTest
//
//  Created by Serge Sychov on 22.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdController : UIViewController
@property (weak,nonatomic) UIView* cView;
@property (nonatomic) UIDeviceOrientation wasOrient;
-(void)dismis;
-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect;
-(void)setNeedViews;

@end
