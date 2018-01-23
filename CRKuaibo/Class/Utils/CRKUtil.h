//
//  CRKUtil.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;

@interface CRKUtil : NSObject

+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSArray<CRKPaymentInfo *> *)allPaymentInfos;
+ (NSArray<CRKPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<CRKPaymentInfo *> *)paidNotProcessedPaymentInfos;

+ (BOOL)isPaid;

+ (NSString *)accessId;
+ (NSString *)userId;
+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (NSString *)paymentReservedData;
+ (CRKDeviceType)deviceType;

+ (void)showSpreadBanner;
+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;
+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;

+ (UIViewController *)currentVisibleViewController;

+ (NSString *)getIPAddress;

@end
