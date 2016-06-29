//
//  CRKHomeCollectionViewCell.h
//  CRKuaibo
//
//  Created by ylz on 16/6/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRKHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *subTitle;

@property (nonatomic)NSNumber *type;

@end
