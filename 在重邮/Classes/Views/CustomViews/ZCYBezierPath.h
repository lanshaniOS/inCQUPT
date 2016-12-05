//
//  ZCYBezierPath.h
//  在重邮
//
//  Created by 周维康 on 16/12/2.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCYBezierPath : UIView

- (CAShapeLayer *)drawThirdBezierPathWithWidth:(CGFloat)screenWidth andHeight:(CGFloat)screenHeight;

- (instancetype)initWithPointArray:(NSArray <NSValue *> *)array;
@end
