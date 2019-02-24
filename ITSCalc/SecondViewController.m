//
//  SecondViewController.m
//  ThirdTestTransition
//
//  Created by Serge Sychov on 25.05.15.
//  Copyright (c) 2015 Serge Sychov. All rights reserved.
//

#import "SecondViewController.h"
#import "BackTransition.h"

#define INDENT 20.0f
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

//NSString *const SecondVCSendChangedNotification=@"SendChangedNotification";


@interface SecondViewController() 
//@property (weak, nonatomic) UIButton *changeButton;
//@property (weak, nonatomic) UIButton *goBackButton;
//@property (weak,nonatomic) UILabel *label;

@end
@implementation SecondViewController
@synthesize cView;

#pragma mark TRANSITION DELEGATE
-(id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[BackTransition alloc] init];
}

#pragma ABSTRACT FUNCTIONS
-(void) dismis
{
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SET SUBVIEWS
//avstract functions
-(void)setNeedViews
{
    
}

-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    
}

#pragma mark VIEW DID LOAD
-(void) viewDidLoad{
    [super viewDidLoad];
    
    //only for test
    [self.view setBackgroundColor:[UIColor colorWithRed:0.25
                                                  green:0.61
                                                   blue:.80
                                                  alpha:1.]];
    [self setNeedViews];
}

@end
