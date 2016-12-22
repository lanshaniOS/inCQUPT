//
//  ZCYAboutusViewController.m
//  在重邮
//
//  Created by 周维康 on 16/12/19.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYAboutusViewController.h"

@interface ZCYAboutusViewController ()

@end

@implementation ZCYAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"关于我们";
}

- (void)initUI
{
    [self initHeaderView];
}

- (void)initHeaderView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"信息协会图标"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(80);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:kFont(kStandardPx(30)) andText:@"教育信息化创新创业协会" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).with.offset(6);
    }];
    
    NSString *introString = @"重庆邮电大学教育信息化创新创业协会，是在教育信息化办公室/信息中心指导下，以蓝山工作室学生队伍为骨干，利用信息化技术，推动学校教育信息化创新，促进大学生创新创业的群众性学生团体。协会支持学校教育教学信息化建设，服务全校师生，起到教育教学信息化应用与广大师生之间的桥梁纽带作用。";
    UILabel *introduceLabel = [[UILabel alloc] init];
    [introduceLabel setFont:kFont(kStandardPx(26)) andText:introString andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    introduceLabel.numberOfLines = 0;
    [self.view addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(20);
    }];

    UIImageView *maImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"群二维码"]];
    [self.view addSubview:maImageView];
    [maImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(introduceLabel.mas_bottom).with.offset(40);
    }];
    
    UILabel *qqLabel = [[UILabel alloc] init];
    [qqLabel setFont:kFont(kStandardPx(30)) andText:@"QQ交流群：605244918" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:qqLabel];
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.centerY.equalTo(maImageView);
    }];
    
    UILabel *lanshanLabel = [[UILabel alloc] init];
    [lanshanLabel setFont:kFont(kStandardPx(18)) andText:@"@2016 蓝山工作室 All rights reserved" andTextColor:kGray_Line_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:lanshanLabel];
    [lanshanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
}
@end
