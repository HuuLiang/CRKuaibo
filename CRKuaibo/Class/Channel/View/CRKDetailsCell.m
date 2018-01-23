//
//  CRKDetailsCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKDetailsCell.h"
#define KStarts 6


@interface CRKDetailsCell ()
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_introductionLabel;
    UILabel *_playNumber;
    UIView *_starView;
}

@end

@implementation CRKDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        NSArray *subviews = [[NSArray alloc] initWithArray:self.contentView.subviews];
        
        for (UIView *subview in subviews) {
            
            [subview removeFromSuperview];}
        
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holder.jpg"]];
        _imageView.contentMode = UIViewContentModeRedraw;
        [_imageView YPB_addAnimationForImageAppearing];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(self).mas_offset(4);
                make.bottom.mas_equalTo(self).offset(-4);
                make.width.mas_equalTo(self).multipliedBy(0.6);
            }];
        }
        //名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13.];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"香草";
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).mas_offset(15/667.*kScreenHeight);
                make.left.mas_equalTo(_imageView.mas_right).mas_offset(7);
            }];
        }
        //介绍
        UILabel *introduceLabel = [[UILabel alloc] init];
        _introductionLabel = introduceLabel;
        introduceLabel.textColor = [UIColor lightGrayColor];
        introduceLabel.text = @"清纯妹子的迷迷之音";
        introduceLabel.font = [UIFont systemFontOfSize:10.];
        introduceLabel.numberOfLines = 0;
        [self addSubview:introduceLabel];
        {
            [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLabel);
                make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(8/667.*kScreenHeight);
            }];
            
        }
        
        //播放次数
        _playNumber = [[UILabel alloc] init];
        _playNumber.font = [UIFont systemFontOfSize:11.];
        _playNumber.textColor = [UIColor orangeColor];
        
        [self addSubview:_playNumber];
        {
            [_playNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel.mas_left);
                make.centerY.mas_equalTo(_imageView.mas_centerY).mas_offset(14/667.*kScreenHeight);
            }];
        }
        //推荐星数
        _starView = [self creatStarView];
        [self addSubview:_starView];
        {
            [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-8/667.*kScreenHeight);
                make.left.mas_equalTo(_nameLabel.mas_left);
                make.right.mas_equalTo(self);
                make.height.mas_equalTo(12/667.*kScreenHeight);
            }];
            
        }
        
        //
        UILabel *recommend = [[UILabel alloc] init];
        recommend.text = @"推荐指数";
        recommend.font = [UIFont systemFontOfSize:11.];
        recommend.textColor = [UIColor blackColor];
        [self addSubview:recommend];
        {
            [recommend mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLabel);
                make.bottom.mas_equalTo(_starView.mas_top).mas_offset(-8/667.*kScreenHeight);
            }];
            
        }
        
    }
    
    return self;
}

- (UIView *)creatStarView{
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = self.backgroundColor;
    
    for (int i = 0; i< KStarts; i++) {
        UIImageView *starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        starImage.frame = CGRectMake(i *12, 0, 10, 10);
        [starView addSubview:starImage];
    }
    return starView;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setIntroduction:(NSString *)introduction {
    _introduction = introduction;
    _introductionLabel.text = introduction;
}

- (void)setPicUrl:(NSString *)picUrl {
    _picUrl = picUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
}

- (void)setSpeStarts:(NSString *)speStarts {
    _speStarts = speStarts;
    for (int i = 0; i < KStarts; i++) {
        if (i>speStarts.integerValue-1) {
            _starView.subviews[i].hidden = YES;
        }else{
            _starView.subviews[i].hidden = NO;
        }
    }
}

- (void)setAttentPerson:(NSString *)attentPerson {
    _attentPerson = attentPerson;
    _playNumber.text = [NSString stringWithFormat:@"播放: %@",attentPerson];
    
}

@end
