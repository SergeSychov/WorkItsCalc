//
//  ShowedView.m
//  ACalcTry
//
//  Created by Serge Sychov on 22.03.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import "ShowedView.h"
#import "cmyk.h"

#define RES_STRING_HEIGHT 96.f

@interface ShowedView()


@property (nonatomic, strong) UIView *paintedView;
//origin point for gesture
@property (nonatomic) CGPoint origin;
@property (nonatomic,strong) NSArray *patchPoints;
@property (nonatomic, strong) CAShapeLayer *line;

@property (nonatomic, strong) NSAttributedString *count;
@property (nonatomic) CGRect rectForCountedString;

@property (nonatomic, strong) NSAttributedString *result;
@property (nonatomic) CGRect rectForResultString;

@property (nonatomic) CGFloat redLineSize; //size of red marker according count fount size
@end

@implementation ShowedView

#define LASY INITIALIZATION
-(CGFloat)redLineSize
{
    if([self.count.string isEqualToString:@""]){
        _redLineSize = 20.;
    } else {
        
        NSDictionary *attributes = [self.count attributesAtIndex:0 effectiveRange:nil];
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
        _redLineSize = wasFont.pointSize * 0.8;
        if(self.count.length > 1){
            //set the size of maximum fon size in whole length
            for(NSInteger i = 1; i < self.count.length -1; i++){
                attributes = [self.count attributesAtIndex:i effectiveRange:nil];
                wasFont = [attributes valueForKey:NSFontAttributeName];
                if((wasFont.pointSize * 0.8)> _redLineSize){
                    _redLineSize = wasFont.pointSize * 0.8;
                }
            }
        }
    }
    return _redLineSize;
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

-(NSArray *)patchPoints
{
    if(!_patchPoints){
        _patchPoints = [[NSArray alloc] init];
    }
    return _patchPoints;
}

-(void) setIsDurty:(BOOL)isDurty
{
    _isDurty = isDurty;
     [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ShowedViewIsDirtyNotification" object:nil]];
    
}

-(NSString*) stringOnScreen
{
    return  [self.count.string stringByAppendingString:self.result.string];
}

-(void) setShowedViewWithCountedStr:(NSAttributedString*)countStr resultStr:(NSAttributedString*)resStr andBluePan:(BOOL)isBluePan
{
    //set the instance of pan color
    self.isBluePanOrRed = isBluePan;
    self.isDurty = NO;
    //clear painted view
    [self.paintedView removeFromSuperview];
    UIView *paintedView = [[UIView alloc] initWithFrame:self.bounds];
    paintedView.backgroundColor = [UIColor clearColor];
    [self addSubview:paintedView];
    self.paintedView = paintedView;
    
    //set count text attributes
    NSMutableAttributedString * countAtrStr = [countStr mutableCopy];
    
    UIFont *font;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.lineHeightMultiple = 0;
    
    [countAtrStr beginEditing];
    NSRange wholeRange = NSMakeRange(0, [countAtrStr length]);
    [countAtrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
    [countAtrStr addAttribute:NSParagraphStyleAttributeName value:style range:wholeRange];
    [countAtrStr endEditing];
    //set drawing rect for counted rect
    NSInteger preferedSize = 48;
    countAtrStr = [[self resizeAttrString:[countAtrStr copy] withHeight:preferedSize] mutableCopy];
    
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize neededSize = CGSizeMake(self.bounds.size.width - 90 - 20,1000);
    CGRect neededRect = [countAtrStr boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:drawContext];
    
    while (neededRect.size.height > self.bounds.size.height - 20- 96) {
        preferedSize = preferedSize - 2;
        countAtrStr = [[self resizeAttrString:[countAtrStr copy] withHeight:preferedSize] mutableCopy];
        neededRect = [countAtrStr boundingRectWithSize:neededSize options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:drawContext];
    }

    neededRect.origin.y = self.bounds.size.height - RES_STRING_HEIGHT - 20 - neededRect.size.height;
    neededRect.origin.x = 90;
    
    self.count = countAtrStr;
    self.rectForCountedString = neededRect;
    
    //set result str
    NSMutableAttributedString * resulAttrStr = [resStr mutableCopy];
    font = [self setFontWithSize:72.];
    style.alignment = NSTextAlignmentRight;
    style.lineHeightMultiple = 1.;
    [resulAttrStr beginEditing];
    wholeRange = NSMakeRange(0, [resulAttrStr length]);
    [resulAttrStr addAttribute:NSFontAttributeName value:font range:wholeRange];
    [resulAttrStr addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:wholeRange];
    [resulAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:wholeRange];
    [resulAttrStr endEditing];
    
    NSInteger resultStringSize = 72;
    
    CGRect resRect = CGRectMake(90,
                                self.bounds.size.height - RES_STRING_HEIGHT - 20,
                                self.bounds.size.width - 90 - 20,
                                RES_STRING_HEIGHT);
    
    CGRect neededResultRect = [resulAttrStr boundingRectWithSize:resRect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                          context:drawContext];
    while(neededResultRect.size.width > (resRect.size.width -10)){
        resultStringSize = resultStringSize - 2;
        resulAttrStr = [[self resizeAttrString:[resulAttrStr copy] withHeight:resultStringSize] mutableCopy];
        neededResultRect = [resulAttrStr boundingRectWithSize:resRect.size options:NSStringDrawingUsesFontLeading//NSStringDrawingUsesFontLeading
                                                      context:drawContext];
    
    }

    self.result = resulAttrStr;
    self.rectForResultString = resRect;
    [self setNeedsDisplay];
 
}

-(NSAttributedString*) resizeAttrString:(NSAttributedString*)inputStr withHeight:(CGFloat)height;
{
    NSMutableAttributedString* resultString = [inputStr mutableCopy];
    
    //find the max height from inpiut string
    CGFloat waspointSize = 0;
    for(int i = 0; i < inputStr.length; i++){
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithAttributedString:[resultString attributedSubstringFromRange:NSMakeRange(i, 1)]];
        NSDictionary *attributes = [symbolString attributesAtIndex:0 effectiveRange:nil];
        UIFont *wasFont = [attributes valueForKey:NSFontAttributeName];
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

        [symbolString beginEditing];
        NSRange wholeRange = NSMakeRange(0, [symbolString length]);
        [symbolString addAttribute:NSFontAttributeName value:font range:wholeRange];
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
    [attrTextMutCopy beginEditing];
    NSRange wholeRange = NSMakeRange(0, [attrTextMutCopy  length]);
    [attrTextMutCopy  addAttribute:NSFontAttributeName value:[self setFontWithSize:size] range:wholeRange];
    [attrTextMutCopy endEditing];
    
    return [attrTextMutCopy copy];
}

#define DRAW LINE

//draw selector for gesture recognizer
-(void) drawLine:(UIPanGestureRecognizer*) sender
{

    if(sender.state == UIGestureRecognizerStateBegan){
        CAShapeLayer *line = [[CAShapeLayer alloc] init];
        line.fillColor = nil;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        if(self.isBluePanOrRed){
            line.opacity = .9;
            line.lineWidth = 4.5;
        } else {
            line.opacity = 0.5;
            line.lineWidth = self.redLineSize;
        }
        
        self.line = line;
        [self.paintedView.layer addSublayer:line];
        
        CGPoint currentPoint = [sender locationInView:self.paintedView];
        
        NSMutableArray *mutArr = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint: currentPoint]];
        self.patchPoints = [mutArr copy];
        
        self.origin = currentPoint;
        
        //set mark for cleaner
        self.isDurty = YES;
    } else if(sender.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [sender translationInView:self.paintedView];
        //draw line
        CGPoint currentPoint = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        NSMutableArray *mutArr = [self.patchPoints mutableCopy];
        [mutArr addObject:[NSValue valueWithCGPoint:currentPoint]];
        self.patchPoints = [mutArr copy];
        
        [sender setTranslation:CGPointZero inView:self];
        [self draw];
        self.origin = currentPoint;

    } else if (sender.state == UIGestureRecognizerStateEnded){
        //add next
        NSArray *generalizedPoints = [self douglasPeucker:self.patchPoints epsilon:2];
        NSArray *splinePoints = [self catmullRomSpline:generalizedPoints segments:4];
        [self drawPathWithPoints:splinePoints];
        //to here
    }
    
}
- (void)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    linePath.flatness = 3.0;
    
    [linePath moveToPoint:fromPoint];
    [linePath addLineToPoint:toPoint];
    
    UIColor *color;
    if(self.isBluePanOrRed){
        color = [UIColor colorWithRed:0.26 green:0.57 blue:0.7 alpha:0.9];
    } else {
        color = [UIColor colorWithRed:0.55 green:0.1 blue:0.2 alpha:0.5];
    }
    
    self.line.path=linePath.CGPath;
    self.line.strokeColor = color.CGColor;
    CGPathRetain(linePath.CGPath);
}

- (void)drawPathWithPoints:(NSArray *)points
{
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    linePath.flatness = 3.0;
    
    int count = [points count];
    CGPoint point = [[points objectAtIndex:0] CGPointValue];
    [linePath moveToPoint:point];
	//CGContextMoveToPoint(currentContext, point.x, point.y);
    for(int i = 1; i < count; i++) {
        point = [[points objectAtIndex:i] CGPointValue];
        [linePath addLineToPoint:point];
        
    }
    
    UIColor *color;
    if(self.isBluePanOrRed){
        color = [UIColor colorWithRed:0.26 green:0.57 blue:0.7 alpha:0.9];
    } else {
        color = [UIColor colorWithRed:0.55 green:0.1 blue:0.2 alpha:0.9];
    }
    
    self.line.path=linePath.CGPath;
    self.line.strokeColor = color.CGColor;
    CGPathRetain(linePath.CGPath);

}

- (NSArray *)douglasPeucker:(NSArray *)points epsilon:(float)epsilon
{
    int count = [points count];
    if(count < 3) {
        return points;
    }
    
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    for(int i = 1; i < count - 1; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGPoint lineA = [[points objectAtIndex:0] CGPointValue];
        CGPoint lineB = [[points objectAtIndex:count - 1] CGPointValue];
        float d = [self perpendicularDistance:point lineA:lineA lineB:lineB];
        if(d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    //If max distance is greater than epsilon, recursively simplify
    NSArray *resultList;
    if(dmax > epsilon) {
        NSArray *recResults1 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        
        NSArray *recResults2 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    } else {
        resultList = [NSArray arrayWithObjects:[points objectAtIndex:0], [points objectAtIndex:count - 1],nil];
    }
    
    return resultList;
}

- (float)perpendicularDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB
{
    CGPoint v1 = CGPointMake(lineB.x - lineA.x, lineB.y - lineA.y);
    CGPoint v2 = CGPointMake(point.x - lineA.x, point.y - lineA.y);
    float lenV1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    float lenV2 = sqrt(v2.x * v2.x + v2.y * v2.y);
    float angle = acos((v1.x * v2.x + v1.y * v2.y) / (lenV1 * lenV2));
    return sin(angle) * lenV2;
}

- (NSArray *)catmullRomSpline:(NSArray *)points segments:(int)segments
{
    int count = [points count];
    if(count < 4) {
        return points;
    }
    
    float b[segments][4];
    {
        // precompute interpolation parameters
        float t = 0.0f;
        float dt = 1.0f/(float)segments;
        for (int i = 0; i < segments; i++, t+=dt) {
            float tt = t*t;
            float ttt = tt * t;
            b[i][0] = 0.5f * (-ttt + 2.0f*tt - t);
            b[i][1] = 0.5f * (3.0f*ttt -5.0f*tt +2.0f);
            b[i][2] = 0.5f * (-3.0f*ttt + 4.0f*tt + t);
            b[i][3] = 0.5f * (ttt - tt);
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    {
        int i = 0; // first control point
        [resultArray addObject:[points objectAtIndex:0]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = (b[j][0]+b[j][1])*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = (b[j][0]+b[j][1])*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    for (int i = 1; i < count-2; i++) {
        // the first interpolated point is always the original control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    {
        int i = count-2; // second to last control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + (b[j][2]+b[j][3])*pointIp1.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + (b[j][2]+b[j][3])*pointIp1.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    // the very last interpolated point is the last control point
    [resultArray addObject:[points objectAtIndex:(count - 1)]];
    
    return resultArray;
}


-(void) draw
{
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    linePath.flatness = 3.0;
    NSValue *value = [self.patchPoints objectAtIndex:0];
    [linePath moveToPoint: [value CGPointValue]];
    for(int i = 2; i < self.patchPoints.count; i+=2){
        NSValue *contrlValue = [self.patchPoints objectAtIndex:i-1];
        NSValue *endValue = [self.patchPoints objectAtIndex:i];
        
        [linePath addQuadCurveToPoint:[endValue CGPointValue] controlPoint:[contrlValue CGPointValue]];
    }
    
    
    UIColor *color;
    if(self.isBluePanOrRed){
        color = [UIColor colorWithRed:0.26 green:0.57 blue:0.7 alpha:0.9];
    } else {
        color = [UIColor colorWithRed:0.55 green:0.1 blue:0.2 alpha:0.9];
    }
    
    self.line.path=linePath.CGPath;
    self.line.strokeColor = color.CGColor;
    CGPathRetain(linePath.CGPath);
    
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
                         UIView *paintedView = [[UIView alloc] initWithFrame:self.bounds];
                         paintedView.backgroundColor = [UIColor clearColor];
                         [self addSubview:paintedView];
                         self.paintedView = paintedView;
                         self.isDurty = NO;
                     }];
    
}


-(void) setup
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperTexture.png"]];
    self.isDurty = NO;
    self.isBluePanOrRed = YES;
    

    UIView *paintedView = [[UIView alloc] initWithFrame:self.bounds];
    paintedView.backgroundColor = [UIColor clearColor];
    [self addSubview:paintedView];
    self.paintedView = paintedView;
    
}

-(void) drawText
{
    [self.count drawInRect:self.rectForCountedString];
    [self.result drawInRect:self.rectForResultString];
}


- (void)drawRect:(CGRect)rect
{
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
