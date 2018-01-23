//
//  CRKPaymentTypeCell.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/7/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRKPaymentButton;

@interface CRKPaymentTypeCell : UICollectionViewCell

@property (nonatomic,retain,readonly) CRKPaymentButton *paymentButton;
@property (nonatomic,copy) CRKAction paymentAction;

@end
