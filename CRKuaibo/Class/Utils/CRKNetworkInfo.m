//
//  CRKNetworkInfo.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKNetworkInfo.h"
#import <AFNetworking.h>

@import SystemConfiguration;
@import CoreTelephony;

@interface CRKNetworkInfo ()
@property (nonatomic,retain,readonly) CTTelephonyNetworkInfo *networkInfo;
@end

@implementation CRKNetworkInfo
@synthesize networkInfo = _networkInfo;

DefineLazyPropertyInitialization(CTTelephonyNetworkInfo, networkInfo)

+ (instancetype)sharedInfo {
    static CRKNetworkInfo *_sharedInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInfo = [[self alloc] init];
    });
    return _sharedInfo;
}

- (void)startMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (CRKNetworkStatus)networkStatus {
    
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return CRKNetworkStatusNotReachable;
    } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return CRKNetworkStatusWiFi;
    } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        NSString *radioAccess = self.networkInfo.currentRadioAccessTechnology;
        if ([radioAccess isEqualToString:CTRadioAccessTechnologyGPRS]
            || [radioAccess isEqualToString:CTRadioAccessTechnologyEdge]
            || [radioAccess isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            return CRKNetworkStatus2G;
        } else if ([radioAccess isEqualToString:CTRadioAccessTechnologyWCDMA]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyHSDPA]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyHSUPA]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
                   || [radioAccess isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            return CRKNetworkStatus3G;
        } else if ([radioAccess isEqualToString:CTRadioAccessTechnologyLTE]) {
            return CRKNetworkStatus4G;
        }
    }
    return CRKNetworkStatusUnknown;
}

- (NSString *)carriarName {
    return self.networkInfo.subscriberCellularProvider.carrierName;
}
@end
