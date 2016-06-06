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
}

@end

@implementation CRKHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.4];
        [_imageView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.mas_equalTo(_imageView);
                make.height.mas_equalTo(24);
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

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    imageUrl = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20150823gzym.jpg";
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}

@end
