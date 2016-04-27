//
//  LogoTextView.m
//  LogoView
//
//  Created by Serge Sychov on 10.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "LogoTextView.h"

@implementation LogoTextView
//lazy initialization strings
-(void) setMainFontsize:(CGFloat)mainFontsize
{
    _mainFontsize = mainFontsize;
}

-(NSString*) logoStr
{
    if(!_logoStr){
        _logoStr = @"Its Calc";
    }
    return _logoStr;
}

-(NSString*) addStr
{
    if(!_addStr){
        _addStr = @"additions";
    }
    return _addStr;
}

-(NSString*) periodStr
{
    if(!_periodStr){
        _periodStr = @"trial period";
    }
    return _periodStr;
}

-(UIColor*) textColor {
    if(!_textColor){
        _textColor = [UIColor darkTextColor];
    }
    
    return _textColor;
}
//set frame according width need proportions
-(void) setFrameWidth:(CGFloat)side
{
    CGFloat height = side*0.595;
    
    [super setFrame:CGRectMake(0, 0, side, height)];
}

//set frame according heigth need proportions
-(CGFloat) setFrameAndReturnStringAccordingHeight:(CGFloat)height
{
    CGFloat side = height/0.595;
    //set the main font heere to return
    CGFloat mainFontsize = side/5;
    UIFont *mainFont = [UIFont systemFontOfSize:mainFontsize];
    //UIColor *textColor = [UIColor darkGrayColor];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineHeightMultiple = 1;
    NSMutableDictionary *attributesItsCalc = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,self.textColor, NSForegroundColorAttributeName, mainFont, NSFontAttributeName,@0.,NSKernAttributeName, nil];
    CGSize needSizeForItsCalc = [self.logoStr sizeWithAttributes:attributesItsCalc];
    while (needSizeForItsCalc.width < side*0.95){
        mainFontsize++;
        mainFont = [UIFont systemFontOfSize:mainFontsize];
        [attributesItsCalc removeObjectForKey:NSFontAttributeName];
        [attributesItsCalc setObject:mainFont forKey:NSFontAttributeName];
        //NSLog(@"Dictionary %@", attributesItsCalc);
        needSizeForItsCalc = [self.logoStr sizeWithAttributes:attributesItsCalc];
    }
    self.mainFontsize = mainFontsize;
    
    [super setFrame:CGRectMake(0, 0, side, height)];
    
    return mainFontsize;
}


-(void) drawStringsInRect:(CGRect)rect
{
    CGFloat side = rect.size.width;
    //1. define rect for @"Its Calc"
    CGRect rectForItsCalc = CGRectMake(0, 0, side, side/2);
    
    
    //4. calculate size for main font
    //CGFloat mainFontsize = side/5;
    UIFont *mainFont = [UIFont systemFontOfSize:self.mainFontsize];
    //UIColor *textColor = [UIColor darkGrayColor];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineHeightMultiple = 1;
    NSMutableDictionary *attributesItsCalc = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,self.textColor, NSForegroundColorAttributeName, mainFont, NSFontAttributeName,@0.,NSKernAttributeName, nil];
    CGSize needSizeForItsCalc = [self.logoStr sizeWithAttributes:attributesItsCalc];
    /*
    while (needSizeForItsCalc.width < side*0.95){
        mainFontsize++;
        mainFont = [UIFont systemFontOfSize:mainFontsize];
        [attributesItsCalc removeObjectForKey:NSFontAttributeName];
        [attributesItsCalc setObject:mainFont forKey:NSFontAttributeName];
        //NSLog(@"Dictionary %@", attributesItsCalc);
        needSizeForItsCalc = [self.logoStr sizeWithAttributes:attributesItsCalc];
    }
    NSLog(@"Main font size from LogoTextview: %f", mainFontsize);
    [self setMainFontsize:mainFontsize];
     */
    
    //draw main string
    [self.logoStr drawInRect:rectForItsCalc withAttributes:attributesItsCalc];
    
    //calculate and draw additional
    CGFloat secondFontSize = self.mainFontsize/2;
    //[self setSecondFontsize:secondFontSize];
    UIFont *secondFont = [UIFont boldSystemFontOfSize:secondFontSize];
    [attributesItsCalc removeObjectForKey:NSFontAttributeName];
    [attributesItsCalc setObject:secondFont forKey:NSFontAttributeName];
    
    CGSize needSizeForAdd = [self.addStr sizeWithAttributes:attributesItsCalc];
    
    //2. define rect for @"additionals"
    
    CGFloat kernel = 0;
    while (needSizeForAdd.width < needSizeForItsCalc.width*0.95){
        kernel += 0.1;
        [attributesItsCalc removeObjectForKey:NSKernAttributeName];
        [attributesItsCalc setObject:[NSNumber numberWithFloat:kernel] forKey:NSKernAttributeName];
        //NSLog(@"Dictionary %@", attributesItsCalc);
        needSizeForAdd = [self.addStr sizeWithAttributes:attributesItsCalc];
        
    }
    //NSLog(@"Size of str width: %f, height: %f", needSizeForItsCalc.width, needSizeForItsCalc.height);
    CGRect rectForAdditionals = CGRectMake(0, needSizeForItsCalc.height*0.81, side, needSizeForAdd.height*0.93);
    
   // NSLog(@"Size of rect width: %f, height: %f", rectForAdditionals.size.width, rectForAdditionals.size.height);
    [self.addStr drawInRect:rectForAdditionals withAttributes:attributesItsCalc];
    
    //2. define фтвrect for @"additionals"
    
    kernel = 0.;
    [attributesItsCalc removeObjectForKey:NSKernAttributeName];
    [attributesItsCalc setObject:[NSNumber numberWithFloat:kernel] forKey:NSKernAttributeName];
    
    CGSize needSizeForPeriod = [self.periodStr sizeWithAttributes:attributesItsCalc];
    
    while (needSizeForPeriod.width < needSizeForItsCalc.width*0.95){
        kernel += 0.1;
        [attributesItsCalc removeObjectForKey:NSKernAttributeName];
        [attributesItsCalc setObject:[NSNumber numberWithFloat:kernel] forKey:NSKernAttributeName];

        needSizeForPeriod = [self.periodStr sizeWithAttributes:attributesItsCalc];
       // NSLog(@"Size of periodstr width: %f, height: %f", needSizeForPeriod.width, needSizeForPeriod.height);
        
    }
   // NSLog(@"Size of periodstr width: %f, height: %f", needSizeForPeriod.width, needSizeForPeriod.height);
    CGRect rectforPeriodStr = CGRectMake(0, needSizeForItsCalc.height*0.81 + needSizeForAdd.height*0.81, side, needSizeForAdd.height*0.93);
    
   // NSLog(@"Size of rect width: %f, height: %f", rectforPeriodStr.size.width, rectforPeriodStr.size.height);
    [self.periodStr drawInRect:rectforPeriodStr withAttributes:attributesItsCalc];

   // CGFloat height = needSizeForItsCalc.height*0.81 + needSizeForAdd.height*0.81 + needSizeForAdd.height*0.93;
   // NSLog(@"Propporion - %f", height/side);
    


}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"Draw rect logo view");
    [self drawStringsInRect:rect];
}


@end
