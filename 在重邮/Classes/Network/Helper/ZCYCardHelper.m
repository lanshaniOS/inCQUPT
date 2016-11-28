//
//  ZCYCardHelper.m
//  在重邮
//
//  Created by 周维康 on 16/10/31.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCardHelper.h"

@implementation ZCYCardHelper

+ (void)getCardDetailWithCardID:(NSString *)cardID withCompletionBlock:(void (^)(NSError *, NSArray *))completionBlock
{
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"yktID" : cardID}andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error)
        {
            completionBlock(error, nil);
            return;
        }
        completionBlock(nil, response[@"data"]);
    } andURLPath:@"/api/get_yktcost.php"];
}
@end
