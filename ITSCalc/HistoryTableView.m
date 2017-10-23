//
//  HistoryTableView.m
//  ACalcTry
//
//  Created by Serge Sychov on 24.02.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "HistoryTableView.h"

@implementation HistoryTableView
-(void) setup
{
    self.isNeedToSetOffsetToButton = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

/*
-(void) setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    
    if(self.isNeedToSetOffsetToButton){
     
        //if(contentSize.height >0){
            CGRect rect = self.frame;
            rect.origin.y = self.contentSize.height - self.frame.size.height;
            [self scrollRectToVisible:rect animated:YES];
       // }
      
    }
    
}
*/

@end
