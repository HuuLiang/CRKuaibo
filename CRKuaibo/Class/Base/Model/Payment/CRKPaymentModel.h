//
//  CRKPaymentModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"
#import "CRKPaymentInfo.h"

@interface CRKPaymentModel : CRKEncryptedURLRequest

+ (instancetype)sharedModel;

- (void)startRetryingToCommitUnprocessedOrders;
- (void)commitUnprocessedOrders;
- (BOOL)commitPaymentInfo:(CRKPaymentInfo *)paymentInfo;

@end
