//
//  CreateNewButtonViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 23.02.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import "SecondViewController.h"

@protocol CreateNewButtonController <NSObject>

-(BOOL)createNewButtonWith:(NSString*)name andProgramm:(NSArray*)programm;

-(NSString*)getPossibleButtonNameWithInitial:(NSString*)initStr;
@end


@interface CreateNewButtonViewController : SecondViewController
@property (nonatomic) id program;
@property (nonatomic) NSString* programDescription;
@property (weak,nonatomic) id delegate; //buttonsStore class with two function:
//1. get possible name from enity buttons
//2. create new button

@end
