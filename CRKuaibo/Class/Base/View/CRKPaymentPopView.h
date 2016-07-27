//
//  CRKPaymentPopView.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRKPaymentPopView : UITableView

@property (nonatomic) NSURL *headerImageURL;

//@property (nonatomic,retain) UIImage *headerImage;
@property (nonatomic,retain) UIImage *footerImage;
//@property (nonatomic,copy) JQKPaymentAction paymentAction;
@property (nonatomic,copy) CRKAction closeAction;
@property (nonatomic) NSNumber *showPrice;

//- (void)addPaymentWithImage:(UIImage *)image title:(NSString *)title available:(BOOL)available action:(CRKAction)action;
- (void)addPaymentWithImage:(UIImage *)image
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
            backgroundColor:(UIColor *)backgroundColor
                     action:(CRKAction)action;
- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width;

@end
