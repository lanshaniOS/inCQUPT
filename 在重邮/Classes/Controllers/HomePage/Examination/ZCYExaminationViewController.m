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
#import "ZCYExamResitTableViewCell.h"
#import "ZCYExamScoreTableViewCell.h"
#import "ZCYExamScoreHelper.h"

@interface ZCYExaminationViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 滑动背景板 */
@property (strong, nonatomic) UITableView *examTableView;  /**< 背景下啦  */
@property (strong, nonatomic) UISegmentedControl *segmentControl;  /**< 顶部导航条 */
@property (strong, nonatomic) UILabel  *examTipLabel;  /**< 提示 */
@property (strong, nonatomic) UILabel  *scoreTipLabel;  /**< 提示 */
@property (strong, nonatomic) NSArray *examArray;  /**< 考试安排数组 */
@property (strong, nonatomic) UITableView *scoreTableView;  /**< 分数查询 */
@property (strong, nonatomic) UITableView *resitTableView;  /**< 补考 */
@property (strong, nonatomic) NSArray *resitArray;  /**< 补考数组 */
@property (strong, nonatomic) NSArray *scoreArray;  /**< 成绩数组 */
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
    [super viewWillAppear:animated];
    if ([ZCYUserMgr sharedMgr].examRecord)
    {
//        self.examTipLabel.hidden = YES;
        self.examArray = [ZCYUserMgr sharedMgr].examRecord;
        [self.examTableView reloadData];
    } else {
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"数据加载中" inView:self.view];
    }
    [ZCYExaminationHelper getExamRecordWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSArray *array) {
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error)
        {
            [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
//            self.examTipLabel.text = @"您的网络似乎在开小差哟～～～";
            return;
        } else {
           
            self.examArray = array;
            [ZCYUserMgr sharedMgr].examRecord = array;
            if (self.examArray.count == 0)
            {
                self.examTipLabel.hidden = NO;
                self.examTipLabel.text = @"最近都没有考试哦～～～";
            } else {
                self.examTipLabel.hidden = YES;
            }
            [self.examTableView reloadData];
        }
    }];
    
    self.scoreTipLabel.text = @"加载数据中...";
    self.scoreTipLabel.hidden = NO;
    [ZCYExamScoreHelper getExamScoreWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSArray *array) {
        if (error)
        {
            self.scoreTipLabel.text = [error localizedDescription];
            self.scoreTipLabel.hidden = NO;
            return;
        } else {
            
            self.scoreArray = array;
//            [ZCYUserMgr sharedMgr].examRecord = array;
            if (self.scoreArray.count == 0)
            {
                self.scoreTipLabel.hidden = NO;
                self.scoreTipLabel.text = @"成绩都还没出来呢～～～";
            } else {
                self.scoreTipLabel.hidden = YES;
            }
            [self.scoreTableView reloadData];
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
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"考试安排", @"成绩查询"]];
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
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 100);
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(100);
    }];
    self.examTableView = [[UITableView alloc] init];
    self.examTableView.delegate = self;
    self.examTableView.dataSource = self;
    self.examTableView.allowsSelection = NO;
    self.examTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backgroundScrollView addSubview:self.examTableView];
    [self.examTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundScrollView);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_offset(self.view.frame.size.height - 100);
    }];
    
    self.scoreTableView = [[UITableView alloc] init];
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    self.scoreTableView.allowsSelection = NO;
    self.scoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backgroundScrollView addSubview:self.scoreTableView];
    [self.scoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examTableView.mas_right);
        make.width.and.top.and.bottom.equalTo(self.examTableView);
    }];
    
//    self.resitTableView = [[UITableView alloc] init];
//    self.resitTableView.delegate = self;
//    self.resitTableView.dataSource = self;
//    self.resitTableView.allowsSelection = NO;
//    self.resitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.backgroundScrollView addSubview:self.resitTableView];
//    [self.resitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.scoreTableView.mas_right);
//        make.width.and.top.and.bottom.equalTo(self.examTableView);
//    }];

}

- (void)initTipLabel
{
    self.examTipLabel = [[UILabel alloc] init];
    [self.examTipLabel setFont:kFont(kStandardPx(50)) andText:@"获取数据中..." andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    self.examTipLabel.hidden = YES;
    self.examTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundScrollView addSubview:self.examTipLabel];
    [self.examTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundScrollView);
        make.centerY.equalTo(self.backgroundScrollView);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];
    
    self.scoreTipLabel = [[UILabel alloc] init];
    [self.scoreTipLabel setFont:kFont(kStandardPx(50)) andText:@"获取数据中..." andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    self.scoreTipLabel.hidden = YES;
    self.scoreTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundScrollView addSubview:self.scoreTipLabel];
    [self.scoreTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreTableView);
        make.centerY.equalTo(self.backgroundScrollView);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.examTableView) {
        return self.examArray.count;
    } else if (tableView == self.resitTableView) {
        return self.resitArray.count;
    } else {
        return self.scoreArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.examTableView) {
        ZCYExaminationTableViewCell *cell = [[ZCYExaminationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExaminationTableViewCellIdentifier"];
        [cell setCellWithExamInfo:self.examArray[indexPath.row]];
        return cell;
    } else if (tableView == self.resitTableView) {
        ZCYExamResitTableViewCell *cell = [[ZCYExamResitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExamResitTableViewCellIdentifier"];
        return cell;
    } else {
        ZCYExamScoreTableViewCell *cell = [[ZCYExamScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExamScoreTableViewCellIdentifier"];
        [cell setCellWithScoreInfo:self.scoreArray[indexPath.row]];
        return cell;
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/self.view.frame.size.width;
//    if (self.segmentControl.selectedSegmentIndex == 1)
//    {
//        [ZCYExamScoreHelper getExamScoreWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSArray *array) {
//            if (error)
//            {
//                self.tipLabel.text = [error localizedDescription];
//                return;
//            }
//            if (array.count == 0)
//            {
//                
//                return;
//            }
//            self.scoreArray = array;
//            [self.scoreTableView reloadData];
//        }];
//    }
}
#pragma mark - 点击事件
- (void)changeSegmentValue
{
    self.backgroundScrollView.contentOffset = CGPointMake(self.segmentControl.selectedSegmentIndex*self.view.frame.size.width, 0);
}
@end
