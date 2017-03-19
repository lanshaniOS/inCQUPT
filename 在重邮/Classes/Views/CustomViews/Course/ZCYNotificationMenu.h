//
//  ZCYNotificationMenu.h
//  i重邮
//
//  Created by 谭培 on 2017/3/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol itemClickedDelegate<NSObject>

@required

- (void)itemClickedAtIndex:(NSInteger)index;

@end

@interface ZCYNotificationMenu : UIView
-(instancetype)initWithArr:(NSArray *)arr containerView:(UIView *)containerView atView:(UIView *)view;
@property (nonatomic,copy)id <itemClickedDelegate>delegate;

@end
