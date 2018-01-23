//
//  CRKVideoImageCollectionViewCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKVideoImageCollectionViewCell.h"

@interface CRKVideoImageCollectionViewCell ()
{
    UIImageView *_imageView;
}

@end

@implementation CRKVideoImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
            
        }
    }
    
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    imageUrl = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823xcmn.jpg";
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

@end
