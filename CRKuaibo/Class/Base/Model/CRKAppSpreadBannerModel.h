//
//  CRKAppSpreadBannerModel.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"

@interface CRKAppSpreadBannerResponse : CRKURLResponse
@property (nonatomic,retain) NSArray<CRKProgram *> *programList;
@end

@interface CRKAppSpreadBannerModel : CRKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *fetchedSpreads;

+ (instancetype)sharedModel;

- (BOOL)fetchAppSpreadWithCompletionHandler:(CRKCompletionHandler)handler;

@end
