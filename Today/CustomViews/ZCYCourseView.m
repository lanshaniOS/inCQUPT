//
//  ZCYCourseView.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCourseView.h"
#import "ZCYStyleDefine.h"
#import "Masonry.h"

@interface ZCYCourseView()

@property (strong, nonatomic) NSString *courseName;  /**< 课程名称 */
@property (strong, nonatomic) NSString *classID;
@property (strong, nonatomic) UIColor *deepTextColor;  /**< 文字颜色 */
@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名称标题 */
@property (strong, nonatomic) UILabel *classIDLabel;  /**< 教室编号 */
@property (strong, nonatomic) UIView *line;  /**< 竖线 */
@property (strong, nonatomic) UIView *cycle;  /**< 小圆圈 */
@property (nonatomic) NSInteger courseTime;  /**< 上课时间 */


@end
@implementation ZCYCourseView


- (instancetype)initWithCourseName:(NSString *)courseName andClassID:(NSString *)classID andCourseTime:(NSInteger)courseTime;
{
    if (self = [super init])
    {
        self.courseName = courseName;
        self.classID = classID;
        self.backgroundColor = kCommonGray_Color;
        self.courseTime = courseTime;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCourseName:nil andClassID:nil andCourseTime:0];
}

- (void)setTextColor:(UIColor *)textColor andBackgroundColor:(UIColor *)bgColor
{
    self.courseNameLabel.textColor = textColor;
    self.classIDLabel.textColor = textColor;
    self.cycle.backgroundColor = textColor;
    self.line.backgroundColor = textColor;
    self.backgroundColor = bgColor;
}

- (void)setup
{
    self.courseNameLabel = [[UILabel alloc] init];
    self.courseNameLabel.text = self.courseName;
    self.courseNameLabel.textColor = self.deepTextColor;
    self.courseNameLabel.font = kFont(15);
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.top.equalTo(self.mas_bottom).with.offset(-72.5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    
    self.classIDLabel = [[UILabel alloc] init];
    self.classIDLabel.text = self.classID;
    self.classIDLabel.textColor = self.deepTextColor;
    self.classIDLabel.font = [UIFont fontWithName:@"Futura"  size:15];
    [self addSubview:self.classIDLabel];
    [self.classIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseNameLabel);
        make.top.equalTo(self.mas_bottom).with.offset(-47.5);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = self.deepTextColor;
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.mas_equalTo(2);
        make.bottom.equalTo(self).with.offset(10);
    }];
    
    self.cycle = [[UIView alloc] init];
    self.cycle.backgroundColor = self.deepTextColor;
    self.cycle.layer.masksToBounds = YES;
    self.cycle.layer.cornerRadius = 4;
    [self addSubview:self.cycle];
    [self.cycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(-3);
        make.top.equalTo(self.line.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = kDeepGray_Color;
    self.timeLabel.text = [self courseTimeString];
    self.timeLabel.font = [UIFont fontWithName:@"Futra" size:18];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseNameLabel);
        make.top.equalTo(self.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
}

- (NSString *)courseTimeString
{
    switch (self.courseTime) {
            case 0:
            return @"08:00";
            case 1:
            return @"10:05";
            case 2:
            return @"14:00";
            case 3:
            return @"16:05";
            case 4:
            return @"19:00";
            case 5:
            return @"21:05";
            
        default:
            return @"00:00";
    }
}
@end
