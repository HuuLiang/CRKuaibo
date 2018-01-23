//
//  CRKRecommendModel.m
//  CRKuaibo
//
//  Created by ylz on 16/5/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKRecommendModel.h"

@implementation CRKAppSpreadResponse
- (Class)programListElementClass{
    return [CRKProgram class];
}

@end

@implementation CRKRecommendModel

+ (Class)responseClass{
    return [CRKAppSpreadResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(CRKCompletionHandler)handler {
    @weakify(self);
    BOOL rect = [self requestURLPath:CRK_APP_SPREAD_LIST_URL standbyURLPath:CRK_STANDBY_APP_SPREAD_LIST_URL withParams:nil responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        NSArray *fetchArr;
        if (respStatus == CRKURLResponseSuccess) {
            CRKAppSpreadResponse *resp = self.response;
            _fetchedSpreads = resp.programList;
            fetchArr = _fetchedSpreads;
        }
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess,fetchArr);
        }
        
    }];
    

    return rect;
}



@end
