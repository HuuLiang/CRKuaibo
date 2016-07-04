//
//  CRKTabStatsModel.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKTabStatsModel.h"

@implementation CRKTabStatsModel

- (BOOL)statsTabWithStatsInfos:(NSArray<CRKStatsInfo *> *)statsInfos
             completionHandler:(CRKCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        SafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:CRK_STATS_TAB_URL
                         withParams:params
                    responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock(completionHandler, respStatus == CRKURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
