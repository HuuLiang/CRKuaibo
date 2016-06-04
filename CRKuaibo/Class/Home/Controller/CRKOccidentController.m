//
//  CRKOccidentController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKOccidentController.h"
#import "SlideHeadView.h"
#import "CRKRHViewController.h"
#import "CRKDLViewController.h"

@interface CRKOccidentController ()

@end

@implementation CRKOccidentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    SlideHeadView *slideVC = [[SlideHeadView alloc]init];
    [self.view addSubview:slideVC];
    CRKRHViewController *riHanVC = [[CRKRHViewController alloc] init];
    CRKDLViewController *mainLandVC = [[CRKDLViewController alloc] init];
    CRKRHViewController *riHanVC1 = [[CRKRHViewController alloc] init];
    CRKDLViewController *mainLandVC1 = [[CRKDLViewController alloc] init];
    CRKRHViewController *riHanVC2 = [[CRKRHViewController alloc] init];
    NSArray *titleArr = @[@"热门",@"肥臀",@"人妻",@"金发",@"巨乳"];
    slideVC.titlesArr = titleArr;
    [slideVC addChildViewController:riHanVC title:titleArr[0]];
    [slideVC addChildViewController:mainLandVC title:titleArr[1]];
    [slideVC addChildViewController:riHanVC1 title:titleArr[2]];
    [slideVC addChildViewController:mainLandVC1 title:titleArr[3]];
    [slideVC addChildViewController:riHanVC2 title:titleArr[4]];
//    [slideVC addChildViewController:mainLandVC title:titleArr[1]];
    
    [slideVC setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
