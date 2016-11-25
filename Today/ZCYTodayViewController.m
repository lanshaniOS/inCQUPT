//
//  TodayViewController.m
//  Today
//
//  Created by 周维康 on 16/11/23.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYTodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "ZCYTimeTableModel.h"
#import "ZCYUserMgr.h"
#import "ZCYCourseView.h"
#import "NSDate+Utilities.h"
#import "Masonry.h"
#import "ZCYStyleDefine.h"

@interface ZCYTodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSArray *todayCourseArray;  /**< 今日课程 */
@end

@implementation ZCYTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    for (UIView *subView in self.view.subviews)
    {
        [subView removeFromSuperview];
    }

    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wakeen.ios.dog"];
    NSData *data = [userDefaults objectForKey:@"shared_usermgr"];
    if (!data)
    {
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [loginButton setTitle:@"请先登录再获取今日课表" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(openLoginController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        return;
    }
    ZCYUserMgr *userMgr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *courseArray = userMgr.courseArray;
    self.todayCourseArray = courseArray[[NSDate date].week - 1];
    __block NSUInteger courseIdx;
    [self.todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        for (NSUInteger index = 0; index<array.count; index++)
        {
            ZCYTimeTableModel *model  = array[index];
            ZCYCourseView *courseView = [[ZCYCourseView alloc] initWithCourseName:model.courseName andClassID:model.coursePlace andCourseTime:idx];
            [courseView setTextColor:kDeepGreen_Color andBackgroundColor:kCommonGreen_Color];
            [self.view addSubview:courseView];
            [courseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).with.offset(24);
                make.width.mas_equalTo((self.view.frame.size.width - 48)/3);
                make.height.mas_equalTo(self.view.frame.size.height);
                make.centerY.equalTo(self.view);
            }];
            courseIdx++;
        }
    }];
    if (courseIdx == 0)
    {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"今天没有课哟";
        tipLabel.textColor = kDeepGray_Color;
        [tipLabel sizeToFit];
        [self.view addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.centerX.equalTo(self.view);
        }];
    }
    completionHandler(NCUpdateResultNewData);
}

- (void)openLoginController
{
    [self.extensionContext openURL:[NSURL URLWithString:@"ZCYLoginViewController://"] completionHandler:nil];
}
@end
