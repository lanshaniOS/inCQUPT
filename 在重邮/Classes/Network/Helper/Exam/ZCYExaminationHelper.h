//
//  ZCYExaminationHelper.h
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYExaminationHelper : NSObject

+ (void)getExamRecordWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock;
@end
