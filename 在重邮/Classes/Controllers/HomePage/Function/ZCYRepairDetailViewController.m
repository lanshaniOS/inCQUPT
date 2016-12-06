//
//  BXDetailViewController.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/19.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairDetailViewController.h"
#import "Masonry.h"
#import "ZCYRepairDetailCellView.h"
#import "ZCYStyleDefine.h"

#define kNavigationHeight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define kDetailCellHeight 130
#define kGDheightSpace 10

@interface ZCYRepairDetailViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *CLDetailView;
@property (nonatomic,strong) UIView *GDDetailView;
@property (nonatomic,strong) UILabel *GDfwxmLabel;
@property (nonatomic,strong) UILabel *GDfwqyLabel;
@property (nonatomic,strong) UILabel *GDbxdzLabel;
@property (nonatomic,strong) UILabel *GDlxdhLabel;
@property (nonatomic,strong) UILabel *GDfwlxLabel;
@property (nonatomic,strong) UILabel *GDsbrLabel;
@property (nonatomic,strong) UILabel *GDsbnrLabel;

@end

@implementation ZCYRepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initScrollView];
    [self addYCFirstView];
}

-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight+20);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-kNavigationHeight-20);
}

-(void)addYCFirstView
{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"处理详情";
    label.textColor = kText_Color_Gray;
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
    }];
    
    
    _CLDetailView = [[UIView alloc]init];
    _CLDetailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_CLDetailView];
    [_CLDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(kDetailCellHeight*4+20*3);
    }];
    
    //异常
    ZCYRepairDetailCellView *YCView = [[ZCYRepairDetailCellView alloc]init];
    YCView.BXtitleLabel.text = @"维修";
    YCView.BXCLRLabel.text = @"老师";
    YCView.BXtimeLabel.text = @"11554121315";
    YCView.BXBZLabel.text = @"粉啊身份卑微粉我粉我买苹个人哦给你温柔味儿浓个哥们我人品果";
    [_CLDetailView addSubview:YCView];
    [YCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(70);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kDetailCellHeight);
    }];
}

-(void)addGDDetailView
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"工单详情";
    titleLabel.textColor = kText_Color_Gray;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CLDetailView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
    }];
    [_scrollView addSubview:titleLabel];
    _GDDetailView = [[UIView alloc]init];
    _GDDetailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_GDDetailView];
    [_GDDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.and.right.mas_equalTo(0);
    }];
    
    UILabel *xmLabel = [[UILabel alloc]init];
    xmLabel.text = @"服务项目";
    xmLabel.textColor = kText_Color_Gray;
    xmLabel.font = kDefaultFont;
    [_GDDetailView addSubview:xmLabel];
    [xmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
    }];
    _GDfwxmLabel = [[UILabel alloc]init];
    _GDfwxmLabel.textColor = kText_Color_Gray;
    _GDfwxmLabel.font = kDefaultFont;
    [_GDDetailView addSubview:_GDfwxmLabel];
    [_GDfwxmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(xmLabel);
    }];
    
    UILabel *qyLabel = [[UILabel alloc]init];
    qyLabel.textColor = kText_Color_Gray;
    qyLabel.text = @"服务区域";
    qyLabel.font = kDefaultFont;
    [_GDDetailView addSubview:qyLabel];
    [qyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xmLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDfwqyLabel = [[UILabel alloc]init];
    _GDfwqyLabel.textColor = kText_Color_Gray;
    _GDfwqyLabel.font = kDefaultFont;
    [_GDDetailView addSubview:_GDfwqyLabel];
    [_GDfwqyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(qyLabel);
    }];
    
    UILabel *bxdzLabel = [[UILabel alloc]init];
    bxdzLabel.textColor = kText_Color_Gray;
    bxdzLabel.text = @"报修地址";
    bxdzLabel.font = kDefaultFont;
    [_GDDetailView addSubview:bxdzLabel];
    [bxdzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qyLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDbxdzLabel = [[UILabel alloc]init];
    _GDbxdzLabel.textColor = kText_Color_Gray;
    _GDbxdzLabel.font = kDefaultFont;
    [_GDbxdzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(bxdzLabel);
    }];
    
    UILabel *dhLabel = [[UILabel alloc]init];
    dhLabel.textColor = kText_Color_Gray;
    dhLabel.text = @"联系电话";
    dhLabel.font = kDefaultFont;
    [dhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bxdzLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDlxdhLabel = [[UILabel alloc]init];
    _GDlxdhLabel.font = kDefaultFont;
    _GDlxdhLabel.textColor = kText_Color_Gray;
    [_GDDetailView addSubview:_GDlxdhLabel];
    [_GDlxdhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(dhLabel);
    }];
    
    UILabel *fwlxLabel = [[UILabel alloc]init];
    fwlxLabel.textColor = kText_Color_Gray;
    fwlxLabel.text = @"服务类型";
    fwlxLabel.font = kDefaultFont;
    [_GDDetailView addSubview:fwlxLabel];
    [fwlxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dhLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDfwlxLabel = [[UILabel alloc]init];
    _GDfwlxLabel.textColor = kText_Color_Gray;
    _GDfwlxLabel.font = kDefaultFont;
    [_GDDetailView addSubview:_GDfwlxLabel];
    [_GDfwlxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(fwlxLabel);
    }];
    
    UILabel *sbrLabel = [[UILabel alloc]init];
    sbrLabel.textColor = kText_Color_Gray;
    sbrLabel.text = @"申报人";
    sbrLabel.font = kDefaultFont;
    [_GDDetailView addSubview:sbrLabel];
    [sbrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fwlxLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDsbrLabel = [[UILabel alloc]init];
    _GDsbrLabel.textColor = kText_Color_Gray;
    _GDsbrLabel.font = kDefaultFont;
    [_GDDetailView addSubview:_GDsbrLabel];
    [_GDsbrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(sbrLabel);
    }];
    
    UILabel *sbnrLabel = [[UILabel alloc]init];
    sbnrLabel.text = @"申报内容";
    sbnrLabel.textColor = kText_Color_Gray;
    sbnrLabel.font = kDefaultFont;
    [_GDDetailView addSubview:sbnrLabel];
    [sbnrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sbrLabel.mas_bottom).offset(kGDheightSpace);
        make.left.mas_equalTo(10);
    }];
    
    _GDsbnrLabel = [[UILabel alloc]init];
    _GDsbnrLabel.textColor = kText_Color_Gray;
    _GDsbnrLabel.font = kDefaultFont;
    [_GDDetailView addSubview:_GDsbnrLabel];
    [_GDsbnrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(sbnrLabel);
    }];
}





@end
