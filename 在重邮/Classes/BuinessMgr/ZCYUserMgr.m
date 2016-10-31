//
//  ZCYUserMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserMgr.h"

@interface ZCYUserMgr() <NSCoding>

@end
@implementation ZCYUserMgr

static ZCYUserMgr *sharedMgr = nil;

+ (ZCYUserMgr *)sharedMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[self alloc] init];
        sharedMgr.studentNumber = @"";
        sharedMgr.courseArray = [[NSArray alloc] init];
    });
    return sharedMgr;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.studentNumber forKey:@"STUDENTNUMBER"];
    [aCoder encodeObject:self.courseArray forKey:@"COURSEARRAY"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [ZCYUserMgr sharedMgr];
    if (self)
    {
        self.studentNumber = [aDecoder decodeObjectForKey:@"STUDENTNUMBER"];
        self.courseArray = [aDecoder decodeObjectForKey:@"COURSEARRAY"];
    }
    return self;
}
@end
