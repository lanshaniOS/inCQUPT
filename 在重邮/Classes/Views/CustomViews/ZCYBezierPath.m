//
//  ZCYBezierPath.m
//  在重邮
//
//  Created by 周维康 on 16/12/2.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYBezierPath.h"

@interface ZCYBezierPath()

@property (strong, nonatomic) NSArray <NSValue *>*pointArray;  /**< 点数组 */

@end

@implementation ZCYBezierPath
{
    CGPoint _onePoint;
    CGPoint _twoPoint;
    CGPoint _threePoint;
    CGPoint _fourPoint;
    CGPoint _fivePoint;
    CGPoint _sixPoint;
    CGPoint _sevenPoint;
    CGPoint _eightPoint;
    CGPoint _nightPoint;
    CGPoint _tenPoint;
    CGFloat _screenWidth;
    CGFloat _screenHeight;
}

- (instancetype)initWithPointArray:(NSArray <NSValue *> *)array
{
    if ([super init])
    {
        self.pointArray = array;
        _onePoint = [array[0] CGPointValue];
        _twoPoint = [array[1] CGPointValue];
        _threePoint = [array[2] CGPointValue];
        _fourPoint = [array[3] CGPointValue];
        _fivePoint = [array[4] CGPointValue];
        _sixPoint = [array[5] CGPointValue];
        _sevenPoint = [array[6] CGPointValue];
        _eightPoint = [array[7] CGPointValue];
        _nightPoint = [array[8] CGPointValue];
        _tenPoint = [array[9] CGPointValue];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [self drawThirdBezierPathWithWidth:_screenWidth andHeight:_screenHeight];
}

- (CAShapeLayer *)drawThirdBezierPathWithWidth:(CGFloat)screenWidth andHeight:(CGFloat)screenHeight
{
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:_onePoint];
    NSArray *oneLineArray = [self getControlPointWithFirstPoint:_onePoint andSecondPoint:_twoPoint];
    NSArray *twoLineArray = [self getControlPointWithFirstPoint:_twoPoint andSecondPoint:_threePoint];
    NSArray *threeLineArray = [self getControlPointWithFirstPoint:_threePoint andSecondPoint:_fourPoint];
    NSArray *fourLineArray = [self getControlPointWithFirstPoint:_fourPoint andSecondPoint:_fivePoint];
    NSArray *fiveLineArray = [self getControlPointWithFirstPoint:_fivePoint andSecondPoint:_sixPoint];
    NSArray *sixLineArray = [self getControlPointWithFirstPoint:_sixPoint andSecondPoint:_sevenPoint];
    NSArray *sevenLineArray = [self getControlPointWithFirstPoint:_sevenPoint andSecondPoint:_eightPoint];
    NSArray *eightLineArray = [self getControlPointWithFirstPoint:_eightPoint andSecondPoint:_nightPoint];
    NSArray *nightLineArray = [self getControlPointWithFirstPoint:_nightPoint andSecondPoint:_tenPoint];
    
    NSArray *lineArray = @[@"", oneLineArray, twoLineArray, threeLineArray, fourLineArray, fiveLineArray, sixLineArray, sevenLineArray, eightLineArray, nightLineArray];
    
    [path moveToPoint:CGPointMake(0, _screenHeight-128-64)];
    [path addLineToPoint:_onePoint];
    for (NSInteger index = 1; index < 10; index++)
    {
        [path addCurveToPoint:[self.pointArray[index] CGPointValue] controlPoint1:[lineArray[index][0] CGPointValue] controlPoint2:[lineArray[index][1] CGPointValue]];
    }
    [path addLineToPoint:_tenPoint];
    [path addLineToPoint:CGPointMake(_screenWidth*2, _screenHeight - 128 - 64)];
    
    for (NSInteger index = 0; index<10; index++)
    {
        UIView *pointView = [[UIView alloc] init];
        pointView.frame = CGRectMake((index)*screenWidth/4.5 - 3.5, [self.pointArray[index] CGPointValue].y - 4, 8, 8);
        pointView.layer.masksToBounds = YES;
        pointView.backgroundColor = kDeepGreen_Color;
        pointView.layer.cornerRadius = 4;
        [self addSubview:pointView];

    }
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 2.0;
    
    UIColor *strokeColor = kDeepGreen_Color;
    [strokeColor set];
//    [path closePath];
    [path stroke];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    return layer;
}

- (NSArray *)getControlPointWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGPoint onePoint = CGPointMake((firstPoint.x+secondPoint.x)/2, firstPoint.y - (secondPoint.y - firstPoint.y)/8);
    CGPoint twoPoint = CGPointMake((firstPoint.x+secondPoint.x)/2, secondPoint.y + (secondPoint.y - firstPoint.y)/8);
    return @[[NSValue valueWithCGPoint:onePoint], [NSValue valueWithCGPoint:twoPoint]];
}
@end
