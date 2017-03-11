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
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"3D_课表"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(20, self.view.frame.size.height/2-20, 30, 30);
//    [self.view addSubview:button];
//    
//    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cardButton setImage:[UIImage imageNamed:@"3D_一卡通"] forState:UIControlStateNormal];
//    cardButton.frame = CGRectMake((self.view.frame.size.width-160)/4+20, self.view.frame.size.height/2-20, 30, 30);
//    [self.view addSubview:cardButton];
//    
//    
//    UIButton *studentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [studentButton setImage:[UIImage imageNamed:@"3D_学生查询"] forState:UIControlStateNormal];
//    studentButton.frame = CGRectMake((self.view.frame.size.width-160)/2+20, self.view.frame.size.height/2-20, 30, 30);
//
//    [self.view addSubview:studentButton];
//   
//
//    UIButton *examButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [examButton setImage:[UIImage imageNamed:@"3D_考试"] forState:UIControlStateNormal];
//    examButton.frame = CGRectMake((self.view.frame.size.width-160)+20, self.view.frame.size.height/2-20, 30, 30);
//
//    [self.view addSubview:examButton];

    completionHandler(NCUpdateResultNewData);
}

- (void)openLoginController
{
    [self.extensionContext openURL:[NSURL URLWithString:@"ZCYLoginViewController://"] completionHandler:nil];
}
@end
