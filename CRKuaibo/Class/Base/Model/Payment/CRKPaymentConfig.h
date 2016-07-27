//
//  CRKPaymentConfig.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKURLResponse.h"

//typedef NS_ENUM(NSUInteger, CRKSubPayType) {
//    CRKSubPayTypeUnknown = 0,
//    CRKSubPayTypeWeChat = 1 << 0,
//    CRKSubPayTypeAlipay = 1 << 1
//};

@interface CRKWeChatPaymentConfig : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

//+ (instancetype)defaultConfig;
@end

@interface CRKAlipayConfig : NSObject
@property (nonatomic) NSString *partner;
@property (nonatomic) NSString *seller;
@property (nonatomic) NSString *productInfo;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@end

@interface CRKIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;
@property (nonatomic) NSString *publicKey;


//+ (instancetype)defaultConfig;
@end

@interface CRKVIAPayConfig : NSObject

//@property (nonatomic) NSString *packageId;
@property (nonatomic) NSNumber *supportPayTypes;

@end

@interface CRKSPayConfig : NSObject
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface CRKHTPayConfig : NSObject
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end


@interface CRKPaymentConfig : CRKURLResponse

@property (nonatomic,retain) CRKWeChatPaymentConfig *weixinInfo;
@property (nonatomic,retain) CRKAlipayConfig *alipayInfo;
@property (nonatomic,retain) CRKIAppPayConfig *iappPayInfo;
@property (nonatomic,retain) CRKVIAPayConfig *syskPayInfo;
@property (nonatomic,retain) CRKSPayConfig *wftPayInfo;
@property (nonatomic,retain) CRKHTPayConfig *haitunPayInfo;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;

@end
