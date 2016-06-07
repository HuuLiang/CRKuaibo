//
//  CRKVideoCollectionViewCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKVideoCollectionViewCell.h"

@interface CRKVideoCollectionViewCell ()
{
    UIImageView *_imageView;
    UIScrollView *_scrollView;
}
@property (nonatomic,assign)NSArray <NSString *>*imageArr;

@end

@implementation CRKVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self);
                make.height.mas_equalTo(self);
            }];
        }
        
        UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPlayicon"]];
        [_imageView addSubview:playImage];
        {
            [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_imageView);
                make.width.height.mas_equalTo(50);
            }];
            
        }
        UIImageView *playProgress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playProgress"]];
        [_imageView addSubview:playProgress];
        {
            [playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(_imageView);
                make.height.mas_equalTo(15);
            }];
            
        }
        
        //        _scrollView = [self creatScrollViewWithItems:5];
        //        [self addSubview:_scrollView];
        //        _scrollView.backgroundColor = [UIColor whiteColor];
        //        {
        //            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.top.mas_equalTo(_imageView.mas_bottom);
        //                make.left.right.mas_equalTo(self);
        //                make.height.mas_equalTo(_scrollView.mas_width).multipliedBy(0.2);
        //
        //            }];
        //
        //        }
        //
        
    }
    
    return self;
}

- (UIScrollView *)creatScrollViewWithItems:(NSInteger)items {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    CGFloat itemWidth = (kScreenWidth -4)/4;
    CGFloat itemHeight = itemWidth;
    CGFloat y = (scrollView.bounds.size.height - itemHeight)/2;
    for (int i = 0; i<items; ++i) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*itemWidth, y, itemWidth, itemHeight)];
        
        NSURL *imageURl = [NSURL URLWithString:self.imageArr[i]];
        
        [manager downloadImageWithURL:imageURl options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error==nil) {
                //                btn.imageView.image = image;
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
        
        [btn bk_addEventHandler:^(id sender) {
            if (![CRKUtil isPaid]) {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"加入会员查看更多" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
                [alerView show];
            }else{
                UIImageView *currentImageView = [self popupBigImageWithImage:imageURl];
                [self addSubview:currentImageView];
                {
                    [currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(self);
                        make.height.width.mas_equalTo(0.1);
                    }];
                }
                
                [UIView animateWithDuration:0.5 animations:^{
                    currentImageView.transform = CGAffineTransformMakeScale(12, 10);
                    
                } completion:nil];
                
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    scrollView.contentSize = CGSizeMake((itemWidth + 5) *items, 0);
    return scrollView;
}

//弹框
- (UIImageView *)popupBigImageWithImage:(NSURL *)imageUrl {
    UIImageView *popuImage = [[UIImageView alloc] init];
    [popuImage sd_setImageWithURL:imageUrl];
    UIButton *closeBtn =  [[UIButton alloc] init];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    [popuImage addSubview:closeBtn];
    {
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(popuImage);
        }];
        
    }
    [closeBtn bk_addEventHandler:^(id sender) {
        [UIView animateWithDuration:0.5 animations:^{
            popuImage.frame = CGRectZero;
            [popuImage removeFromSuperview];
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    return popuImage;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLog(@"支付-->弹框");
    }
    
}

- (void)setIsFreeVideo:(BOOL)isFreeVideo {
    _isFreeVideo = isFreeVideo;
    
    if (isFreeVideo) {
        
        _scrollView.frame = CGRectZero;
        _scrollView.hidden = YES;
        [_scrollView removeFromSuperview];
    }
    
}

- (NSArray<NSString *> *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png",@"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png",@"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png",@"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png",@"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png"];
    }
    return _imageArr;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
