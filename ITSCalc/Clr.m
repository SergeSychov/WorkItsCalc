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
    return [UIColor colorWithRed:.055 green:.388 blue:.533 alpha:1.];
}

+(UIColor*)paperButton{
    return [UIColor colorWithRed:0.355 green:0.363 blue:.333 alpha:1.];

}
+(UIColor*)paperDigits{
    return [UIColor colorWithRed:0.373 green:0.373 blue:.243 alpha:1.];

}
+(UIColor*)paperC{
    return [UIColor colorWithRed:.749 green:.431 blue:.075 alpha:1.];
}
+(UIColor*)paperDisplay{
    return [UIColor clearColor];
}


#pragma mark BLUE
+(UIColor*)blueDisplay{
    return [UIColor colorWithRed:.094 green:0.227 blue:.373 alpha:1.];
}

+(UIColor*)blueButton{
    return [UIColor colorWithRed:.333 green:0.518 blue:0.769 alpha:1];
}
+(UIColor*)blueDigits{
    return [UIColor colorWithRed:.478 green:0.639 blue:0.859 alpha:1];
}
+(UIColor*)blueC{
    return [UIColor colorWithRed:.824 green:0.776 blue:0.706 alpha:1];
}
+(UIColor*)blueGround{
    return [UIColor colorWithRed:.647 green:0.725 blue:0.824 alpha:1];
}


#pragma mark GREEN
+(UIColor*)greenDisplay{
    return [UIColor colorWithRed:.039 green:0.392 blue:.314 alpha:1.];
}

+(UIColor*)greenButton{
    return [UIColor colorWithRed:.478 green:0.812 blue:0.259 alpha:1];
}
+(UIColor*)greenDigits{
    return [UIColor colorWithRed:.592 green:0.89 blue:0.396 alpha:1];
}
+(UIColor*)greenC{
    return [UIColor colorWithRed:1. green:.627 blue:0.451 alpha:1];
}
+(UIColor*)greenGround{
    return [UIColor colorWithRed:.467 green:0.792 blue:0.718 alpha:1];
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

@end
