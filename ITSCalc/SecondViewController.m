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

NSString *const SendChangedNotification=@"SendChangedNotification";


@interface SecondViewController() <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) UIButton *changeButton;
@property (weak, nonatomic) UIButton *goBackButton;
@property (weak,nonatomic) UILabel *label;

@end
@implementation SecondViewController
#pragma mark LAZY INITIALISATION

#pragma mark ACTION
-(void) userPressedChangeButton:(id)sender
{
    //NSLog(@"userPressedChangeButton");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Done",@"Message", nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void) userPressedBackButton:(id)sender
{
    [self dismis];
}
#pragma mark ROTATION

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
    /*
    UILabel *label = [[UILabel alloc] init];
    label.text = @"SECOND VIEW CONTROLLER";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:30];
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    label.adjustsFontSizeToFitWidth = YES;
    [self.cView addSubview:label];
    _label = label;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    changeButton.contentMode = UIViewContentModeRedraw;
    changeButton.tintColor = [UIColor whiteColor];
    [changeButton addTarget:self action:@selector(userPressedChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    //changeButton.backgroundColor = [UIColor clearColor];
    [changeButton setTitle:@"Change main controller" forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    changeButton.titleLabel.numberOfLines = 0;
    changeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cView addSubview:changeButton];
    _changeButton = changeButton;
    
    //continue button
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    goBackButton.contentMode = UIViewContentModeRedraw;
    goBackButton.tintColor = [UIColor whiteColor];
    [goBackButton addTarget:self action:@selector(userPressedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    //goBackButton.backgroundColor = [UIColor clearColor];
    [goBackButton setTitle:@"GO BACK" forState:UIControlStateNormal];
    goBackButton.titleLabel.font = [UIFont systemFontOfSize:30];
    goBackButton.titleLabel.numberOfLines = 0;
    goBackButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cView addSubview:goBackButton];
    _goBackButton = goBackButton;
    */
}

-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    /*
    //thre ellements take firsts three parts from four
    CGFloat part = (rect.size.height - 2*INDENT)/3;
    CGFloat width = rect.size.width - 2*INDENT;
    [self.changeButton setFrame:CGRectMake(rect.origin.x+ INDENT,rect.origin.y+ INDENT, width, part)];
    
    [self.label setFrame:CGRectMake(rect.origin.x+INDENT, rect.origin.y+INDENT+part, width, part)];
    [self.goBackButton setFrame:CGRectMake(rect.origin.x+INDENT, rect.origin.y+ INDENT+2*part, width, part)];
    */
}

#pragma mark VIEW DID LOAD
-(void) viewDidLoad{
    [super viewDidLoad];
    
    //only for test
    [self.view setBackgroundColor:[UIColor colorWithRed:0.25
                                                  green:0.61
                                                   blue:.80
                                                  alpha:1.]];
    

    
    UIView *cView = [[UIView alloc] init];
    cView.center = self.view.center;

    [cView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:cView];
    self.cView = cView;
    
    [self setNeedViews];
}

@end
