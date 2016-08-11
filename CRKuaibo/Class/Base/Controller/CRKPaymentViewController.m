//
//  CRKPaymentViewController.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "CRKPaymentViewController.h"
#import "CRKPaymentPopView.h"
#import "CRKSystemConfigModel.h"
#import "CRKPaymentModel.h"
#import <objc/runtime.h>
#import "CRKPaymentInfo.h"
#import "CRKPaymentConfig.h"

@interface CRKPaymentViewController ()
@property (nonatomic,retain) CRKPaymentPopView *popView;
@property (nonatomic) NSNumber *payAmount;

@property (nonatomic,retain) CRKProgram *programToPayFor;
@property (nonatomic) NSUInteger programLocationToPayFor;
@property (nonatomic,retain) CRKChannel *channelToPayFor;

//@property (nonatomic,retain) CRKPaymentInfo *paymentInfo;

//@property (nonatomic,readonly,retain) NSDictionary *paymentTypeMap;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) NSUInteger closeSeq;
@end

@implementation CRKPaymentViewController

+ (instancetype)sharedPaymentVC {
    static CRKPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[CRKPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (CRKPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    @weakify(self);
    void (^Pay)(CRKPaymentType type, CRKSubPayType subType) = ^(CRKPaymentType type, CRKSubPayType subType)
    {
        @strongify(self);
        [self payForPaymentType:type paymentSubType:subType];
        [self hidePayment];
    };
    
    _popView = [[CRKPaymentPopView alloc] init];
    _popView.backgroundColor = [UIColor colorWithHexString:@"#121212"];
    //    _popView.headerImageURL = [NSURL URLWithString:[CRKSystemConfigModel sharedModel].hasDiscount ? [CRKSystemConfigModel sharedModel].discountImage : [CRKSystemConfigModel sharedModel].paymentImage];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    
    CRKPaymentType wechatPay = [[CRKPaymentManager sharedManager] wechatPaymentType];
    if (wechatPay != CRKPaymentTypeNone) {
        
        //微信支付    首游
        //微信支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#05c30b"] action:^(id sender) {
            Pay(wechatPay, CRKSubPayTypeWeChat);
        }];
    }
    
    CRKPaymentType alipay = [[CRKPaymentManager sharedManager] alipayPaymentType];
    if (alipay != CRKPaymentTypeNone) {
        
        //支付宝支付  首游时空
        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#02a0e9"] action:^(id sender) {
            Pay(alipay, CRKSubPayTypeAlipay);
        }];    }
    
    CRKPaymentType qqPaymentType = [[CRKPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != CRKPaymentTypeNone) {
        [_popView addPaymentWithImage:[UIImage imageNamed:@"qq_icon"] title:@"QQ钱包" subtitle:nil backgroundColor:[UIColor redColor] action:^(id sender) {
            Pay(qqPaymentType, CRKSubPayTypeQQ);
        }];
    }
    
    //    CRKPaymentType cardType = [[CRKPaymentManager sharedManager] cardPayPaymentType];
    //    if (cardType != CRKPaymentTypeNone) {
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"card_pay_icon"] title:@"购卡支付" subtitle:@"支持微信和支付宝" backgroundColor:[UIColor darkPink] action:^(id obj) {
    //            Pay(cardType,CRKSubPayTypeUnknown);
    //        }];
    //    }
    
    //    if ([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & CRKSubPayTypeAlipay) {
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
    //            Pay(CRKPaymentTypeIAppPay, CRKPaymentTypeAlipay);
    //        }];
    //    }
    //    
    //    if ([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & CRKSubPayTypeWeChat) {
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信客户端支付" available:YES action:^(id sender) {
    //            Pay(CRKPaymentTypeIAppPay, CRKPaymentTypeWeChatPay);
    //        }];
    //    }
    //    if (([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & CRKIAppPayTypeWeChat)
    //        || [CRKPaymentConfig sharedConfig].weixinInfo) {
    //        BOOL useBuildInWeChatPay = [CRKPaymentConfig sharedConfig].weixinInfo != nil;
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信客户端支付" available:YES action:^(id sender) {
    //            Pay(useBuildInWeChatPay?CRKPaymentTypeWeChatPay:CRKPaymentTypeIAppPay, useBuildInWeChatPay?CRKPaymentTypeNone:CRKPaymentTypeWeChatPay);
    //        }];
    //    }
    //    
    //    if (([CRKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & CRKIAppPayTypeAlipay)
    //        || [CRKPaymentConfig sharedConfig].alipayInfo) {
    //        BOOL useBuildInAlipay = [CRKPaymentConfig sharedConfig].alipayInfo != nil;
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
    //            Pay(useBuildInAlipay?CRKPaymentTypeAlipay:CRKPaymentTypeIAppPay, useBuildInAlipay?CRKPaymentTypeNone:CRKPaymentTypeAlipay);
    //        }];
    //    }
    //    
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        
        [[CRKStatsManager sharedManager] statsPayWithOrderNo:nil payAction:CRKStatsPayActionClose payResult:PAYRESULT_UNKNOWN forProgram:self.programToPayFor programLocation:self.programLocationToPayFor inChannel:self.channelToPayFor andTabIndex:[CRKUtil currentTabPageIndex] subTabIndex:[CRKUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:self.popView];
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kScreenWidth * 0.95;
            make.size.mas_equalTo(CGSizeMake(width, [self.popView viewHeightRelativeToWidth:width]));
        }];
    }
}

- (void)popupPaymentInView:(UIView *)view
                forProgram:(CRKProgram *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(CRKChannel *)channel
     withCompletionHandler:(void (^)(void))completionHandler
{
    self.completionHandler = completionHandler;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    
    self.payAmount = nil;
    self.programToPayFor = program;
    self.programLocationToPayFor = programLocation;
    self.channelToPayFor = channel;
    self.popView.headerImageURL = [NSURL URLWithString:[[CRKSystemConfigModel sharedModel] paymentImageWithProgram:program]];
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:[CRKHudManager manager].hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0;
    }];
    
    [self fetchPayAmount];
}

- (void)fetchPayAmount {
    @weakify(self);
    CRKSystemConfigModel *systemConfigModel = [CRKSystemConfigModel sharedModel];
    if (systemConfigModel.loaded) {
        self.payAmount = @([systemConfigModel paymentPriceWithProgram:self.programToPayFor]);
    } else {
        [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            @strongify(self);
            if (success) {
                self.payAmount = @([systemConfigModel paymentPriceWithProgram:self.programToPayFor]);
            }
        }];
    }
}

- (void)setPayAmount:(NSNumber *)payAmount {
    //#ifdef DEBUG
    //    payAmount = @(0.1);
    //#endif
    _payAmount = payAmount;
    self.popView.showPrice = @(payAmount.doubleValue / 100);
}

- (void)hidePayment {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        
        self.programToPayFor = nil;
        self.programLocationToPayFor = 0;
        self.channelToPayFor = nil;
        
        ++self.closeSeq;
        if (self.closeSeq == 2 && ![CRKUtil isPaid]) {
            [CRKUtil showSpreadBanner];
        }
    }];
}

- (void)payForPaymentType:(CRKPaymentType)paymentType
           paymentSubType:(CRKSubPayType)paymentSubType {
    if (!self.payAmount) {
        [[CRKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
        return ;
    }
    
    @weakify(self);
    CRKPaymentInfo *paymentInfo = [[CRKPaymentManager sharedManager] startPaymentWithType:paymentType
                                                                                  subType:paymentSubType
                                                                                    price:self.payAmount.unsignedIntegerValue
                                                                               forProgram:self.programToPayFor
                                                                                inChannel:self.channelToPayFor
                                                                          programLocation:self.programLocationToPayFor
                                                                        completionHandler:^(PAYRESULT payResult, CRKPaymentInfo *paymentInfo)
                                   {
                                       @strongify(self);
                                       [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                   }];
    if (paymentInfo) {
        [[CRKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:CRKStatsPayActionGoToPay andTabIndex:[CRKUtil currentTabPageIndex] subTabIndex:[CRKUtil currentSubTabPageIndex]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(CRKPaymentInfo *)paymentInfo {
    if (result == PAYRESULT_SUCCESS && [CRKUtil isPaid]) {
        return ;
    }
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(CRKPaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    if (result == PAYRESULT_SUCCESS) {
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        [CRKUtil showSpreadBanner];
    } else if (result == PAYRESULT_ABANDON) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[CRKPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    
    [[CRKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:CRKStatsPayActionPayBack andTabIndex:[CRKUtil currentTabPageIndex] subTabIndex:[CRKUtil currentSubTabPageIndex]];
}

@end
