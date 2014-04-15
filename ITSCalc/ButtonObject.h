//
//  ButtonObject.h
//  ACalcTry
//
//  Created by Serge Sychov on 10.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonObject : NSObject

@property (nonatomic) BOOL enable;
@property (nonatomic) BOOL isMain;
@property (nonatomic) BOOL alowedTodelete;
@property (nonatomic, strong) NSString *nameButton;
@property (nonatomic) NSInteger position;
@property (nonatomic,strong) NSDate *dateOfDeletting;

@end
