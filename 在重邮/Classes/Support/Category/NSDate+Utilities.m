//
//  NSDate+Utilities.m
//  在重邮
//
//  Created by 周维康 on 16/10/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "NSDate+Utilities.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Utilities)

+ (NSCalendar *)currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSInteger)week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    
    if (components.weekday == 1)
    {
        components.weekday = 7;
    } else {
        components.weekday -= 1;
    }
    return components.weekday;
}

- (NSInteger)schoolWeek
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *oneWeek = [date dateFromString:@"2016-09-04"];
    
    NSTimeInterval oneWeekTime = [oneWeek timeIntervalSince1970];
    NSTimeInterval todayTime = [today timeIntervalSince1970];
    NSInteger weekTime = (todayTime - oneWeekTime)/86400;
    
    return weekTime%7 == 0 ? weekTime/7 : weekTime/7+1;
}

- (NSString *)weekString
{
    switch ([NSDate date].week) {
            case 1:
            return @"一";
            case 2:
            return @"二";
            case 3:
            return @"三";
            case 4:
            return @"四";
            case 5:
            return @"五";
            case 6:
            return @"六";
            case 7:
            return @"日";
        default:
            return @"";
    }
}
- (NSInteger)month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger)day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}
@end
