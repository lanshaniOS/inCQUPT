//
//  ZCYNetworkHelperMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYNetworkHelperMgr.h"

static const NSString * URL = @"https://we.cqu.pt";
static const NSString *WXURL = @"http://wx.cqupt.edu.cn";

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

- (void)requestWithData:(NSDictionary *)data andCompletionBlock:(void (^)(NSError *, id, NSURLSessionDataTask *))completionBlock andURLPath:(NSString *)urlPath
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    [mutableDic setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    [mutableDic setObject:@"在重邮" forKey:@"openid"];
//    [mutableDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ZCYUserToken"] forKey:@"token"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:mutableDic options:0 error:nil];
    
    NSString *requestString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    NSMutableString *signString = [NSMutableString stringWithFormat:@"%@",requestString];
    [signString deleteCharactersInRange:NSMakeRange(requestString.length-1, 1)];
    [signString appendFormat:@",\"token\":\"%@\"}", [[NSUserDefaults standardUserDefaults] objectForKey:@"ZCYUserToken"]];
    NSMutableDictionary *endDic = [[NSMutableDictionary alloc] initWithDictionary:data];
    [endDic setObject:[NSString getmd5WithString:signString] forKey:@"sign"];
    NSMutableString *endString = [NSMutableString stringWithFormat:@"%@",requestString];
    [endString deleteCharactersInRange:NSMakeRange(requestString.length-1, 1)];
    [endString appendFormat:@",\"sign\":\"%@\"}",[NSString getmd5WithString:signString]];
    
    [endDic setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    [endDic setObject:@"在重邮" forKey:@"openid"];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *keyString = [endData base64EncodedStringWithOptions:0];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,urlPath] parameters:@{
                                                                               @"key": keyString
                                                                               
                                                                                   
                                                                               }progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"status"] integerValue] == 200)
        {
            if (completionBlock)
            {
                completionBlock(nil, responseObject, task);
            }
        } else {
            if (completionBlock)
            {
                completionBlock(nil, nil, task);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock)
        {
            completionBlock(error, nil, task);
        }
    }];
}

- (void)wx_requestWithData:(NSDictionary *)data andCompletionBlock:(void(^)(NSError *, id, NSURLSessionDataTask *))completionBlock andURLPath:(NSString *)urlPath
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",WXURL,urlPath] parameters:data progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock)
        {
            completionBlock(nil, responseObject, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (completionBlock)
        {
            completionBlock(error, nil, task);
        }
    }];

}

- (void)postRequestWithData:(NSDictionary *)data andCompletionBlock:(void (^)(NSError *, id, NSURLSessionDataTask *))completionBlock andURLPath:(NSString *)urlPath
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,urlPath] parameters:data progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock)
        {
            completionBlock(nil, responseObject, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (completionBlock)
        {
            completionBlock(error, nil, task);
        }
    }];
    
}
@end
