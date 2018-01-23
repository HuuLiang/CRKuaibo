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

#import <PayUtil/PayUtil.h>
//#import "paySender.h"
#import "IappPayMananger.h"
#import "CRKSystemConfigModel.h"


typedef NS_ENUM(NSUInteger, CRKVIAPayType) {
    CRKVIAPayTypeNone,
    CRKVIAPayTypeWeChat = 2,
    CRKVIAPayTypeQQ = 3,
    CRKVIAPayTypeUPPay = 4,
    CRKVIAPayTypeShenZhou = 5
};


static NSString *const kAlipaySchemeUrl = @"comcrkappalipayurlscheme";
static NSString *const kIappPaySchemeUrl = @"comcrkappiaapayurlscheme";

@interface CRKPaymentManager () <WXApiDelegate, stringDelegate>
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
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    [IappPayMananger sharedMananger].alipayURLScheme = kIappPaySchemeUrl;
    [[CRKPaymentConfigModel sharedModel] fetchConfigWithCompletionHandler:^(BOOL success, id obj) {
        
    }];
    Class class = NSClassFromString(@"VIASZFViewController");
    if (class) {
        [class aspect_hookSelector:NSSelectorFromString(@"viewWillAppear:")
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)
         {
             UIViewController *thisVC = [aspectInfo instance];
             if ([thisVC respondsToSelector:NSSelectorFromString(@"buy")]) {
                 UIViewController *buyVC = [thisVC valueForKey:@"buy"];
                 [buyVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[UIButton class]]) {
                         UIButton *buyButton = (UIButton *)obj;
                         if ([[buyButton titleForState:UIControlStateNormal] isEqualToString:@"购卡支付"]) {
                             [buyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }];
             }
         } error:nil];
    }
}

- (CRKPaymentType)wechatPaymentType {
    if ([CRKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & CRKSubPayTypeWeChat) {
        return CRKPaymentTypeVIAPay;
    }else if ([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & CRKSubPayTypeWeChat){
        return CRKPaymentTypeIAppPay;
    }
    //    else if ([CRKPaymentConfig sharedConfig].wftPayInfo) {
    //        return CRKPaymentTypeSPay;
    //    } else if ([CRKPaymentConfig sharedConfig].iappPayInfo) {
    //        return CRKPaymentTypeIAppPay;
    //    } else if ([CRKPaymentConfig sharedConfig].haitunPayInfo) {
    //        return CRKPaymentTypeHTPay;
    //    }
    return CRKPaymentTypeNone;
}

- (CRKPaymentType)alipayPaymentType {
    if ([CRKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & CRKSubPayTypeAlipay) {
        return CRKPaymentTypeVIAPay;
    }else if ([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & CRKSubPayTypeAlipay){
        return CRKPaymentTypeIAppPay;
    }
    return CRKPaymentTypeNone;
}

- (CRKPaymentType)cardPayPaymentType {
    if ([CRKPaymentConfig sharedConfig].iappPayInfo) {
        return CRKPaymentTypeIAppPay;
    }
    return CRKPaymentTypeNone;
}

- (CRKPaymentType)qqPaymentType {
    if ([CRKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.unsignedIntegerValue & CRKSubPayTypeQQ) {
        return CRKPaymentTypeVIAPay;
    }
    return CRKPaymentTypeNone;
}

- (void)handleOpenURL:(NSURL *)url {
    //    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
    //    [WXApi handleOpenURL:url delegate:self];
    //    [[PayUitls getIntents] paytoAli:url];
    if ([url.absoluteString rangeOfString:kIappPaySchemeUrl].location == 0) {
        [[IappPayMananger sharedMananger] handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:kAlipaySchemeUrl].location == 0) {
        [[PayUitls getIntents] paytoAli:url];
    }
}


- (CRKPaymentInfo *)startPaymentWithType:(CRKPaymentType)type
                                 subType:(CRKSubPayType)subType
                                   price:(NSUInteger)price
                              forProgram:(CRKProgram *)program
                               inChannel:(CRKChannel *)channel
                         programLocation:(NSInteger)programLocation
                       completionHandler:(CRKPaymentCompletionHandler)handler
{
    if (type == CRKPaymentTypeNone) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return nil;
    }
#if DEBUG
    price = 200;
#endif
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
    
    if (type == CRKPaymentTypeVIAPay && (subType == CRKSubPayTypeWeChat || subType == CRKSubPayTypeAlipay || subType == CRKSubPayTypeQQ)) {
        
        NSDictionary *viaPayTypeMapping = @{@(CRKSubPayTypeAlipay):@(CRKVIAPayTypeShenZhou),
                                            @(CRKSubPayTypeWeChat):@(CRKVIAPayTypeWeChat),
                                            @(CRKSubPayTypeQQ):@(CRKVIAPayTypeQQ)};
        NSString *tradeName = @"VIP会员";
        [[PayUitls getIntents]   gotoPayByFee:@(price).stringValue
                                 andTradeName:tradeName
                              andGoodsDetails:tradeName
                                    andScheme:kAlipaySchemeUrl
                            andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", CRK_REST_APP_ID]
                                      andType:[viaPayTypeMapping[@(subType)] stringValue]
                             andViewControler:[CRKUtil currentVisibleViewController]];
    }else if (type == CRKPaymentTypeIAppPay){
        @weakify(self);
        IappPayMananger *iAppMgr = [IappPayMananger sharedMananger];
        iAppMgr.appId = [CRKPaymentConfig sharedConfig].iappPayInfo.appid;
        iAppMgr.privateKey = [CRKPaymentConfig sharedConfig].iappPayInfo.privateKey;
        iAppMgr.waresid = [CRKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
        iAppMgr.appUserId = [CRKUtil userId] ?: @"UnregisterUser";
        iAppMgr.privateInfo = CRK_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [CRKPaymentConfig sharedConfig].iappPayInfo.notifyUrl;
        iAppMgr.publicKey = [CRKPaymentConfig sharedConfig].iappPayInfo.publicKey;
        
        [iAppMgr payWithPaymentInfo:paymentInfo payType:subType completionHandler:^(PAYRESULT payResult, CRKPaymentInfo *paymentInfo) {
            @strongify(self);
            
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
        
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}

//- (void)checkPayment {
//    NSArray<CRKPaymentInfo *> *payingPaymentInfos = [CRKUtil payingPaymentInfos];
//    [payingPaymentInfos enumerateObjectsUsingBlock:^(CRKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CRKPaymentType paymentType = obj.paymentType.unsignedIntegerValue;
//        if (paymentType == CRKPaymentTypeWeChatPay) {
//            if (obj.appId.length == 0 || obj.mchId.length == 0 || obj.signKey.length == 0 || obj.notifyUrl.length == 0) {
//                obj.appId = [CRKPaymentConfig sharedConfig].weixinInfo.appId;
//                obj.mchId = [CRKPaymentConfig sharedConfig].weixinInfo.mchId;
//                obj.signKey = [CRKPaymentConfig sharedConfig].weixinInfo.signKey;
//                obj.notifyUrl = [CRKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
//            }
//            
//            [self.wechatPayOrderQueryRequest queryPayment:obj withCompletionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
//                if ([trade_state isEqualToString:@"SUCCESS"]) {
//                    CRKPaymentViewController *paymentVC = [CRKPaymentViewController sharedPaymentVC];
//                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
//                    [self onPaymentResult:PAYRESULT_SUCCESS];
//                }
//            }];
//        }
//    }];
//}

- (void)onPaymentResult:(PAYRESULT)payResult {
    if (payResult == PAYRESULT_SUCCESS) {
        [[CRKLocalNotificationManager sharedManager] cancelAllNotifications];
    }
}

#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    if (paymentResult == PAYRESULT_FAIL) {
        DLog(@"首游时空支付失败：%@", sender[@"info"]);
        //    } else if (paymentResult == PAYRESULT_SUCCESS) {
        //        UIViewController *currentController = [CRKUtil currentVisibleViewController];
        //        if ([currentController isKindOfClass:NSClassFromString(@"SZFViewController")]) {
        //            [currentController dismissViewControllerAnimated:YES completion:nil];
        //        }
    }
    
    //    [self onPaymentResult:paymentResult withPaymentInfo:self.paymentInfo];
    
    if (self.completionHandler) {
        if ([NSThread currentThread].isMainThread) {
            self.completionHandler(paymentResult, self.paymentInfo);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(paymentResult, self.paymentInfo);
            });
        }
    }
}

//#pragma mark - IapppayAlphaKitPayRetDelegate
//
//- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
//    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(PAYRESULT_SUCCESS),
//                                           @(IapppayAlphaKitPayRetFailedCode):@(PAYRESULT_FAIL),
//                                           @(IapppayAlphaKitPayRetCancelCode):@(PAYRESULT_ABANDON)};
//    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
//    if (!paymentResult) {
//        paymentResult = @(PAYRESULT_UNKNOWN);
//    }
//    
//    [self onPaymentResult:paymentResult.integerValue];
//    
//    if (self.completionHandler) {
//        self.completionHandler(paymentResult.integerValue, self.paymentInfo);
//    }
//}

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
