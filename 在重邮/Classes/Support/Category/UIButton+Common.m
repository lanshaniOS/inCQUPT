//
//  UIButton+Common.m
//  i重邮
//
//  Created by 周维康 on 17/1/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)

- (void)setBackgroundColor:(UIColor *)bgColor andTitle:(NSString *)title WithTitleColor:(UIColor *)titleColor andTarget:(nullable id)target WithClickAction:(SEL)action
{
    [self setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
