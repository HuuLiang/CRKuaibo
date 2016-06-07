//
//  CRKRecommendHeaderView.m
//  CRKuaibo
//
//  Created by ylz on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKRecommendHeaderView.h"

@interface CRKRecommendHeaderView ()


@end

@implementation CRKRecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *recommendImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipheader"]];
        //        [recommendImage sizeToFit];
        [self addSubview:recommendImage];
        { [recommendImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(17);
        }];}
        
    }
    return self;
}




@end
