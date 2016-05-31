//
//  CRKPaymentManager.h
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRKProgram;

typedef void (^CRKPaymentCompletionHandler)(PAYRESULT payResult, CRKPaymentInfo *paymentInfo);

@interface CRKPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;
- (BOOL)startPaymentWithType:(CRKPaymentType)type
                     subType:(CRKPaymentType)subType
                       price:(NSUInteger)price
                  forProgram:(CRKProgram *)program
           completionHandler:(CRKPaymentCompletionHandler)handler;

- (void)handleOpenURL:(NSURL *)url;
- (void)checkPayment;

@end