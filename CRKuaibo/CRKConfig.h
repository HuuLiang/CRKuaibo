//
//  CRKConfig.h
//  CRKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef CRKConfig_h
#define CRKConfig_h

#import "CRKConfiguration.h"

#define CRK_CHANNEL_NO           [CRKConfiguration sharedConfig].channelNo
#define CRK_REST_APP_ID          @"QUBA_2022"
#define CRK_REST_PV              @100  //100
#define CRK_PAYMENT_PV           @103
#define CRK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."
#define CRK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", CRK_REST_APP_ID, CRK_CHANNEL_NO]

#define CRK_BASE_URL             @"http://iv.zcqcmj.com"//@"http://120.24.252.114:8093" //
#define CRK_UMENG_APP_ID         @"56e653d767e58e0eb7002156"

#define CRK_HOME_VIDEO_URL              @"/iosvideo/channelRanking.htm"//@"/iosvideo/homePage.htm"//首页
#define CRK_HOME_SUB_VIDEO_URL    @"/iosvideo/columnProgram.htm"

//#define CRK_VIDEO_LIB_URL               @"/iosvideo/hotVideo.htm"
#define CRK_HOT_VIDEO_URL               @"/iosvideo/hotFilm.htm"

#define CRK_CHANNEL_URL                 @"/iosvideo/channel.htm"
#define CRK_CHANNEL_PROGRAM_URL         @"/iosvideo/program.htm"

#define CRK_VIP_VIDEO_URL               @"/iosvideo/vipvideo.htm"
#define CRK_APP_SPREAD_LIST_URL         @"/iosvideo/appSpreadList.htm"
#define CRK_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define CRK_ACTIVATE_URL                @"/iosvideo/activat.htm"
#define CRK_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define CRK_USER_ACCESS_URL             @"/iosvideo/userAccess.htm"
#define CRK_AGREEMENT_NOTPAID_URL       @"/iosvideo/agreement.html"
#define CRK_AGREEMENT_PAID_URL          @"/iosvideo/agreement-paid.html"

#define CRK_STATS_BASE_URL              @"http://stats.iqu8.cn"//@"http://120.24.252.114"//
#define CRK_STATS_CPC_URL               @"/stats/cpcs.service"
#define CRK_STATS_TAB_URL               @"/stats/tabStat.service"
#define CRK_STATS_PAY_URL               @"/stats/payRes.service"

#define CRK_PAYMENT_COMMIT_URL          @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"//
#define CRK_PAYMENT_CONFIG_URL          @"http://pay.zcqcmj.com/paycenter/payConfig.json"//@"http://120.24.252.114:8084/paycenter/payConfig.json"//
#define CRK_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define CRK_STANDBY_BASE_URL                @"http://appcdn.mqu8.com"
#define CRK_STANDBY_HOME_VIDEO_URL          @"/static/iosvideo/homePage.json"

//#define CRK_STANDBY_VIDEO_LIB_URL           @"/static/iosvideo/hotVideo.json"
#define CRK_STANDBY_HOT_VIDEO_URL           @"/static/iosvideo/hotFilm.json"
#define CRK_STANDBY_VIP_VIDEO_URL           @"/static/iosvideo/vipvideo.json"
#define CRK_STANDBY_CHANNEL_URL             @"/static/iosvideo/channelRanking.json"
#define CRK_STANDBY_CHANNEL_PROGRAM_URL     @"/static/iosvideo/program_%@_%@.json"
#define CRK_STANDBY_APP_SPREAD_LIST_URL     @"/static/iosvideo/appSpreadList.json"
#define CRK_STANDBY_APP_SPREAD_BANNER_URL   @"/static/iosvideo/appSpreadBanner.json"
#define CRK_STANDBY_SYSTEM_CONFIG_URL       @"/static/iosvideo/systemConfig.json"
#define CRK_STANDBY_AGREEMENT_NOTPAID_URL   @"/static/iosvideo/agreement.html"
#define CRK_STANDBY_AGREEMENT_PAID_URL      @"/static/iosvideo/agreement-paid.html"

#define CRK_APP_SPREAD_LIST_URL         @"/iosvideo/appSpreadList.htm"
#define CRK_STANDBY_APP_SPREAD_LIST_URL     @"/static/iosvideo/appSpreadList.json"


#define CRK_SYSTEM_CONFIG_PAY_AMOUNT            @"PAY_AMOUNT"
#define CRK_SYSTEM_CONFIG_SVIP_PAY_AMOUNT       @"SVIP_PAY_AMOUNT"
#define CRK_SYSTEM_CONFIG_CONTACT               @"CONTACT"
#define CRK_SYSTEM_CONFIG_CONTACT_TIME          @"CONTACT_TIME"
#define CRK_SYSTEM_CONFIG_PAY_IMG               @"PAY_IMG"
#define CRK_SYSTEM_CONFIG_SVIP_PAY_IMG          @"SVIP_PAY_IMG"
#define CRK_SYSTEM_CONFIG_DISCOUNT_IMG          @"DISCOUNT_IMG"
#define CRK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE     @"CHANNEL_TOP_IMG"
#define CRK_SYSTEM_CONFIG_STARTUP_INSTALL       @"START_INSTALL"
#define CRK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE      @"SPREAD_TOP_IMG"
#define CRK_SYSTEM_CONFIG_SPREAD_URL            @"SPREAD_URL"
#define CRK_SYSTEM_CONFIG_STATS_TIME_INTERVAL   @"STATS_TIME_INTERVAL"

//价格区间
#define CRK_SYSTEM_CONFIG_PRICE_MIN @"PAY_AMOUNT_RANGE_MIN"
#define CRK_SYSTEM_CONFIG_PRICE_MAX @"PAY_AMOUNT_RANGE_MAX"
#define CRK_SYSTEM_CONFIG_PRICE_EXCLUDE @"PAY_AMOUNT_RANGE_EXCLUDE"
//SVIP价格区间
#define CRK_SYSTEM_CONFIG_SVIPPRICE_MIN @"SVIP_PAY_AMOUNT_RANGE_MIN"
#define CRK_SYSTEM_CONFIG_SVIPPRICE_MAX @"SVIP_PAY_AMOUNT_RANGE_MAX"
#define CRK_SYSTEM_CONFIG_SVIPPRICE_EXCLUDE @"SVIP_PAY_AMOUNT_RANGE_EXCLUDE"

//#define CRK_SYSTEM_CONFIG_HALF_PAY_SEQ          @"HALF_PAY_LAUNCH_SEQ"
//#define CRK_SYSTEM_CONFIG_HALF_PAY_DELAY        @"HALF_PAY_LAUNCH_DELAY"
//#define CRK_SYSTEM_CONFIG_HALF_PAY_NOTIFICATION @"HALF_PAY_LAUNCH_NOTIFICATION"
//#define CRK_SYSTEM_CONFIG_HALF_PAY_NOTI_REPEAT_TIMES @"HALF_PAY_NOTI_REPEAT_TIMES"

#define CRK_SYSTEM_CONFIG_DISCOUNT_AMOUNT               @"DISCOUNT_AMOUNT"
#define CRK_SYSTEM_CONFIG_DISCOUNT_LAUNCH_SEQ           @"DISCOUNT_LAUNCH_SEQ"
#define CRK_SYSTEM_CONFIG_NOTIFICATION_LAUNCH_SEQ       @"NOTIFICATION_LAUNCH_SEQ"
#define CRK_SYSTEM_CONFIG_NOTIFICATION_BACKGROUND_DELAY @"NOTIFICATION_BACKGROUND_DELAY"
#define CRK_SYSTEM_CONFIG_NOTIFICATION_TEXT             @"NOTIFICATION_TEXT"
#define CRK_SYSTEM_CONFIG_NOTIFICATION_REPEAT_TIMES     @"NOTIFICATION_REPEAT_TIMES"

#define CRK_IAPPPAY_PLUGIN_TYPE                 (1009)
#endif /* CRKConfig_h */
