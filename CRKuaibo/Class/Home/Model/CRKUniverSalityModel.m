////
////  CRKUniverSalityModel.m
////  CRKuaibo
////
////  Created by ylz on 16/6/1.
////  Copyright © 2016年 iqu8. All rights reserved.
////
//
#import "CRKUniverSalityModel.h"

//@implementation CRKSubProgram
//
//@end

//@implementation CRKHomeProgramResponse

//- (Class)programListElementClass {
//    return [CRKProgram class];
//}

//@end

@implementation CRKHomeSubResponse
- (Class)columnListElementClass {
    return [CRKChannel class];
}

@end


@implementation CRKUniverSalityModel
+ (Class)responseClass {
    
    return [CRKHomeSubResponse class];
}

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId pageNo:(NSUInteger)pageNo pageSize:(NSUInteger)pageSize completionHandler:(CRKFetchChannelProgramCompletionHandler)handler{
    NSDictionary *params = @{@"columnId":columnId,@"isProgram":@(1)};//isProgram ,@"page":@(pageNo),@"pageSize":@(pageSize)
    BOOL rect = [self requestURLPath:CRK_HOME_SUB_VIDEO_URL standbyURLPath:nil withParams:params responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage) {
        CRKHomeSubResponse *resp;
        if (respStatus == CRKURLResponseSuccess) {
            resp = self.response;
            _fetchChannels = resp.columnList;
        }
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess,_fetchChannels);
        }
    }];
    
    return rect;
}

@end
