//
//  ArchiveSizeView.h
//  ITSCalc
//
//  Created by Serge Sychov on 22.11.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveSizeView : UIView

@property(nonatomic) BOOL isBig;
-(CGPathRef)makeToPath CF_RETURNS_RETAINED;
-(CGPathRef)makeFromPath CF_RETURNS_RETAINED;

@end
