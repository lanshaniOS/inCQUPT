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
#import "ZCYRepairDetailModel.h"

@implementation ZCYRepairDetailHelper

+(void)getrepairDetailWithBXId:(NSString *)BXId withComplitionBlock:(void (^)(NSError *,ZCYRepairDetailModel *))complitionBlock
{
    NSDictionary *dic = @{@"yktID":[[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"],@"bxID":BXId};
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:dic andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            complitionBlock(error,nil);
        }else{
            NSDictionary *dic = response[@"data"];
            ZCYRepairDetailModel *model = [[ZCYRepairDetailModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            complitionBlock(nil,model);
        }
    } andURLPath:@"/api/bx/get_repair_detail.php"];
}

@end
