//
//  UIScrollView+Refresh.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh.h>

static const void *kCRKRefreshViewAssociatedKey = &kCRKRefreshViewAssociatedKey;
static const void *kCRKShowLastUpdatedTimeAssociatedKey = &kCRKShowLastUpdatedTimeAssociatedKey;
static const void *kCRKShowStateAssociatedKey = &kCRKShowStateAssociatedKey;

@implementation UIScrollView (Refresh)

- (UIColor *)CRK_refreshTextColor {
    return [UIColor colorWithWhite:0.8 alpha:1];
}

- (BOOL)isRefreshing {
    if ([self.CRK_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.CRK_refreshView;
        return refresh.state == MJRefreshStateRefreshing;
    }
    return NO;
}

- (UIView *)CRK_refreshView {
    return objc_getAssociatedObject(self, kCRKRefreshViewAssociatedKey);
}

- (void)setCRK_showLastUpdatedTime:(BOOL)CRK_showLastUpdatedTime {
    objc_setAssociatedObject(self, kCRKShowLastUpdatedTimeAssociatedKey, @(CRK_showLastUpdatedTime), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if ([self.header isKindOfClass:[MJRefreshStateHeader class]]) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.header;
        header.lastUpdatedTimeLabel.hidden = !CRK_showLastUpdatedTime;
    }
}

- (BOOL)CRK_showLastUpdatedTime {
    NSNumber *value = objc_getAssociatedObject(self, kCRKShowLastUpdatedTimeAssociatedKey);
    return value.boolValue;
}

- (void)setCRK_showStateLabel:(BOOL)CRK_showStateLabel {
    objc_setAssociatedObject(self, kCRKShowStateAssociatedKey, @(CRK_showStateLabel), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if ([self.header isKindOfClass:[MJRefreshStateHeader class]]) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.header;
        header.stateLabel.hidden = !CRK_showStateLabel;
    }
}

- (BOOL)CRK_showStateLabel {
    NSNumber *value = objc_getAssociatedObject(self, kCRKShowStateAssociatedKey);
    return value.boolValue;
}

- (void)CRK_addPullToRefreshWithHandler:(void (^)(void))handler {
    [self CRK_addPullToRefreshWithStyle:CRKPullToRefreshStyleDefault handler:handler];
}

- (void)CRK_addPullToRefreshWithStyle:(CRKPullToRefreshStyle)style handler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
//            refreshHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        refreshHeader.lastUpdatedTimeLabel.textColor = [self CRK_refreshTextColor];
        refreshHeader.stateLabel.textColor = [self CRK_refreshTextColor];
        refreshHeader.lastUpdatedTimeLabel.hidden = !self.CRK_showLastUpdatedTime;
        self.header = refreshHeader;
        
        objc_setAssociatedObject(self, kCRKRefreshViewAssociatedKey, refreshHeader, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)CRK_triggerPullToRefresh {
    
    if ([self.CRK_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.CRK_refreshView;
        [refresh beginRefreshing];
    }
}

- (void)CRK_endPullToRefresh {
    if ([self.CRK_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.CRK_refreshView;
        [refresh endRefreshing];
        [self.footer resetNoMoreData];
    }
}

- (void)CRK_addPagingRefreshWithIsLoadAll:(BOOL)isLoadAll Handler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
//        refreshFooter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        refreshFooter.stateLabel.textColor = [self CRK_refreshTextColor];
        if (isLoadAll && ![CRKUtil isPaid]) {
            [refreshFooter setTitle:@"⬆️成为VIP，上拉或者点击加载更多" forState:MJRefreshStateIdle];
        }
        self.footer = refreshFooter;
    }
}

- (void)CRK_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}
@end
