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
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : studentNumber,
                                                       @"sfzh" : [[NSUserDefaults standardUserDefaults] objectForKey:@"ZCYUSERPASSWORD"]} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        compeletionBlock(error, response[@"data"]);
    } andURLPath:@"/api/get_kscj"];
}

@end
