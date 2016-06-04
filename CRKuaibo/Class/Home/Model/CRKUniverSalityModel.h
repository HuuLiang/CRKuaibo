//
//  CRKUniverSalityModel.h
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
#import "CRKProgram.h"

@interface CRKHomeProgramResponse : CRKURLResponse
@property (nonatomic,retain) NSArray<CRKProgram *> *columnList;
@end

@interface CRKUniverSalityModel : CRKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *fetchedProgramList;
@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *fetchedVideoAndAdProgramList;

@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *fetchedBannerPrograms;
@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *fetchedTrialVideos;

- (BOOL)fetchProgramsWithCompletionHandler:(CRKCompletionHandler)handler;

@end
