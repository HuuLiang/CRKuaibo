//
//  CRKRHViewController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKRHViewController.h"
#import "SlideHeadView.h"
#import "CRKUniversalityController.h"

@interface CRKRHViewController ()
@property (nonatomic,retain)NSArray *coloumIds;
@end

@implementation CRKRHViewController

- (instancetype)initWithHomePage:( CRKHomePage*)homePage {
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
//    vc1.isHaveFreeVideo = YES;//是否有试播内容
    vc1.hasShownSpreadBanner = YES;//是否要弹框
    vc1.isFirstLoadCounts = YES;//加载的数量
    
    [slider setSlideHeadView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
