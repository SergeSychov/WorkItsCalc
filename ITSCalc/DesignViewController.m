//
//  DesignViewController.m
//  ITSCalc
//
//  Created by Serge Sychov on 13.07.15.
//  Copyright (c) 2015 Sergey Sychov. All rights reserved.
//

#import "DesignViewController.h"
#import "designButtonView.h"
#import "Transition.h"
#import "CalcButton.h"
#import "SettingButton.h"
#import "TestButtonBackGroundView.h"
#import "newButtonView.h"
#import "PlusButton.h"

NSString *const SendChangedNotification=@"SendChangedNotification";

#define IS_IPAD ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
#define INDENT 20.0f
//define design numbers
#define DESIGN_CLASSIC 1
#define DESIGN_PAPER 2
#define DESIGN_COLOR_BLUE 30
#define DESIGN_COLOR_GREEN 31
#define DESIGN_COLOR_PINK 32
#define DESIGN_COLOR_YELOW 33
#define DESIGN_COLOR_GRAY 34
#define DESIGN_PHOTO 4

@interface DesignViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>//need for choosingn new photo at design

@property (nonatomic,weak) CalcButton* calcButton;
@property (nonatomic,weak) SettingButton *settingButton;

@property (nonatomic,weak) UILabel* chooseDesignLabel;

@property (nonatomic,weak) UIView *classicPartView;
@property (nonatomic,weak) TestButtonBackGroundView *classicButton;
@property (nonatomic,weak) designButtonView *classicButtonView;

@property (nonatomic,weak) UIView *paperPartView;
@property (nonatomic,weak) TestButtonBackGroundView *paperButton;
@property (nonatomic,weak) designButtonView *paperButtonView;

@property (nonatomic,weak) UIView *colorPartView;
@property (nonatomic,weak) designButtonView *colorButtonView;
@property (nonatomic,weak) TestButtonBackGroundView *clolorBlueButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorPinkButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorGreenButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorYelowButton;
@property (nonatomic,weak) TestButtonBackGroundView *colorBlackButton;

@property (nonatomic,weak) UIImageView *photo;
@property (nonatomic,weak) UIView *photoPartView;
@property (nonatomic,weak) designButtonView *photoButtonView;
@property (nonatomic,weak) TestButtonBackGroundView *photButton;
@property (nonatomic,weak) PlusButton *addNewPhotoButton; //"+"

//necessary to add plus button


@end

@implementation DesignViewController

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark ROTATION
-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self willRotatetoSize:size];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark TAP ACTION SEND NOTIFICATION
-(void)calcButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate designViewControllerDidCloseWithString:@"TO CALC"];
    }];
}

-(void) settingButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.delegate designViewControllerDidCloseWithString:@"BACK"];

}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.photo setImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
    UIImage *imageFromLibrary = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *newImageData = UIImagePNGRepresentation(imageFromLibrary);
    
    //save image
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documentName = @"PhotoPicture";//@"MyDocument.sqlite"
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        if([fileManager isDeletableFileAtPath:[storeURL path]]){
            NSError *error;
            BOOL delSucces = [fileManager removeItemAtPath:[storeURL path] error:&error];
            if(delSucces){
                NSLog(@"File exist and deleted");
                if([newImageData writeToURL:storeURL atomically:YES]){
                    NSLog(@"File replace succesefuly");
                } else {
                    NSLog(@"But not replace");
                }
            } else {
                NSLog(@"File exist but not deleted");
            }
        }
    } else {
        NSLog(@"File not finded");
        if([newImageData writeToURL:storeURL atomically:YES]){
            NSLog(@"File created succesefuly");
        } else {
            NSLog(@"But not created");
        }
    }
    

    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void) choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)chooseNewPhoto:(id)sender
{
    [self choosePhoto];
}

#pragma mark CHOSE NEW DESIGN
-(void) chooseButtonTapped:(id)sender
{
    NSInteger design = 0;
    id senderView = nil;
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        senderView = ((UITapGestureRecognizer*)sender).view;
    }

    if(senderView){
        if([senderView isKindOfClass:[TestButtonBackGroundView class]]){
            design = ((TestButtonBackGroundView*)senderView).designIndex;
        } else if ([senderView isKindOfClass:[designButtonView class]]){
            design = ((designButtonView*)senderView).design;
        } else if([senderView isKindOfClass:[UIView class]]){
            design = ((UIView*)senderView).tag;
        }
    }
    
    NSNumber *message = [NSNumber numberWithInteger:design];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"ChangedDesign",nil];
    NSNotification *note = [[NSNotification alloc] initWithName:SendChangedNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];

    self.design = design;

}

-(void)setNeedViews
{
    CalcButton *calcButton = [CalcButton buttonWithType:UIButtonTypeSystem];
    [calcButton addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [calcButton setTintColor:[UIColor whiteColor]];
    [self.cView addSubview:calcButton];
    self.calcButton = calcButton;
    
    SettingButton *settingButton = [SettingButton buttonWithType:UIButtonTypeSystem];
    [settingButton addTarget:self action:@selector(settingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTintColor:[UIColor whiteColor]];
    [self.cView addSubview:settingButton];
    self.settingButton = settingButton;
    
    
    
    UILabel *chooseDesignLabel = [[UILabel alloc] init];
    chooseDesignLabel.text = @"Выберите подходящий дизайн";
    chooseDesignLabel.textAlignment = NSTextAlignmentCenter;
    chooseDesignLabel.numberOfLines = 0;
    chooseDesignLabel.textColor = [UIColor whiteColor];
    if(IS_IPAD){
        chooseDesignLabel.font = [UIFont systemFontOfSize:30];
    } else {
        chooseDesignLabel.font = [UIFont systemFontOfSize:20];
    }
    chooseDesignLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    chooseDesignLabel.adjustsFontSizeToFitWidth = YES;
    [self.cView addSubview:chooseDesignLabel];
    self.chooseDesignLabel = chooseDesignLabel;
    
    
    UIView *classicPartView = [[UIView alloc] init];
    classicPartView.backgroundColor = [UIColor blackColor];

    [self.cView addSubview:classicPartView];
    self.classicPartView = classicPartView;
    //need to set button classic button
    designButtonView *classicButtonView= [[designButtonView alloc] init];
    [self.classicPartView addSubview:classicButtonView];
    self.classicButtonView = classicButtonView;
    
    TestButtonBackGroundView *classicButton = [[TestButtonBackGroundView alloc]init];
    classicButton.isChoosed = NO;
    [self.classicPartView addSubview:classicButton];
    self.classicButton = classicButton;
    
    
    UIView *paperPartView = [[UIView alloc] init];
    paperPartView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myTextureSych 3.png"]];
    [self.cView addSubview:paperPartView];
    self.paperPartView = paperPartView;
    designButtonView *paperButtonView= [[designButtonView alloc] init];
    paperButtonView.backgroundColor = [UIColor clearColor];
    [self.paperPartView addSubview:paperButtonView];
    self.paperButtonView = paperButtonView;
    
    TestButtonBackGroundView *paperButton = [[TestButtonBackGroundView alloc]init];
    paperButton.isChoosed = NO;
    [self.paperPartView addSubview:paperButton];
    self.paperButton = paperButton;
    
    
    //need to set button classic button
    designButtonView *colorButtonView= [[designButtonView alloc] init];
    
    //IMPORTANT need to be according design
    colorButtonView.design = DESIGN_COLOR_BLUE;
    colorButtonView.backgroundColor = [UIColor clearColor];
    [self.cView addSubview:colorButtonView];
    self.colorButtonView = colorButtonView;
    
    //blue
    TestButtonBackGroundView *clolorBlueButton = [[TestButtonBackGroundView alloc]init];
    //clolorBlueButton.backgroundColor= [UIColor clearColor];
    //clolorBlueButton.mainviewcolor = [UIColor whiteColor];
    //clolorBlueButton.coloredColor = [UIColor colorWithRed:0.25 //64
     //                                               green:0.61 //156
      //                                               blue:.80 //204
     //                                               alpha:1.];
    clolorBlueButton.designIndex = DESIGN_COLOR_BLUE;
    clolorBlueButton.isChoosed = NO;
    [self.cView addSubview:clolorBlueButton];
    self.clolorBlueButton = clolorBlueButton;
    
    //pink
    TestButtonBackGroundView *colorPinkButton = [[TestButtonBackGroundView alloc]init];
    /*
    colorPinkButton.backgroundColor= [UIColor clearColor];
    colorPinkButton.mainviewcolor = [UIColor whiteColor];
    colorPinkButton.coloredColor = [UIColor colorWithRed:1
                                                   green:0.55
                                                    blue:.42
                                                   alpha:1.];
    */
    colorPinkButton.designIndex = DESIGN_COLOR_PINK;
    colorPinkButton.isChoosed = NO;
    [self.cView addSubview:colorPinkButton];
    self.colorPinkButton = colorPinkButton;
    
    //green
    TestButtonBackGroundView *colorGreenButton = [[TestButtonBackGroundView alloc]init];
    /*
    colorGreenButton.backgroundColor= [UIColor clearColor];
    colorGreenButton.mainviewcolor = [UIColor whiteColor];
    colorGreenButton.coloredColor = [UIColor colorWithRed:0.1
                                                    green:0.79
                                                     blue:.42
                                                    alpha:1.];
    */
    colorGreenButton.designIndex = DESIGN_COLOR_GREEN;
    colorGreenButton.isChoosed = NO;
    [self.cView addSubview:colorGreenButton];
    self.colorGreenButton = colorGreenButton;
    
    //yelow
    TestButtonBackGroundView *colorYelowButton = [[TestButtonBackGroundView alloc]init];
    /*
    colorYelowButton.backgroundColor= [UIColor clearColor];
    colorYelowButton.mainviewcolor = [UIColor whiteColor];
    colorYelowButton.coloredColor = [UIColor colorWithRed:.97
                                                    green:0.71
                                                     blue:.0
                                                    alpha:1.];
    */
    colorYelowButton.isChoosed = NO;
    colorYelowButton.designIndex = DESIGN_COLOR_YELOW;
    [self.cView addSubview:colorYelowButton];
    self.colorYelowButton = colorYelowButton;
    
    //black
    TestButtonBackGroundView *colorBlackButton = [[TestButtonBackGroundView alloc]init];
    /*
    colorBlackButton.backgroundColor= [UIColor clearColor];
    colorBlackButton.mainviewcolor = [UIColor whiteColor];
    colorBlackButton.coloredColor = [UIColor colorWithRed:.2
                                                    green:0.2
                                                     blue:.2
                                                    alpha:1.];
    */
    colorBlackButton.isChoosed = NO;
    colorBlackButton.designIndex = DESIGN_COLOR_GRAY;
    [self.cView addSubview:colorBlackButton];
    self.colorBlackButton = colorBlackButton;

    UIView *photoPartView = [[UIView alloc] init];

    photoPartView.clipsToBounds = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documentName = @"PhotoPicture";//@"MyDocument.sqlite"
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL =  [documentsDirectory URLByAppendingPathComponent:documentName];
    UIImage *imageForPhotoPart;
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        if([fileManager isDeletableFileAtPath:[storeURL path]]){
             imageForPhotoPart = [UIImage imageWithData:[NSData dataWithContentsOfURL:storeURL]];
        } else {
            [UIImage imageNamed:/*@"handmadepaper.png"*/@"IMG_1552.jpg"];
        }
    } else {
        [UIImage imageNamed:/*@"handmadepaper.png"*/@"IMG_1552.jpg"];

    }
    
    UIImageView *photo = [[UIImageView alloc] initWithImage:imageForPhotoPart];
    photo.contentMode = UIViewContentModeScaleAspectFill;
    photo.backgroundColor = self.cView.backgroundColor;
    photo.clipsToBounds = YES;
    self.photo = photo;
    
    [photoPartView addSubview:photo];
    
    [self.cView addSubview:photoPartView];
    self.photoPartView = photoPartView;
    
    TestButtonBackGroundView *photButton = [[TestButtonBackGroundView alloc]init];
    photButton.isChoosed = NO;
    [self.photoPartView addSubview:photButton];
    self.photButton = photButton;

    //need to set button classic button
    designButtonView *photoButtonView= [[designButtonView alloc] init];
    photoButtonView.backgroundColor = [UIColor clearColor];
    [self.photoPartView addSubview:photoButtonView];
    self.photoButtonView = photoButtonView;
    
    PlusButton *addNewPhotoButton = [[PlusButton alloc] init];
    [addNewPhotoButton addTarget:self action:@selector(chooseNewPhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.addNewPhotoButton = addNewPhotoButton;
    [self.cView addSubview:addNewPhotoButton];
    
    switch (self.design) {
        case DESIGN_CLASSIC:
            self.classicButton.isChoosed = YES;
            break;
        case DESIGN_PAPER:
            self.paperButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_BLUE:
            self.clolorBlueButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_GREEN:
            self.colorGreenButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_PINK:
            self.colorPinkButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_YELOW:
            self.colorYelowButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_GRAY:
            self.colorBlackButton.isChoosed = YES;
        case DESIGN_PHOTO:
            self.photButton.isChoosed = YES;
            break;
        default:
            break;
    }
    
    
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
     UITapGestureRecognizer *tapOnView13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseButtonTapped:)];
    
    [self.classicPartView addGestureRecognizer:tapOnView];
    [self.classicButton addGestureRecognizer:tapOnView1];
    [self.classicButtonView addGestureRecognizer:tapOnView2];
    
    [self.paperPartView addGestureRecognizer:tapOnView3];
    [self.paperButtonView addGestureRecognizer:tapOnView4];
    [self.paperButton addGestureRecognizer:tapOnView5];
    
    [self.clolorBlueButton addGestureRecognizer:tapOnView6];
    [self.colorPinkButton addGestureRecognizer:tapOnView7];
    [self.colorGreenButton addGestureRecognizer:tapOnView8];
    [self.colorYelowButton addGestureRecognizer:tapOnView9];
    [self.colorBlackButton addGestureRecognizer:tapOnView10];
    
    [self.photoPartView addGestureRecognizer:tapOnView11];
    [self.photoButtonView addGestureRecognizer:tapOnView12];
    [self.photButton addGestureRecognizer:tapOnView13];
}


-(void) setLayOutOfSettingsView:(CGRect)rect
{
    CGFloat onePart;
    CGFloat origHeight;
    CGFloat origWidth;
    //nex two parts need be in setLayout in case of redrawing views
    self.classicButton.designIndex = DESIGN_CLASSIC;
    self.classicButtonView.design = DESIGN_CLASSIC;
    self.classicPartView.tag = DESIGN_CLASSIC;
    
    self.paperButton.designIndex = DESIGN_PAPER;
    self.paperButtonView.design = DESIGN_PAPER;
    self.paperPartView.tag = DESIGN_PAPER;
    
    self.colorButtonView.design = DESIGN_COLOR_BLUE;
    self.clolorBlueButton.designIndex = DESIGN_COLOR_BLUE;
    self.colorPinkButton.designIndex = DESIGN_COLOR_PINK;
    self.colorGreenButton.designIndex = DESIGN_COLOR_GREEN;
    self.colorYelowButton.designIndex = DESIGN_COLOR_YELOW;
    self.colorBlackButton.designIndex = DESIGN_COLOR_GRAY;
    
    self.photoPartView.tag = DESIGN_PHOTO;
    self.photoButtonView.design = DESIGN_PHOTO;
    self.photButton.designIndex = DESIGN_PHOTO;
    
    switch (self.design) {
        case DESIGN_CLASSIC:
            self.classicButton.isChoosed = YES;
            break;
        case DESIGN_PAPER:
            self.paperButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_BLUE:
            self.clolorBlueButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_GREEN:
            self.colorGreenButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_PINK:
            self.colorPinkButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_YELOW:
            self.colorYelowButton.isChoosed = YES;
            break;
        case DESIGN_COLOR_GRAY:
            self.colorBlackButton.isChoosed = YES;
        case DESIGN_PHOTO:
            self.photButton.isChoosed = YES;
            break;
        default:
            break;
    }
    
    
    if(IS_IPAD){

        onePart = rect.size.height/7;
        origHeight  = rect.origin.y;
        origWidth = rect.origin.x;
        
        CGFloat quardSide = onePart*0.8;//rect.size.width/(5 +0.2);
        CGFloat addition = quardSide*0.2;
        
        CGFloat firstPositionStart = quardSide*0.1;
        CGFloat addToColorButtonX = (rect.size.width - 5*quardSide - quardSide*0.2)/6;
        
        CGRect rct = CGRectMake(firstPositionStart+origWidth+addToColorButtonX, (onePart-quardSide)/2, quardSide, quardSide);
        /*
        CGRect rctforButtonView = CGRectMake(2*firstPositionStart+origWidth+quardSide-addition/2,
                                             (onePart-quardSide)/2-addition/2,
                                             rect.size.width -2*quardSide - 4*firstPositionStart+addition, quardSide+addition);
        */
        CGRect rctforButtonView = CGRectMake(origWidth+(rect.size.width*3/10),
                                             (onePart-quardSide)/2-addition/2,
                                             rect.size.width/2.5,
                                             quardSide+addition);
        
        CGRect partRect = CGRectMake(0, 0, rect.size.width+2*rect.origin.x, onePart);
        
        [self.chooseDesignLabel setFrame:CGRectInset(partRect, origWidth, 0)];
        [self.chooseDesignLabel setCenter:CGPointMake(origWidth+rect.size.width/2,origHeight+onePart/2)];
        
        [self.classicPartView setFrame:CGRectMake(0, origHeight+onePart, self.cView.bounds.size.width, onePart)];
        
        [self.classicButton setFrame:rct];
        [self.classicButtonView setFrame:rctforButtonView];
        //[self.classicButtonView setCenter:CGPointMake(self.classicPartView.bounds.size.width/2,self.classicPartView.bounds.size.height/2) ];
        
        [self.paperPartView setFrame:CGRectMake(0, origHeight+2*onePart, self.cView.bounds.size.width, onePart)];
        [self.paperButton setFrame:rct];
        [self.paperButtonView setFrame:rctforButtonView];
        [self.paperButtonView setCenter:CGPointMake(self.paperPartView.bounds.size.width/2,self.paperPartView.bounds.size.height/2) ];
        
        [self.colorButtonView setFrame:CGRectMake(origWidth+(rect.size.width*3/10),
                                                  origHeight+(onePart-quardSide)/2+3*onePart-addition/2,
                                                  rect.size.width/2.5,
                                                  quardSide+addition)];
        
        [self.clolorBlueButton setFrame:CGRectMake(firstPositionStart+origWidth +addToColorButtonX,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorPinkButton setFrame:CGRectMake(firstPositionStart+origWidth+addToColorButtonX*2+quardSide,
                                                  origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorGreenButton setFrame:CGRectMake(firstPositionStart+origWidth+addToColorButtonX*3+2*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorYelowButton setFrame:CGRectMake(firstPositionStart+origWidth+addToColorButtonX*4+3*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorBlackButton setFrame:CGRectMake(firstPositionStart+origWidth+addToColorButtonX*5+4*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        
        
        [self.photoPartView setFrame:CGRectMake(0,origHeight+5*onePart, self.cView.bounds.size.width, onePart)];
        [self.photo setFrame:self.photoPartView.bounds];
        [self.photButton setFrame:rct];
        [self.photoButtonView setFrame:rctforButtonView];
        [self.photoButtonView setCenter:CGPointMake(self.photoPartView.bounds.size.width/2,self.photoPartView.bounds.size.height/2) ];
        
        CGFloat viewSide = (self.view.bounds.size.height>self.view.bounds.size.width)? self.view.bounds.size.height/13 : self.view.bounds.size.width/13;
        
        CGRect rectForView = CGRectMake(0, 0, viewSide, viewSide);
        [self.calcButton setBounds:rectForView];
        [self.calcButton setCenter:CGPointMake(rect.origin.x+rect.size.width/3, origHeight+6*onePart+partRect.size.height/2)];
        
        [self.settingButton setBounds:rectForView];
        [self.settingButton setCenter:CGPointMake(rect.origin.x+2*rect.size.width/3, origHeight+6*onePart+partRect.size.height/2)];
        
        [self.addNewPhotoButton setFrame:CGRectMake(origWidth + rect.size.width - firstPositionStart - quardSide - addToColorButtonX,
                                                    (onePart-quardSide)/2+origHeight+5*onePart,
                                                    quardSide,
                                                    quardSide)];

    } else {
        onePart = rect.size.height/7;
        origHeight  = rect.origin.y;
        origWidth = rect.origin.x;
        
        CGFloat quardSide = rect.size.width/(5 +0.2);
        CGFloat addition = quardSide*0.2;
        CGFloat firstPositionStart = quardSide*0.1;
        
        CGRect rct = CGRectMake(firstPositionStart+origWidth, (onePart-quardSide)/2, quardSide, quardSide);
        CGRect rctforButtonView = CGRectMake(2*firstPositionStart+origWidth+quardSide-addition/2,
                                             (onePart-quardSide)/2-addition/2,
                                             rect.size.width -2*quardSide - 4*firstPositionStart+addition, quardSide+addition);
        
        CGRect partRect = CGRectMake(0, 0, rect.size.width+2*rect.origin.x, onePart);
        
        [self.chooseDesignLabel setFrame:CGRectInset(partRect, origWidth, 0)];
        [self.chooseDesignLabel setCenter:CGPointMake(origWidth+rect.size.width/2,origHeight+onePart/2)];

        [self.classicPartView setFrame:CGRectMake(0, origHeight+onePart, self.cView.bounds.size.width, onePart)];

        [self.classicButton setFrame:rct];
        [self.classicButtonView setFrame:rctforButtonView];
        
        [self.paperPartView setFrame:CGRectMake(0, origHeight+2*onePart, self.cView.bounds.size.width, onePart)];
        [self.paperButton setFrame:rct];
        [self.paperButtonView setFrame:rctforButtonView];
        
        [self.colorButtonView setFrame:CGRectMake(2*firstPositionStart+origWidth+quardSide-addition/2,
                                                  origHeight+(onePart-quardSide)/2+3*onePart-addition/2,
                                                  rect.size.width-2*quardSide - 4*firstPositionStart+addition,
                                                  quardSide+addition)];
        
        [self.clolorBlueButton setFrame:CGRectMake(firstPositionStart+origWidth,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorPinkButton setFrame:CGRectMake(firstPositionStart+origWidth+quardSide,
                                                  origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorGreenButton setFrame:CGRectMake(firstPositionStart+origWidth+2*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorYelowButton setFrame:CGRectMake(firstPositionStart+origWidth+3*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        [self.colorBlackButton setFrame:CGRectMake(firstPositionStart+origWidth+4*quardSide,
                                                   origHeight+(onePart-quardSide)/2+4*onePart, quardSide, quardSide)];
        
        
        [self.photoPartView setFrame:CGRectMake(0,origHeight+5*onePart, self.cView.bounds.size.width, onePart)];
        [self.photo setFrame:self.photoPartView.bounds];
        [self.photButton setFrame:rct];
        [self.photoButtonView setFrame:rctforButtonView];
        
        CGFloat viewSide = (self.view.bounds.size.height>self.view.bounds.size.width)? self.view.bounds.size.height/10 : self.view.bounds.size.width/10;
        
        CGRect rectForView = CGRectMake(0, 0, viewSide, viewSide);
        [self.calcButton setBounds:rectForView];
        [self.calcButton setCenter:CGPointMake(rect.origin.x+rect.size.width/3, origHeight+6*onePart+partRect.size.height/2)];
        
        [self.settingButton setBounds:rectForView];
        [self.settingButton setCenter:CGPointMake(rect.origin.x+2*rect.size.width/3, origHeight+6*onePart+partRect.size.height/2)];
        
        [self.addNewPhotoButton setFrame:CGRectMake(origWidth + rect.size.width - firstPositionStart - quardSide,
                                                    (onePart-quardSide)/2+origHeight+5*onePart,
                                                    quardSide,
                                                    quardSide)];

    }
}

-(void) viewDidLayoutSubviewsWithRect:(CGRect)rect
{
    
    [self setLayOutOfSettingsView:rect];
    
}

-(void) setCViewAccordingFrameRect:(CGRect)rctIn
{
    CGRect rct;
    rct.size.width = rctIn.size.width/0.8;
    rct.size.height = rctIn.size.height/0.8;
    rct.origin.x = (rctIn.size.width - rct.size.width)/2;
    rct.origin.y = (rctIn.size.height - rct.size.height)/2;
    
    
    CGRect rect = rctIn;
    rect.origin.x = -rct.origin.x;
    rect.origin.y = -rct.origin.y;
    
    CGFloat angle = 0;
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    self.wasOrient = orient;
    
    if(!IS_IPAD){
        CGFloat width = rct.size.width;
        CGFloat height = rct.size.height;
        
        if(width > height){
            
            switch (orient) {
                case UIDeviceOrientationLandscapeLeft:
                    angle = -M_PI/2;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    angle = M_PI/2;
                    
                default:
                    break;
            }
            rect.size.width = self.view.bounds.size.height;
            rect.size.height = self.view.bounds.size.width;
            rect.origin.x = -rct.origin.y;
            rect.origin.y = -rct.origin.x;
        }
        
        self.cView.center = self.view.center;
        [self.cView setTransform:CGAffineTransformMakeRotation(angle)];
    }
    [self.cView setFrame:rct];
    
    [self viewDidLayoutSubviewsWithRect:rect];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    CGRect rct = self.view.bounds;
    [self setCViewAccordingFrameRect:rct];
    
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appWillGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];
    
}
-(void)willRotatetoSize:(CGSize)size
{
    CGRect rct = CGRectMake(0,0,size.width,size.height);
    [self setCViewAccordingFrameRect:rct];
}

-(void)appWillGoToBackground:(NSNotification *)note{
    [self.delegate designViewControllerDidCloseWithString:@"TO CALC"];
    [self dismis];
}

@end
