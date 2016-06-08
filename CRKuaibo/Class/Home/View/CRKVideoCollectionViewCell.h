//
//  CRKVideoCollectionViewCell.h
//  CRKuaibo
//
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popViewBloc)(NSArray*arr,NSIndexPath*indexpath);

@interface CRKVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,assign)BOOL isFreeVideo;

@property (nonatomic,copy)CRKAction action;

@property (nonatomic,copy)popViewBloc popImageBloc;

@end
