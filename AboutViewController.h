//
//  AboutViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 08.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearedViewController.h"


@interface AboutViewController : AppearedViewController

-(id)initWithController:(UIViewController*)controller daysLeft:(NSInteger)days;

@property (nonatomic) NSInteger daysNumber;

@property (nonatomic,weak) NSString* trialTextString;
@property (nonatomic,weak) NSString* continueString;
@property (nonatomic,weak) NSString* buyString;
@property (nonatomic,weak) NSString* moreString;
@property (nonatomic,weak) NSString* daysString;


@end
