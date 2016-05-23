//
//  CRKAppSpreadBannerModel.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKAppSpreadBannerModel.h"

@implementation CRKAppSpreadBannerResponse

- (Class)programListElementClass {
    return [CRKProgram class];
}
@end

@implementation CRKAppSpreadBannerModel

+ (instancetype)sharedModel {
    static CRKAppSpreadBannerModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
+ (Class)responseClass {
    return [CRKAppSpreadBannerResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(CRKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:CRK_APP_SPREAD_BANNER_URL
                     standbyURLPath:CRK_STANDBY_APP_SPREAD_BANNER_URL
                         withParams:nil
                    responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == CRKURLResponseSuccess) {
                        CRKAppSpreadBannerResponse *resp = self.response;
                        _fetchedSpreads = resp.programList;
                        fetchedSpreads = _fetchedSpreads;
                    }
                    
                    if (handler) {
                        handler(respStatus==CRKURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}
@end
