//
//  ZCYSettingsViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYSettingsViewController.h"
#import "ZCYLoginViewController.h"
#import "ZCYUserDetailViewController.h"
#import "ZCYAlertView.h"

@interface ZCYSettingsViewController () <ZCYAlertViewDelegate>

@property (strong, nonatomic) UIView *headerView;  /**< 用户信息 */
@property (strong, nonatomic) ZCYAlertView *alertView;  /**< 下面弹出的玩意 */
@property (strong, nonatomic) UIImageView *headImageView;  /**< 用户头像 */
@property (strong, nonatomic) UIImageView *topImageView;  /**< 背景板 */

@end

@implementation ZCYSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"设置";
}

- (void)initUI
{
    self.view.backgroundColor = kCommonLightGray_Color;
    [self initUserHeaderView];
    [self initFuncView];
    [self initLogoutView];
}

- (void)initUserHeaderView
{
    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage blurImage:[UIImage imageWithColor:kCommonLightGray_Color] WithBlurNumber:5.0f]];
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.height.mas_equalTo(215*self.view.frame.size.height/667);
    }];
    
    self.headImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kCommonGray_Color]];
    self.headImageView.layer.cornerRadius = 45.f;
    self.headImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.topImageView);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = kCommonWhite_Color;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.topImageView.mas_bottom).with.offset(10);
    }];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserDetailView)];
    [self.headerView addGestureRecognizer:tap];
}

- (void)initFuncView
{
    UIView *userView = [[UIView alloc] init];
    [self setView:userView withImageName:@"个人信息" andFuncName:@"个人信息"];
    [self.view addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UIView *feedView = [[UIView alloc] init];
    [self setView:feedView withImageName:@"反馈意见" andFuncName:@"反馈意见"];
    [self.view addSubview:feedView];
    [feedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).with.offset(20);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);

    }];
    
    UIView *aboutView = [[UIView alloc] init];
    [self setView:aboutView withImageName:@"关于我们" andFuncName:@"关于我们"];
    [self.view addSubview:aboutView];
    [aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedView.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}
- (void)initLogoutView
{
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = kCommonWhite_Color;
    [logoutButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutButton setTitleColor:kCommonText_Color forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-79);
        make.height.mas_equalTo(40);
    }];
    
    self.alertView = [[ZCYAlertView alloc] initWithFuncArray:@[@"退出登录"]];
    self.alertView.delegate = self;
}

- (void)logoutButtonClicked
{
    [self.alertView show];
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
    [userDefaults  setObject:nil forKey:@"ZCYUSERPASSWORD"];
    
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

- (void)pushToUserDetailView
{
    ZCYUserDetailViewController *userVC = [[ZCYUserDetailViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)setView:(UIView *)view withImageName:(NSString *)imageName andFuncName:(NSString *)funcName
{
    view.backgroundColor = kCommonWhite_Color;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(view).with.offset(10);
    }];
    
    UILabel *funcLabel = [[UILabel alloc] init];
    [funcLabel setFont:kFont(kStandardPx(30)) andText:funcName andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [view addSubview:funcLabel];
    [funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(20);
        make.centerY.equalTo(view);
    }];
    
    UILabel *nextLabel = [[UILabel alloc] init];
    [nextLabel setFont:kFont(kStandardPx(40)) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [view addSubview:nextLabel];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-15);
        make.centerY.equalTo(view);
    }];
}
#pragma mark - ZCYAlertViewDelegate
- (void)alertViewDidClickAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self.alertView hide];
        [self logout];
    }
}

@end
