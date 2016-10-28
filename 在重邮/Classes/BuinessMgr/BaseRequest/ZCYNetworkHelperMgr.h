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

- (void)requestWithData:(NSDictionary *)data andCompeletionBlock:(void(^)(NSError *error, id response,NSURLSessionDataTask *task))compeletionBlock andURLPath:(NSString *)urlPath;

@end
