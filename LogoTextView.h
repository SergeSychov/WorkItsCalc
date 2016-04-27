//
//  LogoTextView.h
//  LogoView
//
//  Created by Serge Sychov on 10.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoTextView : UIView

@property (nonatomic, weak) NSString* logoStr;
@property (nonatomic, weak) NSString* addStr;
@property (nonatomic, weak) NSString* periodStr;

@property (nonatomic,weak) UIColor *textColor;

@property (nonatomic, readonly) CGFloat mainFontsize;
//@property (nonatomic, readonly) CGFloat secondFontsize;

//set frame according width need proportions
-(void) setFrameWidth:(CGFloat) side;

//set frame according heigth need proportions
-(CGFloat) setFrameAndReturnStringAccordingHeight:(CGFloat) height;
@end
