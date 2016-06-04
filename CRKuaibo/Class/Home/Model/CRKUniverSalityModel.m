////
////  CRKUniverSalityModel.m
////  CRKuaibo
////
////  Created by ylz on 16/6/1.
////  Copyright © 2016年 iqu8. All rights reserved.
////
//
//#import "CRKUniverSalityModel.h"
//
//@implementation CRKHomeProgramResponse
//
//- (Class)columnListElementClass {
//    return [CRKProgram class];
//}
//@end
//
//@implementation CRKUniverSalityModel
//
//+ (Class)responseClass {
//    return [CRKHomeProgramResponse class];
//}
//
//+ (BOOL)shouldPersistURLResponse {
//    return YES;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        CRKHomeProgramResponse *resp = (CRKHomeProgramResponse *)self.response;
//        _fetchedProgramList = resp.columnList;
//        
////        [self filterProgramTypes];
//    }
//    return self;
//}
//
//- (BOOL)fetchProgramsWithCompletionHandler:(CRKCompletionHandler)handler {
//    @weakify(self);
//    BOOL success = [self requestURLPath:CRK_HOME_VIDEO_URL
//                         standbyURLPath:CRK_STANDBY_HOME_VIDEO_URL
//                             withParams:nil
//                        responseHandler:^(CRKURLResponseStatus respStatus, NSString *errorMessage)
//                    {
//                        @strongify(self);
//                        
//                        if (!self) {
//                            return ;
//                        }
//                        
//                        NSArray *programs;
//                        if (respStatus == CRKURLResponseSuccess) {
//                            CRKHomeProgramResponse *resp = (CRKHomeProgramResponse *)self.response;
//                            programs = resp.columnList;
//                            self->_fetchedProgramList = programs;
//                            
////                            [self filterProgramTypes];
//                        }
//                        
//                        if (handler) {
//                            handler(respStatus==CRKURLResponseSuccess, programs);
//                        }
//                    }];
//    return success;
//}
//
////- (void)filterProgramTypes {
////    _fetchedVideoAndAdProgramList = [self.fetchedProgramList bk_select:^BOOL(id obj)
////                                     {
////                                         CRKProgramType type = ((CRKProgram *)obj).type.unsignedIntegerValue;
////                                         return type == CRKProgramTypeVideo || type == CRKProgramTypeSpread;
////                                     }];
////    
////    NSArray<CRKProgram *> *bannerProgramList = [self.fetchedProgramList bk_select:^BOOL(id obj)
////                                                 {
////                                                     CRKProgramType type = ((CRKProgram *)obj).type.unsignedIntegerValue;
////                                                     return type == CRKProgramTypeBanner;
////                                                 }];
////    
////    NSMutableArray *bannerPrograms = [NSMutableArray array];
////    [bannerProgramList enumerateObjectsUsingBlock:^(CRKProgram * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        if (obj.programList.count > 0) {
////            [bannerPrograms addObjectsFromArray:obj.programList];
////        }
////    }];
////    _fetchedBannerPrograms = bannerPrograms;
////    
////    NSArray<CRKProgram *> *trailProgramList = [self.fetchedProgramList bk_select:^BOOL(id obj) {
////        CRKProgramType type = ((CRKProgram *)obj).type.unsignedIntegerValue;
////        return type == CRKProgramTypeTrial;
////    }];
////    
////    NSMutableArray<CRKProgram *> *trialPrograms = [NSMutableArray array];
////    [trailProgramList enumerateObjectsUsingBlock:^(CRKProgram * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        if (obj.programList.count > 0) {
////            [trialPrograms addObjectsFromArray:obj.programList];
////        }
////    }];
////    _fetchedTrialVideos = trialPrograms;
////}
//
//
//@end
