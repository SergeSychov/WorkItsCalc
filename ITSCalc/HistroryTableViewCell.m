//
//  HistroryTableViewCell.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "HistroryTableViewCell.h"
#import "recBut.h"
#import "DelButton.h"
#import "Clr.h"



NSString *const HistoryTableViewCellViewDidBeginScrolingNotification = @"HistoryTableViewCellViewDidBeginScrolingNotification";

#define  kCatchWidth 160
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_BLACK_MODE YES

//define design numbers
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4


@interface HistroryTableViewCell() <UITextFieldDelegate>


@property (nonatomic) BOOL isButtonShowed;
@property (nonatomic,strong) DelButton *deleteButton;
@property (nonatomic,strong) UIImageView* deleteImage;

//@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) recBut *moreButton;
@property (nonatomic,strong) UIImageView* moreImage;

@property (nonatomic,strong) UIView *scrollViewContentView;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) UILabel *programLabel;

@property (nonatomic, strong) CAGradientLayer *backgroundGradient;
@property (nonatomic, strong) CAGradientLayer *scrollGradientLayer;

@property (nonatomic) CGFloat curentXofSwiper;
@property (nonatomic) CGFloat deltaXofSwiper;

@end

@implementation HistroryTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) makeProgramLabel
{
    CGPoint originTextRect = CGPointMake(20, 13);
    
    if(IS_IPAD){
        originTextRect.x = self.frame.size.width - 32;
    }
    
    CGRect rect = CGRectMake(originTextRect.x,originTextRect.y,40, 12);
    UILabel *programLabel = [[UILabel alloc] initWithFrame:rect];
    programLabel.backgroundColor = [UIColor clearColor];
    
    programLabel.numberOfLines = 0;
    
    [self.scrollViewContentView addSubview:programLabel];
    _programLabel = programLabel;
}


-(void) makeProgramTextView
{
    CGPoint originTextRect = CGPointMake(20, 13);
    
    if(IS_IPAD){
        originTextRect.x = self.frame.size.width - 32;
    }
    
    CGRect rect = CGRectMake(originTextRect.x,originTextRect.y,40, 12);
    UITextView *programTextView = [[UITextView alloc]initWithFrame:rect];
    programTextView.backgroundColor = [UIColor clearColor];
    [programTextView  setTextContainerInset: UIEdgeInsetsMake(0, 0, 0, 0)];
    [programTextView setScrollEnabled:NO];
    //depreacate till now
    //dont forget it's iportant
    //other case it'll be not work
    [programTextView setUserInteractionEnabled:NO];
    
    //set textfield without keyboard
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    programTextView.inputView = dummyView;
    
    [self.scrollViewContentView addSubview:programTextView];
    _programTextView = programTextView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    CGFloat colorClear;
    CGFloat colorFirstGradient;
    CGFloat colorSecondGradient;
    CGFloat colorForSelectedText;
    CGFloat colorForUnselectedText;
    CGFloat firstAlphaForGradient;
    CGFloat secondAlphaForGradient;
    CGFloat selectedAlpha;
    
    switch (self.design) {
        case DESIGN_CLASSIC:
            colorClear = .9;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            firstAlphaForGradient = 1;
            secondAlphaForGradient = 1;
            
            colorForSelectedText = 0.0;
            colorForUnselectedText = 0.3;
            selectedAlpha = 0.;
            
            break;
        case DESIGN_PAPER:
            colorClear = 0.1;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            //colorFirstGradient = 0.12;
            //colorSecondGradient = 0.17;
            firstAlphaForGradient = 0.05;
            secondAlphaForGradient = 0.1;
            
            selectedAlpha = 0.;
            
            colorForSelectedText = 1.;
            colorForUnselectedText = 0.8;
            [self setBackgroundColor:[UIColor clearColor]];
            
            break;
        default:
            colorClear = .9;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            firstAlphaForGradient = 1;
            secondAlphaForGradient = 1;
            
            colorForSelectedText = 0.0;
            colorForUnselectedText = 0.3;
            
            selectedAlpha = 0.;
            
            break;
    }
    /*
    
    if(IS_BLACK_MODE){
        colorClear = 0.1;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;
        //colorFirstGradient = 0.12;
        //colorSecondGradient = 0.17;
        firstAlphaForGradient = 0.05;
        secondAlphaForGradient = 0.1;
        
        selectedAlpha = 0.;
        
        colorForSelectedText = 1.;
        colorForUnselectedText = 0.8;
        [self setBackgroundColor:[UIColor clearColor]];
        
    } else {
        colorClear = .9;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;
        firstAlphaForGradient = 1;
        secondAlphaForGradient = 1;
        
        colorForSelectedText = 0.0;
        colorForUnselectedText = 0.3;
        
        selectedAlpha = 0.;
        
    }
    */
    
    if(selected){
        
        self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorClear alpha:selectedAlpha] CGColor], (id)[[UIColor colorWithWhite:colorClear alpha:selectedAlpha] CGColor],nil];
        
        self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorClear alpha:selectedAlpha] CGColor], (id)[[UIColor colorWithWhite:colorClear alpha:selectedAlpha] CGColor], nil];
        
        
        //set black color for selected cell
        NSMutableAttributedString *atrStr = [self.historyProgramString mutableCopy];
        NSRange wholeRange = NSMakeRange(0, [atrStr  length]);
        UIColor *textColor = [UIColor colorWithWhite:colorForSelectedText alpha:1.0];
        [self.programTextView setTextColor:textColor];
        
        [atrStr beginEditing];
        [atrStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [atrStr endEditing];
        self.historyProgramString = [atrStr copy];
        
        //set color for data label
        self.datelabel.textColor = textColor;
        
        [self.delegate cellDidSelect:self];
    } else {
        
        self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:firstAlphaForGradient] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:secondAlphaForGradient] CGColor], nil];
        
        self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:firstAlphaForGradient] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:secondAlphaForGradient] CGColor], nil];
        
        NSMutableAttributedString *atrStr = [self.historyProgramString mutableCopy];
        NSRange wholeRange = NSMakeRange(0, [atrStr  length]);
        UIColor *textColor = [UIColor colorWithWhite:colorForUnselectedText alpha:1.0];
        [self.programTextView setTextColor:textColor];
        
        [atrStr beginEditing];
        [atrStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [atrStr endEditing];
        self.historyProgramString = [atrStr copy];
        //set color for data label
        self.datelabel.textColor = textColor;
        
        [self hideButtons];
        if(self.deleteButton){
            [self.deleteButton removeFromSuperview];
            [self.moreButton removeFromSuperview];
            self.deleteButton = nil;
            self.moreButton = nil;
            
        }
    }
    
}


-(void) setHistoryDateString:(NSString *)historyDateString
{
    UIFont *font;
    if(IS_IPAD){
        font = [UIFont systemFontOfSize:15.];

    } else {
        font = [UIFont systemFontOfSize:9.];
    }
    
    switch (self.design) {
        case DESIGN_CLASSIC:
            [self.datelabel setTextColor:[UIColor grayColor]];

            break;
        case DESIGN_PAPER:
            [self.datelabel setTextColor:[Clr paperButton]];
            break;

        default:
            [self.datelabel setTextColor:[UIColor grayColor]];

            break;
    }
    /*
    if(IS_BLACK_MODE){
        [self.datelabel setTextColor:[UIColor darkGrayColor]];
    } else {
        [self.datelabel setTextColor:[UIColor grayColor]];
    }
    */
    [self.datelabel  setFont:font];
    self.datelabel.text = historyDateString;
}

-(void) setHistoryProgramString:(NSAttributedString *)historyProgramString
{
    _historyProgramString = historyProgramString;
    if(!self.isCanDrag){
        if(!self.programTextView) [self makeProgramTextView];
        self.programTextView.attributedText = historyProgramString;
        if(self.programLabel){
            [self.programLabel removeFromSuperview];
            self.programLabel = nil;
        }
    } else {
        if(!self.programLabel) [self makeProgramLabel];
        self.programLabel.attributedText = historyProgramString;
        if(self.programTextView){
            [self.programTextView removeFromSuperview];
            self.programTextView = nil;
        }
    }
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize;
    if(IS_IPAD){
        neededSize = CGSizeMake(700, 1000);
    } else {
        neededSize = CGSizeMake(280, 1000);

    }
    CGRect neededRect = [historyProgramString boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin context:drawContext];

    
    CGPoint originTextRect = CGPointMake(20, 13);
    if(!self.isCanDrag){
        if(IS_IPAD){
            originTextRect.x = self.frame.size.width - neededRect.size.width - 10 - 20;
        }
        [self.programTextView setFrame:CGRectMake(originTextRect.x,originTextRect.y,neededRect.size.width +10, neededRect.size.height +7)];
        
    } else {
        if(IS_IPAD){
            originTextRect.x = self.frame.size.width - neededRect.size.width - 20;
        }
        [self.programLabel setFrame:CGRectMake(originTextRect.x,originTextRect.y,neededRect.size.width, neededRect.size.height)];
    }
}

-(void)setup {
    self.isButtonShowed = NO;
    
    CGFloat colorClear;
    CGFloat colorFirstGradient;
    CGFloat colorSecondGradient;
    CGFloat colorForSelectedText;
    CGFloat colorForUnselectedText;
    CGFloat firstAlphaForGradient;
    CGFloat secondAlphaForGradient;
    
    switch (self.design) {
        case DESIGN_CLASSIC:
            colorClear = .9;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            firstAlphaForGradient = 1;
            secondAlphaForGradient = 1;
            
            colorForSelectedText = 0.0;
            colorForUnselectedText = 0.3;

            break;
        case DESIGN_PAPER:
            colorClear = 0.1;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            //colorFirstGradient = 0.12;
            //colorSecondGradient = 0.17;
            firstAlphaForGradient = 0.1;
            secondAlphaForGradient = 0.2;
            
            colorForSelectedText = 0.9;
            colorForUnselectedText = 0.7;
            
            break;
        default:
            colorClear = .9;
            colorFirstGradient = 0.88;
            colorSecondGradient = 0.83;
            firstAlphaForGradient = 1;
            secondAlphaForGradient = 1;
            
            colorForSelectedText = 0.0;
            colorForUnselectedText = 0.3;

            break;
    }
    /*
    if(IS_BLACK_MODE){
        colorClear = 0.1;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;
        //colorFirstGradient = 0.12;
        //colorSecondGradient = 0.17;
        firstAlphaForGradient = 0.1;
        secondAlphaForGradient = 0.2;
        
        colorForSelectedText = 0.9;
        colorForUnselectedText = 0.7;
    } else {
        colorClear = .9;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;
        firstAlphaForGradient = 1;
        secondAlphaForGradient = 1;
        
        colorForSelectedText = 0.0;
        colorForUnselectedText = 0.3;
    }
    */
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:firstAlphaForGradient] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:secondAlphaForGradient] CGColor], nil];
    
    [self.layer insertSublayer:gradient atIndex:0];
    self.backgroundGradient = gradient;
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:self.bounds];
    scrollViewContentView.backgroundColor = [UIColor colorWithWhite:colorFirstGradient alpha:0.0];
    [self.contentView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    CAGradientLayer *gradientForScroll = [CAGradientLayer layer];
    gradientForScroll.frame = self.bounds;
    gradientForScroll.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:firstAlphaForGradient] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:secondAlphaForGradient] CGColor], nil];
    
    [self.scrollViewContentView.layer insertSublayer:gradientForScroll atIndex:0];
    self.scrollGradientLayer = gradientForScroll;
    
    CGRect labelFrame;
    if(IS_IPAD){
        labelFrame = CGRectMake(20, 0, 150, 18);
    } else {
        labelFrame = CGRectMake(20, 0, 150, 12);
        
    }
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self.scrollViewContentView addSubview:dateLabel];
    dateLabel.backgroundColor = [UIColor clearColor];
    self.datelabel = dateLabel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];

}

-(void)drawRect:(CGRect)rect
{
    self.contentView.frame = self.bounds;
    
    self.backgroundGradient.frame = self.bounds;

    self.scrollGradientLayer.frame = self.bounds;
    
    [self setHistoryProgramString:self.historyProgramString];


    
}
/*
-(void) layoutSubviews {

    [self.datelabel setFrame:CGRectMake(20,0,150, 12)];
}
*/

-(void)enclosingTableViewDidScroll
{
    [self hideButtons];

    [self setSelected:NO animated:NO];
    
}

#pragma mark - Private Methods

-(void)userPressedDeleteButton:(id)sender {
    [self.delegate cellDidSelectDelete:self];
}

-(void)userPressedMoreButton:(id)sender {
    [self.delegate cellDidSelectRecount:self];
    // [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Overridden Methods

-(void) hideButtons
{

    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollViewContentView setFrame:self.bounds];
                     } completion:^(BOOL finished) {

                     }];
    

}

//public method
-(void) showButtons:(UISwipeGestureRecognizer *)sender

{
    //NSLog(@"Gesture state %ld",(long)sender.state);
    CGFloat needWidth;
    if(IS_IPAD){
        needWidth = 160;
    } else {
        needWidth = 120;
    }
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"HistoryTableViewCellViewDidBeginScrolingNotification" object:nil]];

    
        // Set up our two buttons
        //set allowed to show recound button only in purchsed version
        //if(self.wasPurhased){
        UIColor *moreButtonColor;
        UIColor *moreButtonBackgroundColor;
        UIColor *deleteButtonColor;
        UIColor *deleteButtonBackgroundColor;
        switch (self.design) {
            case DESIGN_CLASSIC:
                moreButtonColor = [UIColor whiteColor];
                moreButtonBackgroundColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];     deleteButtonColor = [UIColor whiteColor];
                deleteButtonBackgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
                break;
            
            case DESIGN_PAPER:
                moreButtonColor = [Clr paperButton];
                moreButtonBackgroundColor = [UIColor clearColor];
                deleteButtonColor = [Clr paperButton];
                deleteButtonBackgroundColor = [UIColor clearColor];
                break;
            
            default:
                moreButtonColor = [UIColor whiteColor];
                moreButtonBackgroundColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];     deleteButtonColor = [UIColor whiteColor];
                deleteButtonBackgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
                break;
        }
        if(!self.moreButton){
            self.moreButton = [recBut buttonWithType:UIButtonTypeCustom];
        //
            self.moreButton.contentMode = UIViewContentModeRedraw;
        //HERE
            self.moreButton.tintColor = moreButtonColor;
            [self.moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            //HERE
            self.moreButton.backgroundColor = moreButtonBackgroundColor;
            [self.contentView insertSubview:self.moreButton atIndex:0];

        }
    
       

        if(!self.deleteButton){
            self.deleteButton = [DelButton buttonWithType:UIButtonTypeCustom];
        //
            self.deleteButton.contentMode = UIViewContentModeRedraw;
        
        //HERE
            self.deleteButton.tintColor = deleteButtonColor;
            [self.deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchDown];
            //HERE
            self.deleteButton.backgroundColor = deleteButtonBackgroundColor;
            [self.contentView insertSubview:self.deleteButton atIndex:1];
        
        
        }
        self.moreButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
        self.deleteButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
        self.curentXofSwiper = [sender locationInView:self].x;
        self.deltaXofSwiper = 0.;


    } else if (sender.state == UIGestureRecognizerStateChanged){
        self.deltaXofSwiper = self.curentXofSwiper - [sender locationInView:self].x;
        if((self.deltaXofSwiper >0) && (self.deltaXofSwiper < needWidth)){
            NSLog(@"needWidth %f", needWidth);
            NSLog(@"delta x %f", self.deltaXofSwiper);
            CGRect newFrame = self.scrollViewContentView.frame;
            newFrame.origin.x = -self.deltaXofSwiper;
            [self.scrollViewContentView setFrame:newFrame];
            self.moreButton.center = CGPointMake(self.bounds.size.width-self.deltaXofSwiper + needWidth/4., self.bounds.size.height/2);
            self.deleteButton.center = CGPointMake(self.bounds.size.width-self.deltaXofSwiper/2 + needWidth/4, self.bounds.size.height/2);
            //self.moreButton.frame = CGRectMake(self.bounds.size.width-self.deltaXofSwiper, 0, needWidth / 2.0f, self.bounds.size.height);
            //self.deleteButton.frame = CGRectMake(self.bounds.size.width-self.deltaXofSwiper/2, 0, needWidth / 2.0f, self.bounds.size.height);
        }
        
    }  else if (sender.state == UIGestureRecognizerStateEnded){
        self.deltaXofSwiper = self.curentXofSwiper - [sender locationInView:self].x;
        NSLog(@"delta at end x %f", self.deltaXofSwiper);
        if(self.deltaXofSwiper < needWidth/2){
            CGRect scrollFrame = self.scrollViewContentView.frame;
            scrollFrame.origin.x = 0;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.scrollViewContentView setFrame:scrollFrame];
                                 self.moreButton.center = CGPointMake(self.bounds.size.width+ needWidth/4., self.bounds.size.height/2);
                                 self.deleteButton.center = CGPointMake(self.bounds.size.width + needWidth/4, self.bounds.size.height/2);
                                 //self.moreButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
                                 //self.deleteButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
                             } completion:^(BOOL finished) {

                                 
                             }];
        } else {
            CGRect scrollFrame = self.scrollViewContentView.frame;
            scrollFrame.origin.x = -needWidth;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.scrollViewContentView setFrame:scrollFrame];
                                 self.moreButton.center = CGPointMake(self.bounds.size.width - needWidth+needWidth/4., self.bounds.size.height/2);
                                 self.deleteButton.center = CGPointMake(self.bounds.size.width - needWidth/2+ needWidth/4, self.bounds.size.height/2);
                                 //self.moreButton.frame = CGRectMake(self.bounds.size.width - needWidth - nee, 0, needWidth / 2.0f, self.bounds.size.height);
                                 //self.deleteButton.frame = CGRectMake(self.bounds.size.width - needWidth / 2.0f, 0, needWidth / 2.0f, self.bounds.size.height);
                             } completion:^(BOOL finished) {
                                 
                                 
                             }];

        }
    }

    /*
    CGRect newFrame = self.scrollViewContentView.frame;
    //CGFloat finalOffsetScrollView = self.wasPurhased ? kCatchWidth : kCatchWidth/2;
    CGFloat finalOffsetScrollView = needWidth;
    newFrame.origin.x = -finalOffsetScrollView -28;
    CGRect finalFrame = newFrame;
    finalFrame.origin.x += 28;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollViewContentView setFrame:newFrame];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              [self.scrollViewContentView setFrame:finalFrame];
                                          } completion:^(BOOL finished) {
                                              
                                          }];

                     }];
    */
    
}
#define textView delegate



@end
