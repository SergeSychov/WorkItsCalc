//
//  AboutViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 08.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AboutViewController.h"
#import "LogoTextView.h"
#import "AdditionViewController.h"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define INDENT 20.0f


@interface AboutViewController ()

@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic,weak) LogoTextView *logoTextView;
@property (nonatomic, weak) UILabel *appRight;
@property (nonatomic,weak) UILabel *trialText;
@property (nonatomic, weak) UIButton *infoButton;

@property (nonatomic,weak) UILabel *lost;
@property (nonatomic,weak) UILabel *days;
@property (nonatomic,weak) UILabel *lostDays;


@property (nonatomic, weak) UIButton *continueButton;
@property (nonatomic, weak) UIButton *buyButton;

@property (nonatomic) CGSize mainFontSize;
@property (nonatomic) CGSize secondFontSize;

@end

@implementation AboutViewController

# pragma mark LAZY INITIALIZATION
//lazy initialization
-(NSString*) trialTextString
{
    if(!_trialTextString){
        if(self.daysNumber <0){
            _trialTextString = @"Триал период завершен. Дополнительные возможности будут отключены.";
        } else {
            _trialTextString = @"тестируйте преимущества дополнительных функций";
        }
    }
    
    return _trialTextString;
}

-(NSString*) continueString
{
    if(!_continueString){
        if(self.daysNumber < 0){
            _continueString = @"продолжить";
        } else {
            _continueString = @"продолжить триал период";
        }
    }
    return _continueString;
}

-(NSString*) buyString
{
    if(!_buyString){
        _buyString = @"приобрести дополнения";
    }
    return _buyString;
}

-(NSString*) moreString
{
    if(!_moreString){
        _moreString = @"еще";
    }
    return _moreString;
}

-(NSString*) daysString
{
    if(!_daysString){
        _daysString = @"дней";
    }
    return _daysString;
}

-(NSInteger)  daysNumber {
    if(!_daysNumber){
        _daysNumber = 30;
    }
    return _daysNumber;
}

-(id)initWithController:(UIViewController*)controller daysLeft:(NSInteger)days{

    self = [super initWithController:controller];
    if(self){
        //self.copiedView = [self viewFromParentController:controller];
        self.daysNumber = days;
        //_appearensFromTop = YES;
    }
    
    return self;
}

#pragma mark PRESSED ACTION
-(void) userPressedInfoButton:(id)sender
{
    NSLog(@"User Press Info Button");
    AdditionViewController *additionController = [[AdditionViewController alloc] initWithController:self];
    self.appearens = NO;
    additionController.direction = YES;
    additionController.mainViewBackGroundColor = self.mainViewBackGroundColor;
    
    [self presentViewController:additionController animated:NO completion:^{
        nil;
    }];
}

-(void) userPressedCancelButton:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if([sender.titleLabel.text isEqualToString:self.buyString]){
            [self.delegate aboutControllerDidCloseWithString:@"BUY"];
           
        } else if ([sender.titleLabel.text isEqualToString:self.continueString]){
            if(self.daysNumber > 0){ //if continue trial period
                [self.delegate aboutControllerDidCloseWithString:@"CONTINUE"];
            } else { //if work without addition after trial period is finished
                [self.delegate aboutControllerDidCloseWithString:@"CLOSE"];
            }
        }
    }];
}

#pragma mark ADD_AND_LAYOUT_SUBVIEWS
-(void) subViewLayoutWithRect:(CGRect) rect;
{
    [self.logoView setFrame:CGRectMake(INDENT,
                                       INDENT,
                                       rect.size.width - 2*INDENT,
                                       rect.size.height/3 -2*INDENT)];
    
    //calculate parts for labels layout
    CGFloat startHeight = rect.size.height/3;
    CGFloat heightPart = (rect.size.height*2/3 - 2*INDENT)/4;
    
    //set frame for itsCalc and get font size
    CGFloat itcCalcFontSize =[self.logoTextView setFrameAndReturnStringAccordingHeight:heightPart];
    
    CGRect rct = self.logoTextView.frame;
    rct.origin.y = startHeight;
    rct.origin.x = (rect.size.width - rct.size.width)/2;
    [self.logoTextView setFrame:rct];
    
    [self.infoButton setCenter:CGPointMake(rct.origin.x + rct.size.width + INDENT, self.logoTextView.center.y + INDENT/2)];
    
    //get font sizes from logo view
    UIFont *secondFont = [UIFont systemFontOfSize:itcCalcFontSize/2];
    UIFont *daysFont = [UIFont systemFontOfSize:itcCalcFontSize*1.63];
    
    CGRect rectForTrialText;// = CGRectMake(INDENT, startHeight + heightPart, rect.size.width - 2*INDENT, heightPart);
    
    //show these labels only at trial period
    if(self.daysNumber >= 0) {
        rectForTrialText = CGRectMake(INDENT, startHeight + heightPart, rect.size.width - 2*INDENT, heightPart);
        [self.trialText setFont:secondFont];
        [self.trialText setFrame:rectForTrialText];
        //setFrames for days
        CGRect rctForDays = CGRectMake((rect.size.width - 1.5*heightPart)/2, startHeight +2*heightPart, 1.5*heightPart, heightPart);
        [self.days setFont:daysFont];
        [self.days setFrame:rctForDays];
        
        //set frame for "more"
        CGRect rctForMore = CGRectMake(INDENT, startHeight +2*heightPart + heightPart/4, (rect.size.width - 1.5*heightPart)/2 - 2*INDENT, heightPart/2);
        [self.lost setFont:secondFont];
        [self.lost setFrame:rctForMore];
    
        //set frame for "lostDays"
        CGRect rctForLosDays = CGRectMake(rctForDays.origin.x + rctForDays.size.width + INDENT, startHeight +2*heightPart + heightPart/4, (rect.size.width -1.5* heightPart)/2 - 2*INDENT, heightPart/2);
        [self.lostDays setFont:secondFont];
        [self.lostDays setFrame:rctForLosDays];
    } else {
        rectForTrialText = CGRectMake(INDENT, startHeight + 1.5*heightPart, rect.size.width - 2*INDENT, 1.5*heightPart);
        
    }

    [self.trialText setFont:daysFont];
    [self.trialText setFrame:rectForTrialText];
    
    //setFrames for button
    CGRect rctForButton = CGRectMake(INDENT/2, startHeight+3*heightPart, rect.size.width/2 - INDENT, heightPart);
    [self.continueButton.titleLabel setFont:secondFont];
    [self.buyButton.titleLabel setFont:secondFont];
    
    [self.continueButton setFrame:rctForButton];
    
    rctForButton.origin.x = rect.size.width/2+INDENT/2;
    [self.buyButton setFrame:rctForButton];
    
    //set frame for app rights
    CGRect appRightRect = CGRectMake(INDENT,
                                     rect.size.height-2*INDENT,
                                     rect.size.width-INDENT,
                                     INDENT);
    [self.appRight setFrame:appRightRect];

}

-(void) addNeededSubviewsOnMainView
{
    //set logo view
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    [logoImg setContentMode:UIViewContentModeScaleAspectFit];
    [self.mainView addSubview:logoImg];
    self.logoView = logoImg;
    
    UIColor* textColor = [UIColor whiteColor];
    
    //set logoTextView
    LogoTextView *logoTextView = [[LogoTextView alloc] init];
    [logoTextView setContentMode:UIViewContentModeRedraw];
    [logoTextView setBackgroundColor:[UIColor clearColor]];
    [logoTextView setTextColor:textColor];
    [self.mainView addSubview:logoTextView];
    _logoTextView = logoTextView;
    
    //set info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoButton.tintColor = textColor;
    [infoButton addTarget:self action:@selector(userPressedInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:infoButton];
    _infoButton = infoButton;
    
    //set explanation trial tex
    UILabel *trialTextLabel = [[UILabel alloc] init];
    [trialTextLabel setText:self.trialTextString];
    trialTextLabel.adjustsFontSizeToFitWidth = YES;
    trialTextLabel.numberOfLines = 0;
    trialTextLabel.textAlignment = NSTextAlignmentCenter;
    trialTextLabel.textColor = textColor;
    [self.mainView addSubview:trialTextLabel];
    _trialText = trialTextLabel;
    
    
    
    //don't show these labels if trial is finished
    if(self.daysNumber >= 0){
        //set days
        UILabel * days = [[UILabel alloc] init];
        days.text= [@(self.daysNumber) stringValue];
        days.textAlignment = NSTextAlignmentCenter;
        days.textColor = textColor;
        [self.mainView addSubview:days];
        _days = days;
        
        UILabel *lost = [[UILabel alloc] init];
        UILabel *lostDays = [[UILabel alloc] init];
        
        lost.text = self.moreString;
        lostDays.text = self.daysString;
        
        lost.textAlignment = NSTextAlignmentRight;
        lostDays.textAlignment = NSTextAlignmentLeft;
        
        lost.textColor = textColor;
        lostDays.textColor = textColor;
        
        [self.mainView addSubview:lost];
        [self.mainView addSubview:lostDays];
        _lost = lost;
        _lostDays = lostDays;
    }
    
    //set buttons
    //buy button
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    buyButton.contentMode = UIViewContentModeRedraw;
    buyButton.tintColor = textColor;
    [buyButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    buyButton.backgroundColor = [UIColor clearColor];
    [buyButton setTitle:self.buyString forState:UIControlStateNormal];
    buyButton.titleLabel.numberOfLines = 0;
    buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:buyButton];
    _buyButton = buyButton;
    
    //continue button
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    continueButton.contentMode = UIViewContentModeRedraw;
    continueButton.tintColor = textColor;
    [continueButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    continueButton.backgroundColor = [UIColor clearColor];
    [continueButton setTitle:self.continueString forState:UIControlStateNormal];
    continueButton.titleLabel.numberOfLines = 0;
    continueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:continueButton];
    _continueButton = continueButton;
    
    //copyRight
    UILabel *appRightLabel = [[UILabel alloc] init];
    [appRightLabel setText:@"Copyright (c) 2015 Serge Sychov. All rights reserved."];
    appRightLabel.textAlignment = NSTextAlignmentCenter;
    appRightLabel.textColor = textColor;
    [appRightLabel setBackgroundColor:[UIColor clearColor]];
    appRightLabel.font = [UIFont systemFontOfSize:17 weight:.1];
    appRightLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    appRightLabel.adjustsFontSizeToFitWidth = YES;
    [self.mainView addSubview:appRightLabel];
    _appRight = appRightLabel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:self.copiedView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
