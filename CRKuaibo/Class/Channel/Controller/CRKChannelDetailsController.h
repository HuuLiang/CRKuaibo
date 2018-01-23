//
//  CRKChannelDetailsController.h
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
@class CRKChannel;

@interface CRKChannelDetailsController : CRKBaseViewController

@property (nonatomic,retain)CRKChannel *channel;

- (instancetype)initWithChannel:(CRKChannel *)channel ;
@end
