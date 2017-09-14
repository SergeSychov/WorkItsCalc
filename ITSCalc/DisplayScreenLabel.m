//
//  DisplayScreenLabel.m
//  ITSCalc
//
//  Created by Serge Sychov on 18.07.17.
//  Copyright © 2017 Sergey Sychov. All rights reserved.
//

#import "DisplayScreenLabel.h"

@interface DisplayScreenLabel()

@property (nonatomic) NSDictionary* attributes;

@end

@implementation DisplayScreenLabel
-(void) setDesignObj:(DesignObject *)designObj{
    _designObj = designObj;
    self.textColor =self.designObj.screenTextColor;

}


-(void) showString:(NSString *)str
{
    NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithString:str attributes:self.attributes];
    //all kernels to -2
    if([mutAttrString length] > 0){
        [mutAttrString addAttribute:NSKernAttributeName
                              value:@-2
                              range:NSMakeRange(0, mutAttrString.length -1)];
        [mutAttrString addAttribute:NSKernAttributeName
                              value:@5
                              range:NSMakeRange(mutAttrString.length -1, 1)];
    }
    
    //set need ker to "1" and others non numbers symbols
    NSString *point = [self point];
    NSArray* strArray = [[NSArray alloc] initWithObjects:point,@"1",@" ",@".",@",", nil];
    for(int i = 0; i < mutAttrString.length; i++){
        
        if([strArray containsObject:[mutAttrString.string substringWithRange:NSMakeRange(i, 1)]]){
            NSDictionary *attr = [mutAttrString attributesAtIndex:i effectiveRange:nil];
            NSNumber * kernel  = [attr objectForKey:NSKernAttributeName];
            if(kernel){
                int intKern = [kernel intValue] - 4;
                [mutAttrString addAttribute:NSKernAttributeName
                                      value:[NSNumber numberWithInt:intKern]
                                      range:NSMakeRange(i,1)];
                
            }
            if(i > 0){
                attr = [mutAttrString attributesAtIndex:i-1 effectiveRange:nil];
                kernel  = [attr objectForKey:NSKernAttributeName];
                if(kernel){
                    int intKern = [kernel intValue] - 2;
                    [mutAttrString addAttribute:NSKernAttributeName
                                          value:[NSNumber numberWithInt:intKern]
                                          range:NSMakeRange(i -1,1)];
                    
                }
            }
        }
    }
    //NSLog(@"DisplayScreenLabel atribut: %@",[mutAttrString attributesAtIndex:0 effectiveRange:NULL]);

    self.attributedText = [mutAttrString copy];
}

#pragma mark HELPED FUNCTIONS______________________
//return point according localisation
-(NSString *) point
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* anyFloatNumberString = [numberFormatter stringFromNumber:@1.1];
    
    return [anyFloatNumberString substringWithRange:NSMakeRange(1, 1)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
