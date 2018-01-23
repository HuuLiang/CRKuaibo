//
//  CRKURLRequest.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRKURLResponse.h"

typedef NS_ENUM(NSUInteger, CRKURLResponseStatus) {
    CRKURLResponseSuccess,
    CRKURLResponseFailedByInterface,
    CRKURLResponseFailedByNetwork,
    CRKURLResponseFailedByParsing,
    CRKURLResponseFailedByParameter,
    CRKURLResponseNone
};

typedef NS_ENUM(NSUInteger, CRKURLRequestMethod) {
    CRKURLGetRequest,
    CRKURLPostRequest
};
typedef void (^CRKURLResponseHandler)(CRKURLResponseStatus respStatus, NSString *errorMessage);

@interface CRKURLRequest : NSObject

@property (nonatomic,retain) id response;

+ (Class)responseClass;  // override this method to provide a custom class to be used when instantiating instances of CRKURLResponse
+ (BOOL)shouldPersistURLResponse;
- (NSURL *)baseURL; // override this method to provide a custom base URL to be used
- (NSURL *)standbyBaseURL; // override this method to provide a custom standby base URL to be used

- (BOOL)shouldPostErrorNotification;
- (CRKURLRequestMethod)requestMethod;

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(id)params responseHandler:(CRKURLResponseHandler)responseHandler;

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(CRKURLResponseHandler)responseHandler;

// For subclass pre/post processing response object
- (void)processResponseObject:(id)responseObject withResponseHandler:(CRKURLResponseHandler)responseHandler;

@end
