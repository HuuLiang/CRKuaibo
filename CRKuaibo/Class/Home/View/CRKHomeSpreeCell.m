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
//                            make.edges.equalTo(self);
                make.top.bottom.mas_equalTo(self);
                make.left.mas_equalTo(self);//.mas_offset(-2.5);
                make.right.mas_equalTo(self);
            }];
            
        }
    }
    
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}


@end
