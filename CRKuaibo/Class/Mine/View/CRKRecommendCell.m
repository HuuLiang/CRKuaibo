//
//  CRKRecommendCell.m
//  CRKuaibo
//
//  Created by ylz on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKRecommendCell.h"
#import "CRKRecommendModel.h"
#import "CRKRecommentCollectionViewCell.h"

static const CGFloat KFlowlayoutSpace = 10;
static NSString *const CRKRecommendCollectionIdentify = @"crkrecommendidentify";

@interface CRKRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}


@end

@implementation CRKRecommendCell

DefineLazyPropertyInitialization(CRKRecommendModel,recommendModel);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = KFlowlayoutSpace-5;
        layout.minimumInteritemSpacing = KFlowlayoutSpace;
//                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = self.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(13, 13, 13, 13);
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[CRKRecommentCollectionViewCell class] forCellWithReuseIdentifier:CRKRecommendCollectionIdentify];
        
        [self addSubview:_collectionView];
        {
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
        }
        //刷新控件
        [self loadSpreadApps];
        //        @weakify(self);
        //        [_collectionView CRK_addPullToRefreshWithHandler:^{
        //            @strongify(self);
        //            [self loadSpreadApps];
        //        }];
    }
    return self;
}
//加载模型
- (void)loadSpreadApps {
    @weakify(self);
    [self.recommendModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        [self->_collectionView CRK_endPullToRefresh];
        if (success) {
            [self->_collectionView reloadData];
        }
        
    }];
    
}

#pragma collectionView Delegate Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.recommendModel.fetchedSpreads.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKRecommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRKRecommendCollectionIdentify forIndexPath:indexPath];
    if (indexPath.item < self.recommendModel.fetchedSpreads.count) {
        CRKProgram *model = self.recommendModel.fetchedSpreads[indexPath.row];
        cell.imageName = model.coverImg;
        cell.title = model.title;
    }
    return cell;
    
}
#pragma mark UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (kScreenWidth - 20./375*kScreenWidth *5)/4;
    
    CGFloat height = (self.bounds.size.height -20./375*kScreenWidth)/2;
    return  CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKProgram *program = self.recommendModel.fetchedSpreads[indexPath.item];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
}

@end
