//
//  Clr.m
//  ITSCalc
//
//  Created by Serge Sychov on 18.09.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "Clr.h"

@implementation Clr

#pragma mark BUTTONS COLOR
+(UIColor*)cButton{
    return [UIColor colorWithRed:1.
                           green:.686
                            blue:.337
                           alpha:1.];
}
+(UIColor*)equalButton{
    return [UIColor colorWithRed:.259
                           green:.569
                            blue:.702
                           alpha:1.];
}
+(UIColor*)digitsButton{
    return [UIColor colorWithRed:0.69 //64
                           green:0.69 //156
                            blue:.55 //204
                           alpha:1.];
}
+(UIColor*)button{
    return [UIColor colorWithRed:0.51 //64
                           green:0.52 //156
                            blue:.49 //204
                           alpha:1.];
}

#pragma mark PAPER
+(UIColor*)paperEqual{
    return [UIColor colorWithRed:.137 green:.553 blue:.984 alpha:1.];
    //return [UIColor colorWithRed:.031 green:.361 blue:.592 alpha:1.];
}

+(UIColor*)paperButton{
    return [UIColor colorWithRed:0.418 //64
                           green:0.410 //156
                            blue:0.398 //204
                           alpha:1.];

}
+(UIColor*)paperDigits{
    return [UIColor colorWithRed:0.31 green:0.33 blue:.38 alpha:1.];
}
+(UIColor*)paperC{
    return [UIColor colorWithRed:.745 green:.518 blue:.153 alpha:1.];
}
+(UIColor*)paperDisplay{
    return [UIColor clearColor];
}


#pragma mark BLUE
+(UIColor*)blueDisplay{
    return [UIColor colorWithRed:.282 green:0.09 blue:.380 alpha:1.];
}

+(UIColor*)blueButton{
    return [UIColor colorWithRed:.235 green:0.467 blue:0.043 alpha:1];
}
+(UIColor*)blueDigits{
    return [UIColor colorWithRed:.671 green:0.231 blue:0.588 alpha:1];
}
+(UIColor*)blueC{
    return [UIColor colorWithRed:.929 green:0.447 blue:0.200 alpha:1];
}

+(UIColor*)blueEqual{
    return [UIColor colorWithRed:.137 green:0.553 blue:0.984 alpha:1];
}

+(UIColor*)blueGround{
    return [UIColor colorWithRed:.933 green:0.937 blue:0.949 alpha:1];
}

+ (UIColor*)blueFirstGradient{
    return [UIColor colorWithRed:.933 green:0.937 blue:0.949 alpha:1];
}
+ (UIColor*)blueSecondGradient{
    return [UIColor colorWithRed:.812 green:0.867 blue:0.922 alpha:1];
}
+ (UIColor*)blueDelButton{
    return [UIColor colorWithRed:.569 green:0.106 blue:0.106 alpha:1];
}
+ (UIColor*)blueMoreButton{
    return [UIColor colorWithRed:.357 green:0.31 blue:0.23 alpha:1];
}
+(UIColor*)blueText {
    return [UIColor colorWithRed:0.027 green:0.149 blue:0.267 alpha:1.];
}

#pragma mark GREEN
+(UIColor*)greenDisplay{
    //return [UIColor colorWithRed:.027 green:0.161 blue:0.388 alpha:1];
    return [UIColor colorWithRed:.196 green:0.251 blue:0.459 alpha:1];

}

+(UIColor*)greenButton{
    //return [UIColor colorWithRed:.145 green:0.192 blue:0.329 alpha:1];
    return [UIColor colorWithRed:.318 green:0.227 blue:0.400 alpha:1];

}
+(UIColor*)greenDigits{
    //return [UIColor colorWithRed:.314 green:0.063 blue:0.082 alpha:1];
    return [UIColor colorWithRed:.431 green:0.106 blue:0.180 alpha:1];
}
+(UIColor*)greenC{
    return [UIColor colorWithRed:.706 green:.184 blue:0.145 alpha:1];
    //return [UIColor colorWithRed:.898 green:.247 blue:0.278 alpha:1];

}
+(UIColor*)greenEqual{
    return [UIColor colorWithRed:.071 green:.325 blue:0.592 alpha:1];
    //return [UIColor colorWithRed:.361 green:.812 blue:0.961 alpha:1];
}

+(UIColor*)greenGround{
    return [UIColor colorWithRed:.310 green:0.357 blue:0.541 alpha:1];
    //return [UIColor colorWithRed:.947 green:0.845 blue:0.700 alpha:1];
}


+ (UIColor*)greenText{
    return [UIColor colorWithRed:.976 green:0.976 blue:0.976 alpha:1];
    //return [UIColor colorWithRed:.141 green:0.094 blue:0.082 alpha:1];

}
+ (UIColor*)greenFirstGradient{
    return [UIColor colorWithRed:.310 green:0.357 blue:0.541 alpha:1];
    //return [UIColor colorWithRed:.947 green:0.845 blue:0.700 alpha:1];
}
+ (UIColor*)greenSecondGradient{
    return [UIColor colorWithRed:.663 green:0.894 blue:0.843 alpha:1];
    //return [UIColor colorWithRed:.847 green:0.745 blue:0.600 alpha:1];
}
+ (UIColor*)greenDelButton{
    return [UIColor colorWithRed:.569 green:0.059 blue:0.141 alpha:1];
}
+ (UIColor*)greenMoreButton{
    return [UIColor colorWithRed:.518 green:0.518 blue:0.588 alpha:1];
}

+ (UIColor*)greenStorkeAndScreenColor{
    return [UIColor colorWithRed:.822 green:0.844 blue:0.822 alpha:1];
}

#pragma mark YELLOW
+(UIColor*)yellowDisplay{
    return [UIColor colorWithRed:.04 green:0.15 blue:.34 alpha:1.];
}

+(UIColor*)yellowButton{
    return [UIColor colorWithRed:1. green:0.718 blue:0.18 alpha:1];
}
+(UIColor*)yellowDigits{
    return [UIColor colorWithRed:.996 green:0.816 blue:0.220 alpha:1];
}
+(UIColor*)yellowC{
    return [UIColor colorWithRed:.443 green:0.561 blue:0.812 alpha:1];
}
+(UIColor*)yellowGround{
    return [UIColor colorWithRed:.57 green:.64 blue:.78 alpha:1];
}
+ (UIColor*)yellowText{
    return [UIColor colorWithRed:.02 green:0.098 blue:0.24 alpha:1];
}
+ (UIColor*)yellowFirstGradient{
    return [UIColor colorWithRed:.91 green:0.93 blue:0.97 alpha:1];
}
+ (UIColor*)yellowSecondGradient{
    return [UIColor colorWithRed:.75 green:0.80 blue:0.89 alpha:1];
}
+ (UIColor*)yellowDelButton{
    return [UIColor colorWithRed:.569 green:0.106 blue:0.106 alpha:1];
}
+ (UIColor*)yellowMoreButton{
    return [UIColor colorWithRed:.518 green:0.518 blue:0.588 alpha:1];
}

#pragma mark PINK
+(UIColor*)pinkDisplay{
    return [UIColor colorWithRed:.424 green:0.122 blue:0.133 alpha:1];
}

+(UIColor*)pinkButton{
    return [UIColor colorWithRed:.82 green:0.42 blue:0.53 alpha:1];
}
+(UIColor*)pinkDigits{
    return [UIColor colorWithRed:.87 green:0.68 blue:0.67 alpha:1];
}
+(UIColor*)pinkC{
    return [UIColor colorWithRed:.65 green:0.36 blue:0.37 alpha:1];
}
+(UIColor*)pinkGround{
    return [UIColor colorWithRed:.65 green:0.65 blue:0.69 alpha:1];
}

+ (UIColor*)pinkText{
    return [UIColor colorWithRed:.29 green:0.043 blue:0.043 alpha:1];
}
+ (UIColor*)pinkFirstGradient{
    return [UIColor colorWithRed:.984 green:0.898 blue:0.922 alpha:1];
}
+ (UIColor*)pinkSecondGradient{
    return [UIColor colorWithRed:.957 green:0.765 blue:0.816 alpha:1];
}
+ (UIColor*)pinkDelButton{
    return [UIColor colorWithRed:.569 green:0.106 blue:0.106 alpha:1];
}
+ (UIColor*)pinkMoreButton{
    return [UIColor colorWithRed:.518 green:0.518 blue:0.588 alpha:1];
}

#pragma mark GRAY
+(UIColor*)grayDisplay{
    return [UIColor colorWithRed:.15 green:0.15 blue:.14 alpha:1.];
}

+(UIColor*)grayButton{
    return [UIColor colorWithRed:.50 green:0.52 blue:0.50 alpha:1];
}
+(UIColor*)grayDigits{
    return [UIColor colorWithRed:.70 green:0.72 blue:0.70 alpha:1];
}
+(UIColor*)grayC{
    return [UIColor colorWithRed:.757 green:0.682 blue:0.557 alpha:1];
}
+(UIColor*)grayGround{
    return [UIColor colorWithRed:.31 green:0.31 blue:0.29 alpha:1];
}
+ (UIColor*)grayText{
    return [UIColor colorWithRed:.06 green:0.06 blue:0.04 alpha:1];
}
+ (UIColor*)grayFirstGradient{
    return [UIColor colorWithRed:.94 green:0.95 blue:0.94 alpha:1];
}
+ (UIColor*)graySecondGradient{
    return [UIColor colorWithRed:.804 green:0.816 blue:0.804 alpha:1];
}
+ (UIColor*)grayDelButton{
    return [UIColor colorWithRed:1. green:0.231 blue:0.188 alpha:0.9];
}
+ (UIColor*)grayMoreButton{
    return [UIColor colorWithRed:0.68f green:0.68f blue:0.7f alpha:1.0f];
}

+ (UIColor*)photoFirstGradient{
    return [UIColor colorWithWhite:1 alpha:0.1];
}
+ (UIColor*)photoSecondGradient{
    return [UIColor colorWithWhite:1 alpha:0.2];
}
#pragma mark GRAY
@end
