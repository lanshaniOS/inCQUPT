//
//  ZCYTimeTableModel.m
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYTimeTableModel.h"
#import "NSObject+YYModel.h"

@implementation ZCYTimeTableModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(courseTime)) : @"time",
             NSStringFromSelector(@selector(classId)) : @"class_id",
             NSStringFromSelector(@selector(courseId)) : @"c_id",
             NSStringFromSelector(@selector(courseWeek)) : @"all_week",
             NSStringFromSelector(@selector(courseTeacher)) : @"teacher",
             NSStringFromSelector(@selector(courseType)) : @"type",
             NSStringFromSelector(@selector(courseCredit)) : @"xf",
             NSStringFromSelector(@selector(coursePlace)) : @"place",
             NSStringFromSelector(@selector(courseName)) : @"name"
             };
}

@end
