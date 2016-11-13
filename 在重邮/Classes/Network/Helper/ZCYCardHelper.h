//
//  ZCYCardHelper.h
//  在重邮
//
//  Created by 周维康 on 16/10/31.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYCardHelper : NSObject

+ (void)getCardDetailWithCardID:(NSString *)cardID withCompletionBlock:(void (^)(NSError *, NSArray *))completionBlock;

@end
