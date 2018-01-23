//
//  CRKStatsManager.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CRKStatsPayAction) {
    CRKStatsPayActionUnknown,
    CRKStatsPayActionClose,
    CRKStatsPayActionGoToPay,
    CRKStatsPayActionPayBack
};

@class CRKStatsInfo;
@class CRKChannel;
@interface CRKStatsManager : NSObject

+ (instancetype)sharedManager;

- (void)addStats:(CRKStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<CRKStatsInfo *> *)statsInfos;
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
- (void)statsCPCWithChannel:(CRKChannel *)channel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithProgram:(CRKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(CRKChannel *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(CRKStatsPayAction)payAction
                  payResult:(PAYRESULT)payResult
                 forProgram:(CRKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(CRKChannel *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithPaymentInfo:(CRKPaymentInfo *)paymentInfo
                   forPayAction:(CRKStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
