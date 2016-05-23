//
//  CRKActivateModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation CRKActivateModel

+ (instancetype)sharedModel {
    static CRKActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[CRKActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(CRKActivateHandler)handler {
    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    
    NSDictionary *params = @{@"cn":CRK_CHANNEL_NO,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"sms":@"00000000000",
                             @"cw":@(kScreenWidth),
                             @"ch":@(kScreenHeight),
                             @"cm":[CRKUtil deviceName],
                             @"mf":[UIDevice currentDevice].model,
                             @"sdkV":sdkV,
                             @"cpuV":@"",
                             @"appV":[CRKUtil appVersion],
                             @"appVN":@"",
                             @"ccn":CRK_PACKAGE_CERTIFICATE};
    
    BOOL success = [self requestURLPath:CRK_ACTIVATE_URL withParams:params responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage) {
        NSString *userId;
        if (respStatus == CRKURLResponseSuccess) {
            NSString *resp = self.response;
            NSArray *resps = [resp componentsSeparatedByString:@";"];
            
            NSString *success = resps.firstObject;
            if ([success isEqualToString:kSuccessResponse]) {
                userId = resps.count == 2 ? resps[1] : nil;
            }
        }
        
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess && userId, userId);
        }
    }];
    return success;
}

@end
