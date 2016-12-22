//
//  BaoXiuCollectionViewCell.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/13.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairCell.h"
#import "Masonry.h"
#import "ZCYStyleDefine.h"

#define BXSideSpace 5
#define BXWidth self.frame.size.width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define BXHeight self.frame.size.height
#define BXContentHeightSpace 10
#define BXHeadViewHeight 50
#define BXDetailButtonHeight 40

@interface ZCYRepairCell()

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *contentsView;

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *IDLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *wxlxLabel;
@property (nonatomic,strong) UILabel *bxxmLabel;
@property (nonatomic,strong) UILabel *bxTimeLabel;
@property (nonatomic,strong) UIView *firstLine;
@property (nonatomic,strong) UIView *secondLine;

@end

@implementation ZCYRepairCell

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addView];
        [self addline];
        [self initHeadView];
        [self initFirstLine];
        [self initDetailButton];
        [self initContentsView];
        
    }
    return self;
}


-(void)setBXID:(NSString *)BXID
{
    _BXID = BXID;
    _IDLabel.text = BXID;
}

-(void)setBXfwlx:(NSString *)BXfwlx
{
    _BXfwlx = BXfwlx;
    _wxlxLabel.text = BXfwlx;
    
}

-(void)setBXfwsj:(NSString *)BXfwsj
{
    _BXfwsj = BXfwsj;
    _bxTimeLabel.text = BXfwsj;
    
}

-(void)setBXfwxm:(NSString *)BXfwxm
{
    _BXfwxm = BXfwxm;
    _bxxmLabel.text = BXfwxm;
}

-(void)setBXStates:(NSString *)BXStates
{
    _BXStates = BXStates;
    _statusLabel.text = BXStates;
    if ([BXStates isEqualToString:@"待审核"]) {
        _statusLabel.textColor = kDeepPink_Color;
        _image.image = [UIImage imageNamed:@"50"];
    }else if ([BXStates isEqualToString:@"已受理"]){
        _statusLabel.textColor = kCommonGolden_Color;
        _image.image = [UIImage imageNamed:@"49"];
    }else if ([BXStates isEqualToString:@"已派出"]){
        _statusLabel.textColor = kDeepGreen_Color;
        _image.image = [UIImage imageNamed:@"52"];
    }else{
        _statusLabel.textColor = kDeepGray_Color;
        _image.image = [UIImage imageNamed:@"51"];
    }
}

-(void)addView
{
    UIView *lucidView = [[UIView alloc]init];
    lucidView.backgroundColor = kCommonGray_Color;
    [self.contentView addSubview:lucidView];
    [lucidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}

-(void)addline
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kCommonGray_Color;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
-(void)initHeadView
{
    _headView = [[UIView alloc]init];
    [self.contentView addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    //图片
    _image = [[UIImageView alloc]init];
    [_headView addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(10);
        make.centerY.equalTo(_headView);
    }];
    
    //ID
    _IDLabel = [[UILabel alloc]init];
    _IDLabel.font = [UIFont systemFontOfSize:11];
    _IDLabel.textColor = kText_Color_Gray;
    [_headView addSubview:_IDLabel];
    [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_image.mas_right).offset(10);
        make.centerY.equalTo(_headView);
    }];
    
    //状态
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [_headView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headView);
        make.right.mas_equalTo(-10);
    }];
}

-(void)initFirstLine
{
    _firstLine = [[UIView alloc]initWithFrame:CGRectMake(12, 70, kScreenWidth, 1)];
    _firstLine.backgroundColor = kCommonGray_Color;
    [self.contentView addSubview:_firstLine];
}


-(void)initContentsView
{
    _contentsView = [[UIView alloc]init];
    [self.contentView addSubview:_contentsView];
    [_contentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    //第一行
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"服务类型";
    firstLabel.textColor = kText_Color_Gray;
    firstLabel.font = [UIFont systemFontOfSize:12];
    firstLabel.adjustsFontSizeToFitWidth = YES;
    [_contentsView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_contentsView.mas_top).offset(10);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
    }];
    
    _wxlxLabel = [[UILabel alloc]init];
    _wxlxLabel.text = @"维修";
    _wxlxLabel.textColor = kText_Color_Gray;
    _wxlxLabel.font = [UIFont systemFontOfSize:12];
    [_contentsView addSubview:_wxlxLabel];
    [_wxlxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstLabel);
        make.right.mas_equalTo(-12);
    }];
    
    //第二行
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.text = @"服务项目";
    secondLabel.textColor = kText_Color_Gray;
    secondLabel.font = [UIFont systemFontOfSize:12];
    [_contentsView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(firstLabel);
        make.left.equalTo(firstLabel.mas_left);
        make.top.equalTo(firstLabel.mas_bottom).offset(8);
    }];
    
    _bxxmLabel = [[UILabel alloc]init];
    _bxxmLabel.textColor = kText_Color_Gray;
    _bxxmLabel.font = [UIFont systemFontOfSize:12];
    [_contentsView addSubview:_bxxmLabel];
    [_bxxmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondLabel);
        make.right.mas_equalTo(-12);
    }];
    //第三行
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.text = @"申请时间";
    thirdLabel.textColor = kText_Color_Gray;
    thirdLabel.font = [UIFont systemFontOfSize:12];
    [_contentsView addSubview:thirdLabel];
    //thirdLabel.adjustsFontSizeToFitWidth = YES;
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(firstLabel);
        make.left.equalTo(firstLabel.mas_left);
        make.top.equalTo(secondLabel.mas_bottom).offset(BXContentHeightSpace);
        make.bottom.mas_equalTo(-10);
    }];
    
    _bxTimeLabel = [[UILabel alloc]init];
    _bxTimeLabel.textColor = kText_Color_Gray;
    _bxTimeLabel.font = [UIFont systemFontOfSize:13];
    [_contentsView addSubview:_bxTimeLabel];
    [_bxTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thirdLabel);
        make.right.mas_equalTo(-12);
    }];
}

-(void)initDetailButton
{
    _detailButton = [[UIButton alloc]init];
    [_detailButton setTitle:@"详情" forState:UIControlStateNormal];
    [_detailButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    _detailButton.layer.borderWidth = 1;
    _detailButton.layer.borderColor = kCommonGray_Color.CGColor;
    [self.contentView addSubview:_detailButton];
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(0);
    }];
}





@end
