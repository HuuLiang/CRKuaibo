//
//  CRKChannel.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/4/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKChannel.h"

@implementation CRKChannel

//- (BOOL)isEqual:(id)object {
//    if (![object isKindOfClass:[CRKChannel class]]) {
//        return NO;
//    }
//    
//    return [self.columnId isEqualToNumber:[object columnId]];
//}
//
//- (NSUInteger)hash {
//    return self.columnId.hash;
//}

- (Class)programListElementClass {
    return [CRKProgram class];
}
@end
