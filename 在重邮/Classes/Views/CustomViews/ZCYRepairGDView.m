


//
//  ZCYRepairGDView.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/12/7.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairGDView.h"
#define kGDheightSpace 10
@interface ZCYRepairGDView ()

@property (nonatomic,strong)UILabel *GDfwxmLabel;
@property (nonatomic,strong)UILabel *GDfwqyLabel;
@property (nonatomic,strong)UILabel *GDbxdzLabel;
@property (nonatomic,strong)UILabel *GDlxdhLabel;
@property (nonatomic,strong)UILabel *GDsbrLabel;
@property (nonatomic,strong)UILabel *GDsbnrLabel;
@property (nonatomic,strong)UILabel *GDfwlxLabel;

@end


@implementation ZCYRepairGDView

-(void)setGDsbr:(NSString *)GDsbr{
    _GDsbr = GDsbr;
    _GDsbrLabel.text = GDsbr;
}

-(void)setGDbxdz:(NSString *)GDbxdz{
    _GDbxdz = GDbxdz;
    _GDbxdzLabel.text = GDbxdz;
}

-(void)setGDfwlx:(NSString *)GDfwlx{
    _GDfwlx = GDfwlx;
    _GDfwlxLabel.text = GDfwlx;
}

-(void)setGDfwqy:(NSString *)GDfwqy{
    _GDfwqy = GDfwqy;
    _GDfwqyLabel.text = GDfwqy;
}

-(void)setGDfwxm:(NSString *)GDfwxm{
    _GDfwxm = GDfwxm;
    _GDfwxmLabel.text = GDfwxm;
}

-(void)setGDlxdh:(NSString *)GDlxdh{
    _GDlxdh = GDlxdh;
    _GDlxdhLabel.text = GDlxdh;
}

-(void)setGDsbnr:(NSString *)GDsbnr{
    _GDsbnr = GDsbnr;
    _GDsbnrLabel.text = GDsbnr;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *xmLabel = [[UILabel alloc]init];
        xmLabel.text = @"服务项目";
        xmLabel.textColor = kText_Color_Gray;
        xmLabel.font = kFont(15);
        [self addSubview:xmLabel];
        [xmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
        }];
        
        _GDfwxmLabel = [[UILabel alloc]init];
        _GDfwxmLabel.textColor = kText_Color_Gray;
        _GDfwxmLabel.font = kFont(15);
        [self addSubview:_GDfwxmLabel];
        [_GDfwxmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(xmLabel);
        }];
        
        UILabel *qyLabel = [[UILabel alloc]init];
        qyLabel.textColor = kText_Color_Gray;
        qyLabel.text = @"服务区域";
        qyLabel.font = kFont(15);
        [self addSubview:qyLabel];
        [qyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(xmLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDfwqyLabel = [[UILabel alloc]init];
        _GDfwqyLabel.textColor = kText_Color_Gray;
        _GDfwqyLabel.font = kFont(15);
        [self addSubview:_GDfwqyLabel];
        [_GDfwqyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(qyLabel);
        }];
        
        UILabel *bxdzLabel = [[UILabel alloc]init];
        bxdzLabel.textColor = kText_Color_Gray;
        bxdzLabel.text = @"报修地址";
        bxdzLabel.font = kFont(15);
        [self addSubview:bxdzLabel];
        [bxdzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qyLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDbxdzLabel = [[UILabel alloc]init];
        _GDbxdzLabel.textColor = kText_Color_Gray;
        _GDbxdzLabel.font = kFont(15);
        [self addSubview:_GDbxdzLabel];
        [_GDbxdzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(bxdzLabel);
        }];
        
        UILabel *dhLabel = [[UILabel alloc]init];
        dhLabel.textColor = kText_Color_Gray;
        dhLabel.text = @"联系电话";
        dhLabel.font = kFont(15);
        [self addSubview:dhLabel];
        [dhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bxdzLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDlxdhLabel = [[UILabel alloc]init];
        _GDlxdhLabel.font = kFont(15);
        _GDlxdhLabel.textColor = kText_Color_Gray;
        [self addSubview:_GDlxdhLabel];
        [_GDlxdhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(dhLabel);
        }];
        
        UILabel *fwlxLabel = [[UILabel alloc]init];
        fwlxLabel.textColor = kText_Color_Gray;
        fwlxLabel.text = @"服务类型";
        fwlxLabel.font = kFont(15);
        [self addSubview:fwlxLabel];
        [fwlxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dhLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDfwlxLabel = [[UILabel alloc]init];
        _GDfwlxLabel.textColor = kText_Color_Gray;
        _GDfwlxLabel.font = kFont(15);
        [self addSubview:_GDfwlxLabel];
        [_GDfwlxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(fwlxLabel);
        }];
        
        UILabel *sbrLabel = [[UILabel alloc]init];
        sbrLabel.textColor = kText_Color_Gray;
        sbrLabel.text = @"申报人";
        sbrLabel.font = kFont(15);
        [self addSubview:sbrLabel];
        [sbrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fwlxLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDsbrLabel = [[UILabel alloc]init];
        _GDsbrLabel.textColor = kText_Color_Gray;
        _GDsbrLabel.font = kFont(15);
        [self addSubview:_GDsbrLabel];
        [_GDsbrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(sbrLabel);
        }];
        
        UILabel *sbnrLabel = [[UILabel alloc]init];
        sbnrLabel.text = @"申报内容";
        sbnrLabel.textColor = kText_Color_Gray;
        sbnrLabel.font = kFont(15);
        [self addSubview:sbnrLabel];
        [sbnrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sbrLabel.mas_bottom).offset(kGDheightSpace);
            make.left.mas_equalTo(10);
        }];
        
        _GDsbnrLabel = [[UILabel alloc]init];
        _GDsbnrLabel.textColor = kText_Color_Gray;
        _GDsbnrLabel.font = kFont(15);
        [self addSubview:_GDsbnrLabel];
        [_GDsbnrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(sbnrLabel);
        }];
    }
    return self;
}

@end
