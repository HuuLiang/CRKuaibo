//
//  CRKUserProtolController.m
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKUserProtolController.h"

@interface CRKUserProtolController ()
{
    UIWebView *_webView;
}
@end

@implementation CRKUserProtolController


- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl {
    self = [self init];
    if (self) {
        _url = url;
        _standbyUrl = standbyUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:_url];
    NSURLRequest *standUrlReq = [NSURLRequest requestWithURL:_standbyUrl];
    
    if (_standbyUrl) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSHTTPURLResponse *response;
            NSError *error;
            [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&response error:&error];
            NSInteger responseCode = response.statusCode;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseCode == 502 || responseCode == 404) {
                    [_webView loadRequest:standUrlReq];
                } else {
                    [_webView loadRequest:urlReq];
                }
            });
        });
    } else {
        [_webView loadRequest:urlReq];
    }
}



@end
