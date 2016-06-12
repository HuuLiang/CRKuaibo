//
//  CRKVideoCollectionViewCell.h
//  CRKuaibo
//
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popViewBloc)(NSArray*arr,NSIndexPath*indexpath);
typedef void(^playVideoBloc)(BOOL);

@interface CRKVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,assign)BOOL isFreeVideo;

@property (nonatomic,copy)CRKAction action;//支付

@property (nonatomic,copy)popViewBloc popImageBloc;//图片弹框

@property (nonatomic,assign,getter=isFreeVideo)BOOL freeVideo;//是否是试播视频

@property (nonatomic,copy)playVideoBloc playVideo; //视频播放

@end
