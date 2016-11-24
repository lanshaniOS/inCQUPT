//
//  ZCYGetRepairAdrressHelper.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYGetRepairAdrressHelper.h"
#import "ZCYNetworkHelperMgr.h"


@implementation ZCYGetRepairAdrressHelper

+(void)getRepairAdrressFromeNet:(void (^)(NSError *error,NSArray *arr))completionBlock
{
    [[ZCYNetworkHelperMgr sharedMgr]requestWithData:nil andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            completionBlock(error,nil);
        }else{
            NSArray *arr = response[@"data"];
            completionBlock(nil,arr);
        }
        
    } andURLPath:@"/api/bx/get_repair_areas.php"];
}

@end
