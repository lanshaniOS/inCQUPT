//
//  UILabel+Common.m
//  在重邮
//
//  Created by 周维康 on 16/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)

- (void)setFont:(UIFont *)font andText:(NSString *)text andTextColor:(UIColor *)textColor andBackgroundColor:(UIColor *)bgColor
{
    self.font = font;
    self.text = text;
    self.textColor = textColor;
    self.backgroundColor = bgColor;
}
@end
