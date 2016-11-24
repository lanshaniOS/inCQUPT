//
//  ZCYRepairApllyModel.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairApplyModel.h"
#import "ZCYGetRepairApplyData.h"


@implementation ZCYRepairApplyModel

+(NSDictionary *)initToDataWithId:(NSString *)studentId name:(NSString *)name Ip:(NSString *)ip title:(NSString *)title CategoryId:(NSString *)categoryId specificId:(NSString *)specificId phone:(NSString *)phone addressId:(NSString *)addressId content:(NSString   *)content address:(NSString *)address
{
    
    return @{@"Id":studentId,@"Name":name,@"Ip":ip,@"Title":title,@"SpecificId":specificId,@"AddressId":addressId,@"Phone":phone,@"Content":content,@"Address":address};
}



@end
