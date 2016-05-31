//
//  CRKHomeViewController.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomeViewController.h"

typedef NS_ENUM (NSUInteger , SegmentIndex){
    CRKBEuramerican, //欧美
    CRKBJapanKorea,  //日韩
    CRKBMainland     //大陆
};

@interface CRKHomeViewController ()

@end

@implementation CRKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSegmentControll];
    
}
/**
 *  设置SegmentControll
 */
- (void)setSegmentControll {
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"欧美",@"日韩",@"大陆"]];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(0, 0, kScreenWidth*0.5, 31);
    segment.tintColor = [UIColor colorWithWhite:1 alpha:0.5];
    [segment.layer masksToBounds];
    [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.]} forState:UIControlStateNormal];
    self.navigationItem.titleView = segment;
    @weakify(self)
    [segment bk_addEventHandler:^(id sender) {
        @strongify(self)
        switch (segment.selectedSegmentIndex) {
            case CRKBEuramerican:
                DLog(@"欧美");
                break;
            case CRKBJapanKorea:
                DLog(@"日韩");
                break;
            case CRKBMainland:
                DLog(@"大陆");
                break;
            default:
                break;
        }
        
    } forControlEvents:UIControlEventValueChanged];
    
}

/**
 *
 */




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
