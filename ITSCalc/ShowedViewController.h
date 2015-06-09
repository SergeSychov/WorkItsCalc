//
//  ShowedViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 28.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ThirdController.h"

@interface ShowedViewController : ThirdController

@property (nonatomic,weak) UIView *testView; //the view that need be rotated

@property (nonatomic) BOOL isBluePanOrRed;
@property (nonatomic) BOOL isDurty;
@property (nonatomic,strong) NSAttributedString *attrStrForLabel;
@property (nonatomic,strong) NSAttributedString *resStringforShow;

-(void) setNeedStringsForShow:(NSAttributedString*)count andRes:(NSAttributedString*)res;


@end
