//
//  CRKCPCStatsModel.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKStatsBaseModel.h"

@interface CRKCPCStatsModel : CRKStatsBaseModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos
             completionHandler:(CRKCompletionHandler)completionHandler;

@end
