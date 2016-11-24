//
//  GetBXlistHelper.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYRepairlistHelper : NSObject

+ (void)getBXListWithStdNumber:(NSString *)studentNumber withCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock;


@end
