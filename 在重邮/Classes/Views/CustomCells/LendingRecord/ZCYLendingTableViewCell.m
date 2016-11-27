//
//  ZCYLendingTableViewCell.m
//  在重邮
//
//  Created by 周维康 on 16/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLendingTableViewCell.h"
#import "ZWKPieChart.h"

@interface ZCYLendingTableViewCell()

@property (strong, nonatomic) NSString *bookName;  /**< 书名 */
@property (strong, nonatomic) NSString *lendTimeString;  /**< 借书日期 */
@property (strong, nonatomic) NSString *backTimeString;  /**< 还书日期 */

@end
@implementation ZCYLendingTableViewCell
{
    CGFloat _viewWidth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBookName:(NSString *)bookName andLendTime:(NSString *)lendTime andBackTime:(NSString *)backTime andWidth:(CGFloat)width

{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.bookName = bookName;
        self.lendTimeString = lendTime;
        self.backTimeString = backTime;
        _viewWidth = width;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:kFont(kStandardPx(40)) andText:self.bookName andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(21);
        make.width.mas_equalTo(self.frame.size.width - 60);
    }];
    
    UIImageView *lendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lending"]];
    [self addSubview:lendImageView];
    [lendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(9);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    UILabel *lendingLabel = [[UILabel alloc] init];
    [lendingLabel setFont:kFont(kStandardPx(26)) andText:self.lendTimeString andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:lendingLabel];
    [lendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendImageView.mas_right).with.offset(5);
        make.centerY.equalTo(lendImageView);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_backing"]];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendImageView);
        make.top.equalTo(lendImageView.mas_bottom).with.offset(5);
        make.size.equalTo(lendImageView);
    }];
    
    UILabel *backingLabel = [[UILabel alloc] init];
    [backingLabel setFont:kFont(kStandardPx(26)) andText:self.backTimeString andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:backingLabel];
    [backingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendingLabel);
        make.centerY.equalTo(backImageView);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *lendDate = [formatter dateFromString:_lendTimeString];
    NSDate *backDate = [formatter dateFromString:_backTimeString];
    NSTimeInterval lendingTime = [lendDate timeIntervalSince1970];
    NSTimeInterval backingTime = [backDate timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString *dayTimeString = [[NSString alloc] init];
    UILabel *dayLabel = [[UILabel alloc] init];
    if ((nowTime - lendingTime)/(backingTime - lendingTime)>=1.0f)
    {
        dayTimeString = @"已超期";
        [dayLabel setFont:kFont(kStandardPx(26)) andText:dayTimeString andTextColor:[UIColor colorWithRGBHex:0xfc3545] andBackgroundColor:kTransparentColor];
        ZWKPieChart *pieChart = [[ZWKPieChart alloc] initWithPercentArray:@[@(1)]  andColorArray:@[[UIColor colorWithRGBHex:0xfc3545]] andRadius:32 andLocationPoint:CGPointMake(_viewWidth - 79,self.frame.size.height/2)];
        [pieChart setInnerCircleWithRadius:28 andColor:kCommonWhite_Color];
        [pieChart beginPaint];
        [self addSubview:pieChart];
    } else {
        dayTimeString = [NSString stringWithFormat:@"%2d天", (int)(backingTime - nowTime)/24/3600];
        [dayLabel setFont:kFont(kStandardPx(26)) andText:dayTimeString andTextColor:[UIColor colorWithRGBHex:0x32d2b1] andBackgroundColor:kTransparentColor];
        NSMutableAttributedString *attritubeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dayTimeString]];
        [attritubeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x32d2b1] range:NSMakeRange(0, 2)];
        [attritubeString addAttribute:NSFontAttributeName value:kFont(kStandardPx(48)) range:NSMakeRange(0, 2)];
        [attritubeString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(2, 1)];
        [attritubeString addAttribute:NSFontAttributeName value:kFont(kStandardPx(24)) range:NSMakeRange(2, 1)];
        dayLabel.attributedText = attritubeString;
        
        ZWKPieChart *pieChart = [[ZWKPieChart alloc] initWithPercentArray:@[@((nowTime - lendingTime)/(backingTime - lendingTime)), @(1-(nowTime - lendingTime)/(backingTime - lendingTime))]  andColorArray:@[[UIColor colorWithRGBHex:0x32d2b1], kCommonGray_Color] andRadius:32 andLocationPoint:CGPointMake(_viewWidth - 79,self.frame.size.height/2)];
        [pieChart setInnerCircleWithRadius:28 andColor:kCommonWhite_Color];
        [pieChart beginPaint];
        [self addSubview:pieChart];
    }
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(_viewWidth - 79);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(64);
    }];
   
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kDeepGray_Color;
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCellWithBookName:(NSString *)bookName andLendTime:(NSString *)lendTime andBackTime:(NSString *)backTime
{
    self.bookName = bookName;
    self.lendTimeString = lendTime;
    self.backTimeString = backTime;
}
@end
