//
//  BXDetailCellView.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/19.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairDetailCellView.h"
#import "Masonry.h"
#import "ZCYStyleDefine.h"
#define kheightSpace 7

@interface ZCYRepairDetailCellView ()

@property (nonatomic,strong) UILabel *BXtitleLabel;
@property (nonatomic,strong) UILabel *BXCLRLabel;
@property (nonatomic,strong) UILabel *BXtimeLabel;
@property (nonatomic,strong) UILabel *BXBZLabel;

@end

@implementation ZCYRepairDetailCellView

-(void)setBXBZ:(NSString *)BXBZ{
    _BXBZ = BXBZ;
    _BXBZLabel.text = BXBZ;
}

-(void)setBXCLR:(NSString *)BXCLR{
    _BXCLR = BXCLR;
    _BXCLRLabel.text = BXCLR;
}

-(void)setBXtime:(NSString *)BXtime{
    _BXtime = BXtime;
    _BXtimeLabel.text = BXtime;
}

-(void)setBXtitle:(NSString *)BXtitle{
    _BXtitle = BXtitle;
    _BXtitleLabel.text = BXtitle;
}


-(instancetype)init
{
    if (self = [super init]) {
        _BXtitleLabel = [[UILabel alloc]init];
        _BXtitleLabel.textColor = [UIColor blackColor];
        _BXtitleLabel.font = kFont(17);
        [_BXtitleLabel sizeToFit];
        
        [self addSubview:_BXtitleLabel];
        [_BXtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(5);
            make.top.equalTo(self).with.offset(kheightSpace);
            make.height.mas_lessThanOrEqualTo(20);
        }];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"处理人";
        label1.textColor = kText_Color_Gray;
        label1.font = kFont(15);
        [label1 sizeToFit];
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_BXtitleLabel.mas_bottom).offset(kheightSpace);
            make.left.equalTo(self).offset(5);
            make.height.mas_lessThanOrEqualTo(20);
            
        }];
        _BXCLRLabel = [[UILabel alloc]init];
        _BXCLRLabel.textColor = kText_Color_Gray;
        _BXCLRLabel.font = kFont(15);
        [_BXCLRLabel sizeToFit];
        [self addSubview:_BXCLRLabel];
        [_BXCLRLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(label1);
            make.height.mas_lessThanOrEqualTo(20);

        }];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.textColor = kText_Color_Gray;
        label2.text = @"时间";
        label2.font = kFont(15);
        [label2 sizeToFit];
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(kheightSpace);
            make.left.equalTo(self).with.offset(5);
            make.height.mas_lessThanOrEqualTo(20);
            
        }];
        _BXtimeLabel = [[UILabel alloc]init];
        _BXtimeLabel.textColor = kText_Color_Gray;
        _BXtimeLabel.font = kFont(15);
        [self addSubview:_BXtimeLabel];
        [_BXtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(label2);
            make.height.mas_lessThanOrEqualTo(20);

        }];
        
        UILabel *label3 = [[UILabel alloc]init];
        label3.text = @"备注";
        label3.textColor = kText_Color_Gray;
        label3.font = kFont(15);
        [label3 sizeToFit];
        [self addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset(kheightSpace);
            make.left.equalTo(self).offset(5);
            make.height.mas_lessThanOrEqualTo(20);
            
        }];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kGray_Line_Color;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        _BXBZLabel = [[UILabel alloc]init];
        _BXBZLabel.textColor = kText_Color_Gray;
        _BXBZLabel.font = kFont(15);
        _BXBZLabel.numberOfLines = 2;
        _BXBZLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_BXBZLabel];
        [_BXBZLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(_BXtimeLabel.mas_bottom).offset(kheightSpace);
            make.left.equalTo(self.mas_left).offset(80);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        
    }
    return self;
}


@end
