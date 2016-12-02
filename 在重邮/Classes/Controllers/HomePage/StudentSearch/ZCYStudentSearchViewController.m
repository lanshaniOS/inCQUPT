//
//  ZCYStudentSearchViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYStudentSearchViewController.h"
#import "ZCYStudentSeachHelper.h"
#import "ZCYStudentDetailViewController.h"

@interface ZCYStudentSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UISearchController *searchController;  /**< 搜索框 */
@property (strong, nonatomic) NSMutableArray *studentArray;  /**< 搜索结果 */
@property (strong, nonatomic) UITableView *searchTableView;  /**< 搜索结果 */
@end

@implementation ZCYStudentSearchViewController
{
    __block NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.searchController.active = NO;
    [super viewWillDisappear:animated];
    
}
- (NSString *)title
{
    return @"学生查询";
}

- (void)initUI
{
    self.studentArray = [NSMutableArray array];
    _page = 1;
    [self initSearchView];
}

- (void)initSearchView
{
    self.searchTableView = [[UITableView alloc] init];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.rowHeight = 60;
    [self.view addSubview:self.searchTableView];
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.searchBar.placeholder = @"请输入学生学号或姓名";
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.searchBar.barTintColor = [UIColor redColor];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchTableView.tableHeaderView = self.searchController.searchBar;
    self.searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.studentArray.count < 10)
        {
            [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        _page++;
        [self requestMoreData];
    }];
    
    
}

#pragma UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYStudentSearchTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.studentArray[indexPath.row][@"xm"], self.studentArray[indexPath.row][@"yxm"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchController.active = NO;
    ZCYStudentDetailViewController *studentVC = [[ZCYStudentDetailViewController alloc] initWithStudentInfo:self.studentArray[indexPath.row]];
    [self.navigationController pushViewController:studentVC animated:YES];
}
#pragma mark - refresh

- (void)requestMoreData
{
    [ZCYStudentSeachHelper getStudentDetailWithMessage:self.searchController.searchBar.text andPage:_page withCompeletionBlock:^(NSError *error, NSDictionary *resultDic) {
        if (error)
        {
            [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
            return;
        }
        [self endRefresh];
        if (resultDic != nil || resultDic != NULL)
        {
            if (resultDic.count !=0)
            {
                [self.studentArray addObjectsFromArray:resultDic[@"rows"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.searchTableView reloadData];
                });
            }
        }
    }];
}
- (void)endRefresh
{
    [self.searchTableView.mj_footer endRefreshing];
}
#pragma UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.searchTableView.hidden = NO;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (self.searchController.active == YES)
    {
        if (![self.searchController.searchBar.text  isEqual: @""])
        {
            [self.studentArray removeAllObjects];
            _page = 1;
            [self requestMoreData];
        } else {
            [self.studentArray removeAllObjects];
            _page = 1;
            [self.searchTableView reloadData];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController.searchBar resignFirstResponder];
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
    [ZCYStudentSeachHelper getStudentDetailWithMessage:self.searchController.searchBar.text andPage:_page withCompeletionBlock:^(NSError *error, NSDictionary *resultDic) {
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error)
        {
            [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
            return;
        }
        if (resultDic != nil || resultDic != NULL)
        {
            if (resultDic.count !=0)
            {
                [self.studentArray addObjectsFromArray:resultDic[@"rows"]];
                [self.searchTableView reloadData];
            }
        }
    }];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}
@end
