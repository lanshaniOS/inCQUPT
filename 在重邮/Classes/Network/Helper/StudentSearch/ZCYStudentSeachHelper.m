//
//  ZCYStudentSeachHelper.m
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYStudentSeachHelper.h"

@implementation ZCYStudentSeachHelper

+ (void)getStudentDetailWithMessage:(NSString *)message andPage:(NSInteger)page withCompeletionBlock:(void (^)(NSError *error, NSDictionary *resultDic))compeletionBlock
{
    
    
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"key" : message,
                                                       @"page" : @(page)}andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        
                                                           compeletionBlock(error, response[@"data"]);
    } andURLPath:@"/api/get_student_info.php"];
}

@end
