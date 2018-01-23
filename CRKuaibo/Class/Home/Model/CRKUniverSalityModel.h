//
//  CRKUniverSalityModel.h
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"


//@interface CRKHomeProgramResponse : CRKPrograms
////@property (nonatomic)NSString *spreadUrl;
//
//@end

@interface CRKHomeSubResponse : CRKURLResponse
@property (nonatomic,retain)NSArray <CRKChannel *>*columnList;

@end

typedef void(^CRKFetchChannelProgramCompletionHandler)(BOOL success, NSArray<CRKChannel *>*programs);

@interface CRKUniverSalityModel : CRKEncryptedURLRequest

@property (nonatomic,retain) NSArray <CRKChannel *>*fetchChannels;

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(CRKFetchChannelProgramCompletionHandler)handler;
@end
