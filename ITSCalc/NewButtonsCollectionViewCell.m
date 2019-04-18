//
//  NewButtonsCollectionViewCell.m
//  ACalcTry
//
//  Created by Serge Sychov on 01.08.13.
//  Copyright (c) 2013 Sergey Sychov. All rights reserved.
//

#import "NewButtonsCollectionViewCell.h"
#import "cmyk.h"
#import "DesignObject.h"//for definitions

//#define DEBUG_MODE NO

#define ANGLE_OFFSET (M_PI_4 * 0.1f)
#define X_OFFSET 2.0f
#define Y_OFFSET 2.0f
#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)


//define type of buttons
#define MAIN_BUTTON 1
#define CHANGE_BUTTON 2
#define CHANGE_BUTTON_NOT_DELETABLE 3
#define DELETED_BUTTON 4
#define DELETED_USER_BUTTON 5

@interface NewButtonsCollectionViewCell() 
@property (nonatomic) CGFloat incr; //parameter to set increesing by touch
@property (nonatomic) struct Color buttonColor;
@property (nonatomic) CGRect rectArchive;
//@property (nonatomic,weak) UIView *paperFillView;

@end

@implementation NewButtonsCollectionViewCell
-(void)setDesignObj:(DesignObject *)designObj{
    _designObj = designObj;
    self.cellSubView.designObj = designObj;
}

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

NSDate *methodStart;

//static UIView *paperFillView;

-(void) myTouchBegan
{
    methodStart = [NSDate date];
    if(!self.isUnderChanging){
        self.rectArchive = self.frame;
        if(self.designObj.designNumber == DESIGN_PAPER){
            /*CGFloat radiusCorner;
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
            
            if(paperFillView){
                paperFillView = nil;
            }
            
            paperFillView = [[UIView alloc] initWithFrame:rct];
            paperFillView.layer.cornerRadius = radiusCorner;
            paperFillView.backgroundColor = self.cellSubView.buttonColor;
            paperFillView.alpha = 0;
            [self addSubview:paperFillView];*/
            CGColorRef color = [self.cellSubView.buttonColor CGColor];
            
            NSInteger numComponents = CGColorGetNumberOfComponents(color);
            CGFloat red;// = components[0];
            CGFloat green;// = components[1];
            CGFloat blue;// = components[2];
            CGFloat alpha;//
            
            if (numComponents == 4)
            {
                const CGFloat *components = CGColorGetComponents(color);
                red = components[0];
                green = components[1];
                blue = components[2];
                alpha = components[3];
            }
            
            //paperFillView.backgroundColor = self.cellSubView.buttonColor;
           // self.backgroundColor = [UIColor colo]
            
            [UIView animateWithDuration:.2
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.layer.backgroundColor = [self.cellSubView.buttonColor CGColor];
                                // paperFillView.alpha = .8;
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

        if(self.designObj.designNumber == DESIGN_PAPER){
            
            [UIView animateWithDuration:0.6
                                  delay:0.0
                 usingSpringWithDamping:1.
                  initialSpringVelocity:0.0
                                options:  UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.layer.backgroundColor = [[UIColor clearColor] CGColor];
                             } completion:^(BOOL finished) {

                             }];

        } else {
        [UIView animateWithDuration:0.15
                              delay:0
             usingSpringWithDamping:.5
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.frame = self.rectArchive;
                         } completion:nil];
        }
        self.cellSubView.isTaped = NO;
    } else {
       // self.cellSubView.frame = self.rectArchive;
        //self.frame = self.rectArchive;
        //[self.cellSubView setFrame:CGRectMake(0, 0, self.bounds.size.width -4, self.bounds.size.height - 4)];
        self.cellSubView.isTaped = NO;
    }
}
-(void)setTypeOfButton:(NSInteger)typeOfButton{
    
    _typeOfButton = typeOfButton;
    
    switch (typeOfButton) {
        case MAIN_BUTTON:
            [self stopShakeanimation];
            [self removeCheckButtons];
            [self removeRemButton];
            break;
            
        case CHANGE_BUTTON:
            [self showCheckButtons];
            [self removeRemButton];
            [self startShakeAnimation];
            break;
            
        case CHANGE_BUTTON_NOT_DELETABLE:
            [self removeCheckButtons];
            [self removeRemButton];
            [self startShakeAnimation];
            break;
            
        case DELETED_BUTTON:
            [self animateAppearanceForDeletedButtons];
            [self showCheckButtons];
            [self removeRemButton];
            [self stopShakeanimation];
            break;
            
        case DELETED_USER_BUTTON:
            [self animateAppearanceForDeletedButtons];
            [self showCheckButtons];
            [self showRemoveButton];
            [self stopShakeanimation];
            break;
            
        default:
            [self stopShakeanimation];
            [self removeCheckButtons];
            [self removeRemButton];
            break;
    }
}


-(void)setIsUnderChanging:(BOOL)is
{

        _isUnderChanging = is;
    if(!_isUnderChanging){
        //_typeOfButton = MAIN_BUTTON;
        [self stopShakeanimation];
        [self removeCheckButtons];
        if(self.typeOfButton == DELETED_BUTTON || self.typeOfButton == DELETED_USER_BUTTON){
            [self animateDisapearenceForDeletedButtons];
        }
        //if(paperFillView){
        //    paperFillView = nil;
        //}
    }

}

// button action delegate
- (void)tapRemoveItsButton:(UIButton *)sender{
    [self.actionDelegate tapRemoveItsButton:sender];
}
-(void)tapCloseCheckButton:(UIButton *)sender{
    [self.actionDelegate tapCloseCheckButton:sender];
}
-(void) showCheckButtons {
    
        CGFloat closeCheckWidth;
        if(IS_IPAD) {
            closeCheckWidth = 36.*1.5;
        } else {
            closeCheckWidth = 28.*1.5;
            
        }
        CGRect frameStartCloseButton = CGRectMake(self.bounds.size.width-closeCheckWidth*2/3+closeCheckWidth/2-4,
                                             -closeCheckWidth/3-4+closeCheckWidth/2,
                                             0, 0);
        CGRect frameCloseButton = CGRectMake(self.bounds.size.width-closeCheckWidth*2/3-4,
                                             -closeCheckWidth/3-4,
                                             closeCheckWidth, closeCheckWidth);


        if(self.typeOfButton == CHANGE_BUTTON){
            if(!self.closeAndSetButton){
                CloseSetButton* closeAndSetButton = [[CloseSetButton alloc]initWithFrame:frameStartCloseButton];
                [self addSubview:closeAndSetButton];
                self.closeAndSetButton = closeAndSetButton;
                [self.closeAndSetButton addTarget:self action:@selector(tapCloseCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.closeAndSetButton setFrame:frameStartCloseButton];
            }
            self.closeAndSetButton.isClose = YES;
            
            
        
        } else if(self.typeOfButton == DELETED_BUTTON || self.typeOfButton == DELETED_USER_BUTTON){
            if(!self.closeAndSetButton){
                CloseSetButton* closeAndSetButton = [[CloseSetButton alloc]initWithFrame:frameStartCloseButton];
                [self addSubview:closeAndSetButton];
                self.closeAndSetButton = closeAndSetButton;
                [self.closeAndSetButton addTarget:self action:@selector(tapCloseCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.closeAndSetButton setFrame:frameStartCloseButton];
            }
            self.closeAndSetButton.isClose = NO;
            
        }

        //animation
        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:0
                         animations:^{
                            [self.closeAndSetButton setFrame:frameCloseButton];
                         } completion:^(BOOL finished) {
                             nil;
                         }];
    
}

-(void) showRemoveButton{
    CGFloat closeCheckWidth;
    if(IS_IPAD) {
        closeCheckWidth = 36.;
    } else {
        closeCheckWidth = 28.;
        
    }

    
    CGRect frameStartRemoveButton = CGRectMake(closeCheckWidth/2,
                                               -closeCheckWidth/3-4+closeCheckWidth/2,
                                               0, 0);
    
    CGRect frameRemoveButton = CGRectMake(0,
                                          -closeCheckWidth/3-4,
                                          closeCheckWidth, closeCheckWidth);
    
    
    if(self.typeOfButton == DELETED_USER_BUTTON){
        if(!self.removeButton){
            CloseSetButton* removeButton = [[CloseSetButton alloc]initWithFrame:frameStartRemoveButton];
            [self addSubview:removeButton];
            self.removeButton = removeButton;
            [self.removeButton addTarget:self action:@selector(tapRemoveItsButton:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.removeButton setFrame:frameStartRemoveButton];
        }
        self.removeButton.isRemoveButton = YES;
            
    }
    
    //animation
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         if(self.typeOfButton == DELETED_USER_BUTTON)[self.removeButton setFrame:frameRemoveButton];
                     } completion:^(BOOL finished) {
                         nil;
                     }];
}


-(void) removeCheckButtons {
    //if(self.typeOfButton != MAIN_BUTTON){
    CGFloat closeCheckWidth;
    if(IS_IPAD) {
        closeCheckWidth = 36.;
    } else {
        closeCheckWidth = 28.;
        
    }
    CGRect frameEndCloseButton = CGRectMake(self.bounds.size.width-closeCheckWidth*2/3+closeCheckWidth/2-4,
                                              -closeCheckWidth/3-4+closeCheckWidth/2,
                                              0, 0);
    //animation
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         if(self.closeAndSetButton)
                            [self.closeAndSetButton setFrame:frameEndCloseButton];
                         } completion:^(BOOL finished) {
                            if(self.closeAndSetButton){
                                 [self.closeAndSetButton removeFromSuperview];
                                 self.closeAndSetButton = nil;
                             }
                         }];
    
}

-(void)removeRemButton {
    //if(self.typeOfButton != MAIN_BUTTON){
    CGFloat closeCheckWidth;
    if(IS_IPAD) {
        closeCheckWidth = 36.;
    } else {
        closeCheckWidth = 28.;
        
    }

    CGRect frameEndRemoveButton = CGRectMake(self.bounds.size.width-closeCheckWidth*2/3+closeCheckWidth/2-4,
                                             -closeCheckWidth/3-4+closeCheckWidth/2,
                                             0, 0);
    //animation

    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         if(self.removeButton)
                             [self.removeButton setFrame:frameEndRemoveButton];
                     } completion:^(BOOL finished) {
                         if(self.removeButton){
                             [self.closeAndSetButton removeFromSuperview];
                             self.removeButton = nil;
                         }
                         
                     }];
}

//appearence animation of deleted buttons
-(void) animateAppearanceForDeletedButtons {
    self.alpha = 0;

    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         nil;
                     }];
}
-(void) animateDisapearenceForDeletedButtons{
    self.alpha = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         nil;
                     }];
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

    [self.superview bringSubviewToFront:self]; //set cell on the top of collectionView
    
    CGFloat subX = self.frame.origin.x - (self.incr -1)*self.frame.size.width /2;
    CGFloat subY = self.frame.origin.y - (self.incr -1)*self.frame.size.height /2;
    CGFloat subWidth = self.frame.size.width * self.incr;
    CGFloat subHeight = self.frame.size.height * self.incr;
    
    CGFloat collectionYOffset = [self.delegate buttonCollectionOffset];
    CGFloat collectionInsect = [self.delegate buttonCollectionInset];
    
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
    self.cellSubView.designObj = self.designObj;
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
    
    
    if([self.designObj.designString isEqualToString:DESIGN_COLOR_STR]){
        [self.imgGlossyView setImage:[UIImage imageNamed:@"Gloss.png"]];
    }else if([self.designObj.designString isEqualToString:DESIGN_MARTINI_STR]){
        [self.imgGlossyView setImage:[UIImage imageNamed:@"Pepsi1.png"]];
    }else if([self.designObj.designString isEqualToString:DESIGN_PAPER_STR]){
        self.layer.cornerRadius = IS_IPAD? (self.frame.size.height-4)/ 3.5:(self.frame.size.height-4)/ 3.3;;
        self.imgGlossyView.image = nil;
    }else{
        self.imgGlossyView.image = nil;
    }
    [self.cellSubView setFrame:rect];
    // Drawing code
}




@end
