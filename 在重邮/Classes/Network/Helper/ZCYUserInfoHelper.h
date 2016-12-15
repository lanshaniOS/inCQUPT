//
//  ZCYUserInfoHelper.h
//  在重邮
//
//  Created by 周维康 on 16/12/12.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYUserInfoHelper : NSObject

+ (void)getUserTokenwithCompeletionBlock:(void (^)(NSError *, NSArray *))compeletionBlock;

@end
