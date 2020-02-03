//
//  Transition.m
//  TransitionTest
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "Transition.h"

@interface Transition()
@property (weak) id<UIViewControllerContextTransitioning> context;
@property (strong) UIDynamicAnimator *animator;
@property (weak) UIView *viewBeginDismissed;

@end

@implementation Transition

-(id) init
{
    self = [super init];
    if(self){
        self.isGravity = NO;
    }
    return self;
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.2;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.context = transitionContext;
    self.viewBeginDismissed = toVC.view;
    
    
    //toVC.view.alpha = 0;
    
    //self.containerView = [transitionContext containerView];
    if(!self.isGravity){
        UIView *fromView = fromVC.view;
        UIView *toView = toVC.view;
        //------for test transition------------
        if(!self.isForward){
            [transitionContext.containerView addSubview:toView];
            [transitionContext.containerView addSubview:fromView];
            [toView setTransform:CGAffineTransformMakeScale(0.8, .8)];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0.0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                [toView setTransform:CGAffineTransformMakeScale(1., 1.)];
                 [fromView setTransform:CGAffineTransformMakeScale(4., 4.)];
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                [fromView setTransform:CGAffineTransformMakeScale(1., 1.)];
                [self.context completeTransition:YES];
            }];
        } else {
            [transitionContext.containerView addSubview:fromView];
            [transitionContext.containerView addSubview:toView];
            
            [toView setTransform:CGAffineTransformMakeScale(4., 4.)];
            toView.alpha = 0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 [toView setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 [toView setTransform:CGAffineTransformMakeScale(.8, .8)];
                                 toView.alpha = 1;
                             } completion:^(BOOL finished) {
                                 [fromView setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 [self.context completeTransition:YES];
                             }];
            
        }
        
    } else {
        UIView *fromView = fromVC.view;
        UIView *toView = toVC.view;
        
        [transitionContext.containerView addSubview:fromView];
        [transitionContext.containerView addSubview:toView];
            
            CGRect rct = transitionContext.containerView.bounds;
            [toView setFrame:CGRectMake(0, -1.5*rct.size.height, rct.size.width, rct.size.height)];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0.0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0.8
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                [toView setFrame:CGRectMake(0, 0, rct.size.width, rct.size.height)];
            } completion:^(BOOL finished) {
                    [self.context completeTransition:YES];
                }];
    }
}
@end
