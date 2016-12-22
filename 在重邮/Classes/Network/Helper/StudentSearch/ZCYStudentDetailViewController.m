//
//  ZCYStudentDetailViewController.m
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYStudentDetailViewController.h"
#import "ZCYCourseViewController.h"
#import "ZCYExaminationViewController.h"

@interface ZCYStudentDetailViewController ()

@property (strong, nonatomic) NSDictionary *studentInfo;  /**< 学生信息 */
@property (strong, nonatomic) UILabel *nameLabel;  /**< 学生姓名 */
@property (strong, nonatomic) UIImageView *studentCard;  /**< 学生信息 */
@property (strong, nonatomic) UIView *courseSearchView;  /**< 课表查询 */
@property (strong, nonatomic) UIView *examSearchView;  /**< 考试查询 */

@end

@implementation ZCYStudentDetailViewController
{
    CGFloat _screenWidth;
    CGFloat _screenHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"学生详情";
}

- (instancetype)initWithStudentInfo:(NSDictionary *)studentInfo
{
    if (self = [super init])
    {
        self.studentInfo = studentInfo;
    }
    return self;
}

- (void)initUI
{
    _screenWidth = self.view.frame.size.width;
    _screenHeight = self.view.frame.size.height;
    [self initStudentCard];
    [self initCourseSearchView];
    [self initExamSearchView];
}

- (void)initStudentCard
{
    self.studentCard = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x33d4b3]]];
//    self.studentCard.backgroundColor = [UIColor colorWithRGBHex:0x33d4b3];
    self.studentCard.layer.masksToBounds = YES;
    self.studentCard.layer.cornerRadius = 5;
    [self.view addSubview:self.studentCard];
    [self.studentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15*_screenWidth/375);
        make.top.equalTo(self.view).with.offset((163)*_screenHeight/667);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(180*_screenHeight/667);
    }];
    
    UILabel *stdNumberLabel = [[UILabel alloc] init];
    [stdNumberLabel setFont:kFont(kStandardPx(32)) andText:[NSString stringWithFormat:@"学号   %@", self.studentInfo[@"xh"]] andTextColor:kCommonWhite_Color andBackgroundColor:kTransparentColor];
    [self.studentCard addSubview:stdNumberLabel];
    
    UILabel *schLabel = [[UILabel alloc] init];
    [schLabel setFont:kFont(kStandardPx(32)) andText:[NSString stringWithFormat:@"学院   %@", self.studentInfo[@"yxm"]] andTextColor:kCommonWhite_Color andBackgroundColor:kTransparentColor];
    [self.studentCard addSubview:schLabel];

    UILabel *subjectLabel = [[UILabel alloc] init];
    [subjectLabel setFont:kFont(kStandardPx(32)) andText:[NSString stringWithFormat:@"专业   %@", self.studentInfo[@"zym"]] andTextColor:kCommonWhite_Color andBackgroundColor:kTransparentColor];
    [self.studentCard addSubview:subjectLabel];

    UILabel *classLabel = [[UILabel alloc] init];
    [classLabel setFont:kFont(kStandardPx(32)) andText:[NSString stringWithFormat:@"班级   %@", self.studentInfo[@"bj"]] andTextColor:kCommonWhite_Color andBackgroundColor:kTransparentColor];
    [self.studentCard addSubview:classLabel];

    NSArray *viewArray = @[stdNumberLabel, schLabel, subjectLabel, classLabel];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:30 tailSpacing:30];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15*self.view.frame.size.width/375));
    }];
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:[UIFont systemFontOfSize:kStandardPx(80) weight:2] andText:self.studentInfo[@"xm"] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.studentCard.mas_top).with.offset(-30);
        make.left.equalTo(self.view).with.offset(30);
    }];
}

- (void)initCourseSearchView
{
    self.courseSearchView = [[UIView alloc] init];
    [self.view addSubview:self.courseSearchView];
    [self.courseSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.studentCard);
        make.top.equalTo(self.studentCard.mas_bottom).with.offset(10);
        make.height.mas_equalTo(60);
    }];
    
    UIImageView *courseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"课表"]];
    [self.courseSearchView addSubview:courseImageView];
    [courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseSearchView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.courseSearchView);
    }];
    
    UILabel *courseLabel = [[UILabel alloc] init];
    [courseLabel setFont:kFont(kStandardPx(30)) andText:@"课表查询" andTextColor:kDeepGreen_Color andBackgroundColor:kTransparentColor];
    [self.courseSearchView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.courseSearchView);
        make.left.equalTo(courseImageView.mas_right).with.offset(15);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [self.courseSearchView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel);
        make.bottom.and.right.equalTo(self.courseSearchView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *nextLabel = [[UILabel alloc] init];
    [nextLabel setFont:kFont(kStandardPx(40)) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.courseSearchView addSubview:nextLabel];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.courseSearchView);
        make.centerY.equalTo(self.courseSearchView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCourseView)];
    [self.courseSearchView addGestureRecognizer:tap];
}

- (void)initExamSearchView
{
    self.examSearchView = [[UIView alloc] init];
    self.examSearchView.backgroundColor = kCommonWhite_Color;
    [self.view addSubview:self.examSearchView];
    [self.examSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseSearchView.mas_bottom);
        make.left.and.right.and.height.equalTo(self.courseSearchView);
    }];
    
    [self setFuncView:self.examSearchView WithImageName:@"考试查询" funcString:@"考试查询"];
    UITapGestureRecognizer *tapExamSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToExamView)];
    [self.examSearchView addGestureRecognizer:tapExamSearch];
}
- (void)pushToCourseView
{
    ZCYCourseViewController *courseVC = [[ZCYCourseViewController alloc] initWithStudentNumber:self.studentInfo[@"xh"]];
    [self.navigationController pushViewController:courseVC animated:YES];
}

- (void)pushToExamView
{
    ZCYExaminationViewController *examVC = [[ZCYExaminationViewController alloc] initWithLastControllerType:Controller_StudentSearch andStudentNumber:self.studentInfo[@"xh"]];
    [self.navigationController pushViewController:examVC animated:YES];
}
- (void)setFuncView:(UIView *)view WithImageName:(NSString *)imageName funcString:(NSString *)funcString
{
    
    UIImageView *courseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:courseImageView];
    [courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(view);
    }];
    
    UILabel *courseLabel = [[UILabel alloc] init];
    [courseLabel setFont:kFont(kStandardPx(30)) andText:funcString andTextColor:kDeepGreen_Color andBackgroundColor:kTransparentColor];
    [view addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(courseImageView.mas_right).with.offset(15);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel);
        make.bottom.and.right.equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *nextLabel = [[UILabel alloc] init];
    [nextLabel setFont:kFont(kStandardPx(40)) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [view addSubview:nextLabel];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.centerY.equalTo(view);
    }];

}
@end
