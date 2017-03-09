//
//  InfomationHelper.h
//  i重邮
//
//  Created by 谭培 on 2017/2/25.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfomationHelper : NSObject

+(void)getInfomationListWithNewsApi:(NSString *)newsApi andBlock:(void (^)(NSError *, NSArray *))completionBlock;

@end
