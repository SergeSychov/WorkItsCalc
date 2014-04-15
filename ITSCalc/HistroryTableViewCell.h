//
//  HistroryTableViewCell.h
//  ACalcTry
//
//  Created by Serge Sychov on 22.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistroryTableViewCell;

@protocol HistoryTableViewCellDelegate <NSObject>

-(void) cellDidSelectDelete:(HistroryTableViewCell *)cell;
-(void) cellDidSelectRecount:(HistroryTableViewCell *)cell;
-(void) cellDidSelect:(HistroryTableViewCell *)cell;
@end


@interface HistroryTableViewCell : UITableViewCell

@property (nonatomic,strong) NSAttributedString *historyProgramString;
@property (nonatomic, strong) NSString *historyDateString;
@property (nonatomic) BOOL isCanDrag;
-(void) showButtons;

@property (nonatomic,weak) id <HistoryTableViewCellDelegate> delegate;

@end
