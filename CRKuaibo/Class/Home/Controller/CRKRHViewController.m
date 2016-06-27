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
    
    //设置标题
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:_homePage.columnList.count];
    NSMutableArray *coloumIds = [NSMutableArray arrayWithCapacity:_homePage.columnList.count];
    [_homePage.columnList enumerateObjectsUsingBlock:^(CRKHomePageProgram * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArr addObject:obj.name];
        [coloumIds addObject:obj.columnId];
    }];
    slider.titlesArr = titleArr;
    _coloumIds = coloumIds;
    
    CRKUniversalityController *vc1 = [[CRKUniversalityController alloc] initWith:_coloumIds[0]];
    vc1.isHaveFreeVideo = YES;
    CRKUniversalityController *vc2 = [[CRKUniversalityController alloc] initWith:_coloumIds[1]];
    
    CRKUniversalityController *vc3 = [[CRKUniversalityController alloc] initWith:_coloumIds[2]];
    CRKUniversalityController *vc4 = [[CRKUniversalityController alloc] initWith:_coloumIds[3]];
    CRKUniversalityController *vc5 = [[CRKUniversalityController alloc] initWith:_coloumIds[4]];
    
    [slider addChildViewController:vc1 title:slider.titlesArr[0]];
    [slider addChildViewController:vc2 title:slider.titlesArr[1]];
    [slider addChildViewController:vc3 title:slider.titlesArr[2]];
    [slider addChildViewController:vc4 title:slider.titlesArr[3]];
    [slider addChildViewController:vc5 title:slider.titlesArr[4]];
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
