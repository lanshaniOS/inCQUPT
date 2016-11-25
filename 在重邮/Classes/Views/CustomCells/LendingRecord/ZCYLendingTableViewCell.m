//
//  ZCYLendingTableViewCell.m
//  在重邮
//
//  Created by 周维康 on 16/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLendingTableViewCell.h"

@interface ZCYLendingTableViewCell()

@property (strong, nonatomic) NSString *bookName;  /**< 书名 */
@property (strong, nonatomic) NSString *lendTimeString;  /**< 借书日期 */
@property (strong, nonatomic) NSString *backTimeString;  /**< 还书日期 */

@end
@implementation ZCYLendingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
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
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kCommonGray_Color;
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
