//
//  CRKSystemConfigModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
#import "CRKSystemConfig.h"

@class CRKProgram;
//支付弹框里面的图片以及商品的价格,及价格区间都在这里获取
@interface CRKSystemConfigResponse : CRKURLResponse
@property (nonatomic,retain) NSArray<CRKSystemConfig> *confis;
@end

typedef void (^CRKFetchSystemConfigCompletionHandler)(BOOL success);

@interface CRKSystemConfigModel : CRKEncryptedURLRequest

@property (nonatomic) NSUInteger payAmount;
@property (nonatomic) NSUInteger svipPayAmount;
@property (nonatomic) NSString *paymentImage;
@property (nonatomic) NSString *svipPaymentImage;
@property (nonatomic) NSString *discountImage;
@property (nonatomic) NSString *channelTopImage;
@property (nonatomic) NSString *spreadTopImage;
@property (nonatomic) NSString *spreadURL;

@property (nonatomic) NSString *startupInstall;
@property (nonatomic) NSString *startupPrompt;

@property (nonatomic) NSString *contact;
@property (nonatomic) NSString *contactTime;

@property (nonatomic) CGFloat discountAmount;
@property (nonatomic) NSInteger discountLaunchSeq;
@property (nonatomic) NSInteger notificationLaunchSeq;
@property (nonatomic) NSInteger notificationBackgroundDelay;
@property (nonatomic) NSString *notificationText;
@property (nonatomic) NSString *notificationRepeatTimes;

//价格区间
@property (nonatomic) NSString *priceMin;
@property (nonatomic) NSString *priceMax;
@property (nonatomic) NSString *priceExclude;

//SVIP价格区间
@property (nonatomic) NSString *svipPriceMin;
@property (nonatomic) NSString *svipPriceMax;
@property (nonatomic) NSString *svipPriceExclude;

@property (nonatomic) NSUInteger statsTimeInterval;

//@property (nonatomic) NSString *spreadLeftImage;
//@property (nonatomic) NSString *spreadLeftUrl;
//@property (nonatomic) NSString *spreadRightImage;
//@property (nonatomic) NSString *spreadRightUrl;

@property (nonatomic,readonly) BOOL loaded;
@property (nonatomic,readonly) BOOL hasDiscount;



+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(CRKFetchSystemConfigCompletionHandler)handler;
- (NSUInteger)paymentPriceWithProgram:(CRKProgram *)program;
- (NSString *)paymentImageWithProgram:(CRKProgram *)program;

@end
