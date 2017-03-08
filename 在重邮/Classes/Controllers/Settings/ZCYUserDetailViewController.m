//
//  ZCYUserDetailViewController.m
//  在重邮
//
//  Created by 周维康 on 16/12/5.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserDetailViewController.h"

@interface ZCYUserDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *userTableView;  /**< 用户详情 */
@property (strong, nonatomic) NSArray *funcArray;  /**< 功能数组 */
@property (strong, nonatomic) NSArray *detailArray;  /**< 详情数组 */
@end

@implementation ZCYUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"个人信息";
}

- (void)initUI
{
    NSString *dormitoryString;
    if ([ZCYUserMgr sharedMgr].dormitoryArray)
    {
        dormitoryString = [NSString stringWithFormat:@"%@栋%@%@",[ZCYUserMgr sharedMgr].dormitoryArray[0], [ZCYUserMgr sharedMgr].dormitoryArray[2], [ZCYUserMgr sharedMgr].dormitoryArray[3]];
    } else {
        dormitoryString = @"未绑定";
    }
    self.funcArray = @[@"姓名", @"学号",@"学院", @"教育水平", @"寝室", @"一卡通号"];
    self.detailArray = @[[ZCYUserMgr sharedMgr].userName, [ZCYUserMgr sharedMgr].studentNumber, [ZCYUserMgr sharedMgr].collegeName, [ZCYUserMgr sharedMgr].eduType, dormitoryString, [ZCYUserMgr sharedMgr].cardID];
    [self initUserTableView];
}

- (void)initUserTableView
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:kFont(kStandardPx(30)) andText:@"基本信息" andTextColor:kDeepGray_Color andBackgroundColor:kCommonWhite_Color];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.and.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(40);
    }];
    
    UIView *topGrayLine = [[UIView alloc] init];
    topGrayLine.backgroundColor = kCommonGray_Color;
    [self.view addSubview:topGrayLine];
    [topGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(label.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.userTableView = [[UITableView alloc] init];
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    self.userTableView.backgroundColor = kCommonGray_Color;
    self.userTableView.showsVerticalScrollIndicator = NO;
    self.userTableView.scrollEnabled = NO;
    self.userTableView.allowsSelection = NO;
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.userTableView];
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topGrayLine.mas_bottom).with.offset(0);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50*self.detailArray.count);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.userTableView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.funcArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYUserDetailViewTableViewCellIdentifier"];
    UILabel *funcLabel = [[UILabel alloc] init];
    [funcLabel setFont:kFont(kStandardPx(30)) andText:self.funcArray[indexPath.row] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [cell addSubview:funcLabel];
    [funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(15);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    [detailLabel setFont:kFont(kStandardPx(30)) andText:self.detailArray[indexPath.row] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).with.offset(-15);
        make.centerY.equalTo(cell);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [cell addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(cell);
        make.height.mas_equalTo(1);
    }];
    return cell;
}
@end
