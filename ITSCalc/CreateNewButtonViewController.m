//
//  CreateNewButtonViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 23.02.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

#import "CreateNewButtonViewController.h"
#import "newButtonView.h"


@interface CreateNewButtonViewController()
@property (weak, nonatomic) IBOutlet newButtonView *buttonView;
@property (weak, nonatomic) IBOutlet UITextField *textFildForNewButton;
@property (weak, nonatomic) IBOutlet UILabel *labelProgrammDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelActionName;


@end

@implementation CreateNewButtonViewController

#pragma mark SETUP
-(void) viewDidLoad{
    [super viewDidLoad];
    
    //self.buttonView.title = @"";
    if(_programDescription){
        self.labelProgrammDescription.text = _programDescription;
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
            NSLog(@"Create new button programm %@", _program);
            if([_program containsObject:@"°"]){
                //if there is grad array as programm
                self.labelActionName.text = @"создание новой кнопки для константы:";
                self.buttonView.title = _programDescription;


            } else {
                self.labelActionName.text = @"создание новой кнопки для выражения:";
                self.buttonView.title = @"New";
            }
        }
    }
    self.buttonView.buttonColor = [UIColor whiteColor];
    
    self.textFildForNewButton.textColor  =[UIColor whiteColor];
    self.textFildForNewButton.tintColor = [UIColor whiteColor];
    UIColor *placeHolderColor = [UIColor lightTextColor];
    self.textFildForNewButton.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Введите имя новой кнопки" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    [self.textFildForNewButton becomeFirstResponder];

}



#pragma mark ACTIONS
- (IBAction)cancellButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
- (IBAction)okButtonTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        if([self.program isKindOfClass:[NSNumber class]]){
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        } else {
            [self.delegate createNewButtonWith:self.buttonView.title andProgramm:self.program];
        }
    }];
}


@end
