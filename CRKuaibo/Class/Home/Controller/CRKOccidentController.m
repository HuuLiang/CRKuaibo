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
    _slider = slider;
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
    if ([self.segementName isEqualToString:_currentSegmentName]) {
        //        DLog(@"------>>>>");
        vc1.hasShownSpreadBanner = YES;
        vc1.isFirstLoadCounts = YES;
    }
    
    [slider setSlideHeadView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
