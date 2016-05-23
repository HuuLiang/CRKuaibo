//
//  CRKPaymentModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKPaymentModel.h"
#import "CRKPaymentInfo.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@interface CRKPaymentModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation CRKPaymentModel

+ (instancetype)sharedModel {
    static CRKPaymentModel *_sharedModel;
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

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"Payment: on retrying to commit unprocessed orders!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self commitUnprocessedOrders];
            });
        } repeats:YES];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

- (void)commitUnprocessedOrders {
    NSArray<CRKPaymentInfo *> *unprocessedPaymentInfos = [CRKUtil paidNotProcessedPaymentInfos];
    [unprocessedPaymentInfos enumerateObjectsUsingBlock:^(CRKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self commitPaymentInfo:obj];
    }];
}

- (BOOL)commitPaymentInfo:(CRKPaymentInfo *)paymentInfo {
    return [self commitPaymentInfo:paymentInfo withCompletionHandler:nil];
}

- (BOOL)commitPaymentInfo:(CRKPaymentInfo *)paymentInfo withCompletionHandler:(CRKCompletionHandler)handler {
    NSDictionary *statusDic = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(0), @(PAYRESULT_ABANDON):@(2), @(PAYRESULT_UNKNOWN):@(0)};
    
    if (nil == [CRKUtil userId] || paymentInfo.orderId.length == 0) {
        return NO;
    }
    
    NSDictionary *params = @{@"uuid":[CRKUtil userId],
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":paymentInfo.orderPrice.stringValue,
                             @"channelNo":CRK_CHANNEL_NO,
                             @"contentId":paymentInfo.contentId.stringValue ?: @"0",
                             @"contentType":paymentInfo.contentType.stringValue ?: @"0",
                             @"pluginType":paymentInfo.paymentType,
                             @"payPointType":paymentInfo.payPointType ?: @"1",
                             @"appId":CRK_REST_APP_ID,
                             @"versionNo":@([CRKUtil appVersion].integerValue),
                             @"status":statusDic[paymentInfo.paymentResult],
                             @"pV":CRK_PAYMENT_PV,
                             @"payTime":paymentInfo.paymentTime};
    
    BOOL success = [super requestURLPath:CRK_PAYMENT_COMMIT_URL
                              withParams:params
                         responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == CRKURLResponseSuccess) {
            paymentInfo.paymentStatus = @(CRKPaymentStatusProcessed);
            [paymentInfo save];
        } else {
            DLog(@"Payment: fails to commit the order with orderId:%@", paymentInfo.orderId);
        }
                        
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess, errorMessage);
        }
    }];
    return success;
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(CRKURLResponseHandler)responseHandler {
    NSDictionary *decryptedResponse = [self decryptResponse:responseObject];
    DLog(@"Payment response : %@", decryptedResponse);
    NSNumber *respCode = decryptedResponse[@"response_code"];
    CRKURLResponseStatus status = (respCode.unsignedIntegerValue == 100) ? CRKURLResponseSuccess : CRKURLResponseFailedByInterface;
    if (responseHandler) {
        responseHandler(status, nil);
    }
}
@end
