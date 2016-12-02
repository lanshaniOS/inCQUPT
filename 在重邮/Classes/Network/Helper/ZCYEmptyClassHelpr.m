//
//  ZCYEmptyClassHelpr.m
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYEmptyClassHelpr.h"

@implementation ZCYEmptyClassHelpr

+ (void)getEmptyClassWithBuilding:(NSInteger)building andSchoolWeek:(NSInteger)schoolWeek
                          andWeek:(NSInteger)week andSection:(NSInteger)section withCompletionBlock:(void (^)(NSError *, NSArray *))completionBlock
{
    NSString *sectionString;
    switch (section) {
        case 0:
            sectionString = @"1@2";
            break;
        case 1:
            sectionString = @"3@4";
            break;
        case 2:
            sectionString = @"5@6";
            break;
        case 3:
            sectionString = @"7@8";
            break;
        case 4:
            sectionString = @"9@10";
            break;
        case 5:
            sectionString = @"11@12";
            break;
        default:
            sectionString = @"1@2";
            break;
    }
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"weekNo" : [NSString stringWithFormat:@"%@", @(schoolWeek)],
                                                       @"weekDay" : [NSString stringWithFormat:@"%@", @(week)],
                                                       @"buildingNo" : [NSString stringWithFormat:@"%@", @(building)],
                                                       @"classNo": sectionString}andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
        
        completionBlock(error, response[@"data"]);
    } andURLPath:@"/api/get_empty_room.php"];
}

@end
