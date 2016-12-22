//
//  ZCYPropertyRepairViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYPropertyRepairViewController.h"
#import "ZCYRepairListModel.h"
#import "ZCYRepairCell.h"
#import "ZCYStyleDefine.h"
#import "ZCYRepairlistHelper.h"
#import "ZCYUserMgr.h"
#import "ZCYRepairApplyViewController.h"
#import "ZCYRepairDetailViewController.h"
#import "Masonry.h"
#import "ZCYGetRepairApplyData.h"
#import "ZCYGetRepairAdrressHelper.h"

#define cellID @"cellID"
#define kNavigationHeight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface ZCYPropertyRepairViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arr;
@end

@implementation ZCYPropertyRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修进度查询";
    self.view.backgroundColor = kCommonLightGray_Color;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUIAndData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
    [ZCYRepairlistHelper getBXListWithStdNumber:[ZCYUserMgr sharedMgr].cardID withCompeletionBlock:^(NSError *error, NSArray *arr) {
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error) {
            [[ZCYProgressHUD sharedHUD] showWithText:[NSString stringWithFormat:@"%@",[error localizedDescription]] inView:self.view hideAfterDelay:1];
            return;
        }
        if (arr != nil && arr.count > 0) {
            _arr = [NSMutableArray arrayWithArray:arr];
            [_tableView reloadData];
        }
        else{
            [[ZCYProgressHUD sharedHUD] showWithText:@"暂无报修信息" inView:self.view hideAfterDelay:1];
        }
    }];

    if ([ZCYUserMgr sharedMgr].repairInfomation == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [ZCYGetRepairApplyData getRepairApplyDataFromeNet:^(NSError *error, NSDictionary *dic) {
                [ZCYUserMgr sharedMgr].repairInfomation = [NSDictionary dictionaryWithDictionary:dic];
            }];
        });
    }
    
    if ([ZCYUserMgr sharedMgr].repairAddressChoices == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [ZCYGetRepairAdrressHelper getRepairAdrressFromeNet:^(NSError *error, NSArray *arr) {
                [ZCYUserMgr sharedMgr].repairAddressChoices = [NSArray arrayWithArray:arr];
            }];
        });
    }
}
-(void)initUIAndData
{
    _tableView = [[UITableView alloc]init];
    
    _tableView.contentSize = CGSizeMake(kScreenWidth, 40);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kCommonGray_Color;
    _tableView.tableHeaderView = view;
    _tableView.delegate = self;
    _tableView.backgroundColor = kCommonGray_Color;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight+20);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *headCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        headCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        headCell.textLabel.text = @"服务申报";
        headCell.textLabel.font = kFont(14);
        headCell.textLabel.textColor = [UIColor blackColor];
        return headCell;
    }else{
        ZCYRepairCell *cell = [[ZCYRepairCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ZCYRepairListModel *model = _arr[indexPath.row];
        cell.BXID = model.wx_bt;
        cell.BXStates = model.wx_wxztm;
        cell.BXfwlx = model.wx_bxlxm;
        cell.BXfwxm = model.wx_bxnr;
        cell.BXfwsj = model.wx_bxsj;
        
        [cell.detailButton addTarget:self action:@selector(detailClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 200;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        ZCYRepairApplyViewController *VC = [[ZCYRepairApplyViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
}

-(void)detailClicked:(UIButton *)sender
{
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [UIColor colorWithRed:152.0/255 green:251.0/255 blue:152.0/255 alpha:1];
    } completion:^(BOOL finished) {
        sender.backgroundColor = [UIColor whiteColor];
    }];
    ZCYRepairCell *BXCell = (ZCYRepairCell *)sender.superview;
    NSIndexPath *cellIndexPath = [_tableView indexPathForCell:BXCell];
    ZCYRepairListModel *model = _arr[cellIndexPath.row];
    ZCYRepairDetailViewController *detailVC = [[ZCYRepairDetailViewController alloc]init];
    detailVC.BXId = model.wx_djh;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
