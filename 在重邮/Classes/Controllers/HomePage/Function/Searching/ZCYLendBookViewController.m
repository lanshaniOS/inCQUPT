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
@property (strong, nonatomic) UILabel *tipLabel;  /**< 没有借书的提示 */


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
    [self initTipLabel];
    [self getBooklistWithStudentNum:[ZCYUserMgr sharedMgr].studentNumber];
}

- (void)initMainTableView
{
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.allowsSelection = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(0);
    }];
}

- (void)initTipLabel
{
    self.tipLabel = [[UILabel alloc] init];
    [self.tipLabel setFont:kFont(kStandardPx(50)) andText:@"本学期没有借书记录哦～～～" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ZCYUserMgr sharedMgr].lendBookDic)
    {
        self.tipLabel.hidden = YES;
        self.bookList = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"book_list"];
        self.debtString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"dbet"];
        self.totalBookString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"books_num"];
        self.historyString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"history"];
    } else {
        self.tipLabel.hidden = NO;
    }
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCYLendingTableViewCell *cell = [[ZCYLendingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZCYLendingTableViewCellIdentifier" WithBookName:self.bookList[indexPath.row][@"book"] andLendTime:self.bookList[indexPath.row][@"jsrq"] andBackTime:self.bookList[indexPath.row][@"yhrq"] andWidth:self.view.frame.size.width];
    return cell;
}

#pragma mark - tools
- (void)getBooklistWithStudentNum:(NSString *)studentNumber
{
    [ZCYLendingBookHelper getLendingRecordWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber withCompeletionBlock:^(NSError *error, NSDictionary *response) {
        if (error)
        {
            DDLogError(@"%@", error);
            return;
        }
        self.bookList = response[@"data"][@"book_list"];
        self.debtString = response[@"data"][@"dbet"];
        self.totalBookString = response[@"data"][@"books_num"];
        self.historyString = response[@"data"][@"history"];
        [ZCYUserMgr sharedMgr].lendBookDic = response;
        
        if ([response[@"data"][@"book_list"]  isEqual: @""])
        {
            self.tipLabel.hidden = NO;
        } else {
            self.tipLabel.hidden = YES;
            [self.mainTableView reloadData];
            
        }
    }];
}
@end
