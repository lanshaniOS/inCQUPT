//
//  ZCYSettingsViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYSettingsViewController.h"
#import "ZCYLoginViewController.h"

@interface ZCYSettingsViewController ()

@end

@implementation ZCYSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = kDeepGreen_Color;
    [logoutButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
}

- (void)logout
{
    NSData *userMgr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERMGR"];
    ZCYUserMgr *sharedMgr = [NSKeyedUnarchiver unarchiveObjectWithData:userMgr];
    sharedMgr = nil;
    //清空共享数据
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wakeen.ios.dog"];
    [userDefaults setObject:nil forKey:@"shared_usermgr"];
    //清空用户数据
    NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:sharedMgr];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
//    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    ZCYLoginViewController *loginVC = [[ZCYLoginViewController alloc] init];
    [self presentViewController:loginVC animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
