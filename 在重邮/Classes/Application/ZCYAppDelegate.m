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

@interface ZCYAppDelegate ()

@property (strong, nonatomic)  ZCYHomeTabBarController *tabBarC;  /**< TabbarVC */

@end

@implementation ZCYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kCommonWhite_Color;
    
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIMutableApplicationShortcutItem *shareItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"shareItem" localizedTitle:@"分享"];
    shareItem.icon = shareIcon;
    
    UIApplicationShortcutIcon *courseIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"课表"];
    UIApplicationShortcutItem *courseItem = [[UIApplicationShortcutItem alloc] initWithType:@"courseItem" localizedTitle:@"课表" localizedSubtitle:nil icon:courseIcon userInfo:nil];
    
    application.shortcutItems = @[shareItem, courseItem];
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
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"courseItem"])
    {
        ZCYNavigationController *navigationC = self.tabBarC.viewControllers[0];
        ZCYCourseViewController *courseVC = [[ZCYCourseViewController alloc] init];
        [navigationC pushViewController:courseVC animated:NO];
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
