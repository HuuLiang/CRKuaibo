//
//  CRKProgram.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "CRKProgram.h"

static NSString *const kVideoHistoryKeyName = @"crkuaibov_video_history_keyname";

@implementation CRKProgramUrl

@end

@implementation CRKProgram

- (Class)urlListElementClass {
    return [CRKProgramUrl class];
}

+ (NSArray<CRKProgram *> *)allPlayedPrograms {
    NSMutableArray *playedPrograms = [NSMutableArray array];
    NSArray<NSDictionary *> *history = [[NSUserDefaults standardUserDefaults] objectForKey:kVideoHistoryKeyName];
    [history enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CRKProgram *video = [CRKProgram programFromPersistentEntry:obj];
        [playedPrograms addObject:video];
    }];
    return playedPrograms.count > 0 ? playedPrograms : nil;
}

- (NSDictionary *)persistentEntry {
    NSMutableDictionary *entry = [NSMutableDictionary dictionary];
    [entry safelySetObject:self.programId forKey:@"programId"];
    [entry safelySetObject:self.title forKey:@"title"];
    [entry safelySetObject:self.specialDesc forKey:@"specialDesc"];
    [entry safelySetObject:self.videoUrl forKey:@"videoUrl"];
    [entry safelySetObject:self.coverImg forKey:@"coverImg"];
    [entry safelySetObject:self.spec forKey:@"spec"];
    [entry safelySetObject:self.type forKey:@"type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDefaultDateFormat];
    NSString *dateString = [formatter stringFromDate:self.playedDate];
    [entry safelySetObject:dateString forKey:@"playedDate"];
    return entry;
}

+ (instancetype)programFromPersistentEntry:(NSDictionary *)entry {
    CRKProgram *program = [[self alloc] init];
    program.programId = entry[@"programId"];
    program.title = entry[@"title"];
    program.specialDesc = entry[@"specialDesc"];
    program.videoUrl = entry[@"videoUrl"];
    program.coverImg = entry[@"coverImg"];
    program.spec = entry[@"spec"];
    program.type = entry[@"type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDefaultDateFormat];
    program.playedDate = [formatter dateFromString:entry[@"playedDate"]];
    return program;
}

- (void)didPlay {
    self.playedDate = [NSDate date];
    
    NSArray *history = [[NSUserDefaults standardUserDefaults] objectForKey:kVideoHistoryKeyName];
    NSMutableArray *historyM = [history mutableCopy];
    if (!historyM) {
        historyM = [NSMutableArray array];
    }
    
    NSDictionary *existingProgram = [historyM bk_match:^BOOL(NSDictionary *obj) {
        if ([self.programId isEqualToNumber:obj[@"programId"]]) {
            return YES;
        }
        return NO;
    }];
    
    if (existingProgram) {
        [historyM removeObject:existingProgram];
    }
    [historyM addObject:self.persistentEntry];
    
    [[NSUserDefaults standardUserDefaults] setObject:historyM forKey:kVideoHistoryKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)playedDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:self.playedDate];
    return dateString;
}
@end
//
//@implementation CRKPrograms
//
//- (Class)programListElementClass {
//    return [CRKProgram class];
//}
//
//@end
