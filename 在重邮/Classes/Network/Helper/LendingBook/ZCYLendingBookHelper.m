//
//  ZCYLendingBookHelper.m
//  在重邮
//
//  Created by 周维康 on 16/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLendingBookHelper.h"



@implementation ZCYLendingBookHelper

+ (void)getLendingRecordWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSDictionary *))compeletionBlock
{
    
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : studentNumber} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (compeletionBlock)
        {
            compeletionBlock(error, response);
        }
    } andURLPath:@"/api/get_booklist.php"];
}
@end
