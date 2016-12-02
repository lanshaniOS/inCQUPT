//
//  ZCYStudentDetailViewController.h
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYBaseViewController.h"

@interface ZCYStudentDetailViewController : ZCYBaseViewController

/**
 初始化方法
 
 @param studentInfo 学生信息
 @return SELF
 */
- (instancetype)initWithStudentInfo:(NSDictionary *)studentInfo;

@end
