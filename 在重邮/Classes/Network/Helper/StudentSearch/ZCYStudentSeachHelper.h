//
//  ZCYStudentSeachHelper.h
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYStudentSeachHelper : NSObject

+ (void)getStudentDetailWithMessage:(NSString *)message andPage:(NSInteger)page withCompeletionBlock:(void (^)(NSError *error, NSDictionary *resultDic))compeletionBlock;

@end
