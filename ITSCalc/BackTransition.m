//
//  BackTransition.m
//  TransitionTest
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "BackTransition.h"


@interface BackTransition()
@property (weak) id<UIViewControllerContextTransitioning> context;
@property (strong) UIDynamicAnimator *animator;
@property (weak) UIView *viewBeginDismissed;
@end

@implementation BackTransition

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
    return .4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    if(!self.isGravity){
        if(self.isForward){
            [transitionContext.containerView addSubview:toVC.view];
            [transitionContext.containerView addSubview:fromVC.view];
            [toVC.view setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
            self.context = transitionContext;
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 toVC.view.alpha = 1;
                                 
                                 [fromVC.view setTransform:CGAffineTransformMakeScale(4., 4.)];
                                 fromVC.view.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self.context completeTransition:YES];
                             }];
        } else {
            [transitionContext.containerView addSubview:fromVC.view];
            [transitionContext.containerView addSubview:toVC.view];
            [toVC.view setTransform:CGAffineTransformMakeScale(4., 4.)];
            toVC.view.alpha = 0;
            self.context = transitionContext;
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 toVC.view.alpha = 1;
                                 
                                 [fromVC.view setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
                                 //fromVC.view.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self.context completeTransition:YES];
                             }];
        }
        
    } else {
        [transitionContext.containerView addSubview:toVC.view];
        [transitionContext.containerView addSubview:fromVC.view];
        
        self.viewBeginDismissed = fromVC.view;
        CGRect rct = transitionContext.containerView.bounds;
        self.context = transitionContext;
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
        
        
        gravity.gravityDirection = CGVectorMake(.0, 3.);
        
        
        
        __weak typeof(self) weakSelf = self;
        
        gravity.action = ^{
            typeof(self) strongSelf = weakSelf;
            
            if(strongSelf.viewBeginDismissed.frame.origin.y> sqrtf(powf(rct.size.height,2)+powf(rct.size.width,2)) ){
                
                [strongSelf.animator removeAllBehaviors];
                [strongSelf.context completeTransition:YES];
            }
        };
        [self.animator addBehavior:gravity];
    }
}

@end