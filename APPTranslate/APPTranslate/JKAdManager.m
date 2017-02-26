//
//  JKAdManager.m
//  APPTranslate
//
//  Created by wangdan on 2017/2/26.
//  Copyright © 2017年 王丹. All rights reserved.
//

#import "JKAdManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>


@interface JKAdManager ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, weak) UIViewController *integradeVC;
@end

@implementation JKAdManager

+ (id)sharedInstance {
    static JKAdManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (void)integradeWithVc:(UIViewController *)vc {
    _integradeVC = vc;
}

- (void)show {
    [self createAndLoadInterstitial];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.interstitial isReady]) {
            [self.interstitial presentFromRootViewController:weakSelf.integradeVC];
        }
        else {
            [self show];
        }
    });
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2109425832579056/4717274723"];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [interstitial loadRequest:request];
    self.interstitial = interstitial;
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self createAndLoadInterstitial];
}






@end
