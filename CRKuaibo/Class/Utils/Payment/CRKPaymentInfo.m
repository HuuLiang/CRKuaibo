//
//  CRKPaymentInfo.m
//  crkuaibov
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 crkuaibov. All rights reserved.
//

#import "CRKPaymentInfo.h"
#import "NSMutableDictionary+SafeCoding.h"

static NSString *const kPaymentInfoPaymentIdKeyName = @"crkuaibov_paymentinfo_paymentid_keyname";
static NSString *const kPaymentInfoOrderIdKeyName = @"crkuaibov_paymentinfo_orderid_keyname";
static NSString *const kPaymentInfoOrderPriceKeyName = @"crkuaibov_paymentinfo_orderprice_keyname";
static NSString *const kPaymentInfoContentIdKeyName = @"crkuaibov_paymentinfo_contentid_keyname";
static NSString *const kPaymentInfoContentTypeKeyName = @"crkuaibov_paymentinfo_contenttype_keyname";
static NSString *const kPaymentInfoContentLocationKeyName = @"crkuaibov_paymentinfo_contentlocation_keyname";
static NSString *const kPaymentInfoColumnIdKeyName = @"crkuaibov_paymentinfo_columnid_keyname";
static NSString *const kPaymentInfoColumnTypeKeyName = @"crkuaibov_paymentinfo_columntype_keyname";
static NSString *const kPaymentInfoPayPointTypeKeyName = @"crkuaibov_paymentinfo_paypointtype_keyname";
static NSString *const kPaymentInfoPaymentTypeKeyName = @"crkuaibov_paymentinfo_paymenttype_keyname";
static NSString *const kPaymentInfoPaymentResultKeyName = @"crkuaibov_paymentinfo_paymentresult_keyname";
static NSString *const kPaymentInfoPaymentStatusKeyName = @"crkuaibov_paymentinfo_paymentstatus_keyname";
static NSString *const kPaymentInfoPaymentTimeKeyName = @"crkuaibov_paymentinfo_paymenttime_keyname";
static NSString *const kPaymentInfoPaymentReservedDataKeyName = @"crkuaibov_paymentinfo_paymentreserveddata_keyname";

static NSString *const kPaymentInfoPaymentAppId = @"crkuaibov_paymentinfo_paymentappid_keyname";
static NSString *const kPaymentInfoPaymentMchId = @"crkuaibov_paymentinfo_paymentmchid_keyname";
static NSString *const kPaymentInfoPaymentSignKey = @"crkuaibov_paymentinfo_paymentsignkey_keyname";
static NSString *const kPaymentInfoPaymentNotifyUrl = @"crkuaibov_paymentinfo_paymentnotifyurl_keyname";

@implementation CRKPaymentInfo

- (NSString *)paymentId {
    if (_paymentId) {
        return _paymentId;
    }
    
    _paymentId = [NSUUID UUID].UUIDString.md5;
    return _paymentId;
}

+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment {
    CRKPaymentInfo *paymentInfo = [[self alloc] init];
    paymentInfo.paymentId = payment[kPaymentInfoPaymentIdKeyName];
    paymentInfo.orderId = payment[kPaymentInfoOrderIdKeyName];
    paymentInfo.orderPrice = payment[kPaymentInfoOrderPriceKeyName];
    paymentInfo.contentId = payment[kPaymentInfoContentIdKeyName];
    paymentInfo.contentType = payment[kPaymentInfoContentTypeKeyName];
    paymentInfo.contentLocation = payment[kPaymentInfoContentLocationKeyName];
    paymentInfo.columnId = payment[kPaymentInfoColumnIdKeyName];
    paymentInfo.columnType = payment[kPaymentInfoColumnTypeKeyName];
    paymentInfo.payPointType = payment[kPaymentInfoPayPointTypeKeyName];
    paymentInfo.paymentType = payment[kPaymentInfoPaymentTypeKeyName];
    paymentInfo.paymentResult = payment[kPaymentInfoPaymentResultKeyName];
    paymentInfo.paymentStatus = payment[kPaymentInfoPaymentStatusKeyName];
    paymentInfo.paymentTime = payment[kPaymentInfoPaymentTimeKeyName];
    paymentInfo.reservedData = payment[kPaymentInfoPaymentReservedDataKeyName];
    paymentInfo.appId = payment[kPaymentInfoPaymentAppId];
    paymentInfo.mchId = payment[kPaymentInfoPaymentMchId];
    paymentInfo.notifyUrl = payment[kPaymentInfoPaymentNotifyUrl];
    paymentInfo.signKey = payment[kPaymentInfoPaymentSignKey];
    return paymentInfo;
}

- (NSDictionary *)dictionaryFromCurrentPaymentInfo {
    NSMutableDictionary *payment = [NSMutableDictionary dictionary];
    [payment safelySetObject:self.paymentId forKey:kPaymentInfoPaymentIdKeyName];
    [payment safelySetObject:self.orderId forKey:kPaymentInfoOrderIdKeyName];
    [payment safelySetObject:self.orderPrice forKey:kPaymentInfoOrderPriceKeyName];
    [payment safelySetObject:self.contentId forKey:kPaymentInfoContentIdKeyName];
    [payment safelySetObject:self.contentType forKey:kPaymentInfoContentTypeKeyName];
    [payment safelySetObject:self.contentLocation forKey:kPaymentInfoContentLocationKeyName];
    [payment safelySetObject:self.columnId forKey:kPaymentInfoColumnIdKeyName];
    [payment safelySetObject:self.columnType forKey:kPaymentInfoColumnTypeKeyName];
    [payment safelySetObject:self.payPointType forKey:kPaymentInfoPayPointTypeKeyName];
    [payment safelySetObject:self.paymentType forKey:kPaymentInfoPaymentTypeKeyName];
    [payment safelySetObject:self.paymentResult forKey:kPaymentInfoPaymentResultKeyName];
    [payment safelySetObject:self.paymentStatus forKey:kPaymentInfoPaymentStatusKeyName];
    [payment safelySetObject:self.paymentTime forKey:kPaymentInfoPaymentTimeKeyName];
    [payment safelySetObject:self.reservedData forKey:kPaymentInfoPaymentReservedDataKeyName];
    [payment safelySetObject:self.appId forKey:kPaymentInfoPaymentAppId];
    [payment safelySetObject:self.mchId forKey:kPaymentInfoPaymentMchId];
    [payment safelySetObject:self.notifyUrl forKey:kPaymentInfoPaymentNotifyUrl];
    [payment safelySetObject:self.signKey forKey:kPaymentInfoPaymentSignKey];
    return payment;
}

- (void)save {
    NSArray *paymentInfos = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfosM = [paymentInfos mutableCopy];
    if (!paymentInfosM) {
        paymentInfosM = [NSMutableArray array];
    }
    
    NSDictionary *payment = [paymentInfos bk_match:^BOOL(id obj) {
        NSString *paymentId = ((NSDictionary *)obj)[kPaymentInfoPaymentIdKeyName];
        if ([paymentId isEqualToString:self.paymentId]) {
            return YES;
        }
        return NO;
    }];
    
    if (payment) {
        [paymentInfosM removeObject:payment];
    }
    
    payment = [self dictionaryFromCurrentPaymentInfo];
    [paymentInfosM addObject:payment];
    
    [[NSUserDefaults standardUserDefaults] setObject:paymentInfosM forKey:kPaymentInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"Save payment info: %@", payment);
}

@end
