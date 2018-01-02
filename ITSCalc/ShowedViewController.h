//
//  ShowedViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 28.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "ThirdController.h"
#import "DesignObject.h"

@interface ShowedViewController : ThirdController <UIContentContainer>

@property (strong, nonatomic) DesignObject* design;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackLeadingConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackTrailingConstrain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackBottomConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsWidthConstrain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsLeadingConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descrLabelHeightConstrain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultHeightConstrain;//80 iPhone 120 - iPad

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic) UIDeviceOrientation wasOrient;

@property (nonatomic) BOOL isBluePanOrRed;
@property (nonatomic) BOOL isDurty;
//@property (nonatomic,strong) NSAttributedString *attrStrForLabel;
//@property (nonatomic,strong) NSAttributedString *resStringforShow;

-(void) setNeedStrings:(NSAttributedString*)descr:(NSAttributedString*)count andRes:(NSAttributedString*)res;
-(void)upDateStringsWithInfSize:(CGSize)infSize exprSize:(CGSize)exprSize resSize:(CGSize)resSize;


@end
