//
//  CRKBaseViewController.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRKBaseViewController : UIViewController

- (void)switchToPlayProgram:(CRKProgram *)program programLocation:(NSUInteger)programLocation inChannel:(CRKChannel *)channel;

- (void)playVideo:(CRKProgram *)video
    videoLocation:(NSUInteger)videoLocation
        inChannel:(CRKChannel *)channel
  withTimeControl:(BOOL)hasTimeControl
 shouldPopPayment:(BOOL)shouldPopPayment;

- (NSUInteger)currentIndex;

@end
