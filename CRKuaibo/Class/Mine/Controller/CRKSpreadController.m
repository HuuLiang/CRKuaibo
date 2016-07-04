//
//  CRKSpreadController.m
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKSpreadController.h"
#import "CRKSpreadCell.h"
#import "CRKRecommendModel.h"
#import "CRKSystemConfigModel.h"

static NSString *const kSpreadCellIdentifier = @"kspreadcellidentifer";

@interface CRKSpreadController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIImageView *_headerImageView;//头部视图
    UILabel *_priceLabel;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain)CRKRecommendModel *appSpreadModel;

@property (nonatomic,retain)CRKProgram *speProgram;
@end

@implementation CRKSpreadController
DefineLazyPropertyInitialization(CRKRecommendModel,appSpreadModel);

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification) name:kPaidNotificationName object:nil];
    if (![CRKUtil isPaid]) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.userInteractionEnabled = YES;
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14.];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_headerImageView addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_headerImageView);
                make.bottom.equalTo(_headerImageView.mas_centerY).mas_offset(2);
                make.width.equalTo(_headerImageView).multipliedBy(0.1);
                
            }];
        }
        //点击_headerImageView付费
        @weakify(self);
        [_headerImageView bk_whenTapped:^{
            @strongify(self);
            if (![CRKUtil isPaid]) {
                [self payForPayPointType:CRKPayPointTypeVIP];
            };
        }];
        [self.view addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.equalTo(_headerImageView.mas_width).multipliedBy(250./900);
            }];
        }
    }
    
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_layoutCollectionView reloadData];
}
//设置collectionView
- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor clearColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[CRKSpreadCell class] forCellWithReuseIdentifier:kSpreadCellIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_headerImageView?_headerImageView.mas_bottom:self.view);
        }];
    }
    @weakify(self);
    [_layoutCollectionView CRK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadHeaderImage];
        [self loadSpreadModel];
    }];
    [_layoutCollectionView CRK_triggerPullToRefresh];
    
    
    
}

//根据是否支付来判断_headerImageView是否显示
- (void)onPaidNotification {
    [_headerImageView removeFromSuperview];
    _headerImageView = nil;
    
    [_layoutCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)payForPayPointType:(CRKPayPointType)payPointType {
    CRKProgram *program = [[CRKProgram alloc] init];
    program.payPointType = @(payPointType);
    CRKChannel *channel = [[CRKChannel alloc] init];
    //    channel.
    
    [self switchToPlayProgram:program programLocation:1 inChannel:channel];
}
//获取模型数据
- (void)loadSpreadModel {
    @weakify(self);
    [self.appSpreadModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView CRK_endPullToRefresh];
        
        if (success) {
            [self->_layoutCollectionView reloadData];
        }
    }];
}
/**
 *  获取头部视图以及价格信息
 */
- (void)loadHeaderImage {
    if ([CRKUtil isPaid]) {
        return ;
    }
    @weakify(self);
    CRKSystemConfigModel *systemConfigModel = [CRKSystemConfigModel sharedModel];
    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            @weakify(self);
            [self->_headerImageView sd_setImageWithURL:[NSURL URLWithString:systemConfigModel.spreadTopImage]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 @strongify(self);
                 if (!self) {
                     return ;
                 }
                 
                 if (image) {
                     NSUInteger showPrice = systemConfigModel.payAmount ;
                     BOOL showInteger = showPrice % 100 == 0;
                     self->_priceLabel.text = showInteger ? [NSString stringWithFormat:@"%lu", showPrice/100] : [NSString stringWithFormat:@"%.2f", showPrice/100.];
                 } else {
                     self->_priceLabel.text = nil;
                 }
             }];
        }
    }];
}


#pragma mark _collectionView Datasource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _appSpreadModel.fetchedSpreads.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell
    CRKSpreadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSpreadCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    
    if (indexPath.item < self.appSpreadModel.fetchedSpreads.count) {
        CRKProgram *appSpread = self.appSpreadModel.fetchedSpreads[indexPath.item];
        cell.imageURL = [NSURL URLWithString:appSpread.coverImg];
        cell.isInstalled = NO;
        
        [CRKUtil checkAppInstalledWithBundleId:appSpread.specialDesc completionHandler:^(BOOL installed) {
            if (installed) {
                cell.isInstalled = YES;
            }
        }];
        
    }else {
        cell.imageURL = nil;
        cell.isInstalled = NO;
        
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds) - layout.sectionInset.left - layout.sectionInset.right;
    //    const CGFloat itemWidth = (fullWidth - 2 * layout.minimumInteritemSpacing) / 3;
    //    const CGFloat itemHeight = itemWidth + 20;
    return CGSizeMake(fullWidth, fullWidth * 0.35);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CRKProgram *appSpread = self.appSpreadModel.fetchedSpreads[indexPath.item];
    _speProgram = appSpread;
//数据统计
    [[CRKStatsManager sharedManager] statsCPCWithProgram:appSpread programLocation:indexPath.item inChannel:nil andTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex]];
    
    [CRKUtil checkAppInstalledWithBundleId:appSpread.specialDesc completionHandler:^(BOOL installed) {
        if (installed) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:[NSString stringWithFormat:@"您已安装%@是否再次安装该应用",appSpread.title] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
//            [[CRKHudManager manager] showHudWithText:[NSString stringWithFormat:@"您已安装%@",appSpread.title]];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appSpread.videoUrl]];
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_speProgram.videoUrl]];
        return;
    }
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    [[CRKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[CRKUtil currentSubTabPageIndex] forSlideCount:1];
    
}
@end
