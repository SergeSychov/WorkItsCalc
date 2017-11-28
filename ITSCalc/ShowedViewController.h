//
//  ShowedViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 28.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ThirdController.h"

@interface ShowedViewController : ThirdController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultHeightConstrain;//80 iPhone 120 - iPad

@property (nonatomic) UIDeviceOrientation wasOrient;

@property (nonatomic) BOOL isBluePanOrRed;
@property (nonatomic) BOOL isDurty;
//@property (nonatomic,strong) NSAttributedString *attrStrForLabel;
//@property (nonatomic,strong) NSAttributedString *resStringforShow;

-(void) setNeedStringsForShow:(NSAttributedString*)count andRes:(NSAttributedString*)res;


@end
