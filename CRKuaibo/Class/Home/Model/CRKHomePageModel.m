
//
//  CRKHomePage.m
//  CRKuaibo
//
//  Created by ylz on 16/6/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomePageModel.h"

@implementation CRKUniverSlity



@end


@implementation CRKHomePageProgram
- (Class)columnListElementClass {
    return [CRKUniverSlity class];
}
@end

@implementation CRKHomePage
- (Class)columnListElementClass {
    return [CRKHomePageProgram class];
}
@end

@implementation CRKHomePageResponse

- (Class)columnListElementClass {
    return [CRKHomePage class];
}

@end


@implementation CRKHomePageModel

+ (Class)responseClass {
    return [CRKHomePageResponse class];
}
- (BOOL)fetchWiithCompletionHandler:(CRKFetchChannelsCompletionHandler)handler{
    @weakify(self);
    BOOL rect = [self requestURLPath:CRK_HOME_VIDEO_URL standbyURLPath:nil withParams:nil responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        
        CRKHomePageResponse *resp ;
        if (respStatus == CRKURLResponseSuccess) {
            resp = self.response;
            self->_fetchChannel = resp;
            _fetchHomePage = resp.columnList;
//            NSMutableArray *subHomePage = [NSMutableArray array];
            [_fetchHomePage enumerateObjectsUsingBlock:^(CRKHomePage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == CRKHomePageOM) {
                    _homePageOM = obj;
                }else if (idx == CRKHomePageRH){
                    _homePageRH = obj;
                }else if (idx == CRKHomePageDL){
                    _homePageDL = obj;
                }
               
                
            }];
//            _fetcheSubHomePage = subHomePage;
            
            
            
        }
        
        if (handler) {
            handler(respStatus == CRKURLResponseSuccess,_fetchHomePage);
        }
    }];
    return rect;
}


@end
