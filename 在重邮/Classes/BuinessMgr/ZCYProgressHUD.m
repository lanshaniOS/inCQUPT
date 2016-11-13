//
//  ZCYProgressHUD.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYProgressHUD.h"

@interface ZCYProgressHUD()

@property (strong, nonatomic) MBProgressHUD *hud;  /**< hud */
@end
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

- (void)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.labelText = text;
    self.hud.mode = MBProgressHUDModeText;
    [self.hud hide:YES afterDelay:delay];
}

- (void)rotateWithText:(NSString *)text inView:(UIView *)view
{
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.labelText = text;
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
    [self.hud hide:YES afterDelay:delay];
}
@end
