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
//#import "Clr.h"
#import "GradientView.h"

#import "LineView.h"
/////////test4



NSString *const HistoryTableViewCellViewDidBeginScrolingNotification = @"HistoryTableViewCellViewDidBeginScrolingNotification";


@interface HistroryTableViewCell() <UITextFieldDelegate>


@property (nonatomic) BOOL isButtonShowed;
@property (nonatomic) BOOL sel;
@property (nonatomic,strong) DelButton *deleteButton;
@property (nonatomic,strong) UIImageView* deleteImage;

@property (nonatomic,strong) recBut *moreButton;
@property (nonatomic,strong) UIImageView* moreImage;

@property (weak, nonatomic) IBOutlet GradientView *scrollGradientView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainProgrammLabel;


//check why
@property (nonatomic,weak) LineView* lineView;

@property (nonatomic) CGFloat curentXofSwiper;
@property (nonatomic) CGFloat deltaXofSwiper;

@end

@implementation HistroryTableViewCell
-(void)setup {
    self.isButtonShowed = NO;
    
    self.programAtrString = nil;
    self.dateString = nil;
    self.exchangeCurrencyString = nil;
    self.variableValuesString = nil;
    self.funcDescriptAtrString = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   
    if(self.sel != selected){

        _sel = selected;
        //self.selected = selected;
    // [self setHistoryProgramString:self.historyProgramString];
        if(!selected && self.deleteButton){}//IMPORTANT check condition LOOP [self hideButtons];
    
        if(selected){
            [self.delegate cellDidSelect:self];
        }
        //[super setSelected:selected animated:animated];
        [self setNeedsDisplay];
    }
    [super setSelected:selected animated:animated];
    //NSLog(@"Self selected");
    
}


-(void) setTextForLabels{
    
    //set info string according strings
    //NSLog(@"mainProgrammLabel:%@",[self.programAtrString string] );
    NSMutableAttributedString *wholeInfo = [[NSMutableAttributedString alloc] initWithString:@" " attributes:self.design.atrForLabelHistoryTable];
    NSAttributedString* spaceMark = [[NSAttributedString alloc] initWithString:@" "];//IMPORTANT Check if it need to set attributes
    if(self.dateString){
        [wholeInfo insertAttributedString:self.dateString atIndex:0];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    if(self.exchangeCurrencyString){
        [wholeInfo insertAttributedString:self.exchangeCurrencyString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    if(self.variableValuesString){
        [wholeInfo insertAttributedString:self.variableValuesString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    if(self.funcDescriptAtrString){
        [wholeInfo insertAttributedString:self.funcDescriptAtrString atIndex:[wholeInfo length]];
        [wholeInfo insertAttributedString:spaceMark atIndex:[wholeInfo length]];
    }
    
    self.infoLabel.attributedText = [wholeInfo copy];
    //self.infoLabel.attributedText = [self infoLabelsAttributedStringFromString:[wholeInfo copy]];
    
    self.mainProgrammLabel.attributedText = self.programAtrString;
    
}


-(NSAttributedString*)infoLabelsAttributedStringFromString:(NSAttributedString*)atrStr {
    //find need font size ratio between Main Attributed Text size and need size
    //for compact width size infolabel text size as caption1
    //other case - Callout
    CGFloat needRatio;
    NSString *needFontName;
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        needRatio =[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].pointSize/[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3].pointSize;
        needFontName  = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].fontName;
    }else {
        needRatio =[UIFont preferredFontForTextStyle:UIFontTextStyleCallout].pointSize/[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1].pointSize;
        needFontName  = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout].fontName;
    }
    NSMutableAttributedString *atrOutStr = [atrStr mutableCopy];
    //for each char set point size according ratio and needFontName
    [atrOutStr beginEditing];
    
    for (NSInteger index = 0; index < [atrOutStr length]; index++){
        NSDictionary * attributes = [atrOutStr attributesAtIndex:index effectiveRange:NULL];
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        CGFloat newSize = wasFont.pointSize * needRatio;
        
        UIFont *newFont = [UIFont fontWithName:needFontName size:newSize];
        
        NSRange charRange = NSMakeRange(index, 1);
        
        [atrOutStr addAttribute:NSFontAttributeName value:newFont range:charRange];
    }
    
    //set left aliment in any case
    NSMutableParagraphStyle *style = [[[atrOutStr attributesAtIndex:0 effectiveRange:NULL] valueForKey:NSParagraphStyleAttributeName] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    NSRange wholeRange = NSMakeRange(0, [atrOutStr length]);
    [atrOutStr addAttribute:NSParagraphStyleAttributeName value:[style copy] range:wholeRange];
    
    //set right text color according design and selection
    //UIColor *textColor = self.selected ? [UIColor darkTextColor] : [UIColor grayColor];
    //[atrOutStr addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
    
    [atrOutStr endEditing];
    
    return [atrOutStr copy];
}

-(void)drawRect:(CGRect)rect
{
    if(self.selected){
        self.scrollGradientView.firstGradientColor = self.design.colorSelectedFirstGradient;
        self.scrollGradientView.secondGradientColor = self.design.colorSelectedSecondGradient;
        [self.scrollGradientView setNeedsDisplay];
        
        [self.infoLabel setTextColor:self.design.colorForSelectedText];
        [self.mainProgrammLabel setTextColor:self.design.colorForSelectedText];
        
    } else {
        
        self.scrollGradientView.firstGradientColor = self.design.colorUnselectedFirstGradient;
        self.scrollGradientView.secondGradientColor = self.design.colorUnselectedSecondGradient;
        [self.scrollGradientView setNeedsDisplay];
        
        [self.infoLabel setTextColor:self.design.colorForUnselectedText];
        [self.mainProgrammLabel setTextColor:self.design.colorForUnselectedText];
    }
}

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
-(void) showButtons:(UIGestureRecognizer *)sender
{
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
        
        self.moreButton.tintColor = self.design.moreButtonColor;
        self.moreButton.backgroundColor = self.design.moreButtonBackgroundColor;
        self.moreButton.shadowColor = self.design.buttonShadowColor;
        self.moreButton.shadowBlur = self.design.buttonShadowBlur;
        self.moreButton.shadowSize = self.design.buttonShadowSize;
        
        
        if(!self.deleteButton){
            self.deleteButton = [DelButton buttonWithType:UIButtonTypeCustom];
            self.deleteButton.contentMode = UIViewContentModeRedraw;
            [self.deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchDown];
            [self.contentView insertSubview:self.deleteButton atIndex:1];
        }
        
        self.deleteButton.tintColor = self.design.deleteButtonColor;
        self.deleteButton.backgroundColor = self.design.deleteButtonBackgroundColor;
        self.deleteButton.shadowColor = self.design.buttonShadowColor;
        self.deleteButton.shadowBlur = self.design.buttonShadowBlur;
        self.deleteButton.shadowSize = self.design.buttonShadowSize;
        
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

//check may be not needed
-(void)layoutSubviews{
    [super layoutSubviews];
    self.mainProgrammLabel.preferredMaxLayoutWidth = self.frame.size.width;
    self.infoLabel.preferredMaxLayoutWidth = self.frame.size.width;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HistoryTableViewCellViewDidBeginScrolingNotification object:nil];
}

@end
