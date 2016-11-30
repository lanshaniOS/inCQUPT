//
//  ZCYExaminationViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYExaminationViewController.h"
#import "ZCYExaminationHelper.h"
#import "ZCYExaminationTableViewCell.h"

@interface ZCYExaminationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *examTableView;  /**< 背景下啦  */
@property (strong, nonatomic) UISegmentedControl *segmentControl;  /**< 顶部导航条 */
@property (strong, nonatomic) UILabel  *tipLabel;  /**< 提示 */
@property (strong, nonatomic) NSArray *examArray;  /**< 考试安排数组 */
@end

@implementation ZCYExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"考试查询";
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([ZCYUserMgr sharedMgr].examRecord)
    {
        self.tipLabel.hidden = YES;
        self.examArray = [ZCYUserMgr sharedMgr].examRecord;
        [self.examTableView reloadData];
    }
    [super viewWillAppear:animated];
    [ZCYExaminationHelper getExamRecordWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSArray *array) {
        if (error)
        {
            self.tipLabel.text = @"您的网络似乎在开小差哟～～～";
            return;
        } else {
           
            self.examArray = array;
            [ZCYUserMgr sharedMgr].examRecord = array;
            if (self.examArray.count == 0)
            {
                self.tipLabel.hidden = NO;
                self.tipLabel.text = @"最近都没有考试哦～～～";
            } else {
                self.tipLabel.hidden = YES;
            }
            [self.examTableView reloadData];
        }
    }];
}
- (void)initUI
{
    [self initSegmentControl];
    [self initExamTableView];
    [self initTipLabel];
}

- (void)initSegmentControl
{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"考试安排", @"补考安排", @"成绩查询"]];
    self.segmentControl.tintColor = kDeepGreen_Color;
    
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(changeSegmentValue) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(4);
        make.right.equalTo(self.view).with.offset(-4);
        make.top.equalTo(self.view).with.offset(66);
        make.height.mas_equalTo(30);
    }];

}
- (void)initExamTableView
{
    self.examTableView = [[UITableView alloc] init];
    self.examTableView.delegate = self;
    self.examTableView.dataSource = self;
    self.examTableView.allowsSelection = NO;
    self.examTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.examTableView];
    [self.examTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(100);
    }];
}

- (void)initTipLabel
{
    self.tipLabel = [[UILabel alloc] init];
    [self.tipLabel setFont:kFont(kStandardPx(50)) andText:@"获取数据中..." andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCYExaminationTableViewCell *cell = [[ZCYExaminationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExaminationTableViewCellIdentifier"];
    [cell setCellWithExamInfo:self.examArray[indexPath.row]];
    return cell;
}
#pragma mark - 点击事件
- (void)changeSegmentValue
{
    
}
@end
