//
//  RepairShowView.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairShowView.h"

@interface ZCYRepairShowView ()
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation ZCYRepairShowView

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    _title = title;
}

-(instancetype)init
{
    if (self = [super init]) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = kCommonWhite_Color;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(0);
        }];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_titleLabel.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        _contentTable = [[UITableView alloc]init];
        _contentTable.showsVerticalScrollIndicator = NO;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_contentTable];
        [_contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(lineView.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}


@end
