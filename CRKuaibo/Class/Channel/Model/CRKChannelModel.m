//
//  CRKChannelModel.m
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannelModel.h"

@implementation CRKChannelModelResponse

- (Class)columnListElementClass{
    return [CRKChannel class];
}

@end


@implementation CRKChannelModel

+ (Class)responseClass {
    return [CRKChannelModelResponse class];
}
+ (BOOL)shouldPersistURLResponse {
    return YES;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        CRKChannelModelResponse *resp = self.response;
        _fetchedVideos = resp.columnList;
    }
    return self;
}

- (BOOL)fetchWithPage:(NSInteger)page withCompletionHandler:(CRKFetchChannelsCompletionHandler)handler {
    @weakify(self);
    BOOL rect = [self requestURLPath:CRK_CHANNEL_URL
                      standbyURLPath:nil
                          withParams:@{@"page":@(page)}
                     responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (!self) {
            return ;
        }
        NSArray *channels;
        if (respStatus == CRKURLResponseSuccess) {
            CRKChannelModelResponse *resp = (CRKChannelModelResponse *)self.response;
            self ->_fetchedVideos = resp.columnList;
            channels = _fetchedVideos;
            if (handler) {
                handler(respStatus == CRKURLResponseSuccess,channels);
            }
        }else {
            if (handler) {
                handler(NO, nil);
            }
        }
        
    }];
    
    return rect;
}

@end
