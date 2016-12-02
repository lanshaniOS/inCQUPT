//
//  ZCYExamScoreHelper.h
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYExamScoreHelper : NSObject

+ (void)getExamScoreWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock;

@end
