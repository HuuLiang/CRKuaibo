//
//  CRKErrorHandler.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKErrorHandler.h"
#import "CRKURLRequest.h"

NSString *const kNetworkErrorNotification = @"CRKNetworkErrorNotification";
NSString *const kNetworkErrorCodeKey = @"CRKNetworkErrorCodeKey";
NSString *const kNetworkErrorMessageKey = @"CRKNetworkErrorMessageKey";

@implementation CRKErrorHandler

+ (instancetype)sharedHandler {
    static CRKErrorHandler *_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[CRKErrorHandler alloc] init];
    });
    return _handler;
}

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkError:) name:kNetworkErrorNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onNetworkError:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CRKURLResponseStatus resp = (CRKURLResponseStatus)(((NSNumber *)userInfo[kNetworkErrorCodeKey]).unsignedIntegerValue);
    
    if (resp == CRKURLResponseFailedByInterface) {
        [[CRKHudManager manager] showHudWithText:@"获取网络数据失败"];
    } else if (resp == CRKURLResponseFailedByNetwork) {
        [[CRKHudManager manager] showHudWithText:@"网络错误，请检查网络连接！"];
    }
    
}
@end
