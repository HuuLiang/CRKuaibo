//
//  CRKLaunchView.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKLaunchView.h"

@interface CRKLaunchView ()
{
    UIImageView *_imageView;
}
@end

@implementation CRKLaunchView

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *launchImagePath = [[NSBundle mainBundle] pathForResource:@"launchImage" ofType:@"jpg"];
        _imageView.image = [UIImage imageWithContentsOfFile:launchImagePath];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)dealloc {
    DLog(@"CRKLaunchView dealloc");
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow.subviews containsObject:keyWindow]) {
        return ;
    }
    
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
//    {
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(keyWindow);
//        }];
//    }
    
    [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        _imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
