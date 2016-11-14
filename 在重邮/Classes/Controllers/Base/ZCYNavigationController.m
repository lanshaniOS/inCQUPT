//
//  ZCYNavigationController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYNavigationController.h"

@interface ZCYNavigationController ()

@end

@implementation ZCYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark- override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
}

@end
