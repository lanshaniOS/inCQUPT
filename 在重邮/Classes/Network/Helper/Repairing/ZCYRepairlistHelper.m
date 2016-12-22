//
//  GetBXlistHelper.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairlistHelper.h"
#import "ZCYRepairListModel.h"
#import "ZCYNetworkHelperMgr.h"
#import "YYModel.h"

@implementation ZCYRepairlistHelper
+ (void)getBXListWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *error, NSArray *arr))compeletionBlock
{
    
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"yktID":studentNumber} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        NSMutableArray *arr = [NSMutableArray array];
        id datas = response[@"data"];
        NSInteger status = [response[@"status"] integerValue];
        if (error)
        {
            DDLogError(@"%@", error);
            compeletionBlock(error, nil);
            return;
        }else{
            if (status == 200) {
                if ([datas isKindOfClass:[NSDictionary class]])
                {
                    ZCYRepairListModel *model = [[ZCYRepairListModel alloc]init];
                    [model yy_modelSetWithDictionary:datas];
                    [arr addObject:model];
                } else {
                    for (NSDictionary *dic in datas) {
                        ZCYRepairListModel *model = [[ZCYRepairListModel alloc]init];
                        [model yy_modelSetWithDictionary:dic];
                        [arr addObject:model];
                    }
                }
                compeletionBlock(nil,arr);
            }else{
                compeletionBlock(nil,nil);
            }
            
            
        }
        
    } andURLPath:@"/api/bx/get_repair_list.php"];
}



@end
