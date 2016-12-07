//
//  ZCYDormitoryHelper.m
//  在重邮
//
//  Created by 周维康 on 16/12/7.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYDormitoryHelper.h"
#import "objc/runtime.h"

@implementation ZCYDormitoryHelper

+ (void)getElectricDetailWithBuilding:(NSString *)building andFloor:(NSInteger)floor
                             andRoom:(NSInteger)room withCompeletionBlock:(void (^)(NSError *error, NSDictionary *resultDic))compeletionBlock
{
    
    
    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"buildingNo" : building,
                                                       @"floor" : @(floor),
                                                       @"room" : @(room)}
                                  andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
                                                           if ([[response[@"data"] class] isSubclassOfClass:[NSDictionary class]])
                                                           {
                                                               compeletionBlock(error, response[@"data"]);
                                                               return;
                                                           }
                                                           compeletionBlock(error, nil);
                                                       } andURLPath:@"/api/get_elec.php"];
}

@end
