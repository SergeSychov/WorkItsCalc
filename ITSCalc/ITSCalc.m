//
//  ITSCalc.m
//  ITSCalc
//
//  Created by Serge Sychov on 04.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import "ITSCalc.h"
#import <CoreLocation/CoreLocation.h>
#import "Currensies.h"
#import "CurrencyStore.h"
#import "CalcButton.h"
#import "convertBut.h"
#import "Reachability.h"

#define LAST_FROM_CURRENCY @"LastFromCurrency"
#define LAST_TO_CURRENCY @"LastToCurrency"

#define LIST_CHANGED_NOTIFICATION @"ListChangedNotification"
#define NOT_AVAILABLE_SERVISE_NOTIFICATION @"NotAvailableServiceNotification"

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@interface ITSCalc() <UIPickerViewDelegate, UIPickerViewDataSource,GetPairCurrensiesProtocol>

@property (weak, nonatomic) UIVisualEffectView *blur;
@property (weak, nonatomic) UIView *blurBackGroundView;
@property (weak, nonatomic) UIPickerView *currencyFromPicker;
@property (weak, nonatomic) UIPickerView *currencyToPicker;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) ConvertBut *convertButton;
@property (weak, nonatomic) CalcButton *backButton;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *showCurrensiesGestureRecognizer;


@property (nonatomic,strong) NSArray* listCurrensiesForPicker;//list of currensies for pickers, save inusers default

@property (nonatomic) CurrencyStore *converter;//initial and string curensies storage

//for currency cviper
@property (nonatomic) CGPoint currencySvipeGestureLocation;
@property (nonatomic) CGFloat blurAlpha;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic) Reachability *rechablity;
@property (nonatomic) BOOL wasInternetConnected;

@end

@implementation ITSCalc

#pragma mark DRAG GESTURE RECOGNIZERS
- (IBAction)currencyDragGestureRecognizer:(UIPanGestureRecognizer *)sender {
    
    CGPoint currencySvipeGestureLocation = [sender locationInView:self.blur];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        
        self.currencySvipeGestureLocation = currencySvipeGestureLocation;
        self.blurAlpha = self.blur.alpha;
        
        self.blur.hidden = NO;
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        CGFloat svipePersent = (currencySvipeGestureLocation.x - self.currencySvipeGestureLocation.x)/ (self.view.frame.size.width /2.);
        
        if(svipePersent < 1. || svipePersent > -1.){
            self.blur.alpha = self.blurAlpha+svipePersent;
            CGFloat innitialCenterXFrom = (self.blurAlpha*self.blurBackGroundView.frame.size.width*2/5 - self.blurBackGroundView.frame.size.width/5);
            CGFloat settedCenterX = self.blurBackGroundView.frame.size.width/5*2*svipePersent+innitialCenterXFrom;
            
            CGFloat initialCenterXTo = (self.blurBackGroundView.frame.size.width*6/5 - self.blurAlpha*self.blurBackGroundView.frame.size.width*2/5);
            CGFloat settedCenterXTo = initialCenterXTo -self.blurBackGroundView.frame.size.width/5*2*svipePersent;
            
            //set initial value for label
            //y from self.blur.frame.size.height + self.blur.frame.size.width/12  to self.currencyFromPicker.frame.origin.y + self.blur.frame.size.width/6
            CGFloat labelWay = (self.blurBackGroundView.frame.size.height + self.blurBackGroundView.frame.size.width/12)- self.blurBackGroundView.frame.size.width/6;
            CGFloat initialCenteYLabel = (1-self.blurAlpha)*labelWay + self.blurBackGroundView.frame.size.width/6;
            CGFloat settedCenteYLabel = initialCenteYLabel - svipePersent*labelWay;
            
            CGFloat cButtonWay = self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/7 //initial value
            -self.blurBackGroundView.center.y;
            CGFloat initCenterYConBut = (1-self.blurAlpha)*cButtonWay+self.blurBackGroundView.center.y;
            CGFloat settedCenterYcBut = initCenterYConBut - svipePersent*cButtonWay;
            
            CGFloat backButtonWay = self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/3.5+ self.blurBackGroundView.frame.size.width/12 -(self.blurBackGroundView.frame.size.height - self.blurBackGroundView.frame.size.width/6) ;
            CGFloat initCenterYBackBut = (1-self.blurAlpha)*backButtonWay+(self.blur.frame.size.height - self.blur.frame.size.width/6);
            CGFloat settedCenterYbackBut = initCenterYBackBut - svipePersent*backButtonWay;
            
            
            if(settedCenterX >= self.view.frame.size.width/5){
                
                [self.currencyFromPicker setCenter:CGPointMake(self.view.frame.size.width/5, self.blurBackGroundView.center.y)];
                [self.currencyToPicker setCenter:CGPointMake(self.view.frame.size.width*4/5, self.blurBackGroundView.center.y)];
                [self.resultLabel setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.width/6)];
                [self.convertButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.center.y)];
                [self.backButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blur.frame.size.height - self.blurBackGroundView.frame.size.width/6)];
                
            } else if (settedCenterX <= -self.view.frame.size.width/5){
                [self.currencyFromPicker setCenter:CGPointMake(-self.view.frame.size.width/5, self.blurBackGroundView.center.y)];
                [self.currencyToPicker setCenter:CGPointMake(self.view.frame.size.width*6/5, self.blurBackGroundView.center.y)];
                [self.resultLabel setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.width/6 + labelWay)];
                [self.convertButton setCenter:CGPointMake(self.blurBackGroundView.center.x,
                                                          self.blurBackGroundView.frame.size.height+ self.blurBackGroundView.frame.size.width/6+ self.blurBackGroundView.frame.size.width/7)];
                [self.backButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/3.5+ self.blurBackGroundView.frame.size.width/12)];
            } else {
                [self.currencyFromPicker setCenter:CGPointMake(settedCenterX, self.blurBackGroundView.center.y)];
                [self.currencyToPicker setCenter:CGPointMake(settedCenterXTo, self.blurBackGroundView.center.y)];
                [self.resultLabel setCenter:CGPointMake(self.blurBackGroundView.center.x, settedCenteYLabel)];
                [self.convertButton setCenter:CGPointMake(self.blurBackGroundView.center.x, settedCenterYcBut)];
                [self.backButton setCenter:CGPointMake(self.blurBackGroundView.center.x, settedCenterYbackBut)];
            }
            
        } else  if (svipePersent >=1.){
            self.blur.alpha = 1;
            self.blur.hidden = NO;
            [self.currencyFromPicker setCenter:CGPointMake(self.view.frame.size.width/5, self.blurBackGroundView.center.y)];
            [self.currencyToPicker setCenter:CGPointMake(self.view.frame.size.width*4/5, self.blurBackGroundView.center.y)];
            [self.resultLabel setCenter:CGPointMake(self.blurBackGroundView.center.x,self.blurBackGroundView.frame.size.width/6)];
            [self.convertButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.center.y)];
            [self.backButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blur.frame.size.height - self.blurBackGroundView.frame.size.width/6)];
        } else {
            self.blur.alpha = 0;
            self.blur.hidden = YES;
            [self.currencyFromPicker setCenter:CGPointMake(-self.view.frame.size.width/5, self.blurBackGroundView.center.y)];
            [self.currencyToPicker setCenter:CGPointMake(self.view.frame.size.width*6/5, self.blurBackGroundView.center.y)];
            [self.resultLabel setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.width + self.blurBackGroundView.frame.size.width/12)];
            [self.convertButton setCenter:CGPointMake(self.blurBackGroundView.center.x,
                                                      self.blurBackGroundView.frame.size.height+ self.blurBackGroundView.frame.size.width/6+ self.blurBackGroundView.frame.size.width/7)];
            [self.backButton setCenter:CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/3.5+ self.blurBackGroundView.frame.size.width/12)];
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if(self.blurAlpha == 0){
            if(self.blur.alpha > 0.3){
                
                [self endDrawCurrencyConverterOn:YES withVelocity:[sender velocityInView:self.blur]];
                
            } else {
                
                [self endDrawCurrencyConverterOn:NO withVelocity:[sender velocityInView:self.blur]];
                
            }
        } else {
            if(self.blur.alpha > 0.7){
                
                [self endDrawCurrencyConverterOn:YES withVelocity:[sender velocityInView:self.blur]];
                
            } else {
                
                [self endDrawCurrencyConverterOn:NO withVelocity:[sender velocityInView:self.blur]];
                
            }
        }
        
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
        // NSLog(@"filed or canceled");
    }
    
}

-(void)endDrawCurrencyConverterOn:(BOOL)isOn withVelocity:(CGPoint)velocity
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.blur];
    velocity.y = 0;
    UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.currencyFromPicker, self.currencyToPicker, self.resultLabel, self.convertButton,self.backButton]];
    dynamicItem.allowsRotation = NO;
    //add dinamics for pickers
    [dynamicItem addLinearVelocity:velocity forItem:self.currencyFromPicker];
    CGPoint velocityMirrow = CGPointMake(-velocity.x, 0);
    [dynamicItem addLinearVelocity:velocityMirrow forItem:self.currencyToPicker];
    
    //ad  dinamics for label and buttons
    //first count velocity for each element
    //for label
    CGFloat labelWay = (self.blurBackGroundView.frame.size.height + self.blurBackGroundView.frame.size.width/12)- (self.blurBackGroundView.frame.size.width/6);//whole way
    CGFloat labelVelocityRatio = labelWay/(self.blurBackGroundView.frame.size.width*2);//ration
    CGPoint velocityLabel = CGPointMake(0, velocity.x*labelVelocityRatio);
    [dynamicItem addLinearVelocity:velocityLabel forItem:self.resultLabel];
    //for convertButton
    CGFloat convertButtonWay = self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/7 //initial value
    -self.currencyToPicker.center.y;
    CGFloat convertButtonVelocityRatio = convertButtonWay/(self.blurBackGroundView.frame.size.width*2);//ration
    CGPoint velocityConvertButton = CGPointMake(0, velocity.x*convertButtonVelocityRatio);
    [dynamicItem addLinearVelocity:velocityConvertButton forItem:self.convertButton];
    //for back button
    CGFloat backButtonWay = self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6+self.blurBackGroundView.frame.size.width/3.5+ self.blurBackGroundView.frame.size.width/12 -(self.blur.frame.size.height - self.blurBackGroundView.frame.size.width/6);
    CGFloat backButtonVelocityRatio = backButtonWay/(self.view.frame.size.width*2);//ration
    CGPoint velocityBackButton = CGPointMake(0, velocity.x*backButtonVelocityRatio);
    [dynamicItem addLinearVelocity:velocityBackButton forItem:self.backButton];
    
    [animator addBehavior:dynamicItem];
    if(isOn){
        //add snapBehaviour for pickers
        CGFloat centerX = self.blur.frame.size.width/5;
        CGPoint snapPoint = CGPointMake(centerX,self.blurBackGroundView.center.y);
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.currencyFromPicker snapToPoint:snapPoint];
        snap.damping = .5;
        [animator addBehavior:snap];
        
        CGFloat centerX2 = self.blur.frame.size.width*4/5;
        CGPoint snapPoint2 = CGPointMake(centerX2,self.blurBackGroundView.center.y);
        UISnapBehavior *snap2 = [[UISnapBehavior alloc] initWithItem:self.currencyToPicker snapToPoint:snapPoint2];
        snap2.damping = .5;
        [animator addBehavior:snap2];
        
        //add snap Behaviour for others elements
        CGPoint centerLabel = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.width/6);
        UISnapBehavior *snapLabel = [[UISnapBehavior alloc] initWithItem:self.resultLabel snapToPoint:centerLabel];
        snapLabel.damping = 0.2;//*labelVelocityRatio;
        [animator addBehavior:snapLabel];
        
        CGPoint centerConvertButton = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.center.y);
        UISnapBehavior *snapConvertButton = [[UISnapBehavior alloc] initWithItem:self.convertButton snapToPoint:centerConvertButton];
        snapConvertButton.damping = 0.2;//*labelVelocityRatio;
        [animator addBehavior:snapConvertButton];
        
        CGPoint centerBackButton = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height - self.blurBackGroundView.frame.size.width/6);
        UISnapBehavior *snapBackButton = [[UISnapBehavior alloc] initWithItem:self.backButton snapToPoint:centerBackButton];
        snapConvertButton.damping = .3;//*labelVelocityRatio;
        [animator addBehavior:snapBackButton];
        
        
        
        __weak typeof (self) weakSelf = self;
        snap.action = ^{
            typeof(self) strongSelf = weakSelf;
            UIView *viewFrom = strongSelf.currencyFromPicker;
            UIView *viewTo = strongSelf.currencyToPicker;
            UILabel *labelResult = strongSelf.resultLabel;
            UIButton *convertButton = strongSelf.convertButton;
            UIButton *backButton = strongSelf.backButton;
            
            CGFloat blurOpacity;
            blurOpacity = (strongSelf.blurBackGroundView.frame.size.width*2/5)/(viewFrom.frame.origin.x+strongSelf.blurBackGroundView.frame.size.width*2/5);
            strongSelf.blur.alpha = blurOpacity;
            
            
            CGFloat needXFrom = 0;
            CGFloat needXTo = strongSelf.blur.frame.size.width*3/5;
            CGPoint needLabelCenter = CGPointMake(strongSelf.blurBackGroundView.center.x, strongSelf.blurBackGroundView.frame.size.width/6);
            CGPoint needConvertButtonCenter = CGPointMake(strongSelf.blurBackGroundView.center.x, strongSelf.blurBackGroundView.center.y);
            CGPoint needBackButtonCenter = CGPointMake(strongSelf.blurBackGroundView.center.x, strongSelf.blurBackGroundView.frame.size.height - strongSelf.blurBackGroundView.frame.size.width/6);
            //CGFloat needY = self.blur.frame.size.height*2/3;
            
            if(ABS(strongSelf.currencyFromPicker.frame.origin.x) < 1 && [dynamicItem linearVelocityForItem:viewFrom].y < 0.001){
                [animator removeAllBehaviors];
                CGRect dynamicRect = viewFrom.frame;
                dynamicRect.origin.x = needXFrom;
                [viewFrom setFrame:dynamicRect];
                
                dynamicRect = viewTo.frame;
                dynamicRect.origin.x = needXTo;
                [viewTo setFrame:dynamicRect];
                
                [labelResult setCenter:needLabelCenter];
                
                [convertButton setCenter:needConvertButtonCenter];
                
                [backButton setCenter:needBackButtonCenter];
                
                strongSelf.blur.hidden = NO;
                strongSelf.blur.alpha = 1;
                strongSelf.blurAlpha = strongSelf.blur.alpha;
                [self.blur addGestureRecognizer:self.showCurrensiesGestureRecognizer];
                
                
            }
            
            
        };
    }else{
        
        //add snapBehaviour for pickers
        CGFloat centerX = - self.blurBackGroundView.frame.size.width*2./5.-2.;
        CGPoint snapPoint = CGPointMake(centerX,self.blurBackGroundView.center.y);
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.currencyFromPicker snapToPoint:snapPoint];
        snap.damping = 3.;
        [animator addBehavior:snap];
        
        CGFloat centerX2 = self.blurBackGroundView.frame.size.width*(1 +2./5.);
        CGPoint snapPoint2 = CGPointMake(centerX2,self.blurBackGroundView.center.y);
        UISnapBehavior *snap2 = [[UISnapBehavior alloc] initWithItem:self.currencyToPicker snapToPoint:snapPoint2];
        snap2.damping = 3;
        [animator addBehavior:snap2];
        
        //add snap Behaviour for others elements
        CGPoint centerLabel = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height*(1+1./6.));
        UISnapBehavior *snapLabel = [[UISnapBehavior alloc] initWithItem:self.resultLabel snapToPoint:centerLabel];
        snapLabel.damping = 1;//*labelVelocityRatio;
        [animator addBehavior:snapLabel];
        
        CGPoint centerConvertButton = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height*(1+1./6.+2./7.));
        UISnapBehavior *snapConvertButton = [[UISnapBehavior alloc] initWithItem:self.convertButton snapToPoint:centerConvertButton];
        snapConvertButton.damping = 1;//*labelVelocityRatio;
        [animator addBehavior:snapConvertButton];
        
        CGPoint centerBackButton = CGPointMake(self.blurBackGroundView.center.x, self.blurBackGroundView.frame.size.height*(1+1./6.+2./7.+1./6.));
        UISnapBehavior *snapBackButton = [[UISnapBehavior alloc] initWithItem:self.backButton snapToPoint:centerBackButton];
        snapConvertButton.damping = 1;//*labelVelocityRatio;
        [animator addBehavior:snapBackButton];
        //dynamicItem.elasticity = 1.;
        
        __weak typeof (self) weakSelf = self;
        snap.action = ^{
            typeof(self) strongSelf = weakSelf;
            
            UIView *viewFrom = strongSelf.currencyFromPicker;
            UIView *viewTo = strongSelf.currencyToPicker;
            UILabel *labelResult = strongSelf.resultLabel;
            UIButton *convertButton = strongSelf.convertButton;
            UIButton *backButton = strongSelf.backButton;
            
            CGFloat blurOpacity;
            blurOpacity = 1- viewFrom.frame.origin.x/(-strongSelf.blurBackGroundView.frame.size.width*2./5.);
            
            strongSelf.blur.alpha = blurOpacity;
            
            CGFloat needXFrom = - self.blurBackGroundView.frame.size.width*2./5.;
            CGFloat needXTo = self.blurBackGroundView.frame.size.width*(1+4./5.);
            CGFloat needLabelY = self.blurBackGroundView.frame.size.height*(1);
            CGFloat needConvertButtonY = self.blurBackGroundView.frame.size.height*(1+1./6.+2./7.)+2;
            CGFloat needBackButtonY = self.blurBackGroundView.frame.size.height*(1+1./6.+2./7.+1./6.)+2;
            //NSLog(@"currensy from.y: %f, need X: %f", strongSelf.currencyFromPicker.frame.origin.x, needXFrom);
            
            if((strongSelf.resultLabel.frame.origin.y) > needLabelY){
                [animator removeAllBehaviors];
                CGRect dynamicRect = viewFrom.frame;
                dynamicRect.origin.x = needXFrom;
                [viewFrom setFrame:dynamicRect];
                
                dynamicRect = viewTo.frame;
                dynamicRect.origin.x = needXTo;
                [viewTo setFrame:dynamicRect];
                
                dynamicRect = labelResult.frame;
                dynamicRect.origin.y = needLabelY;
                [labelResult setFrame:dynamicRect];
                
                dynamicRect = convertButton.frame;
                dynamicRect.origin.y = needConvertButtonY;
                [convertButton setFrame:dynamicRect];
                
                dynamicRect = backButton.frame;
                dynamicRect.origin.y = needBackButtonY;
                [backButton setFrame:dynamicRect];
                
                strongSelf.blur.hidden = YES;
                strongSelf.blur.alpha = 0;
                strongSelf.blurAlpha = strongSelf.blur.alpha;
                [self.currensies makeNewCurrensiesList];
                [self.viewforCurrencyRecognizer addGestureRecognizer:self.showCurrensiesGestureRecognizer];
            }
            
        };
    }
    
    self.animator = animator;
}

-(void) setBlurAlpha:(CGFloat)blurAlpha
{
    _blurAlpha = blurAlpha;
    if(blurAlpha == 1.){
        [self pickerDidSelect];
    }
}


#pragma mark BUTTONS TAPPED
-(void)convertButtonTapped:(id)sender
{
    //call function to renew usersDictionary: synbol and Array [0] - count of using, [1] - last date using
        //1. make array from string
    NSArray* symbolsArray = [[NSArray alloc]initWithObjects:self.fromCur,self.toCur, nil];
    NSArray *countArray = [[NSArray alloc] initWithObjects:@"$",self.fromCur,self.toCur, self.value, nil];
    [self.currensies renewUsersCurrensies:symbolsArray];
    NSString *resStr = [@"$" stringByAppendingString:self.fromCur];
    resStr = [resStr stringByAppendingString:@"/"];
    resStr = [resStr stringByAppendingString:self.toCur];
    resStr = [resStr stringByAppendingString:@"/"];
    resStr = [resStr stringByAppendingString:[self.value stringValue]];
    
    [self tappedButtonWithTitle:countArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.fromCur forKey:LAST_FROM_CURRENCY];
    [[NSUserDefaults standardUserDefaults] setObject:self.toCur forKey:LAST_TO_CURRENCY];
    
    [self endDrawCurrencyConverterOn:NO withVelocity:CGPointMake(0, 0)];

}

-(void)backButtonTapped:(id)sender
{
    [self endDrawCurrencyConverterOn:NO withVelocity:CGPointMake(0, 0)];
    
}
-(void) discardChanging
{
    [self endDrawCurrencyConverterOn:NO withVelocity:CGPointMake(0, 0)];
    [super discardChanging];
}
#pragma mark PICKERS DELEGATE

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 1;
    if(self.listCurrensiesForPicker){
        rows = self.listCurrensiesForPicker.count*100;
    }
    return rows;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *keyFromList = (NSString*)[self.listCurrensiesForPicker objectAtIndex:row%self.listCurrensiesForPicker.count];
    NSArray* curArr = [self.converter.currensyWithDescription objectForKey:keyFromList];
    
    CGRect rct = CGRectMake(0, 0,
                            pickerView.bounds.size.width,
                            [pickerView rowSizeForComponent:component].height);
    UIView *picView = [[UIView alloc] initWithFrame:rct];
    //picView.backgroundColor = [UIColor greenColor];
    if(pickerView.tag == 2001){
        CGRect rectForFlag = CGRectMake(0, 0,
                                        pickerView.bounds.size.width/3,
                                        [pickerView rowSizeForComponent:component].height);
        UILabel *flagLabel = [[UILabel alloc] initWithFrame:rectForFlag];
        flagLabel.font = [UIFont systemFontOfSize:40];
        flagLabel.textColor = [UIColor whiteColor];
        //flagLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        flagLabel.numberOfLines = 0;
        flagLabel.adjustsFontSizeToFitWidth = YES;
        flagLabel.textAlignment = NSTextAlignmentLeft;
        [flagLabel setCenter:CGPointMake(pickerView.bounds.size.width*1.5/6, picView.center.y)];
        [picView addSubview:flagLabel];
        
        CGRect rectForText = CGRectMake(0, 0,
                                        pickerView.bounds.size.width/3,
                                        [pickerView rowSizeForComponent:component].height);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:rectForText];

        textLabel.font = [UIFont systemFontOfSize:40];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        textLabel.textAlignment = NSTextAlignmentLeft;
        //textLabel.numberOfLines = 0;
        textLabel.adjustsFontSizeToFitWidth = YES;
        [textLabel setCenter:CGPointMake(pickerView.bounds.size.width*2/3, picView.center.y)];
        [picView addSubview:textLabel];
        
        if(curArr){
            flagLabel.text = (NSString*)[curArr objectAtIndex:1];
            textLabel.text = (NSString*)[curArr objectAtIndex:0];
        }

        
    } else if (pickerView.tag == 2002){
        CGRect rectForFlag = CGRectMake(0, 2*pickerView.bounds.size.width/3,
                                        pickerView.bounds.size.width/3,
                                        [pickerView rowSizeForComponent:component].height);
        UILabel *flagLabel = [[UILabel alloc] initWithFrame:rectForFlag];
        flagLabel.font = [UIFont systemFontOfSize:40];
        //flagLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        flagLabel.numberOfLines = 0;
        flagLabel.adjustsFontSizeToFitWidth = YES;
        flagLabel.textAlignment = NSTextAlignmentRight;
        [flagLabel setCenter:CGPointMake(pickerView.bounds.size.width*4.5/6, picView.center.y)];
        [picView addSubview:flagLabel];
        
        CGRect rectForText = CGRectMake(0, 0,
                                        pickerView.bounds.size.width/3,
                                        [pickerView rowSizeForComponent:component].height);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:rectForText];
        textLabel.font = [UIFont systemFontOfSize:40];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        textLabel.textAlignment = NSTextAlignmentRight;
        //textLabel.numberOfLines = 0;
        textLabel.adjustsFontSizeToFitWidth = YES;
        [textLabel setCenter:CGPointMake(pickerView.bounds.size.width/3, picView.center.y)];
        [picView addSubview:textLabel];
    
        if(curArr){
            flagLabel.text = (NSString*)[curArr objectAtIndex:1];
            textLabel.text = (NSString*)[curArr objectAtIndex:0];
        }
    
    }
    
    return picView;
}

-(void) selectPickersAtStart
{
    NSInteger fromIndex = 0;
    NSInteger toIndex = -1;
    if([[NSUserDefaults standardUserDefaults] objectForKey:LAST_FROM_CURRENCY] && [[NSUserDefaults standardUserDefaults] objectForKey:LAST_TO_CURRENCY]){
        self.fromCur = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_FROM_CURRENCY];
        fromIndex = [self.listCurrensiesForPicker indexOfObject:self.fromCur];
        self.toCur = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_TO_CURRENCY];
        toIndex = [self.listCurrensiesForPicker indexOfObject:self.toCur];
        
    }
    [self.currencyFromPicker selectRow:(self.listCurrensiesForPicker.count)*50 + fromIndex inComponent:0 animated:NO];
    [self.currencyToPicker selectRow:(self.listCurrensiesForPicker.count)*50 +toIndex inComponent:0 animated:NO];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self pickerDidSelect];
}

-(void) pickerDidSelect
{
    //define currensy from
    NSInteger selectedRowFrom = [self.currencyFromPicker selectedRowInComponent:0]%self.listCurrensiesForPicker.count;
    NSString *curencyFromSymbol = [self.listCurrensiesForPicker objectAtIndex:selectedRowFrom];
    //define currensy to
    
    NSInteger selectedRowTo = [self.currencyToPicker selectedRowInComponent:0]%self.listCurrensiesForPicker.count;
    NSString *curencyToSymbol = [self.listCurrensiesForPicker objectAtIndex:selectedRowTo];
    [self resultForm:curencyFromSymbol To:curencyToSymbol];
    //call function with both papameters
}

-(void) resultForm:(NSString*)fromCur To:(NSString*)toCur
{
    NSString *valueStr;
    if([fromCur isEqualToString:toCur]){
        valueStr = [@1.0000 stringValue];
        [self getCurrensiesFrom:fromCur To:toCur AndValue:@1.000];
        //if there is - stop and remove spiner
    }else {
        
        if([self.currensies.mainPairsdictionary objectForKey:fromCur] && [self.currensies.mainPairsdictionary objectForKey:toCur]){
            NSDictionary *insideDict = (NSDictionary*)[self.currensies.mainPairsdictionary objectForKey:fromCur];
            NSNumber *valueNumber = [insideDict valueForKey:toCur];
            [self getCurrensiesFrom:fromCur To:toCur AndValue:valueNumber];
            [self.currensies askResultForm:fromCur To:toCur];
            //if there is - stop and remove spiner
        } else {
            [self getCurrensiesFrom:fromCur To:toCur AndValue:nil];
            [self.currensies askResultForm:fromCur To:toCur];
            //set and start spinner
        }
    }
}

#pragma mark SET AND GET PAIR REQEST GetPairCurrensiesProtocol

-(void) getCurrensiesFrom:(NSString *)fromCur To:(NSString *)toCur AndValue:(NSNumber *)val
{
    //set need values
    NSString *resultStr = [fromCur stringByAppendingString:@"/"];
    resultStr = [resultStr stringByAppendingString:toCur];
    resultStr = [resultStr stringByAppendingString:@"\n"];
    CGFloat alpha = 1;
    if(val){
        resultStr = [resultStr stringByAppendingString:[val stringValue]];
        self.convertButton.enabled = YES;
        self.fromCur = fromCur;
        self.toCur = toCur;
        self.value = val;
    } else {
        resultStr = [resultStr stringByAppendingString:@"--.--"];
        self.convertButton.enabled = NO;
        alpha = 0.3;
    }
    //check if value in mainPairdictionary - replace it
    if([self.currensies.mainPairsdictionary objectForKey:fromCur] && [self.currensies.mainPairsdictionary objectForKey:toCur]){
        NSMutableDictionary* mutMainPairdict = [self.currensies.mainPairsdictionary mutableCopy];
        NSMutableDictionary* mutObjDict = [(NSDictionary*)[self.currensies.mainPairsdictionary objectForKey:fromCur] mutableCopy];
        [mutObjDict setValue:val forKey:toCur];
        [mutMainPairdict setValue:[mutObjDict copy] forKey:fromCur];
        self.currensies.mainPairsdictionary = [mutMainPairdict copy];
        //if there is - stop and remove spiner
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.resultLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.resultLabel setText:resultStr];
        [UIView animateWithDuration:0.3 animations:^{
            self.resultLabel.alpha = alpha;
        }];
    }];
}

-(void) getCurrensiesArray:(NSArray *)currensiesExhangeRates {
    [super resetProgrammAfterCurrensiesChecked:currensiesExhangeRates];
}

#pragma mark NOTIFICATION HANDLING
-(void)recivedChangeListNotification:(NSNotification*)notification
{
    NSLog(@"recived Change notification");
    self.listCurrensiesForPicker = self.currensies.listCurrensiesForPicker;
    //reload pickers
    [self.currencyFromPicker reloadAllComponents];
    [self.currencyToPicker reloadAllComponents];
    //set piccers to necessary positions
    [self selectPickersAtStart];
}

-(void) recivedNoServiseNotification:(NSNotification*)notification
{
    NSArray *keys = notification.userInfo.allKeys;
    if(keys.count && (keys.count < 2) && [keys[0] isKindOfClass:[NSString class]]){
        //NSLog(@"Ok recived notification %@ for key %@", [notification.userInfo objectForKey:keys[0]], keys[0]);
        NSString *key = keys[0];
        if([key isEqualToString:@"LastUpDataDate"]){
            if((self.blurAlpha == 1.)){
                [self showAllertNoServise:(NSDate*)[notification.userInfo objectForKey:key]];
                //self.design = [[notification.userInfo objectForKey:keys[0]] integerValue];
            }
            
        }
        //NSLog(@"recived wrong notification");
    }
}

- (void) handleNetworkChange:(NSNotification *)note
{
    Reachability* curReach = [note object];
    
    
    if([curReach currentReachabilityStatus] == NotReachable){
        self.wasInternetConnected = NO;
    } else {
        if(!self.wasInternetConnected){
            NSLog(@"Internet connection change to ON");
            [self.currensies renewPairsDictionary];
        }
        self.wasInternetConnected = YES;
    }
    
}
#define ALERT_TITLE_NO_SERVICE NSLocalizedStringFromTable(@"Сервис курсов валют не доступен",@"ACalcTryViewControllerTableNew", @"Сервис не доступен")

#define ALERT_MESSAGE_NO_SERVISE NSLocalizedStringFromTable(@"Последние значения основных валют сохранены:\n",@"ACalcTryViewControllerTableNew", @"Последние значения основных валют сохранены:\n")

#define ALERT_MESSAGE_NO_SERVISE_NO_ARCHIVE NSLocalizedStringFromTable(@"Проверьте интернет соединение или повторите попытку позже",@"ACalcTryViewControllerTableNew", @"Проверьте интернет соединение или повторите попытку позже")
-(void) showAllertNoServise:(NSDate*)date
{
    // NSLog(@"Need show allert");
    //self.allertNoConnectionWasShowed = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    NSString *lastDate;
    if(date){
        
        lastDate = [dateFormatter stringFromDate: date];
        lastDate = [ALERT_MESSAGE_NO_SERVISE stringByAppendingString:lastDate];
    } else {
        lastDate = ALERT_MESSAGE_NO_SERVISE_NO_ARCHIVE;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                ALERT_TITLE_NO_SERVICE
                                                                   message:lastDate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {;

                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark VIEW STATUSES
-(void) initialLayoutDynamicContainerWithSize:(CGSize)size
{
    [super initialLayoutDynamicContainerWithSize:size];
    
    
    [self setNecessaryViews];
    CGRect blurFrameRect = CGRectMake(self.viewforCurrencyRecognizer.frame.origin.x,
                                      self.viewforCurrencyRecognizer.frame.origin.y +self.labelViewHeight,
                                      self.viewforCurrencyRecognizer.frame.size.width,
                                      self.viewforCurrencyRecognizer.frame.size.height - self.labelViewHeight);
    
    [self.blur setFrame:blurFrameRect];
    
    [self setInitialLayoutWithHeight:0];
}

-(void)setInitialLayoutWithHeight:(CGFloat)height
{

    CGSize sizePiccers = CGSizeMake(self.blur.bounds.size.width*2/5, self.blur.bounds.size.height);
    //1. set cuurensy from initial frame
    CGRect fromCurrFrame = CGRectMake(-sizePiccers.width, 0, sizePiccers.width, sizePiccers.height);
    [self.currencyFromPicker setFrame:fromCurrFrame];
    //2. set cuurensy to initial frame
    CGRect toCurrFrame = CGRectMake(self.blurBackGroundView.frame.size.width, 0, sizePiccers.width, sizePiccers.height);
    [self.currencyToPicker setFrame:toCurrFrame];
    
    //3. set label initial fram
    
    CGRect rectForLabel = CGRectMake(self.blurBackGroundView.frame.size.width/2. - self.blurBackGroundView.frame.size.width/6.,
                                     self.blurBackGroundView.frame.size.height,
                                     self.blurBackGroundView.frame.size.width/3.,
                                     self.blurBackGroundView.frame.size.width/6.);
    [self.resultLabel setFrame:rectForLabel];
    
    
    
    //4. set convertButtonInitial frame
    CGRect rectForConverButton = CGRectMake(self.blurBackGroundView.frame.size.width/2. - self.blurBackGroundView.frame.size.width/7.,
                                            self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6.,
                                            self.blurBackGroundView.frame.size.width/3.5,
                                            self.blurBackGroundView.frame.size.width/3.5);
    [self.convertButton setFrame:rectForConverButton];
    
    
    
    //5.set backButton initial frame
    CGRect rectForBackButton = CGRectMake(self.blurBackGroundView.frame.size.width/2 - self.blurBackGroundView.frame.size.width/12,
                                          self.blurBackGroundView.frame.size.height+self.blurBackGroundView.frame.size.width/6.+ self.blurBackGroundView.frame.size.width/3.5,
                                          self.blurBackGroundView.frame.size.width/6,
                                          self.blurBackGroundView.frame.size.width/6);
    [self.backButton setFrame:rectForBackButton];


    
}

-(void)setNecessaryViews
{
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] init];
    blur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [self.dynamicContainer addSubview:blur];
    self.blur = blur;
    self.blur.alpha = 0;
    self.blurAlpha = self.blur.alpha;
    self.blur.hidden = YES;
    self.blurBackGroundView = blur.contentView;
    
    UIPickerView *currencyFromPicker = [[UIPickerView alloc] init];
    [self.blur addSubview:currencyFromPicker];
    self.currencyFromPicker = currencyFromPicker;
    self.currencyFromPicker.tag = 2001;
    self.currencyFromPicker.delegate = self;
    
    UIPickerView *currencyToPicker = [[UIPickerView alloc] init];
    [self.blur addSubview:currencyToPicker];
    self.currencyToPicker = currencyToPicker;
    self.currencyToPicker.tag = 2002;
    self.currencyToPicker.delegate = self;
    
    UILabel *resultLabel = [[UILabel alloc] init];
    [self.blur addSubview:resultLabel];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.numberOfLines = 2;
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.adjustsFontSizeToFitWidth = YES;
    resultLabel.backgroundColor = [UIColor clearColor];
    self.resultLabel = resultLabel;
    
    ConvertBut *convertBut = [ConvertBut buttonWithType:UIButtonTypeSystem];
    [convertBut addTarget:self action:@selector(convertButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    convertBut.tintColor = [UIColor whiteColor];
    [self.blur addSubview:convertBut];
    self.convertButton = convertBut;
    
    CalcButton *backButton = [CalcButton buttonWithType:UIButtonTypeSystem];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.blur addSubview:backButton];
    backButton.tintColor = [UIColor whiteColor];
    self.backButton = backButton;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.currensies = [[Currensies alloc] init];
    self.currensies.delegate = self;
    
    self.converter = [[CurrencyStore alloc] init];
    
    //add notifiations observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedChangeListNotification:) name: LIST_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedNoServiseNotification:) name: NOT_AVAILABLE_SERVISE_NOTIFICATION object:nil];

    
    //check for internet connection
    self.rechablity = [Reachability reachabilityForInternetConnection];
    [self.rechablity startNotifier];
    if([self.rechablity currentReachabilityStatus] == NotReachable){
        self.wasInternetConnected = NO;
    } else {
        self.wasInternetConnected = YES;
    }
    
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(handleNetworkChange:)
                                                   name:kReachabilityChangedNotification
                                                 object:nil];

    //inint necessary views
    //[self setNecessaryViews];
    
}

@end
