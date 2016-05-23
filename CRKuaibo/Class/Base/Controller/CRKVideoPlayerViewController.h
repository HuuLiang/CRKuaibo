//
//  CRKVideoPlayerViewController.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"

@interface CRKVideoPlayerViewController : CRKBaseViewController

@property (nonatomic,retain,readonly) CRKProgram *video;
@property (nonatomic,readonly) NSUInteger videoLocation;
@property (nonatomic,retain,readonly) CRKChannel *channel;
@property (nonatomic) BOOL shouldPopupPaymentIfNotPaid;

- (instancetype)initWithVideo:(CRKProgram *)video videoLocation:(NSUInteger)videoLocation channel:(CRKChannel *)channel;

@end
