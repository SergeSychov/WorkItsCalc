//
//  ITSCalcViewController.h
//  ITSCalc
//
//  Created by Serge Sychov on 15.04.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>
#import <StoreKit/StoreKit.h>

@interface ITSCalcViewController : UIViewController <ADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate>


@end

