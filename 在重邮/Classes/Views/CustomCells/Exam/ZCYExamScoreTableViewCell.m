//
//  ZCYExamScoreTableViewCell.m
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYExamScoreTableViewCell.h"

@interface ZCYExamScoreTableViewCell()

@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名称 */
@property (strong, nonatomic) UILabel *examAttrLabel;  /**< 考试属性 */
@property (strong, nonatomic) UILabel *creditLabel;  /**< 学分 */
@property (strong, nonatomic) UILabel *scoreLabel;  /**< 分数 */
@property (strong, nonatomic) UILabel *typeLabel;  /**< 类型 */
@property (strong, nonatomic) NSString *nameString;  /**< 课程名称 */
@property (strong, nonatomic) NSString *typeString;  /**< 性质 */
@property (strong, nonatomic) NSString *scoreString;  /**< 分数 */
@property (strong, nonatomic) NSString *attrString;  /**< 属性 */
@end

@implementation ZCYExamScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithScoreDic:(NSDictionary *)scoreDic
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.nameString = scoreDic[@"course_name"];
        self.typeString = scoreDic[@"ksxz"];
        self.attrString = scoreDic[@"type"];
        self.scoreString = scoreDic[@"socres"];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scoreLabel = [[UILabel alloc] init];
    self.typeLabel = [[UILabel alloc] init];
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
    if ([self.scoreString floatValue] >= 60 || [self.scoreString  isEqualToString: @"A"] || [self.scoreString  isEqualToString: @"A+"] || [self.scoreString  isEqualToString: @"A-"] || [self.scoreString  isEqualToString: @"B"] || [self.scoreString  isEqualToString: @"B+"] || [self.scoreString  isEqualToString: @"B-"] || [self.scoreString  isEqualToString: @"C"] || [self.scoreString  isEqualToString: @"C+"] || [self.scoreString  isEqualToString: @"C-"])
    {
        [self.scoreLabel setFont:kFont(kStandardPx(60)) andText:self.scoreString andTextColor:kDeepGreen_Color andBackgroundColor:kTransparentColor];
        [self.typeLabel setFont:kFont(kStandardPx(26)) andText:self.typeString andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGreen_Color];
    } else {
        [self.scoreLabel setFont:kFont(kStandardPx(60)) andText:self.scoreString andTextColor:kCommonRed_Color andBackgroundColor:kTransparentColor];
        [self.typeLabel setFont:kFont(kStandardPx(26)) andText:self.typeString andTextColor:kCommonWhite_Color andBackgroundColor:kCommonRed_Color];

    }
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).with.offset([UIApplication sharedApplication].keyWindow.frame.size.width - 15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(36);
    }];
    
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 4.0f;
    self.typeLabel.layer.masksToBounds = YES;
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreLabel.mas_left).with.offset(-6);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.typeString.length*14+6, 17));
    }];

    self.courseNameLabel = [[UILabel alloc] init];
    [self.courseNameLabel setFont:kFont(kStandardPx(36)) andText:self.nameString andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.courseNameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(18);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.typeLabel.mas_left).with.offset(-6);
    }];
    
    self.examAttrLabel = [[UILabel alloc] init];
    [self.examAttrLabel setFont:kFont(kStandardPx(26)) andText:self.attrString andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGreen_Color];
    self.examAttrLabel.textAlignment = NSTextAlignmentCenter;
    self.examAttrLabel.layer.cornerRadius = 4.0f;
    self.examAttrLabel.layer.masksToBounds = YES;
    [self addSubview:self.examAttrLabel];
    [self.examAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseNameLabel);
        make.top.equalTo(self.courseNameLabel.mas_bottom).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(self.attrString.length*14+6, 17));
    }];
    
//    self.creditLabel = [[UILabel alloc] init];
//    [self.creditLabel setFont:kFont(kStandardPx(26)) andText:@"" andTextColor:kCommonWhite_Color andBackgroundColor:kCommonGolden_Color];
//    self.creditLabel.textAlignment = NSTextAlignmentCenter;
//    self.creditLabel.layer.cornerRadius = 4.0f;
//    self.creditLabel.layer.masksToBounds = YES;
//    [self addSubview:self.creditLabel];
//    [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.examAttrLabel.mas_right).with.offset(6);
//        make.top.equalTo(self.courseNameLabel.mas_bottom).with.offset(6);
//        make.size.mas_equalTo(CGSizeMake(34, 17));
//    }];

    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCellWithScoreInfo:(NSDictionary *)examInfo
{
    self.courseNameLabel.text = examInfo[@"course_name"];
    self.scoreLabel.text = examInfo[@"socres"];
    self.examAttrLabel.text = examInfo[@"type"];
//    self.creditLabel.text = examInfo[@"number"];
    self.typeLabel.text = examInfo[@"ksxz"];
}

@end
