//
//  ZCYAppDelegate.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYAppDelegate.h"
#import "ZCYHomeTabBarController.h"
#import "ZCYLoginViewController.h"
#import "ZCYNavigationController.h"
#import "ZCYCourseViewController.h"
#import "ZCYCardDetailViewController.h"
#import "ZCYExaminationViewController.h"
#import "ZCYStudentSearchViewController.h"
#import "ZCYUserInfoHelper.h"
#import <UserNotifications/UserNotifications.h>

@interface ZCYAppDelegate ()<UNUserNotificationCenterDelegate>

@property (strong, nonatomic)  ZCYHomeTabBarController *tabBarC;  /**< TabbarVC */

@end

@implementation ZCYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    BuglyConfig *config = [BuglyConfig defaultConfig];
    config.unexpectedTerminatingDetectionEnable = YES;
    config.reportLogLevel = BuglyLogLevelWarn;
    [Bugly startWithAppId:@"abf2c183e5" config:config];
    [ZCYUserInfoHelper getUserTokenwithCompeletionBlock:^(NSError *error, NSArray *array) {
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSData *userMgr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERMGR"];
    ZCYUserMgr *sharedMgr = [NSKeyedUnarchiver unarchiveObjectWithData:userMgr];
    if ([sharedMgr.studentNumber  isEqualToString: @""] || sharedMgr.studentNumber == nil)
    {
        ZCYLoginViewController *loginVC = [[ZCYLoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    } else {
        self.tabBarC = [[ZCYHomeTabBarController alloc] init];
        self.window.rootViewController = self.tabBarC;
        
    }
    self.window.backgroundColor = kCommonWhite_Color;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)
    {
        UIApplicationShortcutIcon *courseIcon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_课表"];
        UIApplicationShortcutItem *courseItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"courseItem1" localizedTitle:@"课表查询" localizedSubtitle:nil icon:courseIcon1 userInfo:nil];
        UIApplicationShortcutIcon *courseIcon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_考试"];
        UIApplicationShortcutItem *courseItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"courseItem2" localizedTitle:@"考试查询" localizedSubtitle:nil icon:courseIcon2 userInfo:nil];
        UIApplicationShortcutIcon *courseIcon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_一卡通"];
        UIApplicationShortcutItem *courseItem3 = [[UIApplicationShortcutItem alloc] initWithType:@"courseItem3" localizedTitle:@"一卡通查询" localizedSubtitle:nil icon:courseIcon3 userInfo:nil];
        UIApplicationShortcutIcon *courseIcon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_学生查询"];
        UIApplicationShortcutItem *courseItem4 = [[UIApplicationShortcutItem alloc] initWithType:@"courseItem4" localizedTitle:@"学生查询" localizedSubtitle:nil icon:courseIcon4 userInfo:nil];
        application.shortcutItems = @[courseItem1, courseItem2, courseItem3, courseItem4];
    }

    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice] systemVersion].integerValue >= 10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    }else if ([[UIDevice currentDevice] systemVersion].integerValue >= 8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    ZCYNavigationController *navigationC = self.tabBarC.viewControllers[0];
    if ([shortcutItem.type isEqualToString:@"courseItem1"])
    {
        ZCYCourseViewController *courseVC = [[ZCYCourseViewController alloc] init];
        [navigationC pushViewController:courseVC animated:NO];
    } else if ([shortcutItem.type isEqualToString:@"courseItem2"]) {
        ZCYExaminationViewController *examVC = [[ZCYExaminationViewController alloc] init];
        [navigationC pushViewController:examVC animated:NO];
    } else if ([shortcutItem.type isEqualToString:@"courseItem3"]) {
        ZCYCardDetailViewController *cardVC = [[ZCYCardDetailViewController alloc] init];
        [navigationC pushViewController:cardVC animated:NO];
    } else if ([shortcutItem.type isEqualToString:@"courseItem4"]) {
        ZCYStudentSearchViewController *searchVC = [[ZCYStudentSearchViewController alloc] init];
        [navigationC pushViewController:searchVC animated:NO];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
