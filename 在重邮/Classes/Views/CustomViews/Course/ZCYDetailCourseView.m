//
//  ZCYDetailCourseView.m
//  在重邮
//
//  Created by 周维康 on 16/11/18.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYDetailCourseView.h"
#import "ZCYTimeTableModel.h"

@interface ZCYDetailCourseView()

@property (strong, nonatomic) NSArray *courseArray;  /**< 课程数组 */
@property (strong, nonatomic) UILabel *weekLabel;  /**< 星期数 */
@property (strong, nonatomic) UILabel *pitchLabel;  /**< 课程节数 */
@property (strong, nonatomic) UILabel *timeLabel;  /**< 课程时间 */
@property (strong, nonatomic) UISegmentedControl *segmentControl;  /**< 课程导航条 */
@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名字 */
@property (strong, nonatomic) UILabel *attributeLabel;  /**< 课程性质 */
@property (strong, nonatomic) UILabel *creditLabel;  /**< 学分 */
@property (strong, nonatomic) UILabel *detailLabel;  /**< "课程详情" */
@property (strong, nonatomic) UILabel *teacherLabel;  /**< 教师名称 */
@property (strong, nonatomic) UILabel *coursePlaceLabel;  /**< 上课地点 */
@property (strong, nonatomic) UILabel *groupLabel;  /**< 上课班级 */

@property (strong, nonatomic) ZCYTimeTableModel *model;  /**< 课程数据 */
@end

@implementation ZCYDetailCourseView
{
    NSArray *_weekArray;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.courseArray = [[NSArray alloc] init];
        _weekArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七"];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = kCommonLightGray_Color;
    self.alpha = 0.95f;
    self.layer.shadowOpacity = 0.95f;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset= CGSizeMake(0, -0.5);
    self.layer.cornerRadius = kStandardPx(18);
    
    UIView *colLine = [[UIView alloc] init];
    colLine.backgroundColor = kDeepGray_Color;
    colLine.layer.cornerRadius = kStandardPx(5);
    [self addSubview:colLine];
    [colLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(36, 5));
    }];
    
    self.weekLabel = [[UILabel alloc] init];
    [self.weekLabel setFont:kFont(kStandardPx(44)) andText:[NSString stringWithFormat:@""] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.equalTo(self).with.offset(22);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-16);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.pitchLabel = [[UILabel alloc] init];
    [self.pitchLabel setFont:kFont(kStandardPx(40)) andText:@" 节" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.pitchLabel];
    [self.pitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right).with.offset(5);
        make.bottom.equalTo(self.weekLabel);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setFont:kFont(kStandardPx(30)) andText:@"-" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.timeLabel sizeToFit];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.weekLabel.mas_bottom).with.offset(7);
    }];
    
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:nil];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.tintColor = kDeepGreen_Color;
    [self.segmentControl addTarget:self action:@selector(changeSegmentValue) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(23);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(25);
    }];
    
    self.courseNameLabel = [[UILabel alloc] init];
    [self.courseNameLabel setFont:kFont(kStandardPx(36)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.segmentControl.mas_bottom).with.offset(21);
    }];
    
    self.attributeLabel = [[UILabel alloc] init];
    [self.attributeLabel setFont:kFont(kStandardPx(20)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGreen_Color];
    self.attributeLabel.layer.cornerRadius = 5.0f;
    self.attributeLabel.layer.masksToBounds = YES;
    self.attributeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.attributeLabel];
    [self.attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.top.equalTo(self.courseNameLabel.mas_bottom).with.offset(6);
    }];
    
    self.creditLabel = [[UILabel alloc] init];
    [self.creditLabel setFont:kFont(kStandardPx(20)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kCommonGolden_Color];
    self.creditLabel.textAlignment = NSTextAlignmentCenter;
    self.creditLabel.layer.cornerRadius = 5.0f;
    self.creditLabel.layer.masksToBounds = YES;
    [self addSubview:self.creditLabel];
    [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attributeLabel.mas_right).with.offset(6);
        make.size.and.top.equalTo(self.attributeLabel);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    [self.detailLabel setFont:kFont(kStandardPx(22)) andText:@"详细信息" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.attributeLabel.mas_bottom).with.offset(20);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *teacherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_teacher"]];
    [self addSubview:teacherImageView];
    [teacherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(self.weekLabel);
    }];
    
    self.teacherLabel = [[UILabel alloc] init];
    [self.teacherLabel setFont:kFont(kStandardPx(30)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.teacherLabel];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teacherImageView.mas_right).with.offset(10);
        make.centerY.equalTo(teacherImageView);
    }];
    
    UIImageView *coursePlaceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_classPlace"]];
    [self addSubview:coursePlaceImageView];
    [coursePlaceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherImageView.mas_bottom).with.offset(16);
        make.size.left.equalTo(teacherImageView);
    }];
    
    self.coursePlaceLabel = [[UILabel alloc] init];
    [self.coursePlaceLabel setFont:kFont(kStandardPx(30)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.coursePlaceLabel];
    [self.coursePlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teacherLabel);
        make.centerY.equalTo(coursePlaceImageView);
    }];
    
    UIImageView *groupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_group"]];
    [self addSubview:groupImageView];
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coursePlaceImageView.mas_bottom).with.offset(16);
        make.size.and.left.equalTo(teacherImageView);
    }];
    
    self.groupLabel = [[UILabel alloc] init];
    [self.groupLabel setFont:kFont(kStandardPx(30)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.groupLabel];
    [self.groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coursePlaceLabel);
        make.centerY.equalTo(groupImageView);
    }];
}

- (void)updateUIWithCourseArray:(NSArray *)courseArray andCourseTime:(NSInteger)courseTime andWeekNum:(NSUInteger)weekNum
{
    self.courseArray = courseArray;
    [self.segmentControl removeAllSegments];
    ZCYTimeTableModel *model = self.courseArray[0];
    for (NSInteger index = 0; index < self.courseArray.count; index++)
    {
        
        if (model.courseWeeks[index] == [model.courseWeeks lastObject])
        {
            [self.segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"第 %@ 周",model.courseWeeks[index]] atIndex:index animated:YES];
        } else {
            [self.segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"第 %@-%@ 周",model.courseWeeks[index], [model.courseWeeks lastObject]] atIndex:index animated:YES];
        }
    }
    
    
    self.segmentControl.selectedSegmentIndex = 0;
    self.pitchLabel.text = [self courseNumWithCourseTime:courseTime];
    self.weekLabel.text = [NSString stringWithFormat:@"星期%@", _weekArray[weekNum]];
    self.timeLabel.text = [self courseTimeStringWithCourseTime:courseTime];
    self.courseNameLabel.text = model.courseName;
    self.attributeLabel.text = model.courseType;
    self.creditLabel.text = model.courseCredit;
    self.teacherLabel.text = model.courseTeacher;
    self.coursePlaceLabel.text = model.coursePlace;
    self.groupLabel.text = model.classId;
}

- (void)closeButtonDidTouched
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonDidPressed)])
    {
        [self.delegate closeButtonDidPressed];
    }
    [self.segmentControl removeAllSegments];
}

- (void)changeSegmentValue
{
    NSUInteger index = self.segmentControl.selectedSegmentIndex;
    ZCYTimeTableModel *model = self.courseArray[index];
    
    self.courseNameLabel.text = model.courseName;
    self.attributeLabel.text = model.courseType;
    self.creditLabel.text = model.courseCredit;
    self.teacherLabel.text = model.courseTeacher;
    self.coursePlaceLabel.text = model.coursePlace;
    self.groupLabel.text = model.classId;

}

- (NSString *)courseTimeStringWithCourseTime:(NSInteger)courseTime
{
    switch (courseTime) {
        case 0:
            return @"08:00－09:40";
        case 1:
            return @"10:05－11:45";
        case 2:
            return @"14:00－15:40";
        case 3:
            return @"16:05－17:45";
        case 4:
            return @"19:00－20:40";
        case 5:
            return @"21:05－22:45";
            
        default:
            return @"00:00－";
    }
}

- (NSString *)courseNumWithCourseTime:(NSInteger)courseTime
{
    switch (courseTime) {
        case 0:
            return @"一二节";
        case 1:
            return @"三四节";
        case 2:
            return @"五六节";
        case 3:
            return @"七八节";
        case 4:
            return @"九十节";
        case 5:
            return @"十一十二节";
            
        default:
            return @"wrong";
    }
}
@end
