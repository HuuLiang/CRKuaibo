//
//  CRKPaymentConfigModel.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKPaymentConfigModel.h"

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation CRKPaymentConfigModel

+ (Class)responseClass {
    return [CRKPaymentConfig class];
}

+ (instancetype)sharedModel {
    static CRKPaymentConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (CRKURLRequestMethod)requestMethod {
    return CRKURLPostRequest;
}

+ (NSString *)signKey {
    return kSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":CRK_REST_APP_ID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":CRK_CHANNEL_NO,
                                   @"pV":CRK_PAYMENT_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":CRK_REST_APP_ID};
}

- (BOOL)fetchConfigWithCompletionHandler:(CRKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:CRK_PAYMENT_CONFIG_URL
                     standbyURLPath:[NSString stringWithFormat:CRK_STANDBY_PAYMENT_CONFIG_URL, CRK_REST_APP_ID]
                         withParams:@{@"appId":CRK_REST_APP_ID, @"channelNo":CRK_CHANNEL_NO, @"pV":CRK_PAYMENT_PV}
                    responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        CRKPaymentConfig *config;
        if (respStatus == CRKURLResponseSuccess) {
            self->_loaded = YES;
            
            config = self.response;
            [config setAsCurrentConfig];
            
            DLog(@"Payment config loaded!");
        }
        
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess, config);
        }
    }];
    return ret;
}
@end
