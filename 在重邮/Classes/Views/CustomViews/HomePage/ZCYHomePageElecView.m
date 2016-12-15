//
//  ZCYHomePageElecView.m
//  在重邮
//
//  Created by 周维康 on 16/12/12.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHomePageElecView.h"

@interface ZCYHomePageElecView()

@property (strong, nonatomic) UILabel *elecLabel;  /**< 电费 */
@property (copy, nonatomic) NSString *elecString;  /**< 电费 */
@property (strong, nonatomic) UIButton *bindButton;  /**< 绑定寝室 */
@property (strong, nonatomic) UILabel *bindLabel;  /**< 绑定寝室 */

@end
@implementation ZCYHomePageElecView

- (instancetype)initWithElecString:(NSString *)elecString
{
    if (self = [super init])
    {
        self.elecString = elecString;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = kCommonWhite_Color;
    
    UILabel *topLabel = [[UILabel alloc] init];
    [topLabel setFont:[UIFont systemFontOfSize:20 weight:2] andText:@"水电费" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(14);
        make.left.equalTo(self).with.offset(20);
    }];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [detailButton setTitle:@"水电详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    detailButton.layer.masksToBounds = YES;
    detailButton.titleLabel.font = kFont(16);
    [detailButton addTarget:self action:@selector(detailButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).with.offset(-90);
        make.bottom.equalTo(topLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
    self.elecLabel = [[UILabel alloc] init];
    [self.elecLabel setFont:kFont(kStandardPx(150)) andText:self.elecString andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    
    [self addSubview:self.elecLabel];
    [self.elecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    if ([self.elecString isEqualToString:@"00"])
    {
        self.elecLabel.hidden = YES;
        self.bindLabel = [[UILabel alloc] init];
        [self.bindLabel setFont:kFont(kStandardPx(40)) andText:@"你还没有绑定寝室哦～" andTextColor:kDeepGray_Color andBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.bindLabel];
        [self.bindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
        self.bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bindButton setTitle:@"去绑定" forState:UIControlStateNormal];
        [self.bindButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
        [self.bindButton addTarget:self action:@selector(detailButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        self.bindButton.titleLabel.font = kFont(kStandardPx(40));
        [self addSubview:self.bindButton];
        [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bindLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(40);
        }];
        
    } else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.elecString];
        [attributeString addAttribute:NSFontAttributeName value:kFont(kStandardPx(36)) range:NSMakeRange(0, self.elecString.length)];
        
        self.elecLabel.attributedText = attributeString;
        self.elecLabel.hidden = NO;
        
    }
    UILabel *tipLabel = [[UILabel alloc] init];
    [tipLabel setFont:kFont(kStandardPx(26)) andText:@"当月电费" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor colorWithRGBHex:0xd8d8d8];
    
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];


}

- (void)updateViewWithElecString:(NSString *)elecString
{
    if ([self.elecString isEqualToString:@"00"])
    {
        self.elecLabel.hidden = YES;
        self.bindButton.hidden = NO;
        self.bindLabel.hidden = NO;
    } else {
        self.elecLabel.hidden = NO;
        self.bindButton.hidden = YES;
        self.bindLabel.hidden = YES;
    }
    self.elecString = elecString;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.elecString];
    [attributeString addAttribute:NSFontAttributeName value:kFont(kStandardPx(36)) range:NSMakeRange(self.elecString.length-1, 1)];
    
    self.elecLabel.attributedText = attributeString;
}
- (void)detailButtonDidClicked
{
    if (self.clickedBlock)
    {
        self.clickedBlock();
    }
}


@end
