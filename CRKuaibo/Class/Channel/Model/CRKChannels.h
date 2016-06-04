//
//  Channels.h
//  CRKuaibo
//
//  Created by ylz on 16/6/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CRKChannels <NSObject>

@end


@interface CRKChannels : NSObject

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;
@property (nonatomic,retain) NSArray<CRKProgram *> *programList;

@end

