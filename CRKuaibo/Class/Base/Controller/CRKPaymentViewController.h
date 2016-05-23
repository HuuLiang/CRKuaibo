//
//  CRKPaymentViewController.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "CRKBaseViewController.h"

@class CRKProgram;
@class CRKPaymentInfo;

@interface CRKPaymentViewController : CRKBaseViewController

+ (instancetype)sharedPaymentVC;

- (void)popupPaymentInView:(UIView *)view
                forProgram:(CRKProgram *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(CRKChannel *)channel
     withCompletionHandler:(void (^)(void))completionHandler;
- (void)hidePayment;

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(CRKPaymentInfo *)paymentInfo;

@end
