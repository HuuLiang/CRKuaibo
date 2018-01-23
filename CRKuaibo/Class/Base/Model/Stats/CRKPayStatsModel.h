//
//  CRKPayStatsModel.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKStatsBaseModel.h"

@interface CRKPayStatsModel : CRKStatsBaseModel

- (BOOL)statsPayWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos completionHandler:(CRKCompletionHandler)completionHandler;

@end
