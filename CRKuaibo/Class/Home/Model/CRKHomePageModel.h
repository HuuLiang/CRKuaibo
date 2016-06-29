//
//  CRKHomePage.h
//  CRKuaibo
//
//  Created by ylz on 16/6/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKEncryptedURLRequest.h"



@interface CRKUniverSlity : NSObject

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSString *columnImg;

@end


@interface CRKHomePageProgram : NSObject
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic,retain)NSArray <CRKUniverSlity *>*columnList;
@end


@interface CRKHomePage :NSObject

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic,retain)NSArray <CRKHomePageProgram *>*columnList;

@end

@interface CRKHomePageResponse : CRKURLResponse
@property (nonatomic,retain)NSArray <CRKHomePage *>*columnList;

@end


typedef void (^CRKFetchChannelsCompletionHandler)(BOOL success, NSArray<CRKHomePage *>*programs);

@interface CRKHomePageModel : CRKEncryptedURLRequest

@property (nonatomic,retain) CRKHomePageResponse *fetchChannel;

@property (nonatomic,retain) NSArray<CRKHomePage *> *fetchHomePage;

@property (nonatomic,retain) CRKHomePage *homePageOM;
@property (nonatomic,retain) CRKHomePage *homePageRH;
@property (nonatomic,retain) CRKHomePage *homePageDL;

//@property (nonatomic,retain) NSArray<CRKHomePageProgram*>*fetcheSubHomePage;
//
//@property (nonatomic,retain) NSArray <CRKUniverSlity*>*fetchUniverSlityOM;
//@property (nonatomic,retain) NSArray <CRKUniverSlity*>*fetchUniverSlityRH;
//@property (nonatomic,retain) NSArray <CRKUniverSlity*>*fetchUniverSlityDL;

- (BOOL)fetchWiithCompletionHandler:(CRKFetchChannelsCompletionHandler)handler;

@end
