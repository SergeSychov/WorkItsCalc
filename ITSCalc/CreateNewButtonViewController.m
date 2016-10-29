//
//  CreateNewButtonViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.02.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import "CreateNewButtonViewController.h"
#import "newButtonView.h"
#import "ACalcBrain.h" //for check programm


@interface CreateNewButtonViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet newButtonView *buttonView;
@property (weak, nonatomic) IBOutlet UITextField *textFildForNewButton;
@property (weak, nonatomic) IBOutlet UILabel *labelProgrammDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelActionName;


//attributes for program description
@property (nonatomic,strong) NSDictionary * attributes;


@end

@implementation CreateNewButtonViewController
#pragma mark ATTRIBUTES
/*
-(NSDictionary*) attributes
{
    if(!_attributes){
        
        UIColor *textColor = [UIColor whiteColor];

        //change font size
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        
        //Change fontName to Helvetica Neue Light
        NSString *fontName = nil;
        NSArray *famalyNames  =[UIFont familyNames];
        if([famalyNames containsObject:@"Helvetica Neue"]){
            NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
            if([fontNames containsObject:@"HelveticaNeue-Light"]){
                fontName = @"HelveticaNeue-Light";
            }
        }
        CGFloat fontSize;// = 17.0;
        
        
        if(IS_IPAD){
            fontSize = 26.0;
            style.alignment = NSTextAlignmentRight;
        } else {
            fontSize = 17.0;
            style.alignment = NSTextAlignmentLeft;
        }
        UIFont *system = [UIFont systemFontOfSize:fontSize];
        UIFont *font; //if there is no needed font
        if(fontName){
            font = [UIFont fontWithName:system.fontName size:fontSize];
        }else {
            font =[UIFont boldSystemFontOfSize:fontSize];
        }
        
        _attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[style copy], NSParagraphStyleAttributeName,textColor, NSForegroundColorAttributeName, font, NSFontAttributeName , nil];
    }
    return _attributes;
}
*/
static NSString *funAddition; //means "(x,Y)"

#pragma HELP FUNCTION
-(NSString*) createStringAdditionFromProgram:(NSArray*)prog
{
    NSString *str = @"(";
    
    //may be it'll be usefull
     NSSet *variables = [ACalcBrain chekForVariablesInProgramm:prog];
    if([variables count]){
        if([variables containsObject:@"x"]) str = [str stringByAppendingString:@"x,"];
        if ([variables containsObject:@"y"]) str = [str stringByAppendingString:@"y,"];
    }
    
    if( [ACalcBrain chekForCurrensiesProgramm:prog]){
        str = [str stringByAppendingString:@"$"];
    } else {
        str = [str substringToIndex:[str length]-1];
    }
    
    str = [str stringByAppendingString:@")"];


    return str;
}

#pragma mark SETUP
-(void) viewDidLoad{
    [super viewDidLoad];
    self.textFildForNewButton.delegate = self;
    
    funAddition =@"";//initial value of additional for new button name
    
    //self.buttonView.title = @"";
    if(_programDescription){
        self.labelProgrammDescription.attributedText = _programDescription;
    }
    if(_program){
        if([_program isKindOfClass:[NSNumber class]]){
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setExponentSymbol:@"e"];
            if (fabs([_program doubleValue])>9e9 || fabs([_program doubleValue])<9e-9) {
                [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
                [numberFormatter setMaximumFractionDigits:7];
            }
            else{
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                double intPartLenght = log10(fabs([_program doubleValue]));
                double  intPart;//fractPart,
                modf(intPartLenght, &intPart);//fractPart =
                if(intPart <0) intPart = 0;
                [numberFormatter setMaximumFractionDigits:(9 - (int)intPart)];
            }
            self.labelProgrammDescription.text = [numberFormatter stringFromNumber:_program];
            
            self.buttonView.title = [self.delegate getPossibleButtonNameWithInitial:@"k"];
           
            
            self.labelActionName.text = @"создание новой кнопки для константы:";
            
           
        } else if ([_program isKindOfClass:[NSArray class]]){
            //if it is grad
            if([_program containsObject:@"°"]){
                //if there is grad array as programm
                self.labelActionName.text = @"создание новой кнопки для константы:";
                self.buttonView.attrbutedTitle = _programDescription;


            } else {
                id firstObjFromProg = [_program firstObject];
                NSString *newButtonProName = [self.delegate getPossibleButtonNameWithInitial:@"f"];
                
                if([firstObjFromProg isKindOfClass:[NSArray class]]){
                    
                    funAddition = [self createStringAdditionFromProgram:_program];
                    
                    newButtonProName = [newButtonProName stringByAppendingString:funAddition];
                }
                //NSLog(@"Create new button _programDescription %@", _programDescription);
                self.labelActionName.text = @"создание новой кнопки для выражения:";
                self.buttonView.title =newButtonProName;
            }
        }
    }
    self.buttonView.buttonColor = [UIColor whiteColor];
    
    self.textFildForNewButton.textColor  =[UIColor whiteColor];
    self.textFildForNewButton.tintColor = [UIColor whiteColor];
    UIColor *placeHolderColor = [UIColor lightTextColor];
    self.textFildForNewButton.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Введите другое имя новой кнопки" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    [self.textFildForNewButton becomeFirstResponder];

}



#pragma mark ACTIONS

- (IBAction)cancellButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
- (IBAction)okButtonTapped:(UIButton *)sender {
    [self createButton];
    /*
    CGPoint offsetPoint = CGPointMake(0, self.mainController.buttonsCollection.contentSize.height - self.mainController.buttonsCollection.bounds.size.height+50.);
    [self.mainController.buttonsCollection setContentOffset:offsetPoint];
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.program isKindOfClass:[NSNumber class]]){
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        } else {
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        }

    }];
    */
}

-(void) createButton{
    CGPoint offsetPoint = CGPointMake(0, self.mainController.buttonsCollection.contentSize.height - self.mainController.buttonsCollection.bounds.size.height+50.);
    [self.mainController.buttonsCollection setContentOffset:offsetPoint];
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.program isKindOfClass:[NSNumber class]]){
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        } else {
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        }
        
    }];
}

#pragma mark TEXT FILD DELEGATE
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@"\n"]){
        NSLog(@"Enter press");
    
    } else {
        NSString *finStr = textField.text;
        finStr = [finStr stringByReplacingCharactersInRange:range withString:string];
        finStr = [self.delegate getPossibleButtonNameWithInitial:finStr];
        NSLog(@"finStr %@",finStr);
        
        self.buttonView.title =[finStr stringByAppendingString:funAddition];
        self.buttonView.buttonColor = [UIColor whiteColor];
        [self.buttonView setNeedsDisplay];
        
        
    }
    return YES;
}


@end
