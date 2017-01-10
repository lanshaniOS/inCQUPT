//
//  ZWKBarChart.m
//  ZWKPieChart
//
//  Created by 周维康 on 16/9/11.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZWKBarChart.h"

@interface ZWKBarChart()

@property (strong, nonatomic) NSArray <UIColor *>*colorArray;  /**< 每条柱形的颜色 */
@property (strong, nonatomic) NSArray *dataArray;  /**< 数据数组 */
@property (assign, nonatomic) CGRect barFrame;  /**< frame */

@end

@implementation ZWKBarChart
{
    
}

- (instancetype)initWithDataArray:(NSArray *)dataArray andBarColorArray:(NSArray<UIColor *> *)colorArray andFrame:(CGRect)frame
{
    if (self = [super init])
    {
        self.colorArray = colorArray;
        self.dataArray = dataArray;
        self.barFrame = frame;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDataArray:nil andBarColorArray:nil andFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)beginPaint
{
    self.frame = self.barFrame;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.barWidth == 0)
    {
        self.barWidth = 40;
    }
    for (NSUInteger i = 0; i < self.colorArray.count; i++)
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(i*(_barWidth+_separateWidth), (1-[self.dataArray[i] floatValue]) * self.barFrame.size.height, _barWidth, [self.dataArray[i] floatValue] * self.barFrame.size.height)];
        CGContextSetFillColorWithColor(context, self.colorArray[i].CGColor);
        CGContextAddPath(context, path.CGPath);
        CGContextFillPath(context);
    }
}
@end
