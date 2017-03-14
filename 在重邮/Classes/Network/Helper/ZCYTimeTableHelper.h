//
//  ZCYTimeTableHelper.h
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYTimeTableHelper : NSObject

+ (void)getTimeTableWithStdNumber:(NSString *)studentNumber shouldSaveTime:(BOOL)shouldSave withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock;

@end
