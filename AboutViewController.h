//
//  AboutViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 08.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogoView.h"

@interface AboutViewController : UIViewController

-(id)initWithController:(UIViewController*)controller;

@property (nonatomic,weak) UIView* copiedView;
@property (nonatomic, weak) LogoView* mainView;
@property (nonatomic) NSInteger daysNumber;


@end
