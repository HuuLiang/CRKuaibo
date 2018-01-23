//
//  UIScrollView+Refresh.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CRKPullToRefreshStyle) {
    CRKPullToRefreshStyleDefault,
    CRKPullToRefreshStyleDissolution
};

@interface UIScrollView (Refresh)

@property (nonatomic) BOOL CRK_showLastUpdatedTime;
@property (nonatomic) BOOL CRK_showStateLabel;
@property (nonatomic,weak,readonly) UIView *CRK_refreshView;
@property (nonatomic,readonly) BOOL isRefreshing;

- (void)CRK_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)CRK_addPullToRefreshWithStyle:(CRKPullToRefreshStyle)style handler:(void (^)(void))handler;
- (void)CRK_triggerPullToRefresh;
- (void)CRK_endPullToRefresh;

//- (void)CRK_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)CRK_addPagingRefreshWithIsLoadAll:(BOOL)isLoadAll Handler:(void (^)(void))handler;
- (void)CRK_pagingRefreshNoMoreData;

@end
