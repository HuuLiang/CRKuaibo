//
//  CRKUniversalityController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKUniversalityController.h"
#import "CRKHomeCollectionViewCell.h"
//#import "CRKHomeHeaderReusableView.h"
#import "CRKHomeHeaderReusableView.h"

CGFloat const kHomespace = 5;
CGFloat const kHomeSection = 2;
static NSString *const kHomeCellIdentifer = @"khomecellidentifers";
static NSString *const kSectionHeaderReusableIdentifier = @"SectionHeaderReusableIdentifier";

@interface CRKUniversalityController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectinView;
    
}

@end

@implementation CRKUniversalityController

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
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectinView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectinView.dataSource = self;
    _collectinView.delegate = self;
    _collectinView.scrollEnabled = YES;
    _collectinView.backgroundColor = self.view.backgroundColor;
    _collectinView.contentInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    [_collectinView registerClass:[CRKHomeCollectionViewCell class] forCellWithReuseIdentifier:kHomeCellIdentifer];
    
    [_collectinView registerClass:[CRKHomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderReusableIdentifier];
    
    [self.view addSubview:_collectinView];
    {
        [_collectinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
//            make.top.mas_equalTo(self.view).mas_offset(3);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark collectionViewDatasoure collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kHomeSection;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kHomeSection*2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifer forIndexPath:indexPath];
    //    cell.i
    cell.imageUrl = @"";
    cell.title = @"";
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kwidth = (kScreenWidth - kHomespace*3)/2;
    return CGSizeMake(kwidth, kwidth/3*2);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    CRKHomeHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderReusableIdentifier forIndexPath:indexPath];
     headerView.backgroundColor = self.view.backgroundColor;
    if (indexPath.section == 0 && _isHaveFreeVideo ) {
        headerView.isFreeVideo = YES;
        return headerView;
    }else {
        headerView.isFreeVideo = NO;
        return headerView;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 ){
        if (_isHaveFreeVideo) {
            
            return CGSizeMake(0, 30);
        }else {
            return CGSizeMake(0, 0);
        }
    }
    
    return CGSizeMake(0, 34);
}

@end
