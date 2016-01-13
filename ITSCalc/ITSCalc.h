//
//  ITSCalc.h
//  ITSCalc
//
//  Created by Serge Sychov on 04.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import "ITSCalcViewController.h"

@interface ITSCalc : ITSCalcViewController

@property (nonatomic,strong) NSString *fromCur; //save in archive
@property (nonatomic,strong) NSString *toCur;// save in archive
@property (nonatomic,strong) NSNumber *value;

@end
