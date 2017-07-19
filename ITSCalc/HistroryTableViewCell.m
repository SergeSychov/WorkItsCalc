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
#import "GradientView.h"
#import "LineView.h"
/////////test4



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
@property (nonatomic) BOOL sel;
@property (nonatomic,strong) DelButton *deleteButton;
@property (nonatomic,strong) UIImageView* deleteImage;

//@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) recBut *moreButton;
@property (nonatomic,strong) UIImageView* moreImage;

@property (nonatomic,strong) GradientView *scrollGradientView;
//@property (nonatomic,strong) UIView *scrollViewContentView;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UILabel *programLabel;
@property (nonatomic,weak) LineView* lineView;

//@property (nonatomic, strong) CAGradientLayer *backgroundGradient;
//@property (nonatomic, strong) CAGradientLayer *scrollGradientLayer;

@property (nonatomic) CGFloat curentXofSwiper;
@property (nonatomic) CGFloat deltaXofSwiper;

@property (nonatomic, strong)UIColor* colorSelectedFirstGradient;
@property (nonatomic, strong)UIColor* colorSelectedSecondGradient;
@property (nonatomic, strong)UIColor* colorUnselectedFirstGradient;
@property (nonatomic, strong)UIColor* colorUnselectedSecondGradient;
@property (nonatomic, strong)UIColor* colorForSelectedText;
@property (nonatomic, strong)UIColor* colorForUnselectedText;

@property (nonatomic, strong)UIColor *moreButtonColor;
@property (nonatomic, strong)UIColor *moreButtonBackgroundColor;
@property (nonatomic, strong)UIColor *buttonShadowColor;
@property (nonatomic)CGSize buttonShadowSize;
@property (nonatomic)CGFloat buttonShadowBlur;

@property (nonatomic, strong)UIColor *deleteButtonColor;
@property (nonatomic, strong)UIColor *deleteButtonBackgroundColor;

@end

@implementation HistroryTableViewCell
-(void)setup {
    self.isButtonShowed = NO;
    self.backgroundColor = [UIColor clearColor];
    
    GradientView *scrollGradientView = [[GradientView alloc] init];
    scrollGradientView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:scrollGradientView];
    self.scrollGradientView = scrollGradientView;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.backgroundColor = [UIColor clearColor];
    [self.scrollGradientView addSubview:dateLabel];
    self.datelabel = dateLabel;
    self.historyExchangeCurrencyString = nil;
    /*
    if(self.historyExchangeCurrencyString){
        UILabel *currencyLabel = [[UILabel alloc] init];
        currencyLabel.backgroundColor = [UIColor clearColor];
        [self.scrollGradientView addSubview:currencyLabel];
        self.currencyLabel = currencyLabel;
    }*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];
    
}

#pragma marks SET DESIGN PROPERZTIES
-(UIColor*)colorSelectedFirstGradient{
    return self.designObj.colorSelectedFirstGradient;
}
-(UIColor*)colorSelectedSecondGradient{
    return self.designObj.colorSelectedSecondGradient;
}
-(UIColor*)colorUnselectedFirstGradient{
    return self.designObj.colorUnselectedFirstGradient;
}
-(UIColor*)colorUnselectedSecondGradient{
    return self.designObj.colorUnselectedSecondGradient;
}
-(UIColor*)colorForSelectedText{
    return self.designObj.colorForSelectedText;
}
-(UIColor*)colorForUnselectedText{
    return self.designObj.colorForUnselectedText;
}
-(UIColor*)moreButtonColor{
    return self.designObj.moreButtonColor;
}
-(UIColor*)moreButtonBackgroundColor{
    return self.designObj.moreButtonBackgroundColor;
}
-(UIColor*)deleteButtonColor{
    return self.designObj.deleteButtonColor;
}
-(UIColor*)deleteButtonBackgroundColor{
    return self.designObj.deleteButtonBackgroundColor;
}
-(UIColor*)buttonShadowColor{
    return self.designObj.buttonShadowColor;
}
-(CGSize)buttonShadowSize{
    return self.designObj.buttonShadowSize;
}
-(CGFloat)buttonShadowBlur{
    return self.designObj.buttonShadowBlur;
}

-(void) setDesignObj:(DesignObject *)designObj{
    _designObj = designObj;
    switch (designObj.designNumber) {
        case DESIGN_CLASSIC:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
            
        case DESIGN_PAPER:
            if(!self.lineView){
                LineView *lineView = [[LineView alloc] init];
                lineView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:lineView];
                self.lineView = lineView;
            }
            break;
            
        case DESIGN_COLOR_BLUE:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        case DESIGN_COLOR_GREEN:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        case DESIGN_COLOR_YELOW:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        case DESIGN_COLOR_PINK:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        case DESIGN_COLOR_GRAY:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        case DESIGN_PHOTO:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
        default:
            if(self.lineView){
                [self.lineView removeFromSuperview];
                self.lineView = nil;
            }
            break;
    }
    
    [self setNeedsDisplay];

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
    
    [self.scrollGradientView addSubview:programLabel];
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
    
    [self.scrollGradientView addSubview:programTextView];
    _programTextView = programTextView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(self.sel != selected){
        self.sel = selected;
        [self setHistoryProgramString:self.historyProgramString];
        if(!selected && self.deleteButton)[self hideButtons];
        [self setNeedsDisplay];
        if(selected){
            [self.delegate cellDidSelect:self];
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

    [self.datelabel  setFont:font];
    self.datelabel.text = historyDateString;
}

-(void) setHistoryExchangeCurrencyString:(NSString *)historyExchangeCurrencyString
{
    if(historyExchangeCurrencyString){
        UIFont *font;
        CGRect labelFrame;
        if(IS_IPAD){
            font = [UIFont systemFontOfSize:15.];
            labelFrame = CGRectMake(170, 0, 150, 18);
        } else {
            font = [UIFont systemFontOfSize:9.];
            labelFrame = CGRectMake(120, 0, 200, 12);

        }
        
        if(!self.currencyLabel){
            UILabel *currencyLabel = [[UILabel alloc] init];
            currencyLabel.backgroundColor = [UIColor clearColor];
            currencyLabel.adjustsFontSizeToFitWidth = YES;
            [self.scrollGradientView addSubview:currencyLabel];
            self.currencyLabel = currencyLabel;
            [self.currencyLabel  setFrame:labelFrame];
        }

        
        [self.currencyLabel  setFont:font];
        
        self.currencyLabel.text = historyExchangeCurrencyString;
        self.currencyLabel.textColor = self.colorForUnselectedText;

    } else {
        
        if(self.currencyLabel){
            self.currencyLabel.text = @"";
            [self.currencyLabel removeFromSuperview];
            self.currencyLabel = nil;
        }
    }

}

-(void) setHistoryProgramString:(NSAttributedString *)historyProgramString
{
    if(self.sel){
        NSMutableAttributedString *atrStr = [historyProgramString mutableCopy];
        NSRange wholeRange = NSMakeRange(0, [atrStr  length]);
        //UIColor *textColor = self.colorForUnselectedText;
        [self.programTextView setTextColor:self.colorForSelectedText];
        
        [atrStr beginEditing];
        [atrStr addAttribute:NSForegroundColorAttributeName value:self.colorForSelectedText range:wholeRange];
        if(self.designObj.designNumber == DESIGN_PAPER){
            [atrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
        } else if(self.designObj.designNumber == DESIGN_PHOTO){
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowBlurRadius = 3.;
            shadow.shadowColor = [UIColor blackColor];
            shadow.shadowOffset = CGSizeMake(2, 2);
            [atrStr addAttribute:NSShadowAttributeName value:shadow range:wholeRange];
        }
        [atrStr endEditing];
        _historyProgramString = [atrStr copy];
    } else {
        NSMutableAttributedString *atrStr = [historyProgramString mutableCopy];
        NSRange wholeRange = NSMakeRange(0, [atrStr  length]);

        
        [atrStr beginEditing];
        [atrStr addAttribute:NSForegroundColorAttributeName value:self.colorForUnselectedText range:wholeRange];
        
        
        [atrStr endEditing];
        _historyProgramString = [atrStr copy];
    }

    if(!self.isCanDrag){
        if(!self.programTextView) [self makeProgramTextView];
        self.programTextView.attributedText = _historyProgramString;
        if(self.programLabel){
            [self.programLabel removeFromSuperview];
            self.programLabel = nil;
        }
    } else {
        if(!self.programLabel) [self makeProgramLabel];
        self.programLabel.attributedText = _historyProgramString;
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


-(void)drawRect:(CGRect)rect
{
    self.contentView.frame = rect;
    self.scrollGradientView.frame = rect;
    if(self.lineView){
        self.lineView.frame = CGRectMake(0, rect.size.height - 2, rect.size.width, 3);
    }
    CGRect labelFrame;
    if(IS_IPAD){
        labelFrame = CGRectMake(20, 0, 150, 18);
    } else {
        
        labelFrame = CGRectMake(20, 0, 80, 12);
    }
    [self.datelabel  setFrame:labelFrame];
    
    if(self.historyExchangeCurrencyString){
        if(IS_IPAD){
            labelFrame = CGRectMake(170, 0, 150, 18);
        } else {
        
        labelFrame = CGRectMake(self.datelabel.frame.size.width+40, 0, rect.size.width-self.datelabel.frame.size.width -60, 12);
        }
    
        [self.currencyLabel  setFrame:labelFrame];
    }
    
    if(self.sel){
        
        self.scrollGradientView.firstGradientColor = self.colorSelectedFirstGradient;
        self.scrollGradientView.secondGradientColor = self.colorSelectedSecondGradient;
        [self.scrollGradientView setNeedsDisplay];

        self.datelabel.textColor = self.colorForSelectedText;
        if(self.historyExchangeCurrencyString){
            self.currencyLabel.textColor = self.colorForSelectedText;
        }
        if(self.lineView){
            self.lineView.alpha = 0;
        }
        
    } else {
        self.scrollGradientView.firstGradientColor = self.colorUnselectedFirstGradient;
        self.scrollGradientView.secondGradientColor = self.colorUnselectedSecondGradient;
        [self.scrollGradientView setNeedsDisplay];


        [self.programTextView setTextColor:self.colorForUnselectedText];
        //set color for data label
        self.datelabel.textColor = self.colorForUnselectedText;
        if(self.historyExchangeCurrencyString){
            self.currencyLabel.textColor = self.colorForUnselectedText;
        }
        if(self.lineView){
            self.lineView.alpha = 1;
        }

    }
    
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
    CGFloat needWidth;
    if(IS_IPAD){
        needWidth = 160;
    } else {
        needWidth = 120;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollGradientView setFrame:self.bounds];
                         self.moreButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
                         self.deleteButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
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


        if(!self.moreButton){
            self.moreButton = [recBut buttonWithType:UIButtonTypeCustom];
            self.moreButton.contentMode = UIViewContentModeRedraw;
            [self.moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView insertSubview:self.moreButton atIndex:0];
        }

        self.moreButton.tintColor = self.moreButtonColor;
        self.moreButton.backgroundColor = self.moreButtonBackgroundColor;
        self.moreButton.shadowColor = self.buttonShadowColor;
        self.moreButton.shadowBlur = self.buttonShadowBlur;
        self.moreButton.shadowSize = self.buttonShadowSize;
       

        if(!self.deleteButton){
            self.deleteButton = [DelButton buttonWithType:UIButtonTypeCustom];
            self.deleteButton.contentMode = UIViewContentModeRedraw;
            [self.deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchDown];
            [self.contentView insertSubview:self.deleteButton atIndex:1];
        }

        self.deleteButton.tintColor = self.deleteButtonColor;
        self.deleteButton.backgroundColor = self.deleteButtonBackgroundColor;
        self.deleteButton.shadowColor = self.buttonShadowColor;
        self.deleteButton.shadowBlur = self.buttonShadowBlur;
        self.deleteButton.shadowSize = self.buttonShadowSize;

        self.moreButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
        self.deleteButton.frame = CGRectMake(self.bounds.size.width, 0, needWidth / 2.0f, self.bounds.size.height);
        self.curentXofSwiper = [sender locationInView:self].x;
        self.deltaXofSwiper = 0.;


    } else if (sender.state == UIGestureRecognizerStateChanged){
        self.deltaXofSwiper = self.curentXofSwiper - [sender locationInView:self].x;
        if((self.deltaXofSwiper >0) && (self.deltaXofSwiper < needWidth)){

            CGRect newFrame = self.scrollGradientView.frame;
            newFrame.origin.x = -self.deltaXofSwiper;
            [self.scrollGradientView setFrame:newFrame];
            self.moreButton.center = CGPointMake(self.bounds.size.width-self.deltaXofSwiper + needWidth/4., self.bounds.size.height/2);
            self.deleteButton.center = CGPointMake(self.bounds.size.width-self.deltaXofSwiper/2 + needWidth/4, self.bounds.size.height/2);

        }
        
    }  else if (sender.state == UIGestureRecognizerStateEnded){
        self.deltaXofSwiper = self.curentXofSwiper - [sender locationInView:self].x;

        if(self.deltaXofSwiper < needWidth/2){
            CGRect scrollFrame = self.scrollGradientView.frame;
            scrollFrame.origin.x = 0;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.scrollGradientView setFrame:scrollFrame];
                                 self.moreButton.center = CGPointMake(self.bounds.size.width+ needWidth/4., self.bounds.size.height/2);
                                 self.deleteButton.center = CGPointMake(self.bounds.size.width + needWidth/4, self.bounds.size.height/2);
                             } completion:^(BOOL finished) {

                                 
                             }];
        } else {
            CGRect scrollFrame = self.scrollGradientView.frame;
            scrollFrame.origin.x = -needWidth;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.scrollGradientView setFrame:scrollFrame];
                                 self.moreButton.center = CGPointMake(self.bounds.size.width - needWidth+needWidth/4., self.bounds.size.height/2);
                                 self.deleteButton.center = CGPointMake(self.bounds.size.width - needWidth/2+ needWidth/4, self.bounds.size.height/2);

                             } completion:^(BOOL finished) {
                                 
                                 
                             }];

        }
    }
    
}

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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];
}
#define textView delegate



@end
