//
//  ZCYPropertyRepairViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYPropertyRepairViewController.h"
#import "ZCYRepairListModel.h"
#import "BaoXiuCell.h"
#import "ZCYStyleDefine.h"
#import "ZCYRepairlistHelper.h"
#import "ZCYUserMgr.h"
#import "ZCYRepairApplyViewController.h"
#import "ZCYRepairDetailViewController.h"
#import "Masonry.h"
#import "ZCYGetRepairApplyData.h"

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

-(void)initUIAndData
{
    [ZCYRepairlistHelper getBXListWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSArray *arr) {
        NSLog(@"------%@",arr);
        if (error) {
            [[ZCYProgressHUD sharedHUD] showWithText:[NSString stringWithFormat:@"%@",error] inView:self.view hideAfterDelay:1];
        }
        if (arr != nil && arr.count > 0) {
            
            _arr = [NSMutableArray arrayWithArray:arr];
            _tableView = [[UITableView alloc]init];
            
            _tableView.contentSize = CGSizeMake(kScreenWidth, 40);
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
            view.backgroundColor = kCommonLightGray_Color;
            _tableView.tableHeaderView = view;
            _tableView.delegate = self;
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
        else{
            [[ZCYProgressHUD sharedHUD] showWithText:@"暂无报修信息" inView:self.view hideAfterDelay:1];
            _arr = [NSMutableArray array];
            _tableView = [[UITableView alloc]init];
            _tableView.contentSize = CGSizeMake(kScreenWidth, 60);
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.scrollEnabled = NO;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
            view.backgroundColor = kCommonLightGray_Color;
            _tableView.tableHeaderView = view;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [self.view addSubview:_tableView];
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kNavigationHeight+20);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(60);
            }];
        }
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
        //      headCell.imageView.image = [UIImage imageNamed:@"angle-right"];
        headCell.textLabel.textColor = [UIColor blackColor];
        return headCell;
    }else{
        BaoXiuCell *cell = [[BaoXiuCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ZCYRepairListModel *model = _arr[indexPath.row];
        cell.BXID = model.wx_djh;
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//        view.backgroundColor = [UIColor redColor];
//        return view;
//    }
//    return nil;
//
//}

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
    BaoXiuCell *BXCell = (BaoXiuCell *)sender.superview;
    NSIndexPath *cellIndexPath = [_tableView indexPathForCell:BXCell];
    ZCYRepairListModel *model = _arr[cellIndexPath.row];
    ZCYRepairDetailViewController *detailVC = [[ZCYRepairDetailViewController alloc]init];
    detailVC.BXId = model.wx_djh;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
