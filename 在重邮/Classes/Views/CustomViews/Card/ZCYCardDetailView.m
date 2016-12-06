//
//  ZCYCardDetailView.m
//  在重邮
//
//  Created by 周维康 on 16/12/6.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCardDetailView.h"

@interface ZCYCardDetailView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *cardArray;  /**< 一卡通详情数组 */
@property (strong, nonatomic) UITableView *tableView;  /**< 消费详情 */
@property (strong, nonatomic) UIButton *reportErrorButton;  /**< 报告错误 */

@end
@implementation ZCYCardDetailView

- (instancetype)initWithCardArray:(NSArray *)cardArray
{
    if (self = [super init])
    {
        self.cardArray = cardArray;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = kCommonLightGray_Color;
    self.alpha = 0.95f;

    UILabel *concreteLabel = [[UILabel alloc] init];
    [concreteLabel setFont:kFont(kStandardPx(24)) andText:@"具体收支" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:concreteLabel];
    [concreteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(6);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(concreteLabel);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(concreteLabel.mas_bottom).with.offset(6);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = kCommonLightGray_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayLine.mas_bottom);
        make.height.mas_equalTo(300);
        make.left.and.right.equalTo(grayLine);
    }];
    
    self.reportErrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reportErrorButton setTitle:@"报告错误" forState:UIControlStateNormal];
    self.reportErrorButton.titleLabel.font = kFont(kStandardPx(32));
    [self.reportErrorButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [self addSubview:self.reportErrorButton];
    [self.reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
        make.top.equalTo(self.tableView.mas_bottom).with.offset(12);
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYCardDetailTableViewCell"];
    cell.backgroundColor = kCommonLightGray_Color;
    UIImageView *numImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x32d2b1]]];
    numImageView.layer.masksToBounds = YES;
    numImageView.layer.cornerRadius = 15.0f;
    [cell addSubview:numImageView];
    [numImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [numLabel setFont:kFont(kStandardPx(32)) andText:[NSString stringWithFormat:@"%@", @(indexPath.row+1)] andTextColor:kCommonWhite_Color andBackgroundColor:kTransparentColor];
    [cell addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.equalTo(numImageView);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    NSString *timeString = [self.cardArray[indexPath.row][@"time"] substringWithRange:NSMakeRange(5, 12)];
    [timeLabel setFont:kFont(kStandardPx(36)) andText:timeString andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [cell addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numImageView.mas_right).with.offset(20);
        make.top.equalTo(cell).with.offset(30);
    }];
    
    UILabel *placeLabel = [[UILabel alloc] init];
    [placeLabel setFont:kFont(kStandardPx(32)) andText:self.cardArray[indexPath.row][@"address"] andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).with.offset(3);
        make.left.equalTo(timeLabel);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [moneyLabel setFont:kFont(kStandardPx(50)) andText:@"" andTextColor:kDeepGreen_Color andBackgroundColor:kTransparentColor];
    NSString *balcanc = [NSString stringWithFormat:@"%@元",self.cardArray[indexPath.row][@"balance"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:balcanc];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepGray_Color range:NSMakeRange(balcanc.length-1, 1)];
    [attributedString addAttribute:NSFontAttributeName value:kFont(kStandardPx(24)) range:NSMakeRange(balcanc.length - 1, 1)];
    moneyLabel.attributedText = attributedString;
    [cell addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel setFont:kFont(kStandardPx(26)) andText:self.cardArray[indexPath.row][@"transaction"] andTextColor:kCommonWhite_Color andBackgroundColor:kDeepGreen_Color];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.cornerRadius = 4.0f;
    typeLabel.layer.masksToBounds = YES;
    [cell addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moneyLabel.mas_left).with.offset(-15);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(34, 17));
    }];

    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
    [cell addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell);
        make.left.and.right.equalTo(cell);
        make.height.mas_equalTo(1);
    }];
    return cell;
}

- (void)updateCardDetailViewWithCardArray:(NSArray *)cardArray
{
    self.cardArray = cardArray;
    [self.tableView reloadData];
}
@end
