//
//  CRKUserAccessModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"

typedef void (^CRKUserAccessCompletionHandler)(BOOL success);

@interface CRKUserAccessModel : CRKEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
