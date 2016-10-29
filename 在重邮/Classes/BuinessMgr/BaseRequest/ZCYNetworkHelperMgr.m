//
//  ZCYNetworkHelperMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYNetworkHelperMgr.h"

static const NSString * URL = @"http://we.cqupt.edu.cn";

@implementation ZCYNetworkHelperMgr

+ (ZCYNetworkHelperMgr *)sharedMgr
{
    static ZCYNetworkHelperMgr *networkHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkHelper = [[self alloc] init];
    });
    return networkHelper;
}

- (void)requestWithData:(NSDictionary *)data andCompeletionBlock:(void (^)(NSError *, id, NSURLSessionDataTask *))compeletionBlock andURLPath:(NSString *)urlPath
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@",URL,urlPath] parameters:data progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (compeletionBlock)
        {
            compeletionBlock(nil, responseObject, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (compeletionBlock)
        {
            compeletionBlock(error, nil, task);
        }
    }];
}
@end
