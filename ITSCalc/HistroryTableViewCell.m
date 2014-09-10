//
//  HistroryTableViewCell.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "HistroryTableViewCell.h"


NSString *const HistoryTableViewCellViewDidBeginScrolingNotification = @"HistoryTableViewCellViewDidBeginScrolingNotification";

#define  kCatchWidth 160
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_BLACK_MODE NO

@interface HistroryTableViewCell() <UITextFieldDelegate>


@property (nonatomic) BOOL isButtonShowed;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIImageView* deleteImage;

@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) UIImageView* moreImage;

@property (nonatomic,strong) UIView *scrollViewContentView;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) UILabel *programLabel;

@property (nonatomic, strong) CAGradientLayer *backgroundGradient;
@property (nonatomic, strong) CAGradientLayer *scrollGradientLayer;

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
    if(IS_BLACK_MODE){
        colorClear = 0.1;
        colorFirstGradient = 0.12;
        colorSecondGradient = 0.17;
    } else {
        colorClear = .9;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;

    }
    
    if(selected){
            
            self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorClear alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorClear alpha:1] CGColor],nil];

            self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorClear alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorClear alpha:1] CGColor], nil];
            
            [self.delegate cellDidSelect:self];
        } else {
            
            self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:1] CGColor], nil];

            self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:1] CGColor], nil];
            

            [self hideButtons];
        }
}


-(void) setHistoryDateString:(NSString *)historyDateString
{
    UIFont *font = [UIFont systemFontOfSize:9.];

    if(IS_BLACK_MODE){
        [self.datelabel setTextColor:[UIColor darkGrayColor]];
    } else {
        [self.datelabel setTextColor:[UIColor grayColor]];
    }
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
    if(IS_BLACK_MODE){
        colorClear = 0.1;
        colorFirstGradient = 0.12;
        colorSecondGradient = 0.17;
    } else {
        colorClear = .9;
        colorFirstGradient = 0.88;
        colorSecondGradient = 0.83;
        
    }

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:1] CGColor], nil];

    [self.layer insertSublayer:gradient atIndex:0];
    self.backgroundGradient = gradient;
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:self.bounds];
    scrollViewContentView.backgroundColor = [UIColor colorWithWhite:colorFirstGradient alpha:1.0];
    [self.contentView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    CAGradientLayer *gradientForScroll = [CAGradientLayer layer];
    gradientForScroll.frame = self.bounds;
    gradientForScroll.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:colorFirstGradient alpha:1] CGColor], (id)[[UIColor colorWithWhite:colorSecondGradient alpha:1] CGColor], nil];

    [self.scrollViewContentView.layer insertSublayer:gradientForScroll atIndex:0];
    self.scrollGradientLayer = gradientForScroll;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,150, 12)];
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

   // [self.deleteButton setFrame:CGRectMake(self.bounds.size.width - kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, self.bounds.size.height)];
    //[self.deleteImage setFrame:CGRectMake((self.deleteButton.bounds.size.width - 60)/2,
    //                                      (self.deleteButton.bounds.size.height - 60)/2, 60, 60)];
    
    
    
    //[self.moreButton setFrame:CGRectMake(rect.size.width - kCatchWidth, 0, kCatchWidth / 2.0f, rect.size.height)];
   // [self.moreImage setFrame:CGRectMake((self.moreButton.bounds.size.width - 60)/2,
                                      //    (self.moreButton.bounds.size.height - 60)/2, 60, 60)];


    
    
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
                         // Set up our two buttons
                         //[self.moreButton removeFromSuperview];
                         //if(self.wasPurhased){
                             self.moreButton = nil;
                        // }
                         //[self.deleteButton removeFromSuperview];
                         
                         self.deleteImage = nil;
                     }];
    

}

//public method
-(void) showButtons
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"HistoryTableViewCellViewDidBeginScrolingNotification" object:nil]];
    
    // Set up our two buttons
    //set allowed to show recound button only in purchsed version
    //if(self.wasPurhased){
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.backgroundColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
        moreButton.frame = CGRectMake(self.bounds.size.width - kCatchWidth, 0, kCatchWidth / 2.0f, self.bounds.size.height);
        [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView insertSubview:moreButton atIndex:0];
        //[self.contentView addSubview:moreButton];
        self.moreButton = moreButton;
    
        UIImageView* moreImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.moreButton.bounds.size.width - 60)/2,
                                                                           (self.moreButton.bounds.size.height - 60)/2, 60, 60)];
        [moreImage setImage:[UIImage imageNamed:@"Rec2.png"]];
        moreImage.contentMode = UIViewContentModeScaleToFill;
        [self.moreButton addSubview:moreImage];
        self.moreImage = moreImage;
   // }
    
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(self.bounds.size.width - kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, self.bounds.size.height);
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchDown];
    [self.contentView insertSubview:deleteButton atIndex:0];
    //[self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    UIImageView* deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.deleteButton.bounds.size.width - 60)/2,
                                                                             (self.deleteButton.bounds.size.height - 60)/2, 60, 60)];
    [deleteImage setImage:[UIImage imageNamed:@"deleteBig2.png"]];
    deleteImage.contentMode = UIViewContentModeScaleToFill;
    
    [self.deleteButton addSubview:deleteImage];
    self.deleteImage = deleteImage;
    
    
    CGRect newFrame = self.scrollViewContentView.frame;
    //CGFloat finalOffsetScrollView = self.wasPurhased ? kCatchWidth : kCatchWidth/2;
    CGFloat finalOffsetScrollView = kCatchWidth;
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
    
}
#define textView delegate



@end
