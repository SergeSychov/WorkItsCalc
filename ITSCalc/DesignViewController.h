//
//  DesignViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 13.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "SecondViewController.h"
#import "DesignObject.h"
#import "PaymentObj.h"


@class DesignViewController;
@protocol DesignViewControllerProtocol <NSObject>
@optional
-(void) designViewControllerDidCloseWithString:(NSString*)returnString;

@end

@interface DesignViewController : SecondViewController
@property (nonatomic,weak) id <DesignViewControllerProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cViewWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cViewHeigthConstrain;
@property (nonatomic, weak) DesignObject* designObj;
@property (nonatomic) PaymentObj *paymentObj;

//@property (nonatomic) NSInteger designIndex;

@end
