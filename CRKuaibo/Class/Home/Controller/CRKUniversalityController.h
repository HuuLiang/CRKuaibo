//
//  CRKUniversalityController.h
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//被复用的一个控制器

#import "CRKBaseViewController.h"

@interface CRKUniversalityController : CRKBaseViewController

//@property(nonatomic,assign) BOOL isHaveFreeVideo;
//@property(nonatomic,assign) BOOL isFirstVC;

@property (nonatomic) BOOL hasShownSpreadBanner;//弹框

@property (nonatomic)BOOL isFirstLoadCounts;//第一次加载

//@property (nonatomic) NSInteger homePage;
//@property (nonatomic) NSInteger currentVC;
@property (nonatomic) NSNumber *coloumId;

//- (instancetype)initWith:(CRKCurrentHomePage)homePage currentVC:(NSInteger)currentVC;
- (instancetype)initWith:(NSNumber *)coloumId;

@end
