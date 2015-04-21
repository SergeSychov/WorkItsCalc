//
//  AboutViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 08.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AboutViewController.h"
#import "LogoView.h"
#import "OnlyLogoView.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])


@interface AboutViewController ()

@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic, weak) UILabel *appName;
@property (nonatomic, weak) UILabel *appRight;
@property (nonatomic,weak) UILabel *trialText;
@property (nonatomic,weak) UILabel *trialPeriod;
@property (nonatomic, weak) UIButton *infoButton;

@property (nonatomic,weak) UILabel *lost;
@property (nonatomic,weak) UILabel *days;
@property (nonatomic,weak) UILabel *lostDays;


@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *buyButton;
@property (nonatomic) BOOL direction;

@end

@implementation AboutViewController
-(BOOL) prefersStatusBarHidden
{
    return YES;
}
-(NSInteger)  daysNumber {
    
    return 30;
}

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

-(id)initWithController:(UIViewController*)controller
{
    self = [super init];
    if(self){
        self.copiedView = [self viewFromParentController:controller];
        [self.view addSubview:self.copiedView];
        _direction = YES;
        
    }
    
    return self;
}


-(void) userPressedMoreButton:(id)sender
{

}



-(LogoView*) mainView
{
    if(!_mainView){
        
        //logo view
        LogoView *mainView = [[LogoView alloc] initWithFrame:self.view.bounds];
        mainView.alpha = 0.;
        
        //app name label
        CGRect appNameRect = CGRectMake(100,
                                        0,
                                        self.view.bounds.size.width - 200,
                                        self.view.bounds.size.height/10);
        UILabel *appNameLabel = [[UILabel alloc] initWithFrame:appNameRect];
        appNameLabel.center = CGPointMake(self.view.center.x, self.view.center.y*3/4);
        
        UIFont *font = [UIFont systemFontOfSize:36];;
        UIColor *textColor = [UIColor whiteColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        style.lineHeightMultiple = 0;
        
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
        
        NSAttributedString *stringItsCalc = [[NSAttributedString alloc] initWithString:@"Its Calc" attributes:attributes];
        [appNameLabel setAttributedText:stringItsCalc];

        [appNameLabel setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:appNameLabel];
        _appName = appNameLabel;
        
    
        //trialPeriod
        CGFloat bottomOfAppName = self.appName.frame.origin.y + self.appName.frame.size.height -10 ;
        UILabel *trialPeriod = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                            bottomOfAppName,
                                                                            self.view.bounds.size.width - 40, self.appName.frame.size.height/4)];
        font = [UIFont systemFontOfSize:12];
        textColor = [UIColor whiteColor];
        NSMutableParagraphStyle *styleTwo = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        styleTwo.alignment = NSTextAlignmentCenter;
        styleTwo.lineHeightMultiple = 0;
        
        
        NSDictionary *attributesTrial = [[NSDictionary alloc] initWithObjectsAndKeys:[styleTwo copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , @2.8, NSKernAttributeName, nil];
        
        NSAttributedString *returnStr = [[NSAttributedString alloc] initWithString:@"trial period" attributes:attributesTrial];


        [trialPeriod setAttributedText:returnStr];
        trialPeriod.font = [UIFont systemFontOfSize:17 weight:0.1];
        trialPeriod.adjustsFontSizeToFitWidth = YES;
        _trialPeriod = trialPeriod;
        
        [mainView addSubview:trialPeriod];
        
        //app logo
        CGFloat logoHeight = self.appName.frame.origin.y - 40;

        CGRect logoRect = CGRectMake((self.view.bounds.size.width - logoHeight)/2,
                                     20,
                                     logoHeight,
                                     logoHeight);
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:logoRect];
        logoView.image = [UIImage imageNamed:@"Logo.png"];
        [logoView setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:logoView];
        self.logoView = logoView;

        //trial text
        //CGFloat bottomOfAppName = self.appName.frame.origin.y + self.appName.frame.size.height;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        infoButton.tintColor = [UIColor whiteColor];

        CGFloat yCenterTwoLbels = (appNameLabel.center.y+trialPeriod.center.y)/2;
        [infoButton setCenter:CGPointMake(appNameLabel.frame.origin.x +appNameLabel.frame.size.width + 1.5* infoButton.frame.size.width ,
                                              yCenterTwoLbels)];
       
        
        UILabel *trialTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                           bottomOfAppName + 15,
                                                                            self.view.bounds.size.width - 40, logoHeight/2)];
        [trialTextLabel setText:@"Испытывайте преимущества полной версии приложения"];
        trialTextLabel.font = [UIFont systemFontOfSize:40 weight:0.1];
        trialTextLabel.adjustsFontSizeToFitWidth = YES;
        trialTextLabel.numberOfLines = 0;
        trialTextLabel.textAlignment = NSTextAlignmentCenter;
        trialTextLabel.textColor = [UIColor whiteColor];
        _trialText = trialTextLabel;
        [mainView addSubview:trialTextLabel];

        _infoButton = infoButton;
        [mainView addSubview:infoButton];
        
        
        //copyRight
        
        CGRect appRightRect = CGRectMake(10,
                                         self.view.bounds.size.height-25,
                                         self.view.bounds.size.width-20,
                                         20);
        UILabel *appRightLabel = [[UILabel alloc] initWithFrame:appRightRect];
        [appRightLabel setText:@"Copyright (c) 2015 Serge Sychov. All rights reserved."];
        
        appRightLabel.textAlignment = NSTextAlignmentCenter;
        appRightLabel.textColor = [UIColor whiteColor];
        [appRightLabel setBackgroundColor:[UIColor clearColor]];
        appRightLabel.font = [UIFont systemFontOfSize:17 weight:.1];
        
        appRightLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        appRightLabel.adjustsFontSizeToFitWidth = YES;
        [mainView addSubview:appRightLabel];
        _appRight = appRightLabel;
        
        //buttons
        
        CGFloat buttonWidth = (self.view.bounds.size.width)/2 - 10;
        
        font = [UIFont systemFontOfSize:20];
        textColor = [UIColor whiteColor];
        NSMutableParagraphStyle *buttonStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        buttonStyle.alignment = NSTextAlignmentCenter;
        //buttonStyle.lineHeightMultiple = 0;
        //buttonStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary *buttonAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[buttonStyle copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
        
        NSAttributedString *continueString = [[NSAttributedString alloc] initWithString:@"продолжить триал период" attributes:buttonAttributes];
        NSAttributedString *buyString = [[NSAttributedString alloc] initWithString:@"получить полную версию" attributes:buttonAttributes];
        
        NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
        CGSize needSize = CGSizeMake(buttonWidth, 1000);
        CGRect needRectForcontinueString = [continueString boundingRectWithSize:needSize options:NSStringDrawingUsesLineFragmentOrigin context:drawContext];
        CGRect needRectForBuyString = [buyString boundingRectWithSize:needSize options:NSStringDrawingUsesFontLeading context:drawContext];
        
        //choose maximum of two heights
        CGFloat buttonHeight = (needRectForcontinueString.size.height > needRectForBuyString.size.height)? needRectForcontinueString.size.height : needRectForBuyString.size.height;
        
        
        CGFloat buttonOriginY = appRightLabel.frame.origin.y - buttonHeight - 15;

        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        buyButton.contentMode = UIViewContentModeRedraw;
        [buyButton setFrame:CGRectMake(5,
                                          buttonOriginY,
                                          buttonWidth,
                                          buttonHeight)];
        
        buyButton.tintColor = [UIColor whiteColor];
        [buyButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        buyButton.backgroundColor = [UIColor clearColor];
        [buyButton setTitle:[buyString string] forState:UIControlStateNormal];
        buyButton.titleLabel.numberOfLines = 0;
        buyButton.titleLabel.font = font;
        buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:buyButton];
        _buyButton = buyButton;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.contentMode = UIViewContentModeRedraw;
        [cancelButton setFrame:CGRectMake(self.view.center.x + 5,buttonOriginY,
                                       buttonWidth,
                                       buttonHeight)];
        
        cancelButton.tintColor = [UIColor whiteColor];
        [cancelButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setTitle:[continueString string] forState:UIControlStateNormal];
        cancelButton.titleLabel.numberOfLines = 0;
        cancelButton.titleLabel.font = font;
        cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:cancelButton];
        _cancelButton = cancelButton;
        
        //add days information
        //1. findon therd part buttom of trail Text - top of buttons
        CGFloat bottomOfTrialText = trialTextLabel.frame.origin.y + trialTextLabel.frame.size.height;
        CGFloat thirdPart = (buyButton.frame.origin.y - bottomOfTrialText)/3;
        CGPoint centerDaysNumber = CGPointMake(self.view.center.x,bottomOfTrialText + 3*thirdPart/2);
        CGFloat heightOfDays = thirdPart*1.3;
        
        UILabel * days = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, heightOfDays, heightOfDays)];
        [days setCenter:centerDaysNumber];
        days.text= [@(self.daysNumber) stringValue];
        days.textAlignment = NSTextAlignmentCenter;
        days.font = [UIFont systemFontOfSize:heightOfDays/1.1];
        days.textColor = [UIColor whiteColor];
        [mainView addSubview:days];
        _days = days;
        
        //@property (nonatomic,weak) UILabel *lost;
        CGFloat lostAndDaysLabelsWidth = centerDaysNumber.x - 15 - 1.5 * days.bounds.size.width/2;
        
        UILabel *lost = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                  centerDaysNumber.y - heightOfDays/4,
                                                                  lostAndDaysLabelsWidth,
                                                                  heightOfDays/2)];
        
        UILabel *lostDays = [[UILabel alloc] initWithFrame:CGRectMake(days.frame.origin.x+2.5*days.frame.size.width/2,
                                                                      centerDaysNumber.y - heightOfDays/4,
                                                                      lostAndDaysLabelsWidth,
                                                                      heightOfDays/2)];
        lost.text = @"еще";
        lostDays.text = @"дней";
        
        lost.textAlignment = NSTextAlignmentCenter;
        lostDays.textAlignment = NSTextAlignmentCenter;
        
        lost.font = [UIFont systemFontOfSize:heightOfDays/2.2];
        lostDays.font = [UIFont systemFontOfSize:heightOfDays/2.2];
        
        lost.textColor = [UIColor whiteColor];
        lostDays.textColor = [UIColor whiteColor];
        
        [mainView addSubview:lost];
        _lost = lost;
        [mainView addSubview:lostDays];
        _lostDays = lostDays;
        
        
       // @property (nonatomic,weak) UILabel *lostDays;
        

        [self.view insertSubview:mainView atIndex:1];
        _mainView = mainView;
    }
    
    return _mainView;
}


-(void) setCopiedView:(UIView *)copiedView
{
    _copiedView = copiedView;
    [self.view setNeedsDisplay];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    if(self.direction){
        [self.mainView setFrame:self.view.frame];
        [self.logoView setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.trialPeriod setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.trialText setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.cancelButton setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.buyButton setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.appName setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.appRight setTransform:CGAffineTransformMakeScale(8., 8.)];
        
        [self.infoButton setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.lost setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.days setTransform:CGAffineTransformMakeScale(8., 8.)];
        [self.lostDays setTransform:CGAffineTransformMakeScale(8., 8.)];

        UIViewAnimationOptions option = UIViewAnimationOptionBeginFromCurrentState;
        
        [UIView animateWithDuration: 0.4
                              delay: 0
                            options: option
                         animations:^{
                             
                             // self.copiedView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                             [self.copiedView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];//(.8, .8)];
                             [self.logoView setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.trialPeriod setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.trialText setTransform:CGAffineTransformMakeScale(1., 1.)];

                             [self.cancelButton setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.buyButton setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.appName setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.appRight setTransform:CGAffineTransformMakeScale(1., 1.)];
                             
                             [self.infoButton setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.lost setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.days setTransform:CGAffineTransformMakeScale(1., 1.)];
                             [self.lostDays setTransform:CGAffineTransformMakeScale(1., 1.)];

                             self.mainView.alpha = 1;
                             //self.blurView.alpha = 1.;
                         }
                         completion:^(BOOL finished) { }
         ];
        
    }
    
}
-(void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [UIView animateWithDuration: 0.3
                          delay: 0
                        options: UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         
                         // self.copiedView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                         [self.copiedView setTransform:CGAffineTransformMakeScale(1., 1.)];
                         [self.logoView setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.trialPeriod setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.trialText setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.cancelButton setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.buyButton setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.appName setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.appRight setTransform:CGAffineTransformMakeScale(8., 8.)];
                         
                         [self.infoButton setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.lost setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.days setTransform:CGAffineTransformMakeScale(8., 8.)];
                         [self.lostDays setTransform:CGAffineTransformMakeScale(8., 8.)];

                         
                         self.mainView.alpha = 0.;
                         //self.blurView.alpha = 0.;
                         
                     }
                     completion:^(BOOL finished) { [super dismissViewControllerAnimated:NO completion:completion];}];
    
}

-(void) userPressedCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

-(void)viewDidLayoutSubviews{
    /*
    //[self.copiedView setFrame:self.view.bounds];
    [self.mainView setFrame:self.view.bounds];
    //CGFloat buttonHeight = 30.;
    //[self.cancelButton setFrame:CGRectMake(0,
                                      (self.view.bounds.size.height-buttonHeight)*2/3,
                                      self.view.bounds.size.width,
                                      buttonHeight)];
    
    
    CGRect logoRect = CGRectMake(0, self.view.bounds.size.height/15, self.view.bounds.size.width, self.view.bounds.size.height/3);
    [self.logoView setFrame:logoRect];
     */
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.copiedView];
    // Do any additional setup after loading the view.
    //[self setMotionEffectToView:self.copiedView];
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
