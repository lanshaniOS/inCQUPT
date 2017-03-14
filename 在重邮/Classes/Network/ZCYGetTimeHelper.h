//
//  ZCYGetTimeHelper.h
//  i重邮
//
//  Created by 谭培 on 2017/3/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZCYCuurentTimeModel;

@interface ZCYGetTimeHelper : NSObject

+(void)getCurrentTimeWithCompletionBlock:(void(^)(NSError *error,ZCYCuurentTimeModel *timeModel))completionBlock;

@end
