//
//  NSDate+Utilities.h
//  在重邮
//
//  Created by 周维康 on 16/10/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

@property (readonly) NSInteger week;
@property (readonly) NSInteger month;
@property (readonly) NSInteger day;
@property (readonly) NSString *weekString;
@property (readonly) NSInteger schoolWeek;
@property (readonly) NSString *schoolWeekString;

//返回单例
+ (NSCalendar *)currentCalendar;

@end
