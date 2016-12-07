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
#import "ZCYRepairGDView.h"
#import "ZCYRepairDetailHelper.h"
#import "ZCYRepairDetailModel.h"

#define kNavigationHeight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define kDetailCellHeight 130
#define kGDHeight 220

@interface ZCYRepairDetailViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *CLDetailView;
@property (nonatomic,strong) ZCYRepairGDView *GDDetailView;
@property (nonatomic,strong) UILabel *GDfwxmLabel;
@property (nonatomic,strong) UILabel *GDfwqyLabel;
@property (nonatomic,strong) UILabel *GDbxdzLabel;
@property (nonatomic,strong) UILabel *GDlxdhLabel;
@property (nonatomic,strong) UILabel *GDfwlxLabel;
@property (nonatomic,strong) UILabel *GDsbrLabel;
@property (nonatomic,strong) UILabel *GDsbnrLabel;
@property (nonatomic,strong) ZCYRepairDetailCellView *CLView;
@property (nonatomic,strong) UIImageView *circleView;

@end

@implementation ZCYRepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initScrollView];
    [self addYCFirstView];
    [self addGDDetailView];
    [self initData];
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
    //_scrollView.contentSize = CGSizeMake(kScreenWidth, kDetailCellHeight*3 - kNavigationHeight+kGDHeight+200);
}

-(void)addYCFirstView
{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"处理详情";
    label.font = kFont(18);
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
        make.height.mas_equalTo(kDetailCellHeight+20*2);
    }];
    
    _circleView = [[UIImageView alloc]init];
    [_CLDetailView addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.height.width.mas_equalTo(30);
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, 42, 1, kDetailCellHeight - 32)];
    view.backgroundColor = kGray_Line_Color;
    [_CLDetailView addSubview:view];
    
    _CLView = [[ZCYRepairDetailCellView alloc]init];
    [_CLDetailView addSubview:_CLView];
    [_CLView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kDetailCellHeight);
    }];
}

-(void)addGDDetailView
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"工单详情";
    titleLabel.font = kFont(18);
    titleLabel.textColor = kText_Color_Gray;
    [_scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CLDetailView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
    }];
    
    _GDDetailView = [[ZCYRepairGDView alloc]init];
    _GDDetailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_GDDetailView];
    [_GDDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kGDHeight);
    }];
    
}

-(void)initData{
    [ZCYRepairDetailHelper getrepairDetailWithBXId:self.BXId withComplitionBlock:^(NSError *error, ZCYRepairDetailModel *model) {
        ZCYRepairDetailModel *repairModel = model;
        _GDDetailView.GDsbnr = repairModel.wx_bxnr;
        _GDDetailView.GDlxdh = repairModel.wx_bxdh;
        _GDDetailView.GDfwxm = repairModel.wx_bxnr;
        _GDDetailView.GDfwqy = repairModel.wx_fwqym;
        _GDDetailView.GDfwlx = repairModel.wx_bxlxm;
        _GDDetailView.GDsbr = repairModel.wx_bxr;
        _GDDetailView.GDbxdz = repairModel.wx_bxdd;
        
        _CLView.BXtitle = repairModel.wx_wxztm;
        _CLView.BXtime = repairModel.wx_bxsj;
        _CLView.BXBZ = repairModel.wx_bxnr;
        _CLView.BXCLR = repairModel.wx_slr;
        if ([repairModel.wx_wxztm isEqualToString:@"已受理"]) {
            _circleView.image = [UIImage imageNamed:@"elipse1"];
        }else if ([repairModel.wx_wxztm isEqualToString:@"异常"]){
            _circleView.image = [UIImage imageNamed:@"elipse3"];
        }else{
            _circleView.image = [UIImage imageNamed:@"elipse2"];
        }
    }];
}



@end
