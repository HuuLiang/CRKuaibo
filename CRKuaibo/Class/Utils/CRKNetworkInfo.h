//
//  CRKNetworkInfo.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CRKNetworkStatus) {
    CRKNetworkStatusUnknown = -1,
    CRKNetworkStatusNotReachable = 0,
    CRKNetworkStatusWiFi = 1,
    CRKNetworkStatus2G = 2,
    CRKNetworkStatus3G = 3,
    CRKNetworkStatus4G = 4
};

@interface CRKNetworkInfo : NSObject

@property (nonatomic,readonly) CRKNetworkStatus networkStatus;
@property (nonatomic,readonly) NSString *carriarName;

+ (instancetype)sharedInfo;
- (void)startMonitoring;

@end
