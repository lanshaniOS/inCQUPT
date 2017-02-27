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
//@property (strong, nonatomic) UITableView *resitTableView;  /**< 补考 */
@property (strong, nonatomic) NSArray *resitArray;  /**< 补考数组 */
@property (strong, nonatomic) NSArray *scoreArray;  /**< 成绩数组 */
@property (strong, nonatomic) NSString *studentNumber;  /**< 学号 */
@property (assign, nonatomic) ZCYLastControllerType lastControllerType;  /**< 上个控制器 */
@end

@implementation ZCYExaminationViewController

- (instancetype)initWithLastControllerType:(ZCYLastControllerType)lastTyoe andStudentNumber:(NSString *)studentNumber
{
    if (self = [super init])
    {
        self.studentNumber = studentNumber;
        self.lastControllerType = lastTyoe;
    }
    return self;
}

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
    if (self.lastControllerType == Controller_HomePage)
    {
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
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (NSDictionary *dic in array)
                {
                    NSInteger day = [dic[@"days"] integerValue];
                    if (day >= 0)
                    {
                        [mutableArray addObject:dic];
                    }
                }
                self.examArray = mutableArray;
                [ZCYUserMgr sharedMgr].examRecord = mutableArray;
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
                if (array && array.count != 0)
                {
                    self.scoreArray = array;
                    self.scoreTipLabel.hidden = YES;
                } else {
                    self.scoreTipLabel.hidden = NO;
                    self.scoreTipLabel.text = @"暂时还没有成绩哦";
                    //            [ZCYUserMgr sharedMgr].examRecord = array;
                    
                    
                }
                [self.scoreTableView reloadData];
            }
        }];
    } else if (self.lastControllerType == Controller_StudentSearch)
    {
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"数据加载中" inView:self.view];
        [ZCYExaminationHelper getExamRecordWithStdNumber:self.studentNumber withCompeletionBlock:^(NSError *error, NSArray *array) {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
            if (error)
            {
                [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
                //            self.examTipLabel.text = @"您的网络似乎在开小差哟～～～";
                return;
            } else {
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (NSDictionary *dic in array)
                {
                    NSInteger day = [dic[@"days"] integerValue];
                    if (day >= 0)
                    {
                        [mutableArray addObject:dic];
                    }
                }
                self.examArray = mutableArray;
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
    }
}
- (void)initUI
{
    if (self.lastControllerType == Controller_HomePage)
    {
        [self initSegmentControl];
        [self initExamTableView];
        [self initTipLabel];
    } else {
        [self initExamTableView];
        [self initTipLabel];
    }
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
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    if (self.lastControllerType == Controller_HomePage)
    {
        self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 100);
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

    } else if (self.lastControllerType == Controller_StudentSearch){
        self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64);
        [self.view addSubview:self.backgroundScrollView];
        [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(64);
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
            make.top.equalTo(self.view).with.offset(64);
            make.height.mas_offset(self.view.frame.size.height - 64);
        }];

    }
    
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
    if (self.lastControllerType == Controller_HomePage)
    {
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
    } else if (tableView == self.scoreTableView) {
        return self.scoreArray.count;
    } else {
        return self.examArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.examTableView) {
        ZCYExaminationTableViewCell *cell = [[ZCYExaminationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExaminationTableViewCellIdentifier" andWidth:self.view.frame.size.width];
        [cell setCellWithExamInfo:self.examArray[indexPath.row]];
        return cell;
    } else {
        ZCYExamScoreTableViewCell *cell = [[ZCYExamScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYExamScoreTableViewCellIdentifier" WithScoreDic:self.scoreArray[indexPath.row]];
//        [cell setCellWithScoreInfo:self.scoreArray[indexPath.row]];
        return cell;
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.scoreTableView && scrollView != self.examTableView)
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/self.view.frame.size.width;
}
#pragma mark - 点击事件
- (void)changeSegmentValue
{
    self.backgroundScrollView.contentOffset = CGPointMake(self.segmentControl.selectedSegmentIndex*self.view.frame.size.width, 0);
}
@end
