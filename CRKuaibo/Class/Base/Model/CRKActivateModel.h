//
//  CRKActivateModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"

typedef void (^CRKActivateHandler)(BOOL success, NSString *userId);

@interface CRKActivateModel : CRKEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(CRKActivateHandler)handler;

@end
