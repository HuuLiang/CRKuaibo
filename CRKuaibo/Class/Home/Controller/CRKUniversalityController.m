//
//  CRKUniversalityController.m
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKUniversalityController.h"

static CGFloat const kspace = 5;

@interface CRKUniversalityController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectinView;
    
}

@end

@implementation CRKUniversalityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kspace;
    layout.minimumInteritemSpacing = kspace;
    _collectinView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectinView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_collectinView];
    {
    [_collectinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
