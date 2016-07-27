//
//  CRKChannelCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannelCell.h"

@interface CRKChannelCell ()
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
}

@end

@implementation CRKChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor darkGrayColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [_imageView YPB_addAnimationForImageAppearing];
        [self addSubview:_imageView];
        {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
            
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:25.];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setPicUrl:(NSString *)picUrl {
    _picUrl = picUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];

}

@end
