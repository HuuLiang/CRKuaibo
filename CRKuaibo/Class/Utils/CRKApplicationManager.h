//
//  CRKApplicationManager.h
//  ShiWanSprite
//
//  Created by Sean Yue on 15/5/4.
//  Copyright (c) 2015年 Kuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRKApplication.h"

@interface CRKApplicationManager : NSObject

+(instancetype)defaultManager;
-(instancetype)initWithApplicationWorkspace:(id)appWorkspace;

-(NSArray *)allApplications;
-(NSArray *)allInstalledApplications;

-(NSArray *)allApplicationIdentifiers;
-(NSArray *)allInstalledAppIdentifiers;

@end
