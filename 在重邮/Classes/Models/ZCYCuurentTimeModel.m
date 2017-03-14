//
//  ZCYCuurentTimeModel.m
//  i重邮
//
//  Created by 谭培 on 2017/3/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYCuurentTimeModel.h"

@interface ZCYCuurentTimeModel ()<NSCoding>

@end

@implementation ZCYCuurentTimeModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.term = [aDecoder decodeObjectForKey:@"TERM"];
        self.currentWeekDay = [aDecoder decodeObjectForKey:@"CURRENTWEEKDAY"];
        self.currentWeek = [aDecoder decodeObjectForKey:@"CURRENTWEEK"];
        self.currentDate = [aDecoder decodeObjectForKey:@"CURRENTDATE"];
        self.term_start = [aDecoder decodeObjectForKey:@"TERM_START"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.term forKey:@"TERM"];
    [coder encodeObject:self.currentWeek forKey:@"CURRENTWEEK"];
    [coder encodeObject:self.currentWeekDay forKey:@"CURRENTWEEKDAY"];
    [coder encodeObject:self.currentWeek forKey:@"CURRENTWEEK"];
    [coder encodeObject:self.currentDate forKey:@"CURRENTDATE"];
    [coder encodeObject:self.term_start forKey:@"TERM_START"];
}

@end
