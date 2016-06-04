//
//  CRKChannelViewController.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannelViewController.h"
#import "CRKChannelCell.h"
#import "CRKChannelModel.h"
#import "CRKChannelDetailsController.h"

CGFloat const kspace = 3.;
//NSInteger const kItems = 8;//item的个数

static NSString *const kChannelIdentifier = @"kchannelidentifier";


@interface CRKChannelViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_layoutCollectionView;
    
}
@property (nonatomic,retain)CRKChannelModel *fetchChannel;
@property (nonatomic,retain) NSArray *channels;
@end

@implementation CRKChannelViewController
DefineLazyPropertyInitialization(CRKChannelModel,fetchChannel)
DefineLazyPropertyInitialization(NSArray,channels)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fetchChannel = nil;
    [self setUpCollectionView];
    
    [self loadChannels];
    
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kspace;
    layout.minimumLineSpacing = kspace;
    _layoutCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.delegate = self;
    
    _layoutCollectionView.scrollsToTop = NO;
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(3, 3, 3, 3);
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    
    [_layoutCollectionView registerClass:[CRKChannelCell class] forCellWithReuseIdentifier:kChannelIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
    }

}

- (void)loadChannels {
    if (!_fetchChannel) {
            _fetchChannel = [[CRKChannelModel alloc] init];
    }
    @weakify(self);
    [_fetchChannel fetchWithPage:10 withCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        if (success) {
            self.channels = obj;

            [self ->_layoutCollectionView reloadData];
            
        }
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark CollectionViewDelegate Datasurce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelIdentifier forIndexPath:indexPath];
    if (indexPath.item>7) {
        return nil;
    }else {
        CRKChannels *channel = _channels[indexPath.item];
        cell.title = channel.name;
        cell.picUrl = channel.columnImg;
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKChannelCell *cell = (CRKChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CRKChannel *channel = _channels[indexPath.item];
    //创建detailsVC的同时把channel模型传递过去
    CRKChannelDetailsController *detailsVC = [[CRKChannelDetailsController alloc] initWithChannel:channel];
    detailsVC.title = cell.title;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

#pragma mark flowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kwidth = (kScreenWidth - kspace*3)/2;
    CGFloat kheight = (kScreenHeight + kspace)/5;
    return CGSizeMake(kwidth, kheight);
    
}

@end
