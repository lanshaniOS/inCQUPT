//
//  ZCYProgressHUD.h
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface ZCYProgressHUD : MBProgressHUD

+ (ZCYProgressHUD *)sharedHUD;

- (void)showWithText:(NSString *)text inView:(UIView *)view Delay:(NSTimeInterval)delay;

@end
