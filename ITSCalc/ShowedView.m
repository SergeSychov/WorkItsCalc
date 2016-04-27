//
//  ShowedView.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.03.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "ShowedView.h"
#import "BezierInterpView.h"

#define RES_RECT_HEIGHT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 196.f : 96.f)
#define STRING_INDENT ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 150.f : 90.f)
//#define PAD_STRING ([[UIDevice currentDevice].model hasPrefix:@"iPad"] ? @"YES IPAD" : @"NOT IPAD")

@interface ShowedView()


@property (nonatomic, weak) BezierInterpView *paintedView;
@property (nonatomic, strong) NSAttributedString *count;
@property (nonatomic, strong) NSAttributedString *result;

@end

@implementation ShowedView

#define LASY INITIALIZATION
-(void)countRedLineSize
{
    CGFloat redLineSize;
    if([self.count.string isEqualToString:@""]){
        redLineSize = 20.;
    } else {
        
        NSDictionary *attributes = [self.count attributesAtIndex:0 effectiveRange:nil];
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        redLineSize = wasFont.pointSize * 0.8;
        if(self.count.length > 1){
            //set the size of maximum fon size in whole length
            for(NSInteger i = 1; i < self.count.length -1; i++){
                attributes = [self.count attributesAtIndex:i effectiveRange:nil];
                wasFont = [attributes valueForKey:NSFontAttributeName];
                if((wasFont.pointSize * 0.8)> redLineSize){
                    redLineSize = wasFont.pointSize * 0.8;
                }
            }
        }
    }
    self.paintedView.lineWidth = redLineSize;
}

-(NSAttributedString*) count
{
    if(!_count){
        _count = [[NSAttributedString alloc] initWithString:@""];
    }
    
    return _count;
}

-(NSAttributedString*) result
{
    if(!_result){
        _result = [[NSAttributedString alloc] initWithString:@""];
    }
    
    return _result;
}

-(NSString*) stringOnScreen
{
    return  [self.count.string stringByAppendingString:self.result.string];
}

-(void) setShowedViewWithCountedStr:(NSAttributedString*)countStr resultStr:(NSAttributedString*)resStr andBluePan:(BOOL)isBluePan
{
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.isBluePanOrRed = isBluePan;
        self.count = countStr;
        self.result = resStr;
            //dispatch_async(dispatch_get_main_queue(), ^{
                [self setNeedsDisplay];
           // });
       // });
}

-(NSAttributedString*) resizeAttrString:(NSAttributedString*)inputStr withHeight:(CGFloat)height;
{
    NSMutableAttributedString* resultString = [inputStr mutableCopy];
    
    
    //find the max height from inpiut string
    CGFloat waspointSize = 0;
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        //NSLog(@"symbolString: %@", symbolString.string);
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        //NSLog(@"wasFont pointsize: %f", wasFont.pointSize);
        if(wasFont.pointSize > waspointSize) waspointSize = wasFont.pointSize;
    }
    //count the resizing
    CGFloat k = height / waspointSize;
    
    //set the new value for all of symbols according new k
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        NSNumber *wasOffset = [attributes valueForKey:NSBaselineOffsetAttributeName];
        UIFont *font = [UIFont fontWithName:wasFont.familyName size:wasFont.pointSize * k]; //if there is no needed font
         UIColor *textColor = [UIColor darkTextColor];

        [symbolString beginEditing];
        NSRange wholeRange = NSMakeRange(0, [symbolString length]);
        [symbolString addAttribute:NSFontAttributeName value:font range:wholeRange];
        [symbolString addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
        [symbolString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:[wasOffset floatValue]* k] range:wholeRange];
        [symbolString endEditing];
        [resultString replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:symbolString];
    }
    
    return [resultString copy];
}

-(UIFont*) setFontWithSize:(CGFloat) size
{
    UIFont *font; //if there is no needed font
    
    NSString *fontName = nil;
    NSArray *famalyNames  =[UIFont familyNames];
    if([famalyNames containsObject:@"Helvetica Neue"]){
        NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
        if([fontNames containsObject:@"HelveticaNeue"]){
            fontName = @"HelveticaNeue";
        }
    }
    
    if(fontName){
        font = [UIFont fontWithName:fontName size:size];
    }else {
        font =[UIFont boldSystemFontOfSize:size];
    }
    return  font;
}

-(NSAttributedString*) changeFontInAttrStr:(NSAttributedString*)attrStr sizeWithSize:(CGFloat)size
{
    NSMutableAttributedString * attrTextMutCopy = [attrStr mutableCopy];
    UIColor *textColor = [UIColor darkTextColor];
    

    
    [attrTextMutCopy beginEditing];
    NSRange wholeRange = NSMakeRange(0, [attrTextMutCopy  length]);
    [attrTextMutCopy addAttribute:NSForegroundColorAttributeName value:textColor range:wholeRange];
    [attrTextMutCopy  addAttribute:NSFontAttributeName value:[self setFontWithSize:size] range:wholeRange];
    [attrTextMutCopy endEditing];
    
    return [attrTextMutCopy copy];
}

#define BLUE OR RED BUTTON

-(void) setIsBluePanOrRed:(BOOL)isBluePanOrRed
{
    _isBluePanOrRed = isBluePanOrRed;
    if(_isBluePanOrRed){
        self.paintedView.isBlueColor = YES;
    } else {
        self.paintedView.isBlueColor = NO;
        [self countRedLineSize];
    }
}


#define SET VIEWS and SETUP
-(void) clearPaintedView
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                          self.paintedView.alpha = 0.;
                     } completion:^(BOOL finished) {
                         [self.paintedView removeFromSuperview];
                         BezierInterpView *paintedView = [[BezierInterpView alloc] initWithFrame:self.bounds];
                         paintedView.backgroundColor = [UIColor clearColor];
                         
                         paintedView.isBlueColor = self.isBluePanOrRed;
                         
                         [self addSubview:paintedView];
                         self.paintedView = paintedView;
                         [self countRedLineSize];
                     }];
    
}


-(void) setup
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];//@"handmadepaper.png"
    self.isBluePanOrRed = YES;
    
    BezierInterpView *paintedView = [[BezierInterpView alloc] init];
    paintedView.backgroundColor = [UIColor clearColor];
    [self addSubview:paintedView];
    self.paintedView = paintedView;

}

-(void) drawText
{
    
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize = CGSizeMake(self.bounds.size.width - STRING_INDENT - 20,1000);
    CGRect neededRect = [self.count boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                               context:drawContext];
    neededRect.origin.y = self.bounds.size.height - RES_RECT_HEIGHT - 20 - neededRect.size.height;
    neededRect.origin.x = STRING_INDENT;
    
    [self.count drawInRect:neededRect];
    
    CGRect resRect = CGRectMake(STRING_INDENT,
                                self.bounds.size.height - RES_RECT_HEIGHT - 20,
                                self.bounds.size.width - STRING_INDENT - 20,
                                RES_RECT_HEIGHT);

    
    [self.result drawInRect:resRect];
}


- (void)drawRect:(CGRect)rect
{

    [self.paintedView setFrame:rect];

    [self drawText];
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

    }
    return self;
}
@end
