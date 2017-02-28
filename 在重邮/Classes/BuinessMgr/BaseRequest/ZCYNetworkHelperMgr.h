//
//  ZCYNetworkHelperMgr.h
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYNetworkHelperMgr : NSObject

+ (ZCYNetworkHelperMgr *)sharedMgr;

- (void)requestWithData:(NSDictionary *)data andCompletionBlock:(void(^)(NSError *error, id response,NSURLSessionDataTask *task))completionBlock andURLPath:(NSString *)urlPath;

- (void)wx_requestWithData:(NSDictionary *)data andCompletionBlock:(void(^)(NSError *, id, NSURLSessionDataTask *))completionBlock andURLPath:(NSString *)urlPath;

- (void)GetRequestWithData:(NSDictionary *)data andCompletionBlock:(void (^)(NSError *, id, NSURLSessionDataTask *))completionBlock andURLPath:(NSString *)urlPath;

@end
