//
//  ZWKPieChart.h
//  ZWKPieChart
//
//  Created by 周维康 on 16/9/8.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWKPieChart : UIView

@property (nonatomic, readonly, getter=isShowSeperate) BOOL showSeperate; /**< 是否显示分割线 */
@property (nonatomic, readonly, getter=isShowInnerCircle) BOOL showInnerCircle; /**< 是否显示内圆 */

/**
 *  初始化方法
 *
 *  @param percentArray 每个数据占用的百分比
 *  @param colorArray   跟percent排序相同，设置颜色。例如:black、green
 *  @param radius       饼图半径
 *
 *  @return self
 */
- (instancetype)initWithPercentArray:(NSArray *)percentArray andColorArray:(NSArray <UIColor *>*)colorArray andRadius:(CGFloat)radius andLocationPoint:(CGPoint)point;

/**
 *  设置内圆(不调用就不现实内圈圆)
 *
 *  @param innerRadius 内圆半径
 *  @param color       内圆颜色
 */
- (void)setInnerCircleWithRadius:(CGFloat)innerRadius andColor:(UIColor *)color;

/**
 *  设置分割线
 *
 *  @param color   分割线颜色
 *  @param degree 角度
 */
- (void)setSeperateWithColor:(UIColor *)color andDegree:(CGFloat)degree;
/**
 *  开始绘制饼图
 */
- (void)beginPaint;
@end
