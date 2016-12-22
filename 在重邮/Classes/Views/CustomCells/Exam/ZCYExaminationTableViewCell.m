//
//  ZCYExaminationTableViewCell.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYExaminationTableViewCell.h"

@interface ZCYExaminationTableViewCell()

@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名称 */
@property (strong, nonatomic) UILabel *examTimeLabel;  /**< 考试时间 */
@property (strong, nonatomic) UILabel *examAttrLabel;  /**< 考试属性 */
@property (strong, nonatomic) UILabel *leavingDayLabel;  /**< 剩余天数 */
@property (strong, nonatomic) UILabel *classIDLabel;  /**< 教室号 */
@property (strong, nonatomic) UILabel *sitIDLabel;  /**< 座位号 */
@property (strong, nonatomic) UILabel *dateLabel;  /**< 考试日期 */

@end
@implementation ZCYExaminationTableViewCell
{
    CGFloat _cellWidth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWidth:(CGFloat)cellWidth
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _cellWidth = cellWidth;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.leavingDayLabel = [[UILabel alloc] init];
    [self.leavingDayLabel setFont:kFont(kStandardPx(48)) andText:@"" andTextColor:[UIColor colorWithRGBHex:0xff9c00] andBackgroundColor:kTransparentColor];
    [self addSubview:self.leavingDayLabel];
    [self.leavingDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    [dayLabel setFont:kFont(kStandardPx(24)) andText:@"天" andTextColor:[UIColor colorWithRGBHex:0x666666] andBackgroundColor:kTransparentColor];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leavingDayLabel.mas_right);
        make.bottom.equalTo(self.leavingDayLabel);
//        make.width.mas_equalTo(13);
    }];
    
    
    self.classIDLabel = [[UILabel alloc] init];
    [self.classIDLabel setFont:kFont(kStandardPx(40)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.classIDLabel];
    [self.classIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(self).with.offset(18);
    }];
    
    self.examAttrLabel = [[UILabel alloc] init];
    [self.examAttrLabel setFont:kFont(kStandardPx(26)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGreen_Color];
    self.examAttrLabel.textAlignment = NSTextAlignmentCenter;
    self.examAttrLabel.layer.cornerRadius = 4.0f;
    self.examAttrLabel.layer.masksToBounds = YES;
    [self addSubview:self.examAttrLabel];
    [self.examAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classIDLabel.mas_left).with.offset(-10);
        make.bottom.equalTo(self.classIDLabel);
        make.size.mas_equalTo(CGSizeMake(34, 17));
    }];
    
    self.courseNameLabel = [[UILabel alloc] init];
    [self.courseNameLabel setFont:kFont(kStandardPx(40)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.courseNameLabel.adjustsFontSizeToFitWidth = YES;
    self.courseNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(18);
        make.left.equalTo(self).with.offset(70);
        make.width.mas_equalTo(127*_cellWidth/320);
    }];
    
    
    self.examTimeLabel = [[UILabel alloc] init];
    [self.examTimeLabel setFont:kFont(kStandardPx(24)) andText:@"" andTextColor:[UIColor colorWithRGBHex:0x666666] andBackgroundColor:kTransparentColor];
    [self addSubview:self.examTimeLabel];
    [self.examTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseNameLabel);
        make.top.equalTo(self.courseNameLabel.mas_bottom).with.offset(4);
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    [self.dateLabel setFont:kFont(kStandardPx(25)) andText:@"" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examTimeLabel);
        make.top.equalTo(self.examTimeLabel.mas_bottom).with.offset(4);
    }];

    self.sitIDLabel = [[UILabel alloc] init];
    [self.sitIDLabel setFont:kFont(kStandardPx(26)) andText:@"" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:self.sitIDLabel];
    [self.sitIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classIDLabel);
        make.top.equalTo(self.classIDLabel.mas_bottom).with.offset(3);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCellWithExamInfo:(NSDictionary *)examInfo
{
    self.courseNameLabel.text = examInfo[@"course"];
    self.leavingDayLabel.text = [NSString stringWithFormat:@"%@", examInfo[@"days"]];
    self.examTimeLabel.text = [NSString stringWithFormat:@"第 %@ 周 星期%@ %@", examInfo[@"week"], examInfo[@"day"], examInfo[@"time"]];
    self.examAttrLabel.text = examInfo[@"type"];
    self.sitIDLabel.text = [NSString stringWithFormat:@"座位号%@",examInfo[@"number"]];
//    self.dateLabel.text = examInfo[@"date"];
    self.classIDLabel.text = examInfo[@"room"];
}
@end
