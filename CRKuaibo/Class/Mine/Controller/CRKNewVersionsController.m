//
//  CRKNewVersionsController.m
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKNewVersionsController.h"

@interface CRKNewVersionsController ()

@end

@implementation CRKNewVersionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    UIImageView *appImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app.jpg"]];
    [self.view addSubview:appImageView];
    [appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.width.mas_equalTo(80);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"夜夜快播v2.1";
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(appImageView.mas_centerX);
        make.top.mas_equalTo(appImageView.mas_bottom).mas_offset(8);
    }];
    
    UIButton *commitBtn = [[UIButton alloc] init];
    commitBtn.layer.cornerRadius = 4;
    commitBtn.layer.masksToBounds = YES;
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"inputBtn"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"更新" forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"inputBtn"] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"更新" forState:UIControlStateHighlighted];
//    @weakify(self);
    [commitBtn bk_addEventHandler:^(id sender) {
//        @strongify(self);
        [[CRKHudManager manager] showHudWithText:@"已经是最新版本"];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    {
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    }
    
}




@end
