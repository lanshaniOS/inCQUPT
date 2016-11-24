//
//  ZCYRepairDetailHelper.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/23.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairDetailHelper.h"
#import "ZCYNetworkHelperMgr.h"
#import "ZCYUserMgr.h"

@implementation ZCYRepairDetailHelper

+(void)getrepairDetailWithBXId:(NSString *)BXId withComplitionBlock:(void (^)(NSError *,NSDictionary *))complitionBlock
{
    NSDictionary *dic = @{@"yktID":[ZCYUserMgr sharedMgr].studentNumber,@"bxID":BXId};
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:dic andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            complitionBlock(error,nil);
        }else{
            NSDictionary *dic = response[@"data"];
            complitionBlock(nil,dic);
        }
    } andURLPath:@"/api/bx/get_repair_detail.php"];
}

@end
