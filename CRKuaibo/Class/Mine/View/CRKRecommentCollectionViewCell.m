//
//  CRKRecommentCollectionViewCell.m
//  CRKuaibo
//
//  Created by ylz on 16/5/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKRecommentCollectionViewCell.h"


@interface CRKRecommentCollectionViewCell ()
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
}

@end

@implementation CRKRecommentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self).mas_offset(-5);
                make.centerX.mas_equalTo(self.mas_centerX);
            }];
        }
        
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        {
            //            CGFloat heightWidth = self.bounds.size.height - _titleLabel.bounds.size.height-8;
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self);
                make.bottom.mas_equalTo(_titleLabel.mas_top).mas_offset(-8);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(self.bounds.size.height*0.75);
            }];  
        }
        
    }
    
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    //    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    @weakify(self);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        _imageView.image = [self scaleImage:image toScale:0.5];
    }];
    
}
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
}
//等比例缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
