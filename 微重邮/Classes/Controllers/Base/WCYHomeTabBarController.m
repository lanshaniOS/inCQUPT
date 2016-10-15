//
//  WCYHomeTabBarController.m
//  微重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WCYHomeTabBarController.h"
#import "WCYNavigationController.h"
#import "WCYHomePageViewController.h"
#import "WCYSettingsViewController.h"
#import "WCYInformationViewController.h"

@interface WCYHomeTabBarController ()

@property (strong, nonatomic) NSArray *itemArray;  /**< tabbar数组 */

@end

@implementation WCYHomeTabBarController

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
        
        WCYNavigationController *naviController = [[WCYNavigationController alloc] initWithRootViewController:viewController];
        
        naviController.tabBarItem.title = itemDic[@"name"];
        naviController.tabBarItem.image = [[UIImage imageNamed:itemDic[@"icon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviController.tabBarItem.selectedImage = [[UIImage imageNamed:itemDic[@"icon_s"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [viewControllers addObject:naviController];
    }
    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (NSArray *)tabbarDefines
{
    NSArray *defineArray = @[
                             @{@"name" : @"主页",
                               @"icon" : @"icon_mainHome",
                               @"icon_s" : @"icon_mainHome_f",
                               @"viewController_class" : NSStringFromClass([WCYHomePageViewController class])} ,
                             @{@"name" : @"资讯",
                               @"icon" : @"icon_mainNews",
                               @"icon_s" : @"icon_mainNews_f",
                               @"viewController_class" : NSStringFromClass([WCYInformationViewController class])} ,
                             @{@"name" : @"更多",
                               @"icon" : @"icon_mainMore",
                               @"icon_s" : @"icon_mainMore_f",
                               @"viewController_class" : NSStringFromClass([WCYSettingsViewController class])}];
    return [defineArray copy];
}
@end
