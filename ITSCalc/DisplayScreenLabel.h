//
//  DisplayScreenLabel.h
//  ITSCalc
//
//  Created by Serge Sychov on 18.07.17.
//  Copyright © 2017 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignObject.h"

@interface DisplayScreenLabel : UILabel
@property (nonatomic) DesignObject* designObj;
-(void) showString:(NSString*) str;

@end
