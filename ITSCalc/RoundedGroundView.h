//
//  RoundedGroundView.h
//  RoundedGround
//
//  Created by Serge Sychov on 04.10.15.
//  Copyright © 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedGroundView : UIView
@property (nonatomic,strong) UIColor *color;

+(UIImage*) getImageForRect:(CGRect)rct withColor:(UIColor*)color;

@end
