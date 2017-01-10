//
//  ZWKBarChart.h
//  ZWKPieChart
//
//  Created by 周维康 on 16/9/11.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWKBarChart : UIView

@property (assign, nonatomic) CGFloat separateWidth;  /**< 分割线宽度（两条柱状之间的距离） */
@property (assign, nonatomic) CGFloat barWidth;  /**< 柱形的宽度 */
/**
 *  初始化方法
 *
 *  @param dataArray  数据的百分比数组
 *  @param colorArray 与data顺序对应，每个柱状的颜色
 *
 *  @return self
 */
- (instancetype)initWithDataArray:(NSArray *)dataArray andBarColorArray:(NSArray <UIColor *>*)colorArray andFrame:(CGRect)frame;

/**
 *  开始绘制柱状图
 */
- (void)beginPaint;
@end
