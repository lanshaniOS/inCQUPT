//
//  ZCYUserInfoHelper.m
//  在重邮
//
//  Created by 周维康 on 16/12/12.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserInfoHelper.h"

@implementation ZCYUserInfoHelper

+ (void)getUserTokenwithCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://we.cqu.pt/api/users/get_token.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *token = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"] options:0];
        NSString *baseToken = [[NSString alloc] initWithData:token encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:baseToken forKey:@"ZCYUserToken"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
@end
