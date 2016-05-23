//
//  CRKVideoPlayer.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/1/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRKVideoPlayer : UIView

@property (nonatomic,readonly) NSURL *videoURL;
@property (nonatomic,copy) CRKAction endPlayAction;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;
- (void)startToPlay;
- (void)pause;

@end
