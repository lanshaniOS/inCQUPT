//
//  NSDate+Utilities.m
//  在重邮
//
//  Created by 周维康 on 16/10/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "NSDate+Utilities.h"
#import "ZCYNetworkHelperMgr.h"
#import "ZCYGetTimeHelper.h"

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

    //    NSTimeInterval todayInterval = [today timeIntervalSince1970];
    __block NSInteger weekTime;
//    [[ZCYNetworkHelperMgr sharedMgr] requestWithData:@{@"id" : @"2014213913"} andCompletionBlock:^(NSError *error, id response, NSURLSessionDataTask *task) {
//        if (error)
//        {
//            return;
//        }
//        NSDate *today = [NSDate date];
//        
//        NSDateFormatter *date = [[NSDateFormatter alloc] init];
//        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *oneWeek;
//        
//        NSTimeInterval timeInterval = [response[@"data"][@"week"] integerValue]*7+[response[@"data"][@"day"] integerValue];
//        oneWeek = [NSDate dateWithTimeIntervalSince1970:[today timeIntervalSince1970]-timeInterval*24*3600];
//        NSTimeInterval oneWeekTime = [oneWeek timeIntervalSince1970];
//        NSTimeInterval todayTime = [today timeIntervalSince1970];
//        weekTime = (todayTime - oneWeekTime)/86400;
//    } andURLPath:@"/api/get_kebiao.php"];
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

+ (NSString *)schoolWeekStringWithWeek:(NSInteger)schoolWeek
{
    NSArray *array = @[@"", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"二十一", @"二十二", @"二十三", @"二十四", @"二十五", @"二十六", @"二十八", @"二十九", @"三十"];
    return array[schoolWeek];
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

-(NSInteger)year{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}


@end
