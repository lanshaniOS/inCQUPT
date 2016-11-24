//
//  ZCYGetRepaiApplyData.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYGetRepairApplyData : NSObject

//@property (nonatomic,strong)NSDictionary *

+(void)getRepairApplyDataFromeNet:(void (^) (NSError *,NSDictionary *))completionBlock;

@end
