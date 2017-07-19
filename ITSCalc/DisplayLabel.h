//
//  DisplayLabel.h
//  ACalcTry
//
//  Created by Serge Sychov on 19.11.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"




@interface DisplayLabel : UILabel
@property (nonatomic) DesignObject* designObj;


-(void) showString:(NSString*) str;


@end
