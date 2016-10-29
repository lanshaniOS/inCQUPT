//
//  ZCYProgressHUD.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYProgressHUD.h"

@implementation ZCYProgressHUD

+ (ZCYProgressHUD *)sharedHUD
{
    static ZCYProgressHUD *progressHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[ZCYProgressHUD alloc] init];
    });
    return progressHUD;
}

- (void)showWithText:(NSString *)text inView:(UIView *)view Delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:delay];
}
@end
