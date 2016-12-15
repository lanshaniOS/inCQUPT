//
//  ZCYRepairApplyHelper.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYRepairApplyHelper : NSObject

+(void)CommitRepairApplyWithData:(NSDictionary *)data andCompeletionBlock:(void (^)(NSError *, NSString *))compeletionBlock;

@end
