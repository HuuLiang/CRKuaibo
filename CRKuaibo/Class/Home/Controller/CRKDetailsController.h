//
//  CRKController.h
//  CRKuaibo
//
//  Created by ylz on 16/6/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"

@interface CRKDetailsController : CRKBaseViewController

@property (nonatomic,retain)CRKChannel *channel;
@property (nonatomic,retain)CRKProgram *program;
@property(nonatomic,assign) NSInteger type;

@property (nonatomic,retain)CRKChannel *currentChannel;

@property (nonatomic,retain) CRKChannel *speChannel;
- (instancetype)initWithChannel:(CRKChannel*)channel program:(CRKProgram*)program programIndex:(NSInteger )programIndex;

@end
