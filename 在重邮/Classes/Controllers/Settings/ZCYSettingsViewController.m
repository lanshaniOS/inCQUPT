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
#import "ZCYFeedBackViewController.h"
#import "ZCYAboutusViewController.h"
#import "ZCYCalendarViewController.h"

@interface ZCYSettingsViewController () <ZCYAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIView *headerView;  /**< 用户信息 */
@property (strong, nonatomic) ZCYAlertView *alertView;  /**< 下面弹出的玩意 */
@property (strong, nonatomic) UIImageView *headImageView;  /**< 用户头像 */
@property (strong, nonatomic) UIButton *topImageButton;  /**< 背景板 */
@property (strong, nonatomic) UIImagePickerController *imagePickerController;  /**< 图片选择 */
@property (strong, nonatomic) ZCYAlertView *selectAlertView;  /**< 选择图片 */
@property (strong, nonatomic) UIImage *selectImage;  /**< 选择的图片 */
@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 北京滑动 */
@property (strong, nonatomic) UIView *aboutView;  /**< 关于我们 */
@property (strong, nonatomic) UIButton *logoutButton;  /**< 退出按钮 */
@end

@implementation ZCYSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.logoutButton.frame.size.height + self.logoutButton.frame.origin.y + 40+34);
    [self initImagePickerController];
}
- (NSString *)title
{
    return @"设置";
}

- (void)initUI
{
    self.view.backgroundColor = kCommonLightGray_Color;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.backgroundColor = kCommonLightGray_Color;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.delegate = self;
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
    }];
    [self initUserHeaderView];
    [self initFuncView];
    [self initLogoutView];
    
}

- (void)initUserHeaderView
{
    if (!([ZCYUserMgr sharedMgr].settingImageData))
    {
        [ZCYUserMgr sharedMgr].settingImageData = UIImagePNGRepresentation([UIImage imageNamed:@"settingBackgroundImage"]);
    }
    CGFloat pictureHeight;
    self.selectImage = [UIImage imageWithData:[ZCYUserMgr sharedMgr].settingImageData];
    if (self.selectImage.size.height/2 > 280*self.view.frame.size.height/667)
    {
        pictureHeight = 280*self.view.frame.size.height/667;
    } else {
        pictureHeight = self.selectImage.size.height/2;
    }
    self.topImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topImageButton setAdjustsImageWhenHighlighted:NO];
    [self.topImageButton setBackgroundImage:self.selectImage forState:UIControlStateNormal];
    
    [self.topImageButton addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:self.topImageButton];
    [self.topImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.backgroundScrollView.mas_top).with.offset(pictureHeight);
        make.height.mas_equalTo(self.selectImage.size.height/2);
    }];
//    self.headImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kCommonGray_Color]];
//    self.headImageView.layer.cornerRadius = 45.f;
//    self.headImageView.layer.masksToBounds = YES;
//    [self.view addSubview:self.headImageView];
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.topImageView);
//        make.size.mas_equalTo(CGSizeMake(90, 90));
//    }];
    
//    self.headerView = [[UIView alloc] init];
//    self.headerView.backgroundColor = kCommonWhite_Color;
//    [self.view addSubview:self.headerView];
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.height.mas_equalTo(40);
//        make.top.equalTo(self.topImageButton.mas_bottom).with.offset(10);
//    }];
//    
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserDetailView)];
//    [self.headerView addGestureRecognizer:tap];
}

- (void)initFuncView
{
    UIView *userView = [[UIView alloc] init];
    [self setView:userView withImageName:@"个人信息" andFuncName:@"个人信息"];
    [self.backgroundScrollView addSubview:userView];
    UITapGestureRecognizer *tapUserView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserDetailView)];
    [userView addGestureRecognizer:tapUserView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageButton.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    UIView *calendarView = [[UIView alloc] init];
    [self setView:calendarView withImageName:@"反馈意见" andFuncName:@"校历"];
    [self.backgroundScrollView addSubview:calendarView];
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).with.offset(20);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
        
    }];
    UITapGestureRecognizer *tapCalendar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCalendarController)];
    [calendarView addGestureRecognizer:tapCalendar];
    
    UIView *feedView = [[UIView alloc] init];
    [self setView:feedView withImageName:@"反馈意见" andFuncName:@"反馈意见"];
    [self.backgroundScrollView addSubview:feedView];
    [feedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(calendarView.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);

    }];
    UITapGestureRecognizer *tapFeed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToFeedBackController)];
    [feedView addGestureRecognizer:tapFeed];
    
    self.aboutView = [[UIView alloc] init];
    [self setView:self.aboutView withImageName:@"关于我们" andFuncName:@"关于我们"];
    [self.backgroundScrollView addSubview:self.aboutView];
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedView.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    UITapGestureRecognizer *tapAboutView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAboutController)];
    [self.aboutView addGestureRecognizer:tapAboutView];
}
- (void)initLogoutView
{
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.backgroundColor = kCommonWhite_Color;
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:kCommonText_Color forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.aboutView.mas_bottom).with.offset(90);
        make.height.mas_equalTo(40);
    }];
    
    self.alertView = [[ZCYAlertView alloc] initWithFuncArray:@[@"确认退出"]];
    self.alertView.delegate = self;
}

- (void)logoutButtonClicked
{
    [self.alertView show];
}
- (void)logout
{
    [[ZCYUserMgr sharedMgr] removeMgr];
    //清空共享数据
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wakeen.ios.dog"];
    [userDefaults setObject:nil forKey:@"shared_usermgr"];
    //清空用户数据
    [userDefaults  setObject:nil forKey:@"ZCYUSERPASSWORD"];
    
    NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ZCYUserMgr sharedMgr]];
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

- (void)initImagePickerController
{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    
    self.selectAlertView = [[ZCYAlertView alloc] initWithFuncArray:@[@"从相册中选择", @"拍照"]];
    self.selectAlertView.delegate = self;
}
- (void)pushToUserDetailView
{
    ZCYUserDetailViewController *userVC = [[ZCYUserDetailViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
}

-(void)pushToCalendarController
{
    ZCYCalendarViewController *calendarVC = [[ZCYCalendarViewController alloc]init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

- (void)pushToFeedBackController
{
    ZCYFeedBackViewController *feedVC = [[ZCYFeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedVC animated:YES];
}

- (void)pushToAboutController
{
    ZCYAboutusViewController *aboutController = [[ZCYAboutusViewController alloc] init];
    [self.navigationController pushViewController:aboutController animated:YES];
}
- (void)setView:(UIView *)view withImageName:(NSString *)imageName andFuncName:(NSString *)funcName
{
    view.backgroundColor = kCommonWhite_Color;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(view).with.offset(7.5);
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

- (void)selectPicture
{
    [self.selectAlertView show];
}
#pragma mark - ZCYAlertViewDelegate
- (void)alertView:(ZCYAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    [alertView hide];
    if (alertView == self.alertView)
    {
        if (index == 0)
        {
            [self.alertView hide];
            [self logout];
        }
    } else {
        if (index == 0)
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if(index == 1) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerImageController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.selectImage = info[UIImagePickerControllerEditedImage];
    [ZCYUserMgr sharedMgr].settingImageData = UIImagePNGRepresentation(self.selectImage);
    ZCYUserMgr *userMgr = [ZCYUserMgr sharedMgr];
    CGFloat pictureHeight;
    
    if (self.selectImage.size.height/2 > 280*self.view.frame.size.height/667)
    {
        pictureHeight = 280*self.view.frame.size.height/667;
    } else {
        pictureHeight = self.selectImage.size.height/2;
    }
    
    NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:userMgr];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
    [self.topImageButton setBackgroundImage:self.selectImage forState:UIControlStateNormal];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self.topImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundScrollView.mas_top).with.offset(pictureHeight);
        make.height.mas_equalTo(self.selectImage.size.height/2);
    }];
    
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.logoutButton.frame.size.height + self.logoutButton.frame.origin.y + 40);

}


@end
