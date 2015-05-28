//
//  BackTransition.m
//  TransitionTest
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "BackTransition.h"


@interface BackTransition()
@property (strong) id<UIViewControllerContextTransitioning> context;
@end

@implementation BackTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView addSubview:fromVC.view];
    
    [toVC.view setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    self.context = transitionContext;
    //self.containerView = [transitionContext containerView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                         toVC.view.alpha = 1;
                         
                         [fromVC.view setTransform:CGAffineTransformMakeScale(4., 4.)];
                         fromVC.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.context completeTransition:YES];
                     }];
    
    
    
}

@end
