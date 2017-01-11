//
//  UIButton+Common.h
//  i重邮
//
//  Created by 周维康 on 17/1/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Common)

- (void)setBackgroundColor:(nullable UIColor *)bgColor andTitle:(nullable NSString *)title WithTitleColor:(nullable UIColor *)titleColor andTarget:(nullable id)target WithClickAction:(nullable SEL)action;

@end
