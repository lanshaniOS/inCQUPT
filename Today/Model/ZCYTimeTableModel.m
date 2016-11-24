//
//  ZCYTimeTableModel.m
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYTimeTableModel.h"

@interface ZCYTimeTableModel() <NSCoding>

@end

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
             NSStringFromSelector(@selector(courseName)) : @"name",
             @"courseWeeks": @"weeks"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.courseTime forKey:@"COURSETIME"];
    [aCoder encodeObject:self.classId forKey:@"CLASSID"];
    [aCoder encodeObject:self.courseId forKey:@"COURSEID"];
    [aCoder encodeObject:self.courseWeek forKey:@"COURSEWEEK"];
    [aCoder encodeObject:self.courseTeacher forKey:@"COURSETEACHER"];
    [aCoder encodeObject:self.courseType forKey:@"COURSETYPE"];
    [aCoder encodeObject:self.courseCredit forKey:@"COURSECREDIT"];
    [aCoder encodeObject:self.coursePlace forKey:@"COURSEPLASE"];
    [aCoder encodeObject:self.courseName forKey:@"COURSENAME"];
    [aCoder encodeObject:self.courseWeeks forKey:@"COURSEWEEKS"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.courseTime = [aDecoder decodeObjectForKey:@"COURSETIME"];
        self.classId = [aDecoder decodeObjectForKey:@"CLASSID"];
        self.courseId = [aDecoder decodeObjectForKey:@"COURSEID"];
        self.courseWeek = [aDecoder decodeObjectForKey:@"COURSEWEEK"];
        self.courseTeacher = [aDecoder decodeObjectForKey:@"COURSETEACHER"];
        self.courseType = [aDecoder decodeObjectForKey:@"COURSETYPE"];
        self.courseCredit = [aDecoder decodeObjectForKey:@"COURSECREDIT"];
        self.coursePlace = [aDecoder decodeObjectForKey:@"COURSEPLASE"];
        self.courseName = [aDecoder decodeObjectForKey:@"COURSENAME"];
        self.courseWeeks = [aDecoder decodeObjectForKey:@"COURSEWEEKS"];
    }
    return self;
}
@end
