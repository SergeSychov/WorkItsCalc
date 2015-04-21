//
//  LogoView.m
//  ITSCalc
//
//  Created by Serge Sychov on 08.04.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "LogoView.h"
#import "OnlyLogoView.h"

@interface LogoView ()

@property CAGradientLayer* gradient;
@property OnlyLogoView* logoview;

@end

@implementation LogoView


-(void) setup
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    UIColor *colorOne = [UIColor colorWithRed:0.25
                                        green:0.61
                                         blue:.80
                                        alpha:1.];
    
    UIColor *colorTwo = [UIColor colorWithRed:0.25
                                        green:0.61
                                         blue:0.8
                                        alpha:1.];
    
    gradient.colors = [NSArray arrayWithObjects:(id)[colorOne CGColor], (id)[colorTwo CGColor], nil];
    
    [self.layer insertSublayer:gradient atIndex:0];
    self.gradient = gradient;
    
     CGRect logoRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/3);
    OnlyLogoView *logoView = [[OnlyLogoView alloc] initWithFrame:logoRect];
    [logoView setBackgroundColor:[UIColor clearColor]];
    //[self addSubview:logoView];
    self.logoview = logoView;
    
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
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
- (void)drawRect:(CGRect)rect {
    self.gradient.frame = self.bounds;
    [self.gradient display];
    
     CGRect logoRect = CGRectMake(0, 0, rect.size.width, rect.size.height/3);
   
    [self.logoview setFrame:logoRect];
    // Drawing code
}


@end
