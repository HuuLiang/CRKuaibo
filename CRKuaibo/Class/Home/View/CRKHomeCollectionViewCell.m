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
    UILabel *_freeLabel;
}

@end

@implementation CRKHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *subTitlebottomView = [[UIView alloc] init];
        subTitlebottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:subTitlebottomView];
        {
        [subTitlebottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self);
            make.height.mas_equalTo(20);
        }];
        }
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = [UIFont systemFontOfSize:8.];
        _subLabel.textColor = [UIColor blackColor];
//        _subLabel.backgroundColor = [UIColor whiteColor];
        [subTitlebottomView addSubview:_subLabel];
        {
            [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(subTitlebottomView);
//                make.height.mas_equalTo(20);
                make.centerY.mas_equalTo(subTitlebottomView);
                make.left.mas_equalTo(subTitlebottomView).mas_offset(8);
                make.right.mas_equalTo(subTitlebottomView).mas_offset(-8);
            }];
        }
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [_imageView YPB_addAnimationForImageAppearing];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(subTitlebottomView.mas_top);
            }];
        }
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.55];
        [_imageView addSubview:bottomView];
        {
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_imageView);
            make.height.mas_equalTo(15);
        }];
        
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:9.5];
        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.55];
        [bottomView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(bottomView);
//                make.height.mas_equalTo(15);
                make.left.mas_equalTo(bottomView).mas_offset(8);
                make.right.mas_equalTo(bottomView).mas_offset(-8);
            }];
        }
        
        _freeLabel = [[UILabel alloc] init];
        _freeLabel.textColor = [UIColor whiteColor];
        _freeLabel.text = @"试播";
        _freeLabel.backgroundColor = [UIColor colorWithHexString:@"#dd0077"];
        _freeLabel.textAlignment = NSTextAlignmentCenter;
        _freeLabel.font = [UIFont systemFontOfSize:13.5];
        _freeLabel.layer.cornerRadius = 2.5;
        _freeLabel.layer.masksToBounds = YES;
        [_imageView addSubview:_freeLabel];
        {
        [_freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_imageView).mas_offset(-4);
            make.top.mas_equalTo(_imageView).mas_offset(4);
            make.width.mas_equalTo(33);
        }];
        
        
        }
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subLabel.text = subTitle;
    
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}

- (void)setType:(NSNumber *)type {
    _type = type;
    if (type.integerValue == 5) {
        _freeLabel.hidden = NO;
    }else {
        _freeLabel.hidden = YES;
    }

}

@end
