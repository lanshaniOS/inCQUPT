//
//  ZCYCalendarViewController.m
//  i重邮
//
//  Created by 谭培 on 2017/2/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYCalendarViewController.h"

@interface ZCYCalendarViewController ()

@end

@implementation ZCYCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tiurge.cn/wp-content/uploads/2017/03/20170309164526a.png"]];
    webView.userInteractionEnabled = YES;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    webView.multipleTouchEnabled = YES;
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
    }];
}

- (NSString *)title
{
    return @"校历";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
