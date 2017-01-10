//
//  ZWKPieChart.m
//  ZWKPieChart
//
//  Created by 周维康 on 16/9/8.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZWKPieChart.h"

@interface ZWKPieChart()

@property (strong, nonatomic) NSArray *percentArray; /**< 百分比数组 */
@property (strong, nonatomic) NSArray <UIColor *>*colorArray; /**< 每段百分比的颜色 */
@property (assign, nonatomic) CGFloat radius; /**< 半径 */
@property (assign, nonatomic) CGFloat innerRadius;  /**< 内圆半径 */
@property (strong, nonatomic) UIColor *innerColor;  /**< 内圆颜色 */
@property (assign, nonatomic) BOOL showInnerCircle;  /**< 是否显示内圆 */
@property (assign, nonatomic) BOOL showSeperate;  /**< 是否显示分割线 */
@property (assign, nonatomic) CGPoint circlePoint;  /**< 饼图位置 */
@property (strong, nonatomic) UIColor *seperateColor;  /**< 分割线颜色 */
@property (assign, nonatomic) CGFloat seperateDegree;  /**< 分割线弧度 */

@end

@implementation ZWKPieChart

- (instancetype)initWithPercentArray:(NSArray *)percentArray andColorArray:(NSArray<UIColor *> *)colorArray andRadius:(CGFloat)radius andLocationPoint:(CGPoint)point
{
    if (self = [super init])
    {
        self.percentArray = percentArray;
        self.colorArray = colorArray;
        self.radius = radius;
        self.circlePoint = point;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
   return [self initWithPercentArray:nil andColorArray:nil andRadius:0 andLocationPoint:CGPointMake(0, 0)];
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.seperateColor = [UIColor whiteColor];
    self.innerColor = [UIColor whiteColor];
    self.seperateDegree = 1;
    self.innerRadius = 0.f;
    
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
////    return [self initWithPercentArray:nil andColorArray:nil andRadius:0 andLocationPoint:CGPointMake(0, 0)];
//}

- (void)setInnerCircleWithRadius:(CGFloat)innerRadius andColor:(UIColor *)color
{
    self.showInnerCircle = YES;
    self.innerColor = color;
    self.innerRadius = innerRadius;
}

- (void)setSeperateWithColor:(UIColor *)color andDegree:(CGFloat)degree
{
    self.showSeperate = YES;
    self.seperateColor = color;
    self.seperateDegree = degree;
}

- (void)beginPaint
{
    self.frame = CGRectMake(self.circlePoint.x, self.circlePoint.y, self.radius * 2, self.radius * 2);
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat centerX = self.radius;
    CGFloat centerY = centerX;
    
    CGFloat pieStart = -90.f;
    
//    int clockwise;
//    if (self.rotationDirction == 0)
//    {
//        clockwise = 1;
//    } else {
//        clockwise = 0;
//    }
    
    NSInteger totalView;
    if (self.showSeperate)
    {
        totalView = self.percentArray.count * 2 - 1;
    } else {
        totalView = self.percentArray.count;
    }
    
    for (int i = 0; i < totalView; i ++)
    {
        CGFloat end;
        if (self.isShowSeperate)
        {
            if (i % 2 == 0)
            {
                end = pieStart + [self.percentArray[i/2] floatValue] * 360 - self.seperateDegree;
                UIColor *fillColor = self.colorArray[i/2];
                CGContextSetFillColorWithColor(context, [fillColor CGColor]);
                
            } else {
                end = pieStart + self.seperateDegree;
                CGContextSetFillColorWithColor(context, self.seperateColor.CGColor);
            }
        } else {
            end = pieStart + [self.percentArray[i] floatValue] * 360;
            UIColor *fillColor = (UIColor *)self.colorArray[i];
            CGContextSetFillColorWithColor(context, fillColor.CGColor);
        }
        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, self.radius, [self p_radians:pieStart], [self p_radians:end], 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        pieStart = end;
    }
    
    if (self.showInnerCircle)
    {
        CGContextSetFillColorWithColor(context, self.innerColor.CGColor);
        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, self.innerRadius, 0, [self p_radians:360], 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
    
}

//角度转化弧度的私有方法
- (double) p_radians:(double)degress
{
    return degress * M_PI / 180.f;
}


@end

