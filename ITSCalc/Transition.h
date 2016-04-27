//
//  Transition.h
//  TransitionTest
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Transition : NSObject <UIViewControllerAnimatedTransitioning, UICollisionBehaviorDelegate>

@property (nonatomic) BOOL isGravity;
@property (nonatomic) BOOL isForward;

@end