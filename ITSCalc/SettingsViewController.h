//
//  SettingsViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 14.06.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "SecondViewController.h"

@interface SettingsViewController : SecondViewController

@property (nonatomic) BOOL isiCloudInUse;
@property (nonatomic) BOOL isBigDataBase; //size dataBase
@property (nonatomic) BOOL isSoundOn;
@property (nonatomic) BOOL isBigSizeButtons; //to set big size buttons

@property (nonatomic) BOOL isTrialPeriod;
@property (nonatomic) BOOL wasPurshaised;

//-(void) willRotatetoSize:(CGSize)size;

@end
