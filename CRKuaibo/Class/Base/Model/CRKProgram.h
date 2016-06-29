//
//  CRKProgram.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRKURLResponse.h"

typedef NS_ENUM(NSUInteger, CRKProgramType) {
    CRKProgramTypeNone = 0,
    CRKProgramTypeVideo = 1,
    CRKProgramTypePicture = 2,
    CRKProgramTypeSpread = 3,
    CRKProgramTypeBanner = 4,
    CRKProgramTypeTrial = 5
};

@interface CRKProgramUrl : NSObject
@property (nonatomic) NSNumber *programUrlId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;
@end

@interface CRKProgram : NSObject

@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSNumber *spec;
@property (nonatomic) NSNumber *payPointType; // 1、会员注册 2、付费
@property (nonatomic) NSNumber *type; // 1、视频 2、图片
@property (nonatomic) NSString *offUrl;
@property (nonatomic,retain) NSArray<CRKProgramUrl *> *urlList; // type==2有集合，目前为图集url集合

@property (nonatomic) NSDate *playedDate; // for history

+ (NSArray<CRKProgram *> *)allPlayedPrograms;
- (void)didPlay;

- (NSString *)playedDateString;

@end

//@interface CRKPrograms : CRKURLResponse
//
////@property (nonatomic) NSNumber *items;
////@property (nonatomic) NSNumber *page;
////@property (nonatomic) NSNumber *pageSize;
//
//@property (nonatomic) NSString *spreadUrl;
//@property (nonatomic) NSNumber *columnId;
//@property (nonatomic) NSString *name;
//@property (nonatomic) NSString *columnImg;
//@property (nonatomic) NSString *columnDesc;
//@property (nonatomic) NSNumber *type; // 1、视频 2、图片
//@property (nonatomic) NSNumber *showNumber;
//@property (nonatomic,retain) NSArray<CRKProgram *> *programList;
//@end

