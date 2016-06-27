//
//  CRKCommonDef.h
//  CRKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef CRKCommonDef_h
#define CRKCommonDef_h

typedef NS_ENUM(NSUInteger, CRKPaymentType) {
    CRKPaymentTypeNone,
    CRKPaymentTypeAlipay = 1001,
    CRKPaymentTypeWeChatPay = 1008,
    CRKPaymentTypeIAppPay = 1009,
    CRKPaymentTypeVIAPay = 1010,
    CRKPaymentTypeSPay = 1012
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

@class CRKPaymentInfo;
typedef void (^CRKAction)(id obj);
typedef void (^CRKCompletionHandler)(BOOL success, id obj);
typedef void (^CRKPaymentCompletionHandler)(PAYRESULT payResult, CRKPaymentInfo *paymentInfo);
#endif /* CRKCommonDef_h */
