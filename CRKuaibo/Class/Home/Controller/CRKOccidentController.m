//
//  CRKOccidentController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKOccidentController.h"
#import "SlideHeadView.h"
#import "CRKUniversalityController.h"


@interface CRKOccidentController ()

@property (nonatomic,retain)NSArray *coloumIds;
@end

@implementation CRKOccidentController

- (instancetype)initWithHomePage:( CRKHomePage*)homePage{
    if (self = [self init]) {
        _homePage = homePage;
        //        _subHomePage = subHomePage;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SlideHeadView *slider = [[SlideHeadView alloc] init];
    [self.view addSubview:slider];
    if (_homePage.columnList.count == 0 ) {
        return;
    }
    //设置标题
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:_homePage.columnList.count];
    NSMutableArray *coloumIds = [NSMutableArray arrayWithCapacity:_homePage.columnList.count];
    [_homePage.columnList enumerateObjectsUsingBlock:^(CRKHomePageProgram * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArr addObject:obj.name];
        [coloumIds addObject:obj.columnId];
    }];
    slider.titlesArr = titleArr;
    _coloumIds = coloumIds;

    
    NSMutableArray *vcArr = [NSMutableArray arrayWithCapacity:_coloumIds.count];
    for (int i = 0; i < _coloumIds.count; ++i) {
        CRKUniversalityController *vc = [[CRKUniversalityController alloc] initWith:_coloumIds[i]];
        [slider addChildViewController:vc title:titleArr[i]];
        [vcArr addObject:vc];
    }
    CRKUniversalityController *vc1 = vcArr.firstObject;
    vc1.isHaveFreeVideo = YES;
//    vc1.hasShownSpreadBanner = YES;
//    vc1.isFirstLoadCounts = YES;
    
//    CRKUniversalityController *vc1 = [[CRKUniversalityController alloc] initWith:_coloumIds[0]];
//    vc1.isHaveFreeVideo = YES;
//    vc1.hasShownSpreadBanner = YES;
//    vc1.isFirstLoadCounts = YES;
//    CRKUniversalityController *vc2 = [[CRKUniversalityController alloc] initWith:_coloumIds[1]];
//    
//    CRKUniversalityController *vc3 = [[CRKUniversalityController alloc] initWith:_coloumIds[2]];
//    CRKUniversalityController *vc4 = [[CRKUniversalityController alloc] initWith:_coloumIds[3]];
//    CRKUniversalityController *vc5 = [[CRKUniversalityController alloc] initWith:_coloumIds[4]];
//    
//    [slider addChildViewController:vc1 title:slider.titlesArr[0]];
//    [slider addChildViewController:vc2 title:slider.titlesArr[1]];
//    [slider addChildViewController:vc3 title:slider.titlesArr[2]];
//    [slider addChildViewController:vc4 title:slider.titlesArr[3]];
//    [slider addChildViewController:vc5 title:slider.titlesArr[4]];
    [slider setSlideHeadView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
