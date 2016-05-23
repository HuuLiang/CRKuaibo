//
//  CRKLocalNotificationManager.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKLocalNotificationManager.h"
#import "CRKSystemConfigModel.h"

@implementation CRKLocalNotificationManager

+ (instancetype)sharedManager {
    static CRKLocalNotificationManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)scheduleLocalNotificationInEnteringBackground {
    [self cancelAllNotifications];
    
    NSInteger notiLaunchSeq = [CRKSystemConfigModel sharedModel].notificationLaunchSeq;
    if (notiLaunchSeq >= 0 && [CRKUtil launchSeq] >= notiLaunchSeq) {
        NSString *notification = [CRKSystemConfigModel sharedModel].notificationText;
        NSInteger delay = [CRKSystemConfigModel sharedModel].notificationBackgroundDelay;
        if (notification.length > 0 && delay >= 0) {
            [self scheduleLocalNotification:notification withDelay:delay];
            DLog(@"Schedule local notification %@ with delay %ld", notification, delay);
        }
        
        [self scheduleRepeatNotification];
    }
}

- (void)scheduleLocalNotification:(NSString *)notification withDelay:(NSTimeInterval)delay {
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertBody = notification;
    localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    localNoti.timeZone = [NSTimeZone defaultTimeZone];
    localNoti.applicationIconBadgeNumber = 1;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
}

- (void)cancelAllNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    DLog(@"Cancel all notifications!");
}

- (void)scheduleRepeatNotification {
    NSString *notification = [CRKSystemConfigModel sharedModel].notificationText;
    NSString *repeatTimeString = [CRKSystemConfigModel sharedModel].notificationRepeatTimes;
    NSArray<NSString *> *repeatTimeStrings = [repeatTimeString componentsSeparatedByString:@";"];
    if (notification.length > 0 && repeatTimeStrings.count > 0) {
        [self scheduleRepeatNotification:notification withTimes:repeatTimeStrings];
        DLog(@"Schedule repeated notification: %@ with repeated times: %@", notification, repeatTimeString);
    }
}

- (void)scheduleRepeatNotification:(NSString *)notification withTimes:(NSArray<NSString *> *)times {
    if (notification.length == 0) {
        return ;
    }
    
    _repeatTimes = times;
    [times enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        dateString = [dateString stringByAppendingFormat:@" %@:00", obj];
        
        [dateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
        NSDate *fireDate = [dateFormatter dateFromString:dateString];
        if (fireDate) {
            UILocalNotification *localNoti = [[UILocalNotification alloc] init];
            localNoti.alertBody = notification;
            localNoti.timeZone = [NSTimeZone defaultTimeZone];
            localNoti.applicationIconBadgeNumber = 1;
            localNoti.soundName = UILocalNotificationDefaultSoundName;
            localNoti.repeatCalendar = [NSCalendar currentCalendar];
            localNoti.repeatInterval = NSCalendarUnitDay;
            localNoti.fireDate = fireDate;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        }
    }];
}

@end
