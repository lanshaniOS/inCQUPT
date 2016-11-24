//
//  ZCYRepairApplyHelper.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairApplyHelper.h"
#import "ZCYNetworkHelperMgr.h"


@implementation ZCYRepairApplyHelper

+(void)CommitRepairApplyWithData:(NSDictionary *)data andCompeletionBlock:(void (^)(NSError *, NSString *))compeletionBlock
{
    [[ZCYNetworkHelperMgr sharedMgr]wx_requestWithData:data andCompletionBlock:^(NSError *error, id respect, NSURLSessionDataTask *task) {
        NSString *message = respect[@"message"];
        NSLog(@"%@",respect);
        compeletionBlock(error,message);
    } andURLPath:@"/api/bx/bx.php"];
}

@end
