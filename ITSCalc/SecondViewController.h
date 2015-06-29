//
//  SecondViewController.h
//  ThirdTestTransition
//
//  Created by Serge Sychov on 25.05.15.
//  Copyright (c) 2015 Serge Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackTransition.h"

@interface SecondViewController : UIViewController
@property (strong) BackTransition* transition;
@property (weak,nonatomic) UIView* cView;
@property (nonatomic) UIDeviceOrientation wasOrient;
-(void)dismis;
-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect;
-(void)setNeedViews;

@end
