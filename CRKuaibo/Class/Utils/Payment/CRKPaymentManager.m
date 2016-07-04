//
//  CRKPaymentManager.m
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "CRKPaymentManager.h"
#import "CRKPaymentInfo.h"
#import "CRKPaymentViewController.h"
#import "CRKProgram.h"
#import "CRKPaymentConfigModel.h"

#import "WXApi.h"
#import "WeChatPayQueryOrderRequest.h"
#import "WeChatPayManager.h"

#import <IapppayAlphaKit/IapppayAlphaOrderUtils.h>
#import <IapppayAlphaKit/IapppayAlphaKit.h>

static NSString *const kAlipaySchemeUrl = @"comyykuaibo2016appalipayurlscheme";

@interface CRKPaymentManager () <IapppayAlphaKitPayRetDelegate,WXApiDelegate>
@property (nonatomic,retain) CRKPaymentInfo *paymentInfo;
@property (nonatomic,copy) CRKPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) WeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation CRKPaymentManager

DefineLazyPropertyInitialization(WeChatPayQueryOrderRequest, wechatPayOrderQueryRequest)

+ (instancetype)sharedManager {
    static CRKPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    [[CRKPaymentConfigModel sharedModel] fetchConfigWithCompletionHandler:^(BOOL success, id obj) {
        [[IapppayAlphaKit sharedInstance] setAppAlipayScheme:kAlipaySchemeUrl];
        [[IapppayAlphaKit sharedInstance] setAppId:[CRKPaymentConfig sharedConfig].iappPayInfo.appid mACID:CRK_CHANNEL_NO];
        [WXApi registerApp:[CRKPaymentConfig sharedConfig].weixinInfo.appId];
    }];
}

- (void)handleOpenURL:(NSURL *)url {
    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
    //    [WXApi handleOpenURL:url delegate:self];
}

- (CRKPaymentInfo *)startPaymentWithType:(CRKPaymentType)type
                                 subType:(CRKPaymentType)subType
                                   price:(NSUInteger)price
                              forProgram:(CRKProgram *)program
                               inChannel:(CRKChannel *)channel
                         programLocation:(NSInteger)programLocation
                       completionHandler:(CRKPaymentCompletionHandler)handler
{
    if (type == CRKPaymentTypeNone || (type == CRKPaymentTypeIAppPay && subType == CRKPaymentTypeNone)) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return nil;
    }
    //    price = 1;
    NSString *channelNo = CRK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    CRKPaymentInfo *paymentInfo = [[CRKPaymentInfo alloc] init];
    
    paymentInfo.columnId = channel.realColumnId;
    paymentInfo.columnType = channel.type;
    paymentInfo.contentLocation = @(programLocation+1);
    
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = program.programId;
    paymentInfo.contentType = program.type;
    paymentInfo.payPointType = program.payPointType;
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(CRKPaymentStatusPaying);
    paymentInfo.reservedData = [CRKUtil paymentReservedData];
    if (type == CRKPaymentTypeWeChatPay) {
        paymentInfo.appId = [CRKPaymentConfig sharedConfig].weixinInfo.appId;
        paymentInfo.mchId = [CRKPaymentConfig sharedConfig].weixinInfo.mchId;
        paymentInfo.signKey = [CRKPaymentConfig sharedConfig].weixinInfo.signKey;
        paymentInfo.notifyUrl = [CRKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
    }
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    self.completionHandler = handler;
    
    BOOL success = YES;
    if (type == CRKPaymentTypeWeChatPay) {
        @weakify(self);
        [[WeChatPayManager sharedInstance] startWithPayment:paymentInfo completionHandler:^(PAYRESULT payResult) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
    } else if (type == CRKPaymentTypeIAppPay) {
        NSDictionary *paymentTypeMapping = @{@(CRKPaymentTypeAlipay):@(IapppayAlphaKitAlipayPayType),
                                             @(CRKPaymentTypeWeChatPay):@(IapppayAlphaKitWeChatPayType)};
        NSNumber *payType = paymentTypeMapping[@(subType)];
        if (!payType) {
            return nil;
        }
        
        IapppayAlphaOrderUtils *order = [[IapppayAlphaOrderUtils alloc] init];
        order.appId = [CRKPaymentConfig sharedConfig].iappPayInfo.appid;
        order.cpPrivateKey = [CRKPaymentConfig sharedConfig].iappPayInfo.privateKey;
        order.cpOrderId = orderNo;
#warning 支付
#ifdef DEBUG
        //        order.waresId = @"2";
        order.waresId = [CRKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
#else
        order.waresId = [CRKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
#endif
        order.price = [NSString stringWithFormat:@"%.2f", price/100.];
        order.appUserId = [CRKUtil userId] ?: @"UnregisterUser";
        order.cpPrivateInfo = CRK_PAYMENT_RESERVE_DATA;
        
        NSString *trandData = [order getTrandData];
        success = [[IapppayAlphaKit sharedInstance] makePayForTrandInfo:trandData
                                                          payMethodType:payType.unsignedIntegerValue
                                                            payDelegate:self];
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}

- (void)checkPayment {
    NSArray<CRKPaymentInfo *> *payingPaymentInfos = [CRKUtil payingPaymentInfos];
    [payingPaymentInfos enumerateObjectsUsingBlock:^(CRKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CRKPaymentType paymentType = obj.paymentType.unsignedIntegerValue;
        if (paymentType == CRKPaymentTypeWeChatPay) {
            if (obj.appId.length == 0 || obj.mchId.length == 0 || obj.signKey.length == 0 || obj.notifyUrl.length == 0) {
                obj.appId = [CRKPaymentConfig sharedConfig].weixinInfo.appId;
                obj.mchId = [CRKPaymentConfig sharedConfig].weixinInfo.mchId;
                obj.signKey = [CRKPaymentConfig sharedConfig].weixinInfo.signKey;
                obj.notifyUrl = [CRKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
            }
            
            [self.wechatPayOrderQueryRequest queryPayment:obj withCompletionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    CRKPaymentViewController *paymentVC = [CRKPaymentViewController sharedPaymentVC];
                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
                    [self onPaymentResult:PAYRESULT_SUCCESS];
                }
            }];
        }
    }];
}

- (void)onPaymentResult:(PAYRESULT)payResult {
    if (payResult == PAYRESULT_SUCCESS) {
        [[CRKLocalNotificationManager sharedManager] cancelAllNotifications];
    }
}

#pragma mark - IapppayAlphaKitPayRetDelegate

- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(PAYRESULT_SUCCESS),
                                           @(IapppayAlphaKitPayRetFailedCode):@(PAYRESULT_FAIL),
                                           @(IapppayAlphaKitPayRetCancelCode):@(PAYRESULT_ABANDON)};
    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
    if (!paymentResult) {
        paymentResult = @(PAYRESULT_UNKNOWN);
    }
    
    [self onPaymentResult:paymentResult.integerValue];
    
    if (self.completionHandler) {
        self.completionHandler(paymentResult.integerValue, self.paymentInfo);
    }
}

#pragma mark - WeChat delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        PAYRESULT payResult;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = PAYRESULT_ABANDON;
        } else if (resp.errCode == WXSuccess) {
            payResult = PAYRESULT_SUCCESS;
        } else {
            payResult = PAYRESULT_FAIL;
        }
        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
        [self onPaymentResult:payResult];
    }
}
@end
