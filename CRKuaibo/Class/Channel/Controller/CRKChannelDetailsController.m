//
//  CRKChannelDetailsController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannelDetailsController.h"
#import "CRKDetailsCell.h"
#import "CRKPaymentViewController.h"
#import "CRKChannelProgramModel.h"
#import "CRKChannel.h"

static NSString *kDetailsCellIdentifier = @"kdetailscellidentifier";
static const NSUInteger kDefaultPageSize = 7;

@interface CRKChannelDetailsController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,retain)NSMutableArray <CRKProgram *>*channelPrograms;
@property (nonatomic,retain)CRKChannelProgramModel *program;

@property (nonatomic) NSUInteger currentPage;//当前页

@end

@implementation CRKChannelDetailsController

DefineLazyPropertyInitialization(NSMutableArray,channelPrograms)
DefineLazyPropertyInitialization(CRKChannelProgramModel,program)

- (instancetype)initWithChannel:(CRKChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_program) {
        _program = [[CRKChannelProgramModel alloc] init];
    }
    
    [self setUpTableView];
    
}
- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    // 去掉多余的分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:view];
    
    [_tableView registerClass:[CRKDetailsCell class] forCellReuseIdentifier:kDetailsCellIdentifier];
    //    _tableView.contentInset = UIEdgeInsetsMake(3, 3, 3, 3);
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
    }
    
    _tableView.rowHeight = 160/667.*kScreenHeight;
    
    //下拉刷新
    @weakify(self);
    [_tableView CRK_addPullToRefreshWithHandler:^{
        @strongify(self);
        
        [self.channelPrograms removeAllObjects];
        _currentPage = 0;
        [self loadChannelProgramModel];
        
    }];
    [_tableView CRK_triggerPullToRefresh];
    [_tableView CRK_addPagingRefreshWithHandler:^{
        @strongify(self);
        if (![CRKUtil isPaid]) {
            //弹出提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self joinVipUIAlertView];
                [self->_tableView CRK_endPullToRefresh];
            });
        }else{
            [self loadChannelProgramModel];
        }
    }];
    
}

- (void)loadChannelProgramModel{
    @weakify(self);
    [_program fetchProgramsWithColumnId:_channel.columnId
                                 pageNo:_currentPage++
                               pageSize:kDefaultPageSize
                      completionHandler:^(BOOL success, CRKChannel *programs) {
                          
                          @strongify(self);
                          if (!self) {
                              return ;
                          }
                          if (success && programs.programList) {
                              [_channelPrograms addObjectsFromArray:programs.programList];
                              [self->_tableView reloadData];
                          }
                          
                          [self->_tableView CRK_endPullToRefresh];//结束刷新
                          if (self.channelPrograms.count >= programs.items.unsignedIntegerValue) {
                              [self->_tableView CRK_pagingRefreshNoMoreData];
                          }
                          
                      }];
}

- (void)joinVipUIAlertView {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"加入会员查看更多" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
    [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        CRKProgram *program = _channelPrograms[indexPath.section];
        [self switchToPlayProgram:program programLocation:indexPath.section inChannel:self.channel];
        return;
    }
    
}

#pragma mark tableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.channelPrograms.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRKDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailsCellIdentifier forIndexPath:indexPath];
    if (indexPath.item<self.channelPrograms.count) {
        CRKProgram *program = self.channelPrograms[indexPath.section];
        cell.name = program.title;
        cell.introduction = program.specialDesc;
        cell.picUrl = program.coverImg;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 12;
    }
}
//解决tableView的粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CRKProgram *program = _channelPrograms[indexPath.section];
    if (![CRKUtil isPaid]) {
        [self switchToPlayProgram:program programLocation:indexPath.section inChannel:self.channel];
        return;
    }else {
        //如果已经付费,进入播放界面
        [self playVideo:program videoLocation:indexPath.section inChannel:_channel withTimeControl:YES shouldPopPayment:NO];
        
        
    }
    
}

@end
