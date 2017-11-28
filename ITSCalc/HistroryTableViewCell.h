//
//  HistroryTableViewCell.h
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"
@class HistroryTableViewCell;

@protocol HistoryTableViewCellDelegate <NSObject>

-(void) cellDidSelectDelete:(NSIndexPath*)cellIndexPatch;
-(void) cellDidSelectRecount:(NSIndexPath*)cellIndexPatch;
-(void) cellDidSelect:(HistroryTableViewCell *)cell;
@end


@interface HistroryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainProgrammLabel;

//@property (nonatomic,strong) NSAttributedString* programAtrString;

//ONLY FOR TEST
//@property (nonatomic, strong) NSAttributedString* dateString;
//@property (nonatomic,strong) NSAttributedString* exchangeCurrencyString;
//@property (nonatomic, strong) NSAttributedString* variableValuesString;
//@property (nonatomic, strong) NSAttributedString* funcDescriptAtrString;


//@property (nonatomic) BOOL isCanDrag; //can't drag last cell also set changeble uitextview
//@property (nonatomic, strong) UITextView *programTextView;
//@property (nonatomic) NSInteger design;
@property (nonatomic, weak) DesignObject* design;


//thi property allow user recount history sell / alow apeasr recount button
//@property (nonatomic) BOOL wasPurhased;
//-(void) showButtons:(UIGestureRecognizer *)sender;
//-(void) setTextForLabels;

@property (nonatomic,weak) id <HistoryTableViewCellDelegate> delegate;

@end
