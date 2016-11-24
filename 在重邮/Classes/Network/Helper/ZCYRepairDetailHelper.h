//
//  ZCYRepairDetailHelper.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/23.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYRepairDetailHelper : NSObject

+(void)getrepairDetailWithBXId:(NSString *)BXId withComplitionBlock:(void (^)(NSError *,NSDictionary *))complitionBlock;

@end
