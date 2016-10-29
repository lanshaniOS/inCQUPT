//
//  ZCYCourseView.h
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCYCourseView : UIView

@property (strong, nonatomic) UILabel *timeLabel;  /**< 时间标签 */

- (instancetype)initWithCourseName:(NSString *)courseName andClassID:(NSString *)classID;

- (void)setTextColor:(UIColor *)textColor andBackgroundColor:(UIColor *)bgColor;
@end
