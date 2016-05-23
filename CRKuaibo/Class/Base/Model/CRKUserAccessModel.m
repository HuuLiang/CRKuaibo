//
//  CRKUserAccessModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "CRKUserAccessModel.h"

@implementation CRKUserAccessModel

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static CRKUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[CRKUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [CRKUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:CRK_USER_ACCESS_URL
                          withParams:@{@"userId":userId,@"accessId":[CRKUtil accessId]}
                    responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        BOOL success = NO;
        if (respStatus == CRKURLResponseSuccess) {
            NSString *resp = self.response;
            success = [resp isEqualToString:@"SUCCESS"];
            if (success) {
                DLog(@"Record user access!");
            }
        }
    }];
    return ret;
}

@end
