//
//  CRKChannelProgramModel.m
//  CRKuaibo
//
//  Created by ylz on 16/6/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannelProgramModel.h"

@implementation CRKChannelProgramResponse

@end

@implementation CRKChannelProgramModel

+ (Class)responseClass {
    return [CRKChannel class];
}


- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(CRKFetchChannelProgramCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId, @"page":@(pageNo), @"pageSize":@(pageSize),@"scale":@2};//@1
    BOOL success = [self requestURLPath:CRK_CHANNEL_PROGRAM_URL
                             withParams:params
                        responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        CRKChannel *channel;
                        if (respStatus == CRKURLResponseSuccess) {
                            channel = self.response;
                            self.fetchedChannel = channel;
                        }
                        
                        if (handler) {
                            handler(respStatus==CRKURLResponseSuccess, channel);
                        }
                    }];
    return success;
}



@end
