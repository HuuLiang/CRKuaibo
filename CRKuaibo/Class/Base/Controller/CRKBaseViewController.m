//
//  CRKBaseViewController.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
#import "CRKVideoPlayerViewController.h"
#import "CRKPaymentViewController.h"

@import MediaPlayer;
@import AVKit;
@import AVFoundation.AVPlayer;

@interface CRKBaseViewController ()

@end

@implementation CRKBaseViewController

- (NSUInteger)currentIndex {
    return NSNotFound;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"%@ dealloc", [self class]);
}

- (void)switchToPlayProgram:(CRKProgram *)program programLocation:(NSUInteger)programLocation inChannel:(CRKChannel *)channel {
    if (program.type.unsignedIntegerValue == CRKProgramTypeSpread) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
        return ;
    }

    if (![CRKUtil isPaid]) {
        [self payForProgram:program programLocation:programLocation inChannel:channel];
    } else if (program.type.unsignedIntegerValue == CRKProgramTypeVideo) {
        if (program.spec.unsignedIntegerValue == CRKVideoSpecFree) {
            [self playVideo:program videoLocation:programLocation inChannel:channel withTimeControl:NO shouldPopPayment:YES];
        } else {
            [self playVideo:program videoLocation:programLocation inChannel:channel withTimeControl:YES shouldPopPayment:NO];
        }
    }
}


- (void)playVideo:(CRKProgram *)video
    videoLocation:(NSUInteger)videoLocation
        inChannel:(CRKChannel *)channel
  withTimeControl:(BOOL)hasTimeControl
 shouldPopPayment:(BOOL)shouldPopPayment
{
    if (hasTimeControl) {
        UIViewController *videoPlayVC = [self playerVCWithVideo:video];
        videoPlayVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:videoPlayVC animated:YES completion:nil];
    } else {
        CRKVideoPlayerViewController *playerVC = [[CRKVideoPlayerViewController alloc] initWithVideo:video videoLocation:videoLocation channel:channel];
        playerVC.hidesBottomBarWhenPushed = YES;
        playerVC.shouldPopupPaymentIfNotPaid = shouldPopPayment;
        [self presentViewController:playerVC animated:YES completion:nil];
    }
    
    [video didPlay];
}

- (void)payForProgram:(CRKProgram *)program programLocation:(NSUInteger)programLocation inChannel:(CRKChannel *)channel {
    [[CRKPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window
                                                        forProgram:program
                                                   programLocation:programLocation
                                                         inChannel:channel
                                             withCompletionHandler:nil];
}

- (UIViewController *)playerVCWithVideo:(CRKProgram *)video {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:video.videoUrl]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:video.videoUrl]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
