
//
//  InfomationDetailHelper.m
//  i重邮
//
//  Created by 谭培 on 2017/2/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "InfomationDetailHelper.h"
#import "InfomationDetailModel.h"

@implementation InfomationDetailHelper

+(void)getInfomationDetailWithType:(NSString *)type andId:(NSString *)infomationId andCompletionBlock:(void (^)(NSError *, InfomationDetailModel *))completionBlock{
    [[ZCYNetworkHelperMgr sharedMgr] GetRequestWithData:@{@"type":type,@"id":infomationId} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        
        if (error) {
            completionBlock(error,nil);
        }else{
            NSDictionary *dic = response[@"data"];
            InfomationDetailModel *detail = [[InfomationDetailModel alloc]init];
            
            detail.title = dic[@"title"];
            detail.time = dic[@"author"];
            detail.body = dic[@"body"];
            NSLog(@"000%@",detail.time);
            completionBlock(nil,detail);
        }
        
    } andURLPath:@"/api/get_news_detail.php"];
}

@end
