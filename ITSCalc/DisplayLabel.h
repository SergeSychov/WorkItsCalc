//
//  DisplayLabel.h
//  ACalcTry
//
//  Created by Serge Sychov on 19.11.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface DisplayLabel : UILabel
@property (strong, nonatomic) IBOutlet UILabel *decRadLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstMemoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondMemoryLabel;
@property (nonatomic) NSInteger design;


-(void) showString:(NSString*) str;


@end
