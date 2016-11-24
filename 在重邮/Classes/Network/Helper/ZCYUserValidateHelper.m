//
//  ZCYUserValidateHelper.m
//  在重邮
//
//  Created by 周维康 on 16/11/7.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserValidateHelper.h"
#import "ZCYNetworkHelperMgr.h"


@implementation ZCYUserValidateHelper

+ (void)getUserInfoWithUserName:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(void(^)(NSError *, id response))completionBlock
{
    NSDictionary *userDic = @{
                              @"userName" : username,
                              @"password" : password
                              };
    [[ZCYNetworkHelperMgr sharedMgr] wx_requestWithData:userDic andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error)
        {
            completionBlock(error, nil);
            return;
        }
        completionBlock (nil, response);
    } andURLPath:@"/logisticsRepair/userAuth"];
}
@end
