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

@interface HistroryTableViewCell()


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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
        if(selected){
            self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.95 alpha:1] CGColor], nil];
            self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.95 alpha:1] CGColor], nil];
            [self.delegate cellDidSelect:self];
        } else {
            self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.9 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.85 alpha:1] CGColor], nil];
            self.scrollGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.9 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.85 alpha:1] CGColor], nil];
            [self hideButtons];
        }
}


-(void) setHistoryDateString:(NSString *)historyDateString
{
    UIFont *font = [UIFont systemFontOfSize:9.];

    [self.datelabel setTextColor:[UIColor darkGrayColor]];
    [self.datelabel  setFont:font];
    self.datelabel.text = historyDateString;
}

-(void) setHistoryProgramString:(NSAttributedString *)historyProgramString
{
    self.programLabel.attributedText = historyProgramString;
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize = CGSizeMake(280, 1000);
    CGRect neededRect = [historyProgramString boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin context:drawContext];
    
    
    [self.programLabel setFrame:CGRectMake(20,13,neededRect.size.width, neededRect.size.height)];
    //[self.programLabel drawTextInRect:self.programLabel.bounds];
}

-(void)setup {
    self.isButtonShowed = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.85 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.8 alpha:1] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
    self.backgroundGradient = gradient;
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:self.bounds];
    scrollViewContentView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.0];
    [self.contentView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    CAGradientLayer *gradientForScroll = [CAGradientLayer layer];
    gradientForScroll.frame = self.bounds;
    gradientForScroll.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.85 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.8 alpha:1] CGColor], nil];
    [self.scrollViewContentView.layer insertSublayer:gradientForScroll atIndex:0];
    self.scrollGradientLayer = gradientForScroll;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,150, 12)];
    [self.scrollViewContentView addSubview:dateLabel];
    dateLabel.backgroundColor = [UIColor clearColor];
    self.datelabel = dateLabel;
    
    UILabel *programLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,13,self.bounds.size.width - 40, self.bounds.size.height - 12)];
    programLabel.numberOfLines = 0;
    
    [self.scrollViewContentView addSubview:programLabel];
    self.programLabel = programLabel;
    
    
    /*
    // Set up our two buttons
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
    moreButton.frame = CGRectMake(self.bounds.size.width - kCatchWidth, 0, kCatchWidth / 2.0f, self.bounds.size.height);
    [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView insertSubview:moreButton atIndex:0];
    //[self.contentView addSubview:moreButton];
    self.moreButton = moreButton;
    
    UIImageView* moreImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.moreButton.bounds.size.width - 60)/2,
                                                                             (self.moreButton.bounds.size.height - 60)/2, 60, 60)];
    [moreImage setImage:[UIImage imageNamed:@"Rec.png"]];
    moreImage.contentMode = UIViewContentModeScaleToFill;
    [self.moreButton addSubview:moreImage];
    self.moreImage = moreImage;
    
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(self.bounds.size.width - kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, self.bounds.size.height);
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchDown];
    [self.contentView insertSubview:deleteButton atIndex:0];
    //[self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    UIImageView* deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.deleteButton.bounds.size.width - 60)/2,
                                                                             (self.deleteButton.bounds.size.height - 60)/2, 60, 60)];
    [deleteImage setImage:[UIImage imageNamed:@"deleteBig.png"]];
    deleteImage.contentMode = UIViewContentModeScaleToFill;

    [self.deleteButton addSubview:deleteImage];
    self.deleteImage = deleteImage;
    */


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];
}

-(void)drawRect:(CGRect)rect
{
    self.contentView.frame = self.bounds;
    
    self.backgroundGradient.frame = self.bounds;

    self.scrollGradientLayer.frame = self.bounds;

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
        [moreImage setImage:[UIImage imageNamed:@"Rec.png"]];
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
    [deleteImage setImage:[UIImage imageNamed:@"deleteBig.png"]];
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

@end
