//
//  ZCYExaminationHelper.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYExaminationHelper.h"


@implementation ZCYExaminationHelper

+ (void)getExamRecordWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock
{
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : studentNumber} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        compeletionBlock(error, response[@"data"]);
    } andURLPath:@"/api/get_ks.php"];
}
@end
