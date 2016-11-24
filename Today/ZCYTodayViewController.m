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
    self.view.backgroundColor = [UIColor blueColor];

    NSLog(@"%f---%f",self.view.frame.size.width,self.view.frame.size.height);

    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wakeen.ios.dog"];
    NSData *data = [userDefaults objectForKey:@"shared_usermgr"];
    if (!data)
    {
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    ZCYUserMgr *userMgr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *courseArray = userMgr.courseArray;
    self.todayCourseArray = courseArray[[NSDate date].week];
    if (self.todayCourseArray.count == 0)
    {
        
    }
    completionHandler(NCUpdateResultNewData);
}

@end
