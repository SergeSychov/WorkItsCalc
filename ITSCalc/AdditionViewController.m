//
//  AdditionViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 11.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AdditionViewController.h"
#import "DesignView.h"
#import "NewButtonsCollectionViewCell.h"
#import "AddViewController.h"


#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define INDENT 20.0f

@interface AdditionViewController ()

@property (nonatomic,weak) NSString *returnString;
@property (nonatomic, weak) UIButton *returnButton;


@end

@implementation AdditionViewController
#pragma mark LAZY INITIAlIZATION

-(NSString*)returnString
{
    if(!_returnString){
        _returnString = @"BACK";
    }
    return _returnString;
}

#pragma mark PRESSED ACTION
-(void) userPressedReturnButton:(id)sender
{
    NSLog(@"User Press Return Button");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void) subViewLayoutWithRect:(CGRect) rect;
{
    //set frame for button Back
    CGFloat part = rect.size.height/4;
    [self.returnButton setFrame:CGRectMake(rect.origin.x+INDENT, rect.origin.y+part*3+INDENT, rect.size.width-2*INDENT, part-2*INDENT)];
    
    //set frame for page view controller
    CGFloat width = self.view.bounds.size.width;
    [self.pageController.view setFrame:CGRectMake(rect.origin.x, rect.origin.y, width, part*3)];
    
}
-(void) addNeededSubviewsOnMainView
{
    [self.mainView addSubview:self.pageController.view];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    returnButton.contentMode = UIViewContentModeRedraw;
    returnButton.tintColor = [UIColor whiteColor];
    [returnButton addTarget:self action:@selector(userPressedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    returnButton.backgroundColor = [UIColor clearColor];
    [returnButton setTitle:self.returnString forState:UIControlStateNormal];
    returnButton.titleLabel.numberOfLines = 0;
    [returnButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    returnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:returnButton];
    _returnButton = returnButton;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    AddViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [self.mainView addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PAGE VIEW CONTROLLER
- (AddViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    AddViewController *childViewController = [[AddViewController alloc] initWithIndex:index];
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(AddViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(AddViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
