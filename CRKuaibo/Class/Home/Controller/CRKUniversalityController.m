//
//  CRKUniversalityController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKUniversalityController.h"
#import "CRKHomeCollectionViewCell.h"
#import "CRKHomeSpreeCell.h"
#import "CRKHomeHeaderReusableView.h"
#import "CRKDetailsController.h"
#import "CRKHomePageModel.h"
#import "CRKUniverSalityModel.h"

CGFloat const kHomespace = 2.5;
NSInteger const kHomeSize = 6;//下拉加载的个数

static NSString *const kHomeCellIdentifer = @"khomecellidentifers";
static NSString *const kHomeSpreeCellIdentifer = @"khomespreecellidentifers";
static NSString *const kSectionHeaderReusableIdentifier = @"SectionHeaderReusableIdentifier";

@interface CRKUniversalityController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectinView;
    
}

@property (nonatomic,retain)CRKHomePageModel *homePageModel;
@property (nonatomic,retain)NSMutableArray *univerSlityModels;
@property (nonatomic,retain)NSArray <CRKProgram *>*allModel;//总共的推荐的节目数量
@property (nonatomic,retain)NSMutableArray <CRKProgram *>*currentProgramModel;

@property (nonatomic,retain)CRKUniverSalityModel *homeUniverModel;
@property (nonatomic,retain)CRKChannel *videoChannel;

@property (nonatomic,retain)CRKChannel *specChannel;//推广

@property (nonatomic) NSUInteger currentPage;//当前页


@end

@implementation CRKUniversalityController
DefineLazyPropertyInitialization(CRKHomePageModel, homePageModel)
DefineLazyPropertyInitialization(NSMutableArray,univerSlityModels)
DefineLazyPropertyInitialization(CRKUniverSalityModel, homeUniverModel)
DefineLazyPropertyInitialization(NSMutableArray,currentProgramModel )

//- (instancetype)initWith:(CRKCurrentHomePage)homePage currentVC:(NSInteger)currentVC{
//    if (self = [self init]) {
//        _homePage = homePage;
//        _currentVC = currentVC;
//    }
//    return self;
//}

- (instancetype)initWith:(NSNumber *)coloumId{
    if (self = [self init]) {
        _coloumId = coloumId;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCollectionView];
    
    
}
/**
 *  collectionView
 */
- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kHomespace;
    layout.minimumInteritemSpacing = kHomespace;
    
    _collectinView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectinView.dataSource = self;
    _collectinView.delegate = self;
    _collectinView.scrollEnabled = YES;
    _collectinView.backgroundColor = self.view.backgroundColor;
    _collectinView.contentInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _collectinView.alwaysBounceVertical = YES;
    _collectinView.showsVerticalScrollIndicator = NO;
    
    [_collectinView registerClass:[CRKHomeCollectionViewCell class] forCellWithReuseIdentifier:kHomeCellIdentifer];
    [_collectinView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHomeSpreeCellIdentifer];
    
    [_collectinView registerClass:[CRKHomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderReusableIdentifier];
    
    [self.view addSubview:_collectinView];
    {
        [_collectinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
            //            make.top.mas_equalTo(self.view).mas_offset(3);
        }];
    }
    @weakify(self);
    [_collectinView CRK_addPullToRefreshWithHandler:^{
        @strongify(self);
        //        [self.univerSlityModels removeAllObjects];
        [_currentProgramModel removeAllObjects];
        _currentPage = 0;
        [self loadModel];
    }];
    [_collectinView CRK_triggerPullToRefresh];
    
    [_collectinView CRK_addPagingRefreshWithIsLoadAll:YES Handler:^{
        @strongify(self);
        if ([CRKUtil isPaid]) {
            [self loadLastModel];
        }else {
            //弹出提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self joinVipUIAlertView];
                [self->_collectinView CRK_endPullToRefresh];
            });
            
        }
    }];
    
}
- (void)joinVipUIAlertView {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"加入会员查看更多" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
    [alerView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        //        CRKProgram *program = _channelPrograms[indexPath.section];
        [self switchToPlayProgram:nil programLocation:0 inChannel:nil];
        return;
    }
    
}
- (void)loadModel{
    @weakify(self);
    
    [self.homeUniverModel fetchProgramsWithColumnId:_coloumId pageNo:_currentPage pageSize:kHomeSize completionHandler:^(BOOL success, NSArray<CRKChannel *>*programs) {
        @strongify(self);
        if (!self) {
            return ;
        }
        if (success && programs) {
            
            [programs enumerateObjectsUsingBlock:^(CRKChannel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.type.integerValue == 1) {
                    _allModel = obj.programList;
                }
            }];
            //            [self.univerSlityModels addObjectsFromArray:programs];
            self.univerSlityModels = programs;
            [self loadMoreProgramWithFirstLoad:YES];
            [_collectinView reloadData];
            [_collectinView CRK_endPullToRefresh];
            if (_hasShownSpreadBanner) {
                
                [CRKUtil showSpreadBanner];
                _hasShownSpreadBanner = NO;
            }
        }
    }];
    
}

- (void)loadLastModel {
    @weakify(self);
    //判断是否已经全部加载
    if (_allModel.count == _currentProgramModel.count) {
        [_collectinView CRK_endPullToRefresh];
        [_collectinView CRK_pagingRefreshNoMoreData];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self loadMoreProgramWithFirstLoad:NO];
        [_collectinView reloadData];
        [_collectinView CRK_endPullToRefresh];
    });
    
}

//加载精品推荐
- (void) loadMoreProgramWithFirstLoad:(BOOL) isFirstLoad {
    if (_allModel.count == _currentProgramModel.count) {
        return;
    }
    NSInteger  homeSizes = (_allModel.count - kHomeSize*_currentPage) > kHomeSize ? kHomeSize : (_allModel.count - kHomeSize*_currentPage);
    NSMutableArray *programs = [NSMutableArray array];
    [programs addObjectsFromArray:_currentProgramModel];
    if (_allModel.count<=0) {
        return;
    }
    if (isFirstLoad){
        NSInteger firstLoadCounts = _isFirstLoadCounts ? 20:12;
        firstLoadCounts = firstLoadCounts >= _allModel.count ? _allModel.count : firstLoadCounts;
        
        for (NSInteger i = _currentProgramModel.count; i < firstLoadCounts ; ++i) {
            
            [programs addObject:_allModel[i]];
        }
        
    }else {
        NSInteger  sizes = (homeSizes + _currentProgramModel.count) > _allModel.count ? _allModel.count : (homeSizes + _currentProgramModel.count);
        for (NSInteger i = _currentProgramModel.count; i < sizes; ++i) {
            [programs addObject:_allModel[i]];
        }
        _currentPage ++;
    }
    _currentProgramModel = programs;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark collectionViewDatasoure collectionViewDelegate

- (CRKProgram *)programWithIndexPath:(NSIndexPath *)indexPath {
    CRKChannel *channel = (CRKChannel*)_univerSlityModels[indexPath.section];
    CRKProgram *program = channel.programList[indexPath.item];
    return program;
}

- (CRKChannel *)channelWithIndePath:(NSIndexPath *)indexPath {
    CRKChannel *channel = (CRKChannel*)_univerSlityModels[indexPath.section];
    return channel;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _univerSlityModels.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CRKChannel *channel = (CRKChannel*)_univerSlityModels[section];
    if (channel.type.integerValue == 3) {
        return 1;
    }
    else if (channel.type.integerValue == 1){
        return _currentProgramModel.count;
    }
    return channel.programList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKChannel *channel = [self channelWithIndePath:indexPath];
    if (channel.type.integerValue == 3 ) {
        _specChannel = channel;
        UICollectionViewCell *spreeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSpreeCellIdentifer forIndexPath:indexPath];//首页推广舍弃
        //不让当前界面显示推广
        //        spreeCell.imageUrl = channel.columnImg;
        
        return spreeCell;
        
    }
    if (channel.type.integerValue == 1) {
        _videoChannel = channel;
        //        _allModel = channel.programList;
    }
    CRKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifer forIndexPath:indexPath];
    //    cell.i
    CRKProgram *program = [self programWithIndexPath:indexPath];
    cell.imageUrl = program.coverImg;
    cell.title = program.title;
    cell.subTitle = program.specialDesc;
    cell.type = channel.type;
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kwidth = (kScreenWidth - kHomespace*3)/2;
    
    CRKChannel *channel = [self channelWithIndePath:indexPath];
    if (channel.type.integerValue == 3) {
        return CGSizeMake(0, 1);
    }
    
    return CGSizeMake(kwidth, (kwidth)*0.6 +20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    CRKHomeHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderReusableIdentifier forIndexPath:indexPath];
    CRKChannel *channel = [self channelWithIndePath:indexPath];
    headerView.backgroundColor = self.view.backgroundColor;
    if (channel.type.integerValue == 5) {
        headerView.isFreeVideo = YES;
        return headerView;
    }else {
        headerView.isFreeVideo = NO;
        return headerView;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CRKChannel *channel = (CRKChannel *)_univerSlityModels[section];
    if (channel.type.integerValue == 3 ){
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(0, 34);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKChannel *channel = [self channelWithIndePath:indexPath];
    if (channel.type.integerValue == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:channel.spreadUrl]];
    }else{
        CRKDetailsController *detailsVC = [[CRKDetailsController alloc] initWithChannel:_videoChannel program:channel.programList[indexPath.item] programIndex:indexPath.item];
        detailsVC.speChannel = _specChannel;
        detailsVC.type = channel.type.integerValue;
        detailsVC.currentChannel = channel;
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
        [[CRKStatsManager sharedManager] statsCPCWithProgram:channel.programList[indexPath.item] programLocation:indexPath.item inChannel:channel andTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex]];
    }
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    [[CRKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex] forSlideCount:1];
    
}


@end
