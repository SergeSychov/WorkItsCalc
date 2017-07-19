//
//  DesignViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 13.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "SecondViewController.h"
#import "DesignObject.h"


@class DesignViewController;
@protocol DesignViewControllerProtocol <NSObject>
@optional
-(void) designViewControllerDidCloseWithString:(NSString*)returnString;

@end

@interface DesignViewController : SecondViewController
@property (nonatomic,weak) id <DesignViewControllerProtocol> delegate;

@property (nonatomic, weak) DesignObject* designObj;
@property (nonatomic) NSInteger designIndex;

@end
