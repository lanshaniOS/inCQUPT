//
//  ZCYHomeTabBarController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHomeTabBarController.h"
#import "ZCYNavigationController.h"
#import "ZCYHomePageViewController.h"
#import "ZCYSettingsViewController.h"
#import "ZCYInformationViewController.h"

@interface ZCYHomeTabBarController ()

@property (strong, nonatomic) NSArray *itemArray;  /**< tabbar数组 */

@end

@implementation ZCYHomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBarItem];
    
}

- (void)initTabBarItem
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[self tabbarDefines].count];
    
    for (NSDictionary *itemDic in [self tabbarDefines])
    {
        Class vcClass = NSClassFromString(itemDic[@"viewController_class"]);
        UIViewController *viewController = [[vcClass alloc] init];
        viewController.title = itemDic[@"name"];
        
        ZCYNavigationController *naviController = [[ZCYNavigationController alloc] initWithRootViewController:viewController];
        
        
        naviController.navigationBar.tintColor = kDeepGreen_Color;
        naviController.tabBarItem.title = itemDic[@"name"];
        naviController.navigationBar.barTintColor = kNavBar_Color;
//        [naviController.navigationBar setBackgroundImage:kNavbar_BgImage forBarMetrics:UIBarMetricsDefault];
        naviController.tabBarItem.image = [[UIImage imageNamed:itemDic[@"icon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviController.tabBarItem.selectedImage = [[UIImage imageNamed:itemDic[@"icon_s"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        [viewControllers addObject:naviController];
    }
    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (NSArray *)tabbarDefines
{
    NSArray *defineArray = @[
                             @{@"name" : @"今日",
                               @"icon" : @"icon_mainHome",
                               @"icon_s" : @"icon_mainHome_f",
                               @"viewController_class" : NSStringFromClass([ZCYHomePageViewController class])} ,
                             @{@"name" : @"资讯",
                               @"icon" : @"icon_mainNews",
                               @"icon_s" : @"icon_mainNews_f",
                               @"viewController_class" : NSStringFromClass([ZCYInformationViewController class])} ,
                             @{@"name" : @"更多",
                               @"icon" : @"icon_mainMore",
                               @"icon_s" : @"icon_mainMore_f",
                               @"viewController_class" : NSStringFromClass([ZCYSettingsViewController class])}];
    return [defineArray copy];
}
@end
