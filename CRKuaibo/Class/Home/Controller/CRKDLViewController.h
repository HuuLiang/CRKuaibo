//
//  CRKDLViewController.h
//  CRKuaibo
//
//  Created by ylz on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
#import "CRKHomePageModel.h"

@interface CRKDLViewController : CRKBaseViewController

@property (nonatomic,retain)CRKHomePage *homePage;
//@property (nonatomic,retain)CRKHomePageProgram *subHomePage;

- (instancetype)initWithHomePage:( CRKHomePage*)homePage ;

@end
