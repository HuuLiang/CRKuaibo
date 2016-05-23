//
//  CRKPaymentConfigModel.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
#import "CRKPaymentConfig.h"

@interface CRKPaymentConfigModel : CRKEncryptedURLRequest

@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchConfigWithCompletionHandler:(CRKCompletionHandler)handler;

@end
