//
//  Transition.m
//  TransitionTest
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "Transition.h"

@interface Transition()
@property (strong) id<UIViewControllerContextTransitioning> context;
@end

@implementation Transition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:fromVC.view];
    [transitionContext.containerView addSubview:toVC.view];
    
    [toVC.view setTransform:CGAffineTransformMakeScale(4, 4)];
    toVC.view.alpha = 0;
    self.context = transitionContext;
    //self.containerView = [transitionContext containerView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                         toVC.view.alpha = 1;
                         
                         [fromVC.view setTransform:CGAffineTransformMakeScale(.8, .8)];
                     } completion:^(BOOL finished) {
                          [self.context completeTransition:YES];
                     }];
    
    
    
}

@end
