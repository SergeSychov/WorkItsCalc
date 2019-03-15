
//
//  AppearedViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 16.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AppearedViewController.h"

@interface AppearedViewController ()


@property (nonatomic,strong) NSString* returnString;

@end

@implementation AppearedViewController

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma LAZY INITIALIZATION

-(NSString*)returnString
{
    if(!_returnString){
        _returnString = @"CLOSED";
    }
    return _returnString;
}
-(UIColor*) mainViewBackGroundColor
{
    if(!_mainViewBackGroundColor){
        _mainViewBackGroundColor = [UIColor whiteColor];
    }
    return _mainViewBackGroundColor;
}

#pragma mark GET VIEW FROM PARENT CONTROLLER
- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

-(UIView*)viewFromParentController:(UIViewController*)controller
{
    CGRect needFrame = controller.view.frame;
    
    UIView *newview = [[UIView alloc] initWithFrame:needFrame];
    newview.layer.contents = (id)[self imageFromLayer:controller.view.layer].CGImage;
    
    return newview;
}

-(UIView*)viewFromParentControllerView:(UIView*)view
{
    CGRect needFrame = view.frame;
    
    UIView *newview = [[UIView alloc] initWithFrame:needFrame];
    newview.layer.contents = (id)[self imageFromLayer:view.layer].CGImage;
    
    return newview;
}

-(id)initWithController:(UIViewController*)controller
{
    self = [super init];
    if(self){
        self.copiedView = [self viewFromParentController:controller];
        _appearens = YES;
    }
    
    return self;
}


-(void) setCopiedView:(UIView *)copiedView
{
    _copiedView = copiedView;
    [self.view setNeedsDisplay];
    
}


-(void) addNeededSubviewsOnMainView
{
    //owerride layout of subviews
}

-(void)subViewLayoutWithRect:(CGRect)rect
{
    //owerride subviews
}

-(UIView*) mainView
{
    if(!_mainView){

        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = self.mainViewBackGroundColor;
        if(!self.direction){
            mainView.alpha = 1;
            [self.view insertSubview:mainView atIndex:0];
        } else {
            mainView.alpha = 0.;
            [self.view addSubview:mainView];
        }

        _mainView = mainView;
        [self addNeededSubviewsOnMainView];
    }
    
    return _mainView;
}

-(void) viewDidLayoutSubviews{
}

- (void) viewDidAppear:(BOOL)animated
{
    CGRect mainRect = self.view.bounds;
    CGRect subRect = self.view.bounds;
    if(!self.direction){
        mainRect.origin.x = mainRect.origin.x - mainRect.size.width*(1/0.8-1)/2;
        mainRect.origin.y = mainRect.origin.y - mainRect.size.height*(1/0.8-1)/2;
        mainRect.size.width = mainRect.size.width*1/0.8;
        mainRect.size.height = mainRect.size.height*1/0.8;
        
        subRect.origin.x = subRect.origin.x - mainRect.origin.x;
        subRect.origin.y = subRect.origin.y - mainRect.origin.y;
    }
    [self.mainView setFrame:mainRect];
    [self subViewLayoutWithRect:subRect];
    
    if(self.appearens){

        
        CGAffineTransform scaleTransformMain;
        CGAffineTransform scaleTransformCopied;
        if(self.direction){
            scaleTransformMain = CGAffineTransformMakeScale(4., 4.);
            scaleTransformCopied = CGAffineTransformMakeScale(0.8, 0.8);
        } else {
            scaleTransformMain = CGAffineTransformMakeScale(0.8, 0.8);
            scaleTransformCopied = CGAffineTransformMakeScale(4., 4.);
        }
        
        [self.mainView setTransform:scaleTransformMain];
        
        UIViewAnimationOptions option = UIViewAnimationOptionBeginFromCurrentState;
        
        [UIView animateWithDuration: .4
                              delay: 0
                            options: option
                         animations:^{
                             
                             [self.copiedView setTransform:scaleTransformCopied];
                             [self.mainView setTransform:CGAffineTransformMakeScale(1., 1.)];
                             if(self.direction){
                                 self.mainView.alpha = 1;
                             } else {
                                 self.copiedView.alpha = 0;
                             }
                         }
                         completion:^(BOOL finished) { }
         ];
        
    }
    
}
-(void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    CGAffineTransform scaleTransformMain;
    CGAffineTransform scaleTransformCopied;
    if(self.direction){
        scaleTransformMain = CGAffineTransformMakeScale(4., 4.);
        scaleTransformCopied = CGAffineTransformMakeScale(0.8, 0.8);
    } else {
        scaleTransformMain = CGAffineTransformMakeScale(0.8, 0.8);
        scaleTransformCopied = CGAffineTransformMakeScale(4., 4.);
        self.mainView.alpha = 1.;
    }
    
    [UIView animateWithDuration: .4
                          delay: 0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.copiedView setTransform:CGAffineTransformMakeScale(1., 1.)];
                         [self.mainView setTransform:scaleTransformMain];
                         if(self.direction){
                             self.mainView.alpha = 0.;
                         } else {
                             self.copiedView.alpha = 1;
                         }
                         
                     }
                     completion:^(BOOL finished) { [super dismissViewControllerAnimated:NO completion:completion];}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.copiedView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return NO;
}


@end


