//
//  CRKSpreadBannerViewController.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"

@class CRKProgram;

@interface CRKSpreadBannerViewController : CRKBaseViewController

@property (nonatomic,retain,readonly) NSArray<CRKProgram *> *spreads;

- (instancetype)initWithSpreads:(NSArray<CRKProgram *> *)spreads;
- (void)showInViewController:(UIViewController *)viewController;

@end
