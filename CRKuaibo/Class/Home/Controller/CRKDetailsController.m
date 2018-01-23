//
//  CRKController.m
//  CRKuaibo
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKDetailsController.h"
#import "CRKHomeHeaderReusableView.h"
#import "CRKHomeCollectionViewCell.h"
#import "CRKHomeSpreeCell.h"
#import "CRKVideoCollectionViewCell.h"

CGFloat const kDetailspace = 2.5;//间距

NSString *const kHeaderResusableIdentifier = @"kHeaderResusableIdentifier";
NSString *const kHomeCellIdentifier = @"kHomeCellIdentifier";
NSString *const kHomeSpreeCellIdentifier = @"kHomeSpreeCellIdentifier";
NSString *const kVideoCellIdentifier = @"kVideoCellIdentifier";

NSInteger const KDetailsSections = 2;//组数

@interface CRKDetailsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    //    UIView *_popPictureView;
    UIScrollView *_picScrollView;
    
}
@property (nonatomic,retain)NSMutableArray *programArr;
@property (nonatomic)NSInteger currentVideoLocation;

@end

@implementation CRKDetailsController

- (instancetype)initWithChannel:(CRKChannel*)channel program:(CRKProgram*)program programIndex:(NSInteger )programIndex {
    
    if (self = [self init]) {
        //随机获取下面的热门推荐的四个节目列表
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@(programIndex)];
        for (int i = 0; i< 4; ++i) {
            int temp;
            do {
                temp = arc4random_uniform((int)channel.programList.count);
            } while ([tempArr containsObject:@(temp)]);
            [tempArr addObject:@(temp)];
        }
        [tempArr removeObject:@(programIndex)];
        _programArr = tempArr;
    }
    _program = program;
    _channel = channel;
    _currentVideoLocation = programIndex;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpCollectionView];
    
    
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kDetailspace;
    layout.minimumInteritemSpacing = kDetailspace;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    //    _collectionView.contentInset = UIEdgeInsetsMake(-2.5, 2.5, 0, 2.5);
    
    _collectionView.backgroundColor = self.view.backgroundColor;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[CRKHomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderResusableIdentifier];
    [_collectionView registerClass:[CRKHomeCollectionViewCell class] forCellWithReuseIdentifier:kHomeCellIdentifier];
    [_collectionView registerClass:[CRKHomeSpreeCell class] forCellWithReuseIdentifier:kHomeSpreeCellIdentifier];
    [_collectionView registerClass:[CRKVideoCollectionViewCell class] forCellWithReuseIdentifier:kVideoCellIdentifier];
    [self.view addSubview:_collectionView];
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo (self.view);
            
        }];
        
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    [[CRKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex] forSlideCount:1];
    
}
#pragma mark CollectionViewDelegate Datasoure

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return KDetailsSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _type == 5 ? 1:2;//是否是免费视频
    }else {
        
        return 4;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.item==0) {
            
            CRKVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = _program.coverImg;
            @weakify(self);
            //播放视频
            cell.playVideo = ^(BOOL freeVideo){
                @strongify(self);
                //                CRKProgram *program = _program;
                //                CRKChannel *channel = [[CRKChannel alloc] init];
                if (_type == 5) {
                    //是否是付费,是否是试播进行判断
                    [self playVideo:_program videoLocation:_currentVideoLocation inChannel:_currentChannel withTimeControl:NO shouldPopPayment:YES];
                } else {
                    if ([CRKUtil isPaid]) {
                        [self playVideo:_program videoLocation:_currentVideoLocation inChannel:_currentChannel  withTimeControl:YES shouldPopPayment:NO];
                    }else {
                        [self switchToPlayProgram:_program programLocation:_currentVideoLocation inChannel:_currentChannel];
                    }
                    
                }
                
            };
            
            //            //点击图片详情 支付
            //            cell.action = ^(id sender){
            //                @strongify(self);
            //                CRKProgram *program = [[CRKProgram alloc] init];
            //                CRKChannel *channel = [[CRKChannel alloc] init];
            //                [self switchToPlayProgram:program programLocation:1 inChannel:channel];
            //                
            //            };
            //            //支付完成后点击图片会查看大图
            //            cell.popImageBloc = ^(NSArray*imageArr,NSIndexPath *indexPath){
            //                @strongify(self);
            //                UIView *popView = [self creatPictureBrowserWithImageArr:imageArr indexPath:indexPath];
            //                //                _popPictureView = popView;
            //                [self.view addSubview:popView];
            //                [UIView animateWithDuration:0.3 animations:^{
            //                    popView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            //                }];
            //                
            //            };
            return cell;
        }else {
            CRKHomeSpreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSpreeCellIdentifier forIndexPath:indexPath];
            
            cell.imageUrl = _speChannel.columnImg;
            return cell;
        }
        
    }else {
        CRKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
        if (_programArr.count-1 < indexPath.item) {
            return nil;
        }
        NSNumber *programIdx = _programArr[indexPath.item];
        CRKProgram *program = _channel.programList[programIdx.integerValue];
        cell.imageUrl = program.coverImg;
        cell.title = program.title;
        cell.subTitle = program.specialDesc;
        cell.type = _channel.type;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.item == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_speChannel.spreadUrl]];
            //数据统计
            [[CRKStatsManager sharedManager] statsCPCWithProgram:nil programLocation:indexPath.item inChannel:_speChannel andTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex]];
        }
    }else if (indexPath.section == 1 ){
        NSNumber *programIdx = _programArr[indexPath.item];
        CRKProgram *program = _channel.programList[programIdx.integerValue];
        _program = program;
        _currentVideoLocation = indexPath.item;
        _type = _channel.type.integerValue;
        _currentChannel = _channel;
        //数据统计
        [[CRKStatsManager sharedManager] statsCPCWithProgram:_program programLocation:indexPath.item inChannel:_channel andTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex]];
        
        [_collectionView reloadData];
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            return CGSizeMake(kScreenWidth,kScreenWidth *0.6);
        }else{
            if (_speChannel.columnImg) {
                
                return CGSizeMake(kScreenWidth, 75);
            }else {
                return CGSizeMake(0, 0);
            }
        }
        
    }
    CGFloat kwidth = (kScreenWidth - 3*kDetailspace)/2;
    
    return CGSizeMake(kwidth, kwidth*0.6+20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 ){
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(0, 34);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    CRKHomeHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderResusableIdentifier forIndexPath:indexPath];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.isHotRecommend = YES;
    return headerView;
    
}

/**
 *  图片浏览,该功能暂时舍弃
 */
- (UIView*)creatPictureBrowserWithImageArr:(NSArray *)imageArr indexPath:(NSIndexPath *)indexPath {
    _picScrollView.hidden = NO;
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, kScreenHeight*0.5, 0, 0)];
    popView.backgroundColor = [UIColor colorWithWhite:0.34 alpha:0.9];
    
    //    UIButton *closeBtn = [[UIButton alloc] init];
    //    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    //    _closeBtn = closeBtn;
    //    [closeBtn bk_addEventHandler:^(id sender) {
    //        [UIView animateWithDuration:0.5 animations:^{
    //            popView.frame = CGRectMake(kScreenWidth*0.5, kScreenHeight*0.5, 0, 0);
    //            closeBtn.hidden = YES;
    //        }];
    //        
    //    } forControlEvents:UIControlEventTouchUpInside];
    //  
    //    
    //    [popView addSubview:closeBtn];
    //    {
    //        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.mas_equalTo(popView.mas_right).mas_offset(-4);
    //            make.top.mas_equalTo(popView.mas_top).mas_offset(4);
    //            make.height.width.mas_equalTo(40);
    //        }];
    //        
    //    }
    
    UIScrollView *picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (1- 500/568.)*kScreenHeight/3, kScreenWidth, 450/568.*kScreenHeight)];
    picScrollView.backgroundColor = [UIColor whiteColor];
    picScrollView.contentSize = CGSizeMake(imageArr.count *kScreenWidth, 0);
    _picScrollView = picScrollView;
    [popView addSubview:picScrollView];
    //点击图片弹框,图片弹框销毁
    [popView bk_whenTapped:^{
        [UIView animateWithDuration:0.3 animations:^{
            popView.frame = CGRectMake(kScreenWidth*0.5, kScreenHeight*0.5, 0, 0);
            picScrollView.hidden = YES;
        }completion:^(BOOL finished) {
            if (finished) {
                [popView removeFromSuperview];
            }
            
        }];
    }];
    picScrollView.pagingEnabled = YES;
    //添加图片
    for (int i = 0; i < imageArr.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, CGRectGetHeight(picScrollView.frame))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]]];
        [picScrollView addSubview:imageView];
        
    }
    picScrollView.contentOffset = CGPointMake(indexPath.item*kScreenWidth, 0);
    
    return popView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
    
        return UIEdgeInsetsMake(0, 2.5, 0, 2.5);
    }

}

@end
