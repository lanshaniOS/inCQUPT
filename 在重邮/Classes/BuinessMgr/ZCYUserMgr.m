//
//  ZCYUserMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserMgr.h"

@implementation ZCYUserMgr

+ (ZCYUserMgr *)sharedMgr
{
    static ZCYUserMgr *sharedMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[self alloc] init];
        sharedMgr.studentNumber = @"";
        sharedMgr.courseArray = [[NSArray alloc] init];
    });
    return sharedMgr;
}

- (instancetype)init
{
    return nil;
}
@end
