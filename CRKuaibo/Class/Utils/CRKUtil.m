//
//  CRKUtil.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "CRKApplicationManager.h"
#import "CRKAppSpreadBannerModel.h"
#import "CRKSpreadBannerViewController.h"

NSString *const kPaymentInfoKeyName = @"crkuaibov_paymentinfo_keyname";

static NSString *const kRegisterKeyName = @"crkuaibov_register_keyname";
static NSString *const kUserAccessUsername = @"crkuaibov_user_access_username";
static NSString *const kUserAccessServicename = @"crkuaibov_user_access_service";
static NSString *const kLaunchSeqKeyName = @"crkuaibov_launchseq_keyname";

@implementation CRKUtil

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<CRKPaymentInfo *> *)allPaymentInfos {
    NSArray<NSDictionary *> *paymentInfoArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfos = [NSMutableArray array];
    [paymentInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CRKPaymentInfo *paymentInfo = [CRKPaymentInfo paymentInfoFromDictionary:obj];
        [paymentInfos addObject:paymentInfo];
    }];
    return paymentInfos;
}

+ (NSArray<CRKPaymentInfo *> *)payingPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        CRKPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus.unsignedIntegerValue == CRKPaymentStatusPaying;
    }];
}

+ (NSArray<CRKPaymentInfo *> *)paidNotProcessedPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        CRKPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus.unsignedIntegerValue == CRKPaymentStatusNotProcessed;
    }];
}


+ (CRKPaymentInfo *)successfulPaymentInfo {
    return [self.allPaymentInfos bk_match:^BOOL(id obj) {
        CRKPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult.unsignedIntegerValue == PAYRESULT_SUCCESS) {
            return YES;
        }
        return NO;
    }];
}

+ (BOOL)isPaid {
    return [self successfulPaymentInfo] != nil;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)paymentReservedData {
    return [NSString stringWithFormat:@"%@$%@", CRK_REST_APP_ID, CRK_CHANNEL_NO];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (void)showSpreadBanner {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *spreads = [CRKAppSpreadBannerModel sharedModel].fetchedSpreads;
        NSArray *allInstalledAppIds = [[CRKApplicationManager defaultManager] allInstalledAppIdentifiers];
        NSArray *uninstalledSpreads = [spreads bk_select:^BOOL(id obj) {
            return ![allInstalledAppIds containsObject:[obj specialDesc]];
        }];
        
        if (uninstalledSpreads.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CRKSpreadBannerViewController *spreadVC = [[CRKSpreadBannerViewController alloc] initWithSpreads:uninstalledSpreads];
                [spreadVC showInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            });
        }
    });
}

+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
}

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[CRKApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

@end
