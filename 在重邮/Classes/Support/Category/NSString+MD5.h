//
//  NSString+MD5.h
//  在重邮
//
//  Created by 周维康 on 16/12/13.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString*)getMD5WithData:(NSData *)data;

+ (NSString*)getmd5WithString:(NSString *)string;
@end
