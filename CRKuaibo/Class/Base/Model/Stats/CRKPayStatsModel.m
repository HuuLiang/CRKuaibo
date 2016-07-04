//
//  CRKPayStatsModel.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKPayStatsModel.h"

@implementation CRKPayStatsModel

- (BOOL)statsPayWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos completionHandler:(CRKCompletionHandler)completionHandler {
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos shouldIncludeStatsType:NO];
    if (params.count == 0) {
        SafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:CRK_STATS_PAY_URL
                         withParams:params
                    responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock(completionHandler, respStatus==CRKURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
