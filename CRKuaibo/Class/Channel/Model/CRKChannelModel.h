//
//  CRKChannelModel.h
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
//#import "CRKChannels.h"

@interface CRKChannelModelResponse : CRKURLResponse
@property (nonatomic,retain)NSArray <CRKChannel*> *columnList;

@end

typedef void (^CRKFetchChannelsCompletionHandler)(BOOL success, NSArray<CRKChannel *> *channels);

@interface CRKChannelModel : CRKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray*fetchedVideos;

- (BOOL)fetchWithPage:(NSInteger)page withCompletionHandler:(CRKFetchChannelsCompletionHandler)handler;
@end
