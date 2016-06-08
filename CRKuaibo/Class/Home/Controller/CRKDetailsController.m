//
//  CRKController.m
//  CRKuaibo
//
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
    
}

@end

@implementation CRKDetailsController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpCollectionView];
    
    
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kDetailspace;
    layout.minimumInteritemSpacing = kDetailspace;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collectionView.contentInset = UIEdgeInsetsMake(-2.5, 2.5, 2.5, 2.5);
    
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

#pragma mark CollectionViewDelegate Datasoure

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return KDetailsSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 4;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.item==0) {
            
            CRKVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823mnyh.jpg";
            //点击图片详情 支付
            cell.action = ^(id sender){
                CRKProgram *program = [[CRKProgram alloc] init];
                CRKChannel *channel = [[CRKChannel alloc] init];
                [self switchToPlayProgram:program programLocation:1 inChannel:channel];
                
            };
            //支付完成后点击图片会查看大图
            cell.popImageBloc = ^(NSArray*imageArr,NSIndexPath *indexPath){
                UIView *popView = [self creatPictureBrowserWithImageArr:imageArr indexPath:indexPath];
                //                popView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.9];
                [self.view addSubview:popView];
                [UIView animateWithDuration:0.5 animations:^{
                    popView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                }];
                
            };
            return cell;
        }else {
            CRKHomeSpreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSpreeCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151217b2.jpg";
            return cell;
        }
        
    }else {
        CRKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
        cell.imageUrl = @"";
        cell.title = @"";
        cell.subTitle = @"";
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            return CGSizeMake(kScreenWidth,kScreenWidth *0.8);
        }else {
            return CGSizeMake(kScreenWidth, kScreenWidth *0.2);
        }
    }
    CGFloat kwidth = (kScreenWidth - 3*kDetailspace)/2;
    
    return CGSizeMake(kwidth, kwidth*0.85);
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
 *  图片浏览
 */
- (UIView*)creatPictureBrowserWithImageArr:(NSArray *)imageArr indexPath:(NSIndexPath *)indexPath {
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    popView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.9];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn bk_addEventHandler:^(id sender) {
        [UIView animateWithDuration:0.5 animations:^{
            popView.frame = CGRectMake(0, 0, 0, 0);
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [popView addSubview:closeBtn];
    {
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(popView.mas_right).mas_offset(-4);
            make.top.mas_equalTo(popView.mas_top).mas_offset(4);
        }];
        
    }
    
    return popView;
}


@end
