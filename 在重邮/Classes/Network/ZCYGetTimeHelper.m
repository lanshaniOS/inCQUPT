//
//  ZCYGetTimeHelper.m
//  i重邮
//
//  Created by 谭培 on 2017/3/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYGetTimeHelper.h"
#import "ZCYCuurentTimeModel.h"

@implementation ZCYGetTimeHelper

+(void)getCurrentTimeWithCompletionBlock:(void (^)(NSError *error,ZCYCuurentTimeModel *timeModel))completionBlock{
    [[ZCYNetworkHelperMgr sharedMgr]GetRequestWithData:nil andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        if (error) {
            completionBlock(error,nil);
        }else{
            NSDictionary *dic = response[@"data"];
            ZCYCuurentTimeModel *model = [[ZCYCuurentTimeModel alloc]init];
            model.term = dic[@"term"];
            model.currentWeek = dic[@"week"];
            model.currentWeekDay = dic[@"day"];
            model.currentDate = dic[@"date"];
            model.term_start = dic[@"term_start"];
            completionBlock(nil,model);
        }
    } andURLPath:@"/api/get_week.php"];
}

@end
