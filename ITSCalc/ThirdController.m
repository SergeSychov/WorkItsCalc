//
//  ThirdController.m
//  TransitionTest
//
//  Created by Serge Sychov on 22.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ThirdController.h"
#import "BackTransition.h"

#define INDENT 20.0f

@interface ThirdController() <UIViewControllerTransitioningDelegate>

@property (strong) BackTransition* transition;
@property (weak,nonatomic) UILabel *label;

@end

@implementation ThirdController


#pragma mark TRANSITION DELEGATE

-(id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    BackTransition *transition = [[BackTransition alloc] init];
    transition.isGravity = YES;
    self.transition = transition;
    
    return transition;
}

-(void) dismis
{
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark SUBVIEWS LOAD

-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    //abstract
    
}

-(void)setNeedViews
{
    //abstract
}

#pragma mark VIEW DIDLOAD

-(void)viewDidLoad{
    [super viewDidLoad];
    self.wasOrient = [UIDevice currentDevice].orientation;

    
    UIView *cView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [cView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:cView];
    self.cView = cView;
    
    [self setNeedViews];
    [self viewDidLayoutSubviewsWithRect:self.cView.bounds];
}

@end
