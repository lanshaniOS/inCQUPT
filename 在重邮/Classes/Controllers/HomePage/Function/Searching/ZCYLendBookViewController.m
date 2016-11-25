//
//  ZCYLendBookViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLendBookViewController.h"
#import "ZCYLendingBookHelper.h"
#import "ZCYLendingTableViewCell.h"

@interface ZCYLendBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mainTableView;  /**< 总视图 */
@property (strong, nonatomic) NSArray *bookList;  /**< 借书本数 */
@property (strong, nonatomic) NSString *totalBookString;  /**< 当前学期借书总数 */
@property (strong, nonatomic) NSString *debtString;  /**< 欠债总数 */
@property (strong, nonatomic) NSString *historyString;  /**< 总共借书总数 */


@end

@implementation ZCYLendBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"借阅信息";
}

- (void)initUI
{
    [self initMainTableView];
    [self getBooklistWithStudentNum:[ZCYUserMgr sharedMgr].studentNumber];
}

- (void)initMainTableView
{
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = 110;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
    }];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookList.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCYLendingTableViewCell *cell = [[ZCYLendingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYLendingTableViewCellIdentifier"];
    
    [cell setCellWithBookName:self.bookList[indexPath.row][@"book"] andLendTime:self.bookList[indexPath.row][@"jsrq"] andBackTime:self.bookList[indexPath.row][@"hsrq"]];
    return cell;
}

#pragma mark - tools
- (void)getBooklistWithStudentNum:(NSString *)studentNumber
{
    [ZCYLendingBookHelper getLendingRecordWithStdNumber:@"2015210944" withCompeletionBlock:^(NSError *error, NSDictionary *response) {
        if (error)
        {
            DDLogError(@"%@", error);
            return;
        }
        self.bookList = response[@"data"][@"booklist"];
        self.debtString = response[@"data"][@"dbet"];
        self.totalBookString = response[@"data"][@"books_num"];
        self.historyString = response[@"data"][@"history"];
        [self.mainTableView reloadData];
    }];
}
@end
