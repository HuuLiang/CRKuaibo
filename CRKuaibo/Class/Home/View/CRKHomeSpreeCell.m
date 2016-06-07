//
//  CRKHomeSpreeCell.m
//  CRKuaibo
//
//  Created by ylz on 16/6/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKHomeSpreeCell.h"

@interface CRKHomeSpreeCell ()
{
    UIImageView *_imageView;
}

@end

@implementation CRKHomeSpreeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(-2.5);
        }];
        
        }
    }

    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {

    _imageUrl = imageUrl;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
      [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151217b2.jpg"]];

}


@end
