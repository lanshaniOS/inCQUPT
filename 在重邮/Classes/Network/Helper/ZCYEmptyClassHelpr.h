//
//  ZCYEmptyClassHelpr.h
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYEmptyClassHelpr : NSObject

+ (void)getEmptyClassWithBuilding:(NSInteger)building andSchoolWeek:(NSInteger)schoolWeek
                          andWeek:(NSInteger)week andSection:(NSInteger)section withCompletionBlock:(void (^)(NSError *, NSArray *))completionBlock;

@end
