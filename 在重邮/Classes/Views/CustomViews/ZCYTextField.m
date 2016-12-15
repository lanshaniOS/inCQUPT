//
//  ZCYTextFiled.m
//  在重邮
//
//  Created by 周维康 on 16/12/8.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYTextField.h"

@implementation ZCYTextField


-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

@end
