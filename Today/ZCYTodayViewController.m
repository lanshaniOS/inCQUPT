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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"3D_课表"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.view);
    }];
    completionHandler(NCUpdateResultNewData);
}

- (void)openLoginController
{
    [self.extensionContext openURL:[NSURL URLWithString:@"ZCYLoginViewController://"] completionHandler:nil];
}
@end
