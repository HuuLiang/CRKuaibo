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

@end

@implementation CRKRHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor greenColor];
    SlideHeadView *slider = [[SlideHeadView alloc] init];
        
    [self.view addSubview:slider];
    
    CRKUniversalityController *vc1 = [[CRKUniversalityController alloc] init];
    vc1.isHaveFreeVideo = YES;
    CRKUniversalityController *vc2 = [[CRKUniversalityController alloc] init];

    CRKUniversalityController *vc3 = [[CRKUniversalityController alloc] init];
    CRKUniversalityController *vc4 = [[CRKUniversalityController alloc] init];
    
    CRKUniversalityController *vc5 = [[CRKUniversalityController alloc] init];
    
    slider.titlesArr = @[@"vc1",@"vc2",@"vc3",@"vc4",@"v5"];
    
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
