//
//  AppearedViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 16.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppearedViewController;

@protocol AppearedViewControllerProtocol <NSObject>

@optional
-(void) aboutControllerDidCloseWithString:(NSString*)returnString;

@end


@interface AppearedViewController : UIViewController

@property (nonatomic,weak) UIView* copiedView;
@property (nonatomic, weak) UIView* mainView;
@property (nonatomic,strong) UIColor *mainViewBackGroundColor;
@property (nonatomic) BOOL appearens;//bool value to indicate if view appered
@property (nonatomic) BOOL direction; //direction of appearens from top - YES, from bottom - NO

-(void) addNeededSubviewsOnMainView;
-(void)subViewLayoutWithRect:(CGRect)rect;
-(id)initWithController:(UIViewController*)controller;

@property (nonatomic,weak) id <AppearedViewControllerProtocol> delegate;

@end
