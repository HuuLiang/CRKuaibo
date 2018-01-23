//
//  CRKSystemConfigModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKSystemConfigModel.h"

NSString *const kSystemConfigModelVipKeyPrice = @"crkuaibov_systemconfigModel_vip_keyprice";
NSString *const kSystemConfigModelSVipKeyPrice = @"crkuaibov_systemconfigModel_svip_keyprice";

@implementation CRKSystemConfigResponse

- (Class)confisElementClass {
    return [CRKSystemConfig class];
}

@end

@implementation CRKSystemConfigModel

+ (instancetype)sharedModel {
    static CRKSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[CRKSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _discountAmount = -1;
        _discountLaunchSeq = -1;
        _notificationLaunchSeq = -1;
        _notificationBackgroundDelay = -1;
    }
    return self;
}

+ (Class)responseClass {
    return [CRKSystemConfigResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(CRKFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:CRK_SYSTEM_CONFIG_URL
                         standbyURLPath:CRK_STANDBY_SYSTEM_CONFIG_URL
                             withParams:@{@"type" : @([CRKUtil deviceType])}
                        responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (respStatus == CRKURLResponseSuccess) {
                            CRKSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                CRKSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PAY_AMOUNT]) {
                                    self.payAmount = config.value.integerValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SVIP_PAY_AMOUNT]) {
                                    self.svipPayAmount = config.value.integerValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PAY_IMG]) {
                                    self.paymentImage = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SVIP_PAY_IMG]) {
                                    self.svipPaymentImage = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_DISCOUNT_IMG]) {
                                    self.discountImage = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE]) {
                                    self.channelTopImage = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_STARTUP_INSTALL]) {
                                    self.startupInstall = config.value;
                                    self.startupPrompt = config.memo;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE]) {
                                    self.spreadTopImage = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_URL]) {
                                    self.spreadURL = config.value;
                                    //                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE]) {
                                    //                    self.spreadLeftImage = config.value;
                                    //                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_LEFT_URL]) {
                                    //                    self.spreadLeftUrl = config.value;
                                    //                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE]) {
                                    //                    self.spreadRightImage = config.value;
                                    //                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SPREAD_RIGHT_URL]) {
                                    //                    self.spreadRightUrl = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_CONTACT]) {
                                    self.contact = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_CONTACT_TIME]) {
                                    self.contactTime = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_DISCOUNT_AMOUNT]) {
                                    self.discountAmount = config.value.floatValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_DISCOUNT_LAUNCH_SEQ]) {
                                    self.discountLaunchSeq = config.value.integerValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_NOTIFICATION_LAUNCH_SEQ]) {
                                    self.notificationLaunchSeq = config.value.integerValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_NOTIFICATION_BACKGROUND_DELAY]) {
                                    self.notificationBackgroundDelay = config.value.integerValue;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_NOTIFICATION_TEXT]) {
                                    self.notificationText = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_NOTIFICATION_REPEAT_TIMES]) {
                                    self.notificationRepeatTimes = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PRICE_MIN]){
                                    self.priceMin = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PRICE_MAX]){
                                    self.priceMax = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_PRICE_EXCLUDE]){
                                    self.priceExclude = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SVIPPRICE_MIN]){
                                    self.svipPriceMin = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SVIPPRICE_MAX]){
                                    self.svipPriceMax = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_SVIPPRICE_EXCLUDE]){
                                    self.svipPriceExclude = config.value;
                                } else if ([config.name isEqualToString:CRK_SYSTEM_CONFIG_STATS_TIME_INTERVAL]) {
                                    self.statsTimeInterval = config.value.integerValue;
                                }
                                
                            }];
                            
                            //
                            _loaded = YES;
                            [self saveRandomPayAmount];
                        }
                        
                        if (handler) {
                            handler(respStatus==CRKURLResponseSuccess);
                        }
                    }];
    return success;
}
//本地生成的价格
- (void)saveRandomPayAmount {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *vipPayAmount = [defaults objectForKey:kSystemConfigModelVipKeyPrice];
    NSString *SVipPayAmount = [defaults objectForKey:kSystemConfigModelSVipKeyPrice];
    //VIP价格
    if (!vipPayAmount) {
        NSString *vipPrice = [self PayAmountWithPriceMin:_priceMin priceMax:_priceMax priceExclude:_priceExclude];
        if (vipPrice) {
            [defaults setObject:vipPrice forKey:kSystemConfigModelVipKeyPrice];
            [defaults synchronize];
        }
    }
    //SVIP价格
    if (!SVipPayAmount) {
        NSString *SVipPrice = [self PayAmountWithPriceMin:_svipPriceMin priceMax:_svipPriceMax priceExclude:_svipPriceExclude];
        if (SVipPrice) {
            [defaults setObject:SVipPrice forKey:kSystemConfigModelSVipKeyPrice];
            [defaults synchronize];
        }
    }
    
}
//生成随机价格
- (NSString *)PayAmountWithPriceMin:(NSString *)priceMin priceMax:(NSString *)priceMax priceExclude:(NSString *)priceExclude {
    
    NSInteger min = [priceMin integerValue];
    NSInteger max = [priceMax integerValue];
    if (min > max) {
        return nil;
    }
    //把排除的价格添加到数组中
    NSArray *priceExcludeArr = [priceExclude componentsSeparatedByString:@","];
    //过滤掉重复数据
    NSSet *priceExcludeSet = [NSSet setWithArray:priceExcludeArr];
    priceExcludeArr = [priceExcludeSet allObjects];
    
    for (NSInteger i = min/100;i <= max/100 ; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%ld",(long)i*100];
        
        if (![priceExcludeArr containsObject:str] ) {
            NSInteger price = 0;
            NSString *priceStr = nil;
            
            do {
                
                price = min/100 + arc4random()%(max/100 - min/100 +1);
                
                priceStr = [NSString stringWithFormat:@"%ld",(long)price*100];
                
            }while ([priceExcludeSet containsObject:priceStr] == YES);
            
            return priceStr;
        }
    }
    return nil;
}

- (NSUInteger)payAmount {
    NSString *payAmount = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigModelVipKeyPrice];
    
    NSUInteger payA = _payAmount;
    
    if (payAmount.integerValue>0) {
        payA = payAmount.integerValue;
    }
    
    if ([self hasDiscount]) {
        payA = payA * self.discountAmount;
    }
    return payA;
}

- (NSUInteger)svipPayAmount {
    NSString *SvippayAmount = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigModelSVipKeyPrice];
    
    if (SvippayAmount) {
        return SvippayAmount.integerValue;
    } else {
        return _svipPayAmount;
    }
}

- (BOOL)hasDiscount {
    if (self.discountAmount > 0 && self.discountAmount <= 1 && self.discountLaunchSeq >= 0 && [CRKUtil launchSeq] >= self.discountLaunchSeq) {
        return YES;
    }
    return NO;
}

- (NSUInteger)paymentPriceWithProgram:(CRKProgram *)program {
    return self.payAmount;
}

- (NSString *)paymentImageWithProgram:(CRKProgram *)program {
    if ([self hasDiscount]) {
        return self.discountImage;
    } else {
        return self.paymentImage;
    }
}
@end
