//
//  ZCYDetailCourseView.h
//  在重邮
//
//  Created by 周维康 on 16/11/18.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCYDetailCourseCloseButtonTouchedDelegate<NSObject>

@required

- (void)closeButtonDidPressed;

@end

@interface ZCYDetailCourseView : UIView

@property (weak, nonatomic) id <ZCYDetailCourseCloseButtonTouchedDelegate>delegate;

- (void)updateUIWithCourseArray:(NSArray *)courseArray andCourseTime:(NSInteger)courseTime andWeekNum:(NSUInteger)weekNum;

@end
