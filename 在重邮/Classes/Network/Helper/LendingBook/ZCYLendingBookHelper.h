//
//  ZCYLendingBookHelper.h
//  在重邮
//
//  Created by 周维康 on 16/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYLendingBookHelper : NSObject

+ (void)getLendingRecordWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSDictionary *))compeletionBlock;

@end
