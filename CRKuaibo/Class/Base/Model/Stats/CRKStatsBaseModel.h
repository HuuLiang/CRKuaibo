//
//  CRKStatsBaseModel.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"

typedef NS_ENUM(NSUInteger, CRKStatsType) {
    CRKStatsTypeUnknown,
    CRKStatsTypeColumnCPC,
    CRKStatsTypeProgramCPC,
    CRKStatsTypeTabCPC,
    CRKStatsTypeTabPanning,
    CRKStatsTypeTabStay,
    CRKStatsTypeBannerPanning,
    CRKStatsTypePay = 1000
};

typedef NS_ENUM(NSInteger, CRKStatsNetwork) {
    CRKStatsNetworkUnknown = 0,
    CRKStatsNetworkWifi = 1,
    CRKStatsNetwork2G = 2,
    CRKStatsNetwork3G = 3,
    CRKStatsNetwork4G = 4,
    CRKStatsNetworkOther = -1
};

@interface CRKStatsInfo : DBPersistence

// Unique ID
@property (nonatomic) NSNumber *statsId;

// System Info
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *pv;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *osv;

// Tab/Column/Program
@property (nonatomic) NSNumber *tabpageId;
@property (nonatomic) NSNumber *subTabpageId;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSNumber *programType;
@property (nonatomic) NSNumber *programLocation;
@property (nonatomic) NSNumber *statsType; //CRKStatsType

// Accumalation stats
@property (nonatomic) NSNumber *clickCount;
@property (nonatomic) NSNumber *slideCount;
@property (nonatomic) NSNumber *stopDuration;

// Payment
@property (nonatomic) NSNumber *isPayPopup;
@property (nonatomic) NSNumber *isPayPopupClose;
@property (nonatomic) NSNumber *isPayConfirm;
@property (nonatomic) NSNumber *payStatus;
@property (nonatomic) NSNumber *paySeq;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSNumber *network; //CRKStatsNetwork
//
+ (NSArray<CRKStatsInfo *> *)allStatsInfos;
+ (NSArray<CRKStatsInfo *> *)statsInfosWithStatsType:(CRKStatsType)statsType;
+ (NSArray<CRKStatsInfo *> *)statsInfosWithStatsType:(CRKStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;
+ (void)removeStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos;

- (BOOL)save;
- (BOOL)removeFromDB;
- (NSDictionary *)RESTData;
- (NSDictionary *)umengAttributes;

@end

@interface CRKStatsResponse : CRKURLResponse
@property (nonatomic) NSNumber *errCode;
@end

@interface CRKStatsBaseModel : CRKEncryptedURLRequest

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos;
- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType;

@end
