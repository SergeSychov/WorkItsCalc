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
    self.buttonView.buttonColor = [UIColor whiteColor];
    //self.buttonView.title = @"";
    if(_programDescription){
        self.labelProgrammDescription.text = _programDescription;
    }
    if(_program){
        if([[_program firstObject] isKindOfClass:[NSNumber class]]){
            self.labelActionName.text = @"создание новой кнопки для константы:";
        } else {
            self.labelActionName.text = @"создание новой кнопки для выражения:";
        }
    }

}



#pragma mark ACTIONS
- (IBAction)cancellButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
- (IBAction)okButtonTapped:(UIButton *)sender {
    [self.delegate createNewButtonWith:@"New" andProgramm:_program];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
