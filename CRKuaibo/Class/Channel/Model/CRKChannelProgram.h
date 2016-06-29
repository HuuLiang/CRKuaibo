//
//  CRKDeailsProgram.h
//  CRKuaibo
//
//  Created by ylz on 16/6/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRKProgram.h"


@protocol CRKChannelProgram <NSObject>

@end

@interface CRKChannelProgram : CRKProgram
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;
@end

@protocol CRKChannelPrograms <NSObject>

@end

@interface CRKChannelPrograms : CRKChannel
//@property (nonatomic) NSNumber *items;
//@property (nonatomic) NSNumber *page;
//@property (nonatomic) NSNumber *pageSize;
@end
