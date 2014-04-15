//
//  ShowedView.h
//  ACalcTry
//
//  Created by Serge Sychov on 22.03.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowedView : UIView

@property (nonatomic) BOOL isBluePanOrRed;
@property (nonatomic) BOOL isDurty;

-(void) setShowedViewWithCountedStr:(NSAttributedString*)countStr resultStr:(NSAttributedString*)resStr andBluePan:(BOOL) isBluePan;
-(void) drawLine:(UIPanGestureRecognizer*) sender;
-(void) clearPaintedView;
-(NSString*) stringOnScreen;


@end
