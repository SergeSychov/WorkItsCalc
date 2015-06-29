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
    return .5;
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
        //------for test transition------------
        if(!self.isForward){
            [transitionContext.containerView addSubview:toVC.view];
            [transitionContext.containerView addSubview:fromVC.view];
            [toVC.view setTransform:CGAffineTransformMakeScale(0.8, .8)];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                         [fromVC.view setTransform:CGAffineTransformMakeScale(4., 4.)];
                        fromVC.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [fromVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                         [self.context completeTransition:YES];
                     }];
        } else {
            [transitionContext.containerView addSubview:fromVC.view];
            [transitionContext.containerView addSubview:toVC.view];
            
            [toVC.view setTransform:CGAffineTransformMakeScale(4., 4.)];
            toVC.view.alpha = 0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 [toVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 [fromVC.view setTransform:CGAffineTransformMakeScale(.8, .8)];
                                 toVC.view.alpha = 1;
                             } completion:^(BOOL finished) {
                                 [fromVC.view setTransform:CGAffineTransformMakeScale(1., 1.)];
                                 [self.context completeTransition:YES];
                             }];
            
        }
        
    } else {
        [transitionContext.containerView addSubview:fromVC.view];
        [transitionContext.containerView addSubview:toVC.view];
        
        CGRect rct = transitionContext.containerView.bounds;
        [toVC.view setFrame:CGRectMake(0, -rct.size.height, rct.size.width, rct.size.height)];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
        
        UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[toVC.view]];
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[toVC.view]];
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[toVC.view]];
        
        gravity.gravityDirection = CGVectorMake(.0, 4.0);
        [self.animator addBehavior:gravity];
        [collisionBehavior addBoundaryWithIdentifier:@"Bottom"
                                           fromPoint:CGPointMake(0,rct.size.height+0.5)
                                             toPoint:CGPointMake(rct.size.width,rct.size.height+0.5)];
        [self.animator addBehavior:collisionBehavior];
        
        UIDynamicItemBehavior *elastic = [[UIDynamicItemBehavior alloc] initWithItems:@[toVC.view]];
        elastic.elasticity = 0.4;
        [self.animator addBehavior:elastic];
        
        __weak typeof(self) weakSelf = self;
        
        gravity.action = ^{
            typeof(self) strongSelf = weakSelf;
            UIView *view = strongSelf.viewBeginDismissed;
            if(ABS(strongSelf.viewBeginDismissed.frame.origin.y)< 0.5  && [dynamicItem linearVelocityForItem:view].y < 0.01){
                
                [strongSelf.animator removeAllBehaviors];
                [strongSelf.context completeTransition:YES];
            }
        };
    }
    
}
@end
