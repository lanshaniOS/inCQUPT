//
//  ZCYExaminationViewController.h
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYBaseViewController.h"

typedef NS_ENUM(NSUInteger, ZCYLastControllerType) {
    Controller_HomePage = 0, //default
    Controller_StudentSearch = 1
};

@interface ZCYExaminationViewController : ZCYBaseViewController

- (instancetype)initWithLastControllerType:(ZCYLastControllerType)lastTyoe andStudentNumber:(NSString *)studentNumber;

@end
