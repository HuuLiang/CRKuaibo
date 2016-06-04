//
//  CRKChannelProgramModel.h
//  CRKuaibo
//
//  Created by ylz on 16/6/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
#import "CRKChannelProgram.h"

@interface CRKChannelProgramResponse : CRKChannelPrograms

@end

typedef void (^CRKFetchChannelProgramCompletionHandler)(BOOL success, CRKChannel *programs);

@interface CRKChannelProgramModel : CRKEncryptedURLRequest
@property (nonatomic,retain) CRKChannel *fetchedChannel;

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(CRKFetchChannelProgramCompletionHandler)handler;
@end
