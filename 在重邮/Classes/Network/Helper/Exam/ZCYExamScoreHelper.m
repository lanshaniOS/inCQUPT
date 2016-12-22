//
//  ZCYExamScoreHelper.m
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYExamScoreHelper.h"

@implementation ZCYExamScoreHelper

+ (void)getExamScoreWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock
{
    if ([ZCYUserMgr sharedMgr].identityCard)
    {
        NSString *keyString = [[ZCYUserMgr sharedMgr].identityCard substringWithRange:NSMakeRange([[ZCYUserMgr sharedMgr].identityCard length]-6, 6)];
        [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : studentNumber,
                                                           @"sfzh" : keyString} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
                                                               if ([response[@"status"] integerValue] == 200)
                                                                   compeletionBlock(error, response[@"data"]);
                                                               else {
                                                                   compeletionBlock(error, nil);
                                                               }
                                                           } andURLPath:@"/api/get_kscj.php"];

    } else {
        [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : studentNumber,
                                                           @"sfzh" : [[NSUserDefaults standardUserDefaults] objectForKey:@"ZCYUSERPASSWORD"]} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
                                                               if ([response[@"status"] integerValue] == 200)
                                                                   compeletionBlock(error, response[@"data"]);
                                                               else {
                                                                   compeletionBlock(error, nil);
                                                               }
                                                           } andURLPath:@"/api/get_kscj.php"];

    }
}

@end
