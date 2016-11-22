//
//  UIView+Radius.m
//  在重邮
//
//  Created by 周维康 on 16/11/13.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "UIView+Radius.h"

@implementation UIView (Radius)

- (void)setRadius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
   
}


@end
