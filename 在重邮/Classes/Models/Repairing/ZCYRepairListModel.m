//
//  BXListModel.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairListModel.h"

@interface ZCYRepairListModel ()

@end

@implementation ZCYRepairListModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(wx_bxlxm)) : @"wx_bxlxm",
             NSStringFromSelector(@selector(wx_wxztm)) : @"wx_wxztm",
             NSStringFromSelector(@selector(wx_bxsj)) : @"wx_bxsj",
             NSStringFromSelector(@selector(wx_bt)) : @"wx_bt",
             NSStringFromSelector(@selector(wx_bxnr)) : @"wx_bxnr",
             };
}


@end
