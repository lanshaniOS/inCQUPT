//
//  NSString+MD5.m
//  在重邮
//
//  Created by 周维康 on 16/12/13.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

#define CC_MD5_DIGEST_LENGTH 16 

@implementation NSString (MD5)

+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+ (NSString*)getMD5WithData:(NSData *)data
{
    const char* original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    //也可以定义一个字节数组来接收计算得到的MD5值
    //    Byte byte[16];
    //    CC_MD5(original_str, strlen(original_str), byte);
    //    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    //    for(int  i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
    //        [outPutStr appendFormat:@"%02x",byte[i]];
    //    }
    //    [temp release];
    
    return [outPutStr lowercaseString];
    
}


@end
