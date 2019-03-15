//
//  AddViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 11.05.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "AddViewController.h"
#import "DesignView.h"
#import "NewButtonsCollectionViewCell.h"

#define DESIGN @"design"
#define KEYBOARD @"keyboard"
#define MORE @"more"

//#define DESIGN_NAME_ADDITION NSLocalizedStringFromTable(@"DESIGN_NAME_ADDITION",@"ACalcTryViewControllerTableAdd", @"choose design")
//#define KEYBOARD_NAME_ADDITION NSLocalizedStringFromTable(@"KEYBOARD_NAME_ADDITION",@"ACalcTryViewControllerTableAdd", @"change keyboard")
//#define DESIGN_DESCRIPTION NSLocalizedStringFromTable(@"DESIGN_DESCRIPTION",@"ACalcTryViewControllerTableAdd", @"chosee appropriate design stile. Set liked photo as background")
//#define KEYBOARD_CHANGE_DESCRIPTION NSLocalizedStringFromTable(@"KEYBOARD_CHANGE_DESCRIPTION",@"ACalcTryViewControllerTableAdd", @"Tap and hold keyboar to change. Move buttons. Delete not necessary buttons. Restore previously deleted buttons")
//#define MORE_NAME NSLocalizedStringFromTable(@"DESIGN_DESCRIPTION",@"ACalcTryViewControllerTableAdd", @"more")
//#define MORE_DESCRIPTION NSLocalizedStringFromTable(@"KEYBOARD_CHANGE_DESCRIPTION",@"ACalcTryViewControllerTableAdd", @"to be continued")

//#define INDENT 20.0f

@interface AddViewController ()
@property (nonatomic,weak) UIColor* drawColor;
@property (nonatomic,weak) UIFont* font;

@property (nonatomic,weak) NSString* aim;

@property (nonatomic,weak) UILabel* nameAdditions;
@property (nonatomic,weak) NSString* stringNameAddition;

@property (nonatomic,weak) id viewAdditions;

@property (nonatomic,weak) UILabel* additionDescription;
@property (nonatomic, weak)NSString* stringDescriptions;


@end



@implementation AddViewController

-(id) initWithIndex:(NSUInteger)index
{
    self = [super init];
    if(self){
        self.index = index;
        self.drawColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:30];
    }
    return self;
}

-(void) setIndex:(NSUInteger)index
{
    _index = index;
    if(index == 0){
        _aim = DESIGN;
        _stringNameAddition = DESIGN_NAME_ADDITION;
        _stringNameAddition = DESIGN_DESCRIPTION;
    } else if (index == 1){
        _aim = KEYBOARD;
        _stringNameAddition = KEYBOARD_NAME_ADDITION;
        _stringNameAddition = KEYBOARD_CHANGE_DESCRIPTION;
    }else {
        _aim = MORE;
        _stringNameAddition = MORE_NAME;
        _stringNameAddition = MORE_DESCRIPTION;
    }
    
}

-(void) viewDidLayoutSubviews
{
    //thre ellements take firsts three parts from four
    CGFloat part = (self.view.frame.size.height - 2*INDENT)/4;
    CGFloat width = self.view.frame.size.width - 2*INDENT;
    [self.nameAdditions setFrame:CGRectMake(INDENT, INDENT, width, part)];
    
    CGFloat viewWidth = part;
     if([self.aim isEqualToString:KEYBOARD]){
        viewWidth = part*1.63;
    }
    [self.viewAdditions setFrame:CGRectMake(INDENT, INDENT+part, viewWidth, part)];
    [self.additionDescription setFrame:CGRectMake(INDENT, INDENT+2*part, width, part)];

}

-(void)setNeedViews
{
    
    UILabel *nameAddition = [[UILabel alloc] init];
    nameAddition.text = self.stringNameAddition;
    nameAddition.textAlignment = NSTextAlignmentCenter;
    nameAddition.textColor = self.drawColor;
    [nameAddition setBackgroundColor:[UIColor clearColor]];
    nameAddition.font = self.font;
    nameAddition.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    nameAddition.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:nameAddition];
    _nameAdditions = nameAddition;
    
    UILabel *additionDescription = [[UILabel alloc] init];
    additionDescription.text = self.stringNameAddition;
    additionDescription.textAlignment = NSTextAlignmentCenter;
    additionDescription.textColor = self.drawColor;
    [additionDescription setBackgroundColor:[UIColor clearColor]];
    additionDescription.font = self.font;
    additionDescription.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    additionDescription.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:additionDescription];
    _additionDescription = additionDescription;
    
    UIView *viewAdditions = [[UIView alloc] init];
    [viewAdditions setBackgroundColor:[UIColor clearColor]];
    if([self.aim isEqualToString:DESIGN]){
        DesignView *designView = [[DesignView alloc] init];
        [designView setContentMode:UIViewContentModeRedraw];
        designView.storkeColor = self.drawColor;
        [viewAdditions addSubview:designView];
        
    } else if ([self.aim isEqualToString:KEYBOARD]){
        NewButtonsCollectionViewCell *buttonView = [[NewButtonsCollectionViewCell alloc] init];
        [buttonView setContentMode:UIViewContentModeRedraw];
        buttonView.drawColor = self.drawColor;
        buttonView.name = @"x+y";
        [viewAdditions addSubview:buttonView];
    }else {
        
    }
    [self.view addSubview:viewAdditions];
    _viewAdditions = viewAdditions;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedViews];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
