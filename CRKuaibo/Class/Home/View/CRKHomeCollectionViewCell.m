//
//  CRKHomeCollectionViewCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomeCollectionViewCell.h"

@interface CRKHomeCollectionViewCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_subLabel;
}

@end

@implementation CRKHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = [UIFont systemFontOfSize:11.];
        _subLabel.textColor = [UIColor blackColor];
        _subLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_subLabel];
        {
            [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.mas_equalTo(self);
                make.height.mas_equalTo(15);
            }];
        }
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(_subLabel.mas_top);
            }];
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.55];
        [_imageView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.mas_equalTo(_imageView);
                make.height.mas_equalTo(15);
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    //    _titleLabel.text = title;
    _titleLabel.text = @"哈哈哈哈哈";
    
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subLabel.text = @"sdfsalfjklsaj";
    
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    imageUrl = @"http://apkcdn.mquba.com/wysy/video/imgcover/20160526x2.png";
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}

@end
