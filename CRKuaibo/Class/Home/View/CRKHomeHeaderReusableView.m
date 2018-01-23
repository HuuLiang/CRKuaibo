//
//  CRKHomeHeaderReusableView.m
//  CRKuaibo
//
//  Created by ylz on 16/6/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomeHeaderReusableView.h"

@interface CRKHomeHeaderReusableView ()
{
    UIImageView *_imageView;
}

@end

@implementation CRKHomeHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.height.mas_equalTo(15);
            }];
            
        }
    }
    return self;
}

- (void)setIsFreeVideo:(BOOL)isFreeVideo {
    _isFreeVideo = isFreeVideo;
    
    NSString *imageName = isFreeVideo ? @"freeVideo" :@"recommendImage";
    _imageView.image = [UIImage imageNamed:imageName];
    
}

- (void)setIsHotRecommend:(BOOL)isHotRecommend {
    _isHotRecommend = isHotRecommend;
    if (isHotRecommend) {
        
        _imageView.image = [UIImage imageNamed:@"hotrecommendImage"];
    }
    
}

@end
