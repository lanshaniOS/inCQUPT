//
//  ZCYDormitoryHelper.h
//  在重邮
//
//  Created by 周维康 on 16/12/7.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYDormitoryHelper : NSObject

+ (void)getElectricDetailWithBuilding:(NSString *)building andFloor:(NSInteger)floor
                             andRoom:(NSInteger)room withCompeletionBlock:(void (^)(NSError *error, NSDictionary *resultDic))compeletionBlock;

@end
