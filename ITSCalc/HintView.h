//
//  HintView.h
//  ITSCalc
//
//  Created by Serge Sychov on 19.05.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HintView : UIView


+(HintView*) newHintViewWithFrame:(CGRect)frame labelRect:(CGRect)labelrect type:(NSInteger)type;

@end
