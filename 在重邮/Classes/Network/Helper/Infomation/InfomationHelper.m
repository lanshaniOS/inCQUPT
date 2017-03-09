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

+(void)getInfomationListWithNewsApi:(NSString *)newsApi andBlock:(void (^)(NSError *, NSArray *))completionBlock{
    
    if ([newsApi isEqualToString:@"/api/get_newslist.php"]) {
        [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"page":@"1"} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
            if (error) {
                completionBlock(error,nil);
            }else{
                completionBlock(nil,response[@"data"]);
            }
            
        } andURLPath:@"/api/get_newslist.php"];
    }else{
        [[ZCYNetworkHelperMgr sharedMgr] requestWithData:nil andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
            if (error) {
                completionBlock(error,nil);
            }else{
                completionBlock(nil,response[@"data"]);
            }
            
        } andURLPath:newsApi];
    }
    
    
}

@end
