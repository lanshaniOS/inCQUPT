//
//  ZCYGetRepaiApplyData.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYGetRepairApplyData.h"
#import "ZCYNetworkHelperMgr.h"

@implementation ZCYGetRepairApplyData

+(void)getRepairApplyDataFromeNet:(void (^) (NSError *,NSDictionary *))completionBlock
{
    
    [[ZCYNetworkHelperMgr sharedMgr]requestWithData:nil andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            completionBlock(error,nil);
        }else{
            NSDictionary *dic = response[@"data"];
            NSLog(@"%@",dic);
            completionBlock(nil,dic);
        }
    } andURLPath:@"/api/bx/get_repair_type.php"];
}




@end
