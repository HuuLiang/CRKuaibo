//
//  CRKOccidentController.h
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
#import "CRKHomePageModel.h"
@class SlideHeadView;

@interface CRKOccidentController : CRKBaseViewController

@property (nonatomic,retain)CRKHomePage *homePage;
//@property (nonatomic,retain)CRKHomePageProgram *subHomePage;


@property (nonatomic) BOOL hasShownSpreadBanner;//是否弹框
@property (nonatomic)BOOL isFirstLoadCounts;//第一次加载

@property(nonatomic,assign) BOOL isHaveFreeVideo;
//@property(nonatomic,assign) BOOL isFirstVC;
@property(nonatomic,retain)SlideHeadView *slider;

@property (nonatomic)NSString *segementName;//当前的segement名字
@property (nonatomic)NSString *currentSegmentName;//当前选中的segment名字


- (instancetype)initWithHomePage:( CRKHomePage*)homePage;

@end
