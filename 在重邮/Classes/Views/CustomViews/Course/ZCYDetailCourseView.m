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

@property (strong, nonatomic) UILabel *weekLabel;  /**< 星期数 */
@property (strong, nonatomic) UILabel *pitchLabel;  /**< 课程节数 */
@property (strong, nonatomic) UILabel *timeLabel;  /**< 课程时间 */
@property (strong, nonatomic) UISegmentedControl *segmentControl;  /**< 课程导航条 */
@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名字 */
@property (strong, nonatomic) UILabel *attributeLabel;  /**< 课程性质 */
@property (strong, nonatomic) UILabel *creditLabel;  /**< 学分 */
@property (strong, nonatomic) UILabel *detailLabel;  /**< "课程详情" */

@property (strong, nonatomic) ZCYTimeTableModel *model;  /**< 课程数据 */
@end

@implementation ZCYDetailCourseView

- (void)setup
{
    self.backgroundColor = kCommonLightGray_Color;
    self.alpha = 0.95f;
    self.layer.shadowOpacity = 0.95f;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset= CGSizeMake(0, -0.5);
    self.layer.cornerRadius = kStandardPx(18);
    
    self.weekLabel = [[UILabel alloc] init];
    [self.weekLabel setFont:kFont(kStandardPx(44)) andText:[NSString stringWithFormat:@"星期%@", [NSDate date].weekString ] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.equalTo(self).with.offset(22);
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
    [self addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.mas_bottom).with.offset(23);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(25);
    }];
    
    self.courseNameLabel = [[UILabel alloc] init];
    [self.courseNameLabel setFont:kFont(kStandardPx(26)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.segmentControl.mas_bottom).with.offset(21);
    }];
    
    self.attributeLabel = [[UILabel alloc] init];
    [self.attributeLabel setFont:kFont(kStandardPx(20)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGray_Color];
    self.attributeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.attributeLabel];
    [self.attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.top.equalTo(self.courseNameLabel.mas_bottom).with.offset(6);
    }];
    
    self.creditLabel = [[UILabel alloc] init];
    [self.creditLabel setFont:kFont(kStandardPx(20)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kCommonGolden_Color];
    self.creditLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.creditLabel];
    [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attributeLabel.mas_right).with.offset(6);
        make.size.and.top.equalTo(self.attributeLabel);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    [self.detailLabel setFont:kFont(kStandardPx(22)) andText:@"详细信息" andTextColor:kCommonGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.top.equalTo(self.attributeLabel.mas_bottom).with.offset(20);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kCommonLightGray_Color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel);
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(5);
    }];
    
    
}

@end
