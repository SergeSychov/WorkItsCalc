//
//  AppearedController.m
//  ITSCalc
//
//  Created by Serge Sychov on 21.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AppearedController.h"
#import "Transition.h"
#import "BackTransition.h"

#define INDENT 20.0f

@interface AppearedController () <UIViewControllerTransitioningDelegate>
@property (strong) BackTransition* backTransition;
@property (strong) Transition* transition;

@property (weak, nonatomic) UIButton *changeButton;
@property (weak, nonatomic) UIButton *goBackButton;
@property (weak,nonatomic) UILabel *label;

@end

@implementation AppearedController
#pragma mark TRANSITION DELEGATE

-(id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    return [[Transition alloc] init];;
}

-(id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[BackTransition alloc] init];
}

#pragma mark SET VIEWS
-(void) userPressedChangeButton:(id)sender
{
    NSLog(@"userPressedChangeButton");
    AppearedController *second = [[AppearedController alloc] init];
    second.view.backgroundColor = [UIColor colorWithRed:0.25
                                                  green:0.61
                                                   blue:.80
                                                  alpha:1.];
    second.transitioningDelegate = self;
    
    [self presentViewController:second animated:YES completion:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:SendChangedNotification object:nil];
}

-(void) userPressedBackButton:(id)sender
{
    //NSLog(@"userPressedBackButton");
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) viewDidLayoutSubviews
{
    //thre ellements take firsts three parts from four
    CGFloat part = (self.view.frame.size.height - 2*INDENT)/3;
    CGFloat width = self.view.frame.size.width - 2*INDENT;
    [self.changeButton setFrame:CGRectMake(INDENT, INDENT, width, part)];
    
    [self.label setFrame:CGRectMake(INDENT, INDENT+part, width, part)];
    [self.goBackButton setFrame:CGRectMake(INDENT, INDENT+2*part, width, part)];
    
}

-(void)setNeedViews
{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"SECOND VIEW CONTROLLER as third part and do not nothing according to this and write something more to do this may be it cen help to do my task reply it twicw and maybe in this case i'll see all that i can made with this label or may-be beign so sad becose it dosn't work";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:30];
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:label];
    _label = label;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    changeButton.contentMode = UIViewContentModeRedraw;
    changeButton.tintColor = [UIColor whiteColor];
    [changeButton addTarget:self action:@selector(userPressedChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    //changeButton.backgroundColor = [UIColor clearColor];
    [changeButton setTitle:@"Change main controller " forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    changeButton.titleLabel.numberOfLines = 0;
    changeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:changeButton];
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
    [self.view addSubview:goBackButton];
    _goBackButton = goBackButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLayoutSubviews];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.25
    //                                              green:0.61
    //                                               blue:.80
    //                                              alpha:1.]];
    [self setNeedViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
