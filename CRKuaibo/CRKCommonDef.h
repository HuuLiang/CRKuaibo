//
//  CRKCommonDef.h
//  CRKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef CRKCommonDef_h
#define CRKCommonDef_h

typedef NS_ENUM(NSUInteger, CRKDeviceType) {
    CRKDeviceTypeUnknown,
    CRKDeviceType_iPhone4,
    CRKDeviceType_iPhone4S,
    CRKDeviceType_iPhone5,
    CRKDeviceType_iPhone5C,
    CRKDeviceType_iPhone5S,
    CRKDeviceType_iPhone6,
    CRKDeviceType_iPhone6P,
    CRKDeviceType_iPhone6S,
    CRKDeviceType_iPhone6SP,
    CRKDeviceType_iPhoneSE,
    CRKDeviceType_iPad = 100
};

typedef NS_ENUM(NSUInteger, CRKPaymentType) {
    CRKPaymentTypeNone,
    CRKPaymentTypeAlipay = 1001,
    CRKPaymentTypeWeChatPay = 1008,
    CRKPaymentTypeIAppPay = 1009,
    CRKPaymentTypeVIAPay = 1010,
    CRKPaymentTypeSPay = 1012,
    CRKPaymentTypeHTPay = 1015
};

typedef NS_ENUM(NSUInteger, CRKSubPayType) {
    CRKSubPayTypeUnknown = 0,
    CRKSubPayTypeWeChat = 1 << 0,
    CRKSubPayTypeAlipay = 1 << 1,
    CRKSubPayUPPay = 1 << 2,
    CRKSubPayTypeQQ = 1 << 3
};

typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};

typedef NS_ENUM(NSUInteger, CRKPayPointType) {
    CRKPayPointTypeNone,
    CRKPayPointTypeVIP,
    CRKPayPointTypeSVIP
};

typedef NS_ENUM(NSUInteger, CRKVideoSpec) {
    CRKVideoSpecNone,
    CRKVideoSpecHot,
    CRKVideoSpecNew,
    CRKVideoSpecHD,
    CRKVideoSpecFree
};

typedef NS_ENUM(NSUInteger, CRKCurrentHomePage) {
    CRKHomePageOM,
    CRKHomePageRH,
    CRKHomePageDL
};

//typedef NS_ENUM(NSUInteger, CRKChannelType) {
// 
//};

// DLog
#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define SafelyCallBlock(block,...) \
    if (block) block(__VA_ARGS__);

#define kScreenHeight     [ [ UIScreen mainScreen ] bounds ].size.height
#define kScreenWidth      [ [ UIScreen mainScreen ] bounds ].size.width

#define kPaidNotificationName @"crkuaibo_paid_notification"
#define kDefaultDateFormat    @"yyyyMMddHHmmss"
#define kDefaultCollectionViewInteritemSpace  (3)

#define kBoldMediumFont [UIFont boldSystemFontOfSize:MIN(16, kScreenWidth*0.045)]
#define kExExSmallFont [UIFont systemFontOfSize:MIN(10, kScreenWidth*0.03)]

@class CRKPaymentInfo;
typedef void (^CRKAction)(id obj);
typedef void (^CRKCompletionHandler)(BOOL success, id obj);
typedef void (^CRKPaymentCompletionHandler)(PAYRESULT payResult, CRKPaymentInfo *paymentInfo);
#endif /* CRKCommonDef_h */
