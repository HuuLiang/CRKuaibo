//
//  CRKUserProtolController.h
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"

@interface CRKUserProtolController : CRKBaseViewController

@property (nonatomic,readonly) NSURL *url;
@property (nonatomic,readonly) NSURL *standbyUrl;

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl;

@end
