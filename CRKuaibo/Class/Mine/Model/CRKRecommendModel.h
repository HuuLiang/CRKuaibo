//
//  CRKRecommendModel.h
//  CRKuaibo
//
//  Created by ylz on 16/5/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"

//#import "CRKProgram.h"

@interface CRKAppSpreadResponse : CRKURLResponse
@property (nonatomic,retain)NSArray <CRKProgram*>*programList;
@end

@interface CRKRecommendModel : CRKEncryptedURLRequest

@property (nonatomic,retain)NSArray<CRKProgram*>*fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(CRKCompletionHandler)handler;
@end
