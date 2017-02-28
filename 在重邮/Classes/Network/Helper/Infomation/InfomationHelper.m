//
//  InfomationHelper.m
//  i重邮
//
//  Created by 谭培 on 2017/2/25.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "InfomationHelper.h"
#import "ZCYUserMgr.h"
@implementation InfomationHelper

+(void)getInfomationList:(void (^)(NSError *, NSArray *))completionBlock{
    
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"page":@"1"} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            completionBlock(error,nil);
        }else{
            completionBlock(nil,response[@"data"]);
        }

    } andURLPath:@"/api/get_newslist.php"];
}

@end
