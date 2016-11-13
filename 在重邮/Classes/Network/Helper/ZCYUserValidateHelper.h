//
//  ZCYUserValidateHelper.h
//  在重邮
//
//  Created by 周维康 on 16/11/7.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYUserValidateHelper : NSObject

+ (void)getUserInfoWithUserName:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(void(^)(NSError *, id response))completionBlock;

@end
