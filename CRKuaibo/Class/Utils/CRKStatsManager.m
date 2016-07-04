//
//  CRKStatsManager.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKStatsManager.h"
#import "CRKCPCStatsModel.h"
#import "CRKTabStatsModel.h"
#import "CRKPayStatsModel.h"
#import "CRKPaymentInfo.h"
#import "MobClick.h"


static NSString *const kUmengCPCChannelEvent = @"CPC_CHANNEL";
static NSString *const kUmengCPCProgramEvent = @"CPC_PROGRAM";
static NSString *const kUmengTabEvent = @"TAB_STATS";
static NSString *const kUmengPayEvent = @"PAY_STATS";

@interface CRKStatsManager ()
@property (nonatomic,retain) dispatch_queue_t queue;
@property (nonatomic,retain,readonly) CRKCPCStatsModel *cpcStats;
@property (nonatomic,retain,readonly) CRKTabStatsModel *tabStats;
@property (nonatomic,retain,readonly) CRKPayStatsModel *payStats;
@property (nonatomic,retain,readonly) NSDate *statsDate;
@end

@implementation CRKStatsManager
@synthesize cpcStats = _cpcStats;
@synthesize tabStats = _tabStats;
@synthesize payStats = _payStats;

DefineLazyPropertyInitialization(CRKCPCStatsModel, cpcStats)
DefineLazyPropertyInitialization(CRKTabStatsModel, tabStats)
DefineLazyPropertyInitialization(CRKPayStatsModel, payStats)

- (dispatch_queue_t)queue {
    if (_queue) {
        return _queue;
    }
    
    _queue = dispatch_queue_create("com.CRKuaibo.app.statsq", nil);
    return _queue;
}

+ (instancetype)sharedManager {
    static CRKStatsManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statsDate = [NSDate date];
    }
    return self;
}

- (void)addStats:(CRKStatsInfo *)statsInfo {
    dispatch_async(self.queue, ^{
        [statsInfo save];
    });
}

- (void)removeStats:(NSArray<CRKStatsInfo *> *)statsInfos {
    dispatch_async(self.queue, ^{
        [CRKStatsInfo removeStatsInfos:statsInfos];
    });
}

- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            dispatch_async(self.queue, ^{
                [self uploadStatsInfos:[CRKStatsInfo allStatsInfos]];
            });
            sleep(timeInterval);
        }
    });
}

- (void)uploadStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos {
    if (statsInfos.count == 0) {
        return ;
    }
    
    
    NSArray<CRKStatsInfo *> *cpcStats = [statsInfos bk_select:^BOOL(CRKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeColumnCPC
        || statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeProgramCPC;
    }];
    
    NSArray<CRKStatsInfo *> *tabStats = [statsInfos bk_select:^BOOL(CRKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeTabCPC
        || statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeTabPanning
        || statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeTabStay
        || statsInfo.statsType.unsignedIntegerValue == CRKStatsTypeBannerPanning;
    }];
    
    NSArray<CRKStatsInfo *> *payStats = [statsInfos bk_select:^BOOL(CRKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == CRKStatsTypePay;
    }];
    
    if (cpcStats.count > 0) {
        DLog(@"Commit CPC stats...");
        [self.cpcStats statsCPCWithStatsInfos:cpcStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [CRKStatsInfo removeStatsInfos:cpcStats];
                DLog(@"Commit CPC stats successfully!");
            } else {
                DLog(@"Commit CPC stats with failure: %@", obj);
            }
        }];
    }
    
    if (tabStats.count > 0) {
        DLog(@"Commit TAB stats...");
        [self.tabStats statsTabWithStatsInfos:tabStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [CRKStatsInfo removeStatsInfos:tabStats];
                DLog(@"Commit TAB stats successfully");
            } else {
                DLog(@"Commint TAB stats with failure: %@", obj);
            }
        }];
    }
    
    if (payStats.count > 0) {
        DLog(@"Commit PAY stats...");
        [self.payStats statsPayWithStatsInfos:payStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [CRKStatsInfo removeStatsInfos:payStats];
                DLog(@"Commit PAY stats successfully!");
            } else {
                DLog(@"Commit PAY stats with failure: %@", obj);
            }
        }];
    }
}

- (void)statsCPCWithChannel:(CRKChannel *)channel inTabIndex:(NSUInteger)tabIndex {
    CRKStatsInfo *statsInfo = [[CRKStatsInfo alloc] init];
    statsInfo.tabpageId = @(tabIndex+1);
    statsInfo.columnId = channel.realColumnId;
    statsInfo.columnType = channel.type;
    statsInfo.statsType = @(CRKStatsTypeColumnCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCChannelEvent attributes:[statsInfo umengAttributes]];
}

- (void)statsCPCWithProgram:(CRKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(CRKChannel *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    CRKStatsInfo *statsInfo = [[CRKStatsInfo alloc] init];
    if (channel) {
        statsInfo.columnId = channel.realColumnId;
        statsInfo.columnType = channel.type;
    }
    statsInfo.tabpageId = @(tabIndex+1);
    if (subTabIndex != NSNotFound) {
        statsInfo.subTabpageId = @(subTabIndex+1);
    }
    
    statsInfo.programId = program.programId;
    statsInfo.programType = program.type;
    statsInfo.programLocation = @(programLocation+1);
    statsInfo.statsType = @(CRKStatsTypeProgramCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCProgramEvent attributes:statsInfo.umengAttributes];
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount {
    dispatch_async(self.queue, ^{
        NSArray<CRKStatsInfo *> *statsInfos = [CRKStatsInfo statsInfosWithStatsType:CRKStatsTypeTabCPC tabIndex:tabIndex subTabIndex:subTabIndex];
        CRKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[CRKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(CRKStatsTypeTabCPC);
        }
        
        statsInfo.clickCount = @(statsInfo.clickCount.unsignedIntegerValue + clickCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<CRKStatsInfo *> *statsInfos = [CRKStatsInfo statsInfosWithStatsType:CRKStatsTypeTabPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        CRKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[CRKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(CRKStatsTypeTabPanning);
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    dispatch_async(self.queue, ^{
        NSArray<CRKStatsInfo *> *statsInfos = [CRKStatsInfo statsInfosWithStatsType:CRKStatsTypeTabStay tabIndex:tabIndex subTabIndex:subTabIndex];
        CRKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[CRKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(CRKStatsTypeTabStay);
        }
        
        NSUInteger durationSinceStats = [[NSDate date] timeIntervalSinceDate:self.statsDate];
        statsInfo.stopDuration = @(statsInfo.stopDuration.unsignedIntegerValue + durationSinceStats);
        [statsInfo save];
        
        [self resetStatsDate];
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<CRKStatsInfo *> *statsInfos = [CRKStatsInfo statsInfosWithStatsType:CRKStatsTypeBannerPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        CRKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[CRKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            statsInfo.statsType = @(CRKStatsTypeBannerPanning);
            statsInfo.columnId = bannerColumnId;
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)resetStatsDate {
    _statsDate = [NSDate date];
}

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(CRKStatsPayAction)payAction
                  payResult:(PAYRESULT)payResult
                 forProgram:(CRKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(CRKChannel *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        CRKStatsInfo *statsInfo = [[CRKStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = channel.realColumnId;
        statsInfo.columnType = channel.type;
        statsInfo.programId = program.programId;
        statsInfo.programType = program.type;
        statsInfo.programLocation = @(programLocation+1);
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = orderNo;
        if (payAction == CRKStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == CRKStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == CRKStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(2), @(PAYRESULT_ABANDON):@(3)};
            NSNumber *payStatus = payStautsMapping[@(payResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([CRKUtil launchSeq]);
        statsInfo.statsType = @(CRKStatsTypePay);
        statsInfo.network = @([CRKNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsPayWithPaymentInfo:(CRKPaymentInfo *)paymentInfo
                   forPayAction:(CRKStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        CRKStatsInfo *statsInfo = [[CRKStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = paymentInfo.columnId;
        statsInfo.columnType = paymentInfo.columnType;
        statsInfo.programId = paymentInfo.contentId;
        statsInfo.programType = paymentInfo.contentType;
        statsInfo.programLocation = paymentInfo.contentLocation;
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = paymentInfo.orderId;
        if (payAction == CRKStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == CRKStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == CRKStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(2), @(PAYRESULT_ABANDON):@(3)};
            NSNumber *payStatus = payStautsMapping[paymentInfo.paymentResult];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([CRKUtil launchSeq]);
        statsInfo.statsType = @(CRKStatsTypePay);
        statsInfo.network = @([CRKNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

@end
