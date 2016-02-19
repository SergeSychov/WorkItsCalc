//
//  NewButtonsCollectionViewCell.m
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "NewButtonsCollectionViewCell.h"
#import "cmyk.h"


#define ANGLE_OFFSET (M_PI_4 * 0.1f)
#define X_OFFSET 2.0f
#define Y_OFFSET 2.0f
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

//define design numbers
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

@interface NewButtonsCollectionViewCell() 
@property (nonatomic) CGFloat incr; //parameter to set increesing by touch
@property (nonatomic) struct Color buttonColor;
@property (nonatomic) CGRect rectArchive;
@property (nonatomic,weak) UIView *paperFillView;

@end

@implementation NewButtonsCollectionViewCell

-(void)setDesign:(NSInteger)design
{
    _design = design;
    self.cellSubView.design = design;
}
/*
-(NSInteger)design {
    if((self.design != DESIGN_CLASSIC) &&
       (self.design != DESIGN_PAPER)&&
       (self.design != DESIGN_COLOR_BLUE) &&
       (self.design != DESIGN_COLOR_GREEN) &&
       (self.design != DESIGN_COLOR_PINK) &&
       (self.design != DESIGN_COLOR_YELOW) &&
       (self.design != DESIGN_COLOR_GRAY) &&
       (self.design != DESIGN_PHOTO )){
        _design = DESIGN_CLASSIC;
    }
    
    return _design;
}
*/
-(void) setName:(NSString *)name
{
    
    if(![_name isEqualToString:name]){
        _name = name;
        //to hide messy buttons
        if([name isEqualToString:@"NO"]){
            self.cellSubView.alpha = 0.00;
        }

        [self refreshButtonView];
    }
}

    
-(void)refreshButtonView
{
        self.cellSubView.title = self.name;
       
        
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self myTouchBegan];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self myTouchEnded];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self myTouchEnded];
}

-(void) myTouchBegan
{
    if(!self.isUnderChanging){
        self.rectArchive = self.frame;
        if(self.design == DESIGN_PAPER){
            CGFloat radiusCorner;
            if(IS_IPAD){
               radiusCorner = (self.frame.size.height-4)/ 3.;

            } else {
                radiusCorner = (self.frame.size.height-4)/ 3.2;
            }
            
            CGFloat borderWidth = radiusCorner / 8.2;
            CGFloat x = borderWidth /2+0.5;
            CGFloat y = borderWidth /2;
            CGRect rct = CGRectInset(self.frame,2,2);
            rct.origin = CGPointMake(x, y);
            
            UIView *paperFillView = [[UIView alloc] initWithFrame:rct];
            paperFillView.layer.cornerRadius = radiusCorner;
            paperFillView.backgroundColor = self.cellSubView.buttonColor;
            paperFillView.alpha = 0;
            [self addSubview:paperFillView];
            self.paperFillView = paperFillView;
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.paperFillView.alpha = .8;
                             } completion:^(BOOL finished) {
                                 
                             }];
            
        } else {
        [UIView animateWithDuration:0.15
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{

                             [self setFrame:[self getRect]];
                         } completion:nil];
        }
        self.cellSubView.isTaped = YES;
    } else {

        self.cellSubView.isTaped = YES;
        
    }
}

-(void) myTouchEnded
{
    if(!self.isUnderChanging){

        if(self.design == DESIGN_PAPER){

            [UIView animateWithDuration:0.8
                                  delay:0.0
                                options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.paperFillView.alpha = .0;
                             } completion:^(BOOL finished) {
                                 [self.paperFillView removeFromSuperview];
                             }];

        } else {
        [UIView animateWithDuration:0.15
                              delay:0
             usingSpringWithDamping:.5
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                            // self.cellSubView.frame = self.rectArchive;
                             self.frame = self.rectArchive;
                         } completion:nil];
        }
        self.cellSubView.isTaped = NO;
    } else {
       // self.cellSubView.frame = self.rectArchive;
        //self.frame = self.rectArchive;
        //[self.cellSubView setFrame:CGRectMake(0, 0, self.bounds.size.width -4, self.bounds.size.height - 4)];
        self.cellSubView.isTaped = NO;
        if([self.cellSubView.title isEqualToString:@"M-"]) NSLog(@"REct %f", self.frame.size.height);
    }
}


//setting of enabling of close button and ist image
-(void) setIsEnable:(BOOL)isEnable{
    if(_isEnable != isEnable){
        _isEnable = isEnable;
        if(isEnable){
            self.closeAndSetButton.isClose = YES;
            //[self.closeAndSetButton setImage:[UIImage imageNamed:@"close_3.png"] forState:UIControlStateNormal];

        } else {
            self.closeAndSetButton.isClose = NO;
           // [self.closeAndSetButton setImage:[UIImage imageNamed:@"check_3.png"] forState:UIControlStateNormal];

        }
    }
}

-(void)setIsAllovedToDelete:(BOOL)isAllovedToDelete
{
   // if(_isAllovedToDelete != isAllovedToDelete){
        _isAllovedToDelete = isAllovedToDelete;
        if((self.isChangeble)&&(self.isUnderChanging)&&(isAllovedToDelete)){
            self.closeAndSetButton.hidden = NO;

        } else {
            self.closeAndSetButton.hidden = YES;
        }
    //}
}

-(void) setIsChangeble:(BOOL)isChangeble
{
    _isChangeble = isChangeble;
}
-(void)setIsUnderChanging:(BOOL)is
{
    _isUnderChanging = is;
    //self.cellButton.isButtonUnderChanging = is;
    
    if(self.isChangeble && self.isEnable){
        if((![self isShakeAnimationRunning])&&(is)){
            [self startShakeAnimation];
        } else if (!is){
            [self stopShakeanimation];
        }
    }
    if((self.isChangeble)&&(is)&&(self.isAllovedToDelete) && (self.isEnable)){
        self.closeAndSetButton.hidden = NO;
    } else {
        self.closeAndSetButton.hidden = YES;
    }
}
//shake animation functions
-(BOOL) isShakeAnimationRunning
{
    return  [self.layer animationForKey:@"transform.rotation"] != nil;
}

-(void) startShakeAnimation
{
   // self.closeAndSetButton.hidden = NO;
    
    self.transform = CGAffineTransformMakeRotation(0.0);
    self.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    
    CFTimeInterval offset = (double) arc4random()/(double)RAND_MAX;
    self.transform = CGAffineTransformTranslate(self.transform, - X_OFFSET * 0.5, - Y_OFFSET *0.5);
    self.transform = CGAffineTransformRotate(self.transform, - ANGLE_OFFSET *0.5);
    //x shake
    CABasicAnimation* xAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    xAnim.byValue = [NSNumber numberWithFloat:(X_OFFSET)];
    xAnim.duration = 0.09;
    xAnim.repeatCount = HUGE_VAL;
    xAnim.autoreverses = YES;
    xAnim.timeOffset = offset;
    [self.layer addAnimation:xAnim forKey:@"position.x"];
    //y shake
    CABasicAnimation* yAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
    yAnim.byValue = [NSNumber numberWithFloat:(Y_OFFSET)];
    yAnim.duration = 0.11;
    yAnim.repeatCount = HUGE_VAL;
    yAnim.autoreverses = YES;
    yAnim.timeOffset = offset;
    [self.layer addAnimation:yAnim forKey:@"position.y"];
    //rotation
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animation setDuration:0.15];
    [animation setRepeatCount:HUGE_VAL];
    [animation setAutoreverses:YES];
    animation.timeOffset = offset;
    animation.byValue = [NSNumber numberWithFloat:ANGLE_OFFSET];
    [self.layer addAnimation:animation forKey:@"transform.rotation"];
}

-(void) stopShakeanimation
{
    [self.layer removeAnimationForKey:@"position.y"];
    [self.layer removeAnimationForKey:@"position.x"];
    [self.layer removeAnimationForKey:@"transform.rotation"];
    self.transform = CGAffineTransformMakeRotation(0.0);
    self.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
   // self.closeAndSetButton.hidden = YES;
    
}

//-------------------------------------------------------------------------------------------------

-(CGRect) getRect{
    CGFloat collectionInsect;

    if(IS_IPAD) {

        if(self.isIpadPortraitView){
            collectionInsect = 118;
        } else {
            collectionInsect = 108;
        }
    } else {

        if(IS_568_SCREEN){
            collectionInsect = 72;
        } else {
            collectionInsect= 65;
        }
    }
    [self.superview bringSubviewToFront:self]; //set cell on the top of collectionView
   // CGPoint originInwindow = [self convertPoint:CGPointZero toView:self.window];
    
    CGFloat subX = self.frame.origin.x - (self.incr -1)*self.frame.size.width /2;
    CGFloat subY = self.frame.origin.y - (self.incr -1)*self.frame.size.height /2;
    CGFloat subWidth = self.frame.size.width * self.incr;
    CGFloat subHeight = self.frame.size.height * self.incr;
    
    //CGFloat collect = self.collectionViewOffset.y;
    CGFloat collectionYOffset = [self.delegate buttonCollectionOffset];
    

    if(subX < 0){
        subX = 0;
    }
    if((subX+subWidth) > self.superview.bounds.size.width){
        subX = self.superview.bounds.size.width - subWidth;
    }
    
    if((subY - collectionInsect - collectionYOffset) < 0){
        subY = collectionInsect + collectionYOffset;
    }
    
    if((subY+subHeight - collectionYOffset) > self.superview.bounds.size.height){
        subY = self.superview.bounds.size.height - subHeight + collectionYOffset;
    }
    
    return  CGRectMake(subX, subY, subWidth, subHeight);
}

-(void) setup
{
    self.clipsToBounds = NO;
    if(IS_IPAD){
        self.incr = 1.8;
    } else {
        self.incr = 2.1;
    }
    self.closeAndSetButton.hidden = YES;
    self.isEnable = YES;
    self.isAllovedToDelete = self.isEnable; //to set alloved to delete according quantity of buttons in view
    [self.cellSubView setFrame:CGRectMake(0, 0, self.bounds.size.width -4, self.bounds.size.height - 4)];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   // [self.cellSubView setFrame:CGRectMake(0, 0, rect.size.width -4, rect.size.height - 4)];
    [self.cellSubView setFrame:rect];
    CGFloat closeCheckWidth;
    if(IS_IPAD) {
        closeCheckWidth = 36.;
    } else {
        closeCheckWidth = 28.;

    }
    [self.closeAndSetButton setFrame:CGRectMake(rect.size.width-closeCheckWidth*2/3-4,
                                                -closeCheckWidth/3-4,
                                                closeCheckWidth, closeCheckWidth)];
    // Drawing code
}




@end
