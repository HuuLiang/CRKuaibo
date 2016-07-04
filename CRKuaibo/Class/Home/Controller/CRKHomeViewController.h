//
//  CRKHomeViewController.h
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
@class CRKHomePageModel;

@interface CRKHomeViewController : CRKBaseViewController

@property (nonatomic,retain)UISegmentedControl *segmentCtrolller;
- (instancetype)initWithHomeModel:(CRKHomePageModel*)homePageModel;

@end
