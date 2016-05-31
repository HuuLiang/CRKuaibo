//
//  CRKInputViewController.h
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKBaseViewController.h"
typedef BOOL (^CRKInputTextCompletionHandler)(id sender, NSString *text);
typedef BOOL (^CRKInputTextChangeHandler)(id sender, NSString *text);


@interface CRKInputViewController : CRKBaseViewController

@property (nonatomic) NSUInteger limitedTextLength;
//@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;


@property (nonatomic,copy) CRKInputTextCompletionHandler completionHandler;
@property (nonatomic,copy) CRKInputTextChangeHandler changeHandler;

@end
