//
//  CRKVideoCollectionViewCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKVideoCollectionViewCell.h"
#import "CRKVideoImageCollectionViewCell.h"

CGFloat const kVideoImageItems = 5;
CGFloat const kVideoImageSpace = 10;
static NSString *const kVideoImageIdentifier = @"kVideoImageIdentifier";

@interface CRKVideoCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    UIImageView *_imageView;
//    UICollectionView *_collectionView;
}
@property (nonatomic,assign)NSArray <NSString *>*imageArr;
@property (nonatomic,retain)UIView *popupPictureView;//图片弹框

@end

@implementation CRKVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.height.mas_equalTo(self);
//                make.height.mas_equalTo(self).multipliedBy(0.65);
                make.edges.mas_equalTo(self);
            }];
        }
        
        UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPlayicon"]];
        playImage.userInteractionEnabled = YES;
        _imageView.userInteractionEnabled = YES;
        //点击播放按钮
        [_imageView bk_whenTapped:^{
            if (self.playVideo) {
                self.playVideo(_isFreeVideo);
            }
            
        }];
        [_imageView addSubview:playImage];
        {
            [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_imageView);
                make.width.height.mas_equalTo(50/568.*kScreenHeight);
            }];
            
        }
        UIImageView *playProgress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playProgress"]];
        [_imageView addSubview:playProgress];
        {
            [playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(_imageView);
                make.height.mas_equalTo(15/568.*kScreenHeight);
            }];
            
        }
        //视频下面的图片详情
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumInteritemSpacing = kVideoImageSpace;
//        
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        
//        _collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
//        
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//        [self addSubview:_collectionView];
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        [_collectionView registerClass:[CRKVideoImageCollectionViewCell class] forCellWithReuseIdentifier:kVideoImageIdentifier];
//        
//        {
//            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_imageView.mas_bottom);
//                make.left.right.mas_equalTo(self);
//                make.height.mas_equalTo(self).multipliedBy(0.35);
//                
//            }];
//            
//        }
//        //
        
    }
    
    return self;
}

#pragma mark collectionView Delegate Datasoure

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return kVideoImageItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRKVideoImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoImageIdentifier forIndexPath:indexPath];
    cell.imageUrl = @"";
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kWidth = (kScreenWidth - 5*kVideoImageSpace)/4;
    
    return CGSizeMake(kWidth, kWidth*1.1);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![CRKUtil isPaid]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"会员用户才能查看详情图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
        [alerView show];
    }else {
        //        CRKVideoImageCollectionViewCell *cell = (CRKVideoImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        //        _popupPictureView = [[UIView alloc] init];
        //        _popupPictureView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        //        [self addSubview:_popupPictureView];
        //        {
        //            [_popupPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.edges.mas_equalTo(self);
        //                
        //            }];
        //            
        //        }
        NSArray *imageArr = @[@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg"];;
        
        if (self.popImageBloc) {
            self.popImageBloc(imageArr,indexPath);
        }
        
    }
    
}
//成为会员
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 ) {
        if (self.action) {
            self.action(nil);
        }
    }
}

- (NSArray<NSString *> *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg"];
    }
    
    return _imageArr;
}



- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
