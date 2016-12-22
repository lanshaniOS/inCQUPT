//
//  ZCYTimeTableModel.h
//  在重邮
//
//  Created by 周维康 on 16/10/27.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYTimeTableModel : NSObject

@property (strong, nonatomic) NSString *courseName;  /**< 课程名称 */
@property (strong, nonatomic) NSString *classId;  /**< 教室号 */
@property (strong, nonatomic) NSString *courseTime;  /**< 时间 */
@property (strong, nonatomic) NSString *courseWeek;  /**< 上课周数 */
@property (strong, nonatomic) NSString *courseId;  /**< 课程编号 */
@property (strong, nonatomic) NSString *coursePlace;  /**< 上课地点 */
@property (strong, nonatomic) NSString *courseTeacher;  /**< 上课老师 */
@property (strong, nonatomic) NSString *courseType;  /**< 课程种类（选修，必修） */
@property (strong, nonatomic) NSString *courseCredit;  /**< 课程学分 */
@property (strong, nonatomic) NSArray *courseWeeks;  /**< 课周数 */
@property (strong, nonatomic) NSString *courseNumber;  /**< 几节课 */

@end
