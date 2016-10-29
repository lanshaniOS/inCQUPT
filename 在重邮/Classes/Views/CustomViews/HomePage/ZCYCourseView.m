//
//  ZCYCourseView.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCourseView.h"

@interface ZCYCourseView()

@property (strong, nonatomic) NSString *courseName;  /**< 课程名称 */
@property (strong, nonatomic) NSString *classID;
@property (strong, nonatomic) UIColor *deepTextColor;  /**< 文字颜色 */
@property (strong, nonatomic) UILabel *courseNameLabel;  /**< 课程名称标题 */
@property (strong, nonatomic) UILabel *classIDLabel;  /**< 教室编号 */
@property (strong, nonatomic) UIView *line;  /**< 竖线 */
@property (strong, nonatomic) UIView *cycle;  /**< 小圆圈 */


@end
@implementation ZCYCourseView


- (instancetype)initWithCourseName:(NSString *)courseName andClassID:(NSString *)classID
{
    if (self = [super init])
    {
        self.courseName = courseName;
        self.classID = classID;
        self.backgroundColor = kCommonGray_Color;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCourseName:nil andClassID:nil];
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
    self.courseNameLabel.frame = CGRectMake(12, 105, 90, 25);
    [self addSubview:self.courseNameLabel];
    
    self.classIDLabel = [[UILabel alloc] init];
    self.classIDLabel.text = self.classID;
    self.classIDLabel.textColor = self.deepTextColor;
    self.classIDLabel.font = [UIFont fontWithName:@"Futura"  size:15];
    self.classIDLabel.frame = CGRectMake(12, 130, 90, 25);
    [self addSubview:self.classIDLabel];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = self.deepTextColor;
    self.line.frame = CGRectMake(0, 0, 2, 176.5);
    [self addSubview:self.line];
    
    self.cycle = [[UIView alloc] init];
    self.cycle.backgroundColor = self.deepTextColor;
    self.cycle.frame = CGRectMake(-3, 176.5, 8, 8);
    self.cycle.layer.masksToBounds = YES;
    self.cycle.layer.cornerRadius = 4;
    [self addSubview:self.cycle];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = kDeepGray_Color;
    self.timeLabel.text = @"08:00";
    self.timeLabel.font = [UIFont fontWithName:@"Futra" size:18];
    self.timeLabel.frame = CGRectMake(10, 171.5, 50, 20);
    [self addSubview:self.timeLabel];
}
@end
