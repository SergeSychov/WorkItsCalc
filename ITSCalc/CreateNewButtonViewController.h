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

@end

@interface CreateNewButtonViewController : SecondViewController
@property (nonatomic) NSArray* program;
@property (nonatomic) NSString* programDescription;
@property (weak,nonatomic) id delegate;

@end
