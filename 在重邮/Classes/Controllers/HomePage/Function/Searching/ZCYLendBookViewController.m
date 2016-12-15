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
@property (strong, nonatomic) UIView *topView;  /**< 顶部 */


@end

@implementation ZCYLendBookViewController
{
    BOOL _userHaveData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"借阅信息";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ZCYUserMgr sharedMgr].lendBookDic)
    {
        _userHaveData = YES;
        self.tipLabel.hidden = YES;
        self.bookList = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"book_list"];
        self.debtString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"dbet"];
        self.totalBookString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"books_num"];
        self.historyString = [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"history"];
        
    } else {
        _userHaveData = NO;
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"数据加载中" inView:self.view];
    }
    [self getBooklistWithStudentNum:[ZCYUserMgr sharedMgr].studentNumber];
}

- (void)initUI
{
    [self initMainTableView];
    [self initTipLabel];
    [self initTopView];
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
        make.top.equalTo(self.view).with.offset(100);
    }];
}

- (void)initTopView
{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = kCommonWhite_Color;
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    NSArray *numArray;
    if ([ZCYUserMgr sharedMgr].lendBookDic)
    {
        numArray = @[[ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"history"], [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"books_num"], [ZCYUserMgr sharedMgr].lendBookDic[@"data"][@"dbet"]];
    } else {
        numArray = @[@"0", @"0", @"0"];
    }
    NSArray *nameArray = @[@"累计借书", @"已借书数", @"欠款金额"];
    NSArray *unitArray = @[@"册", @"册", @"元"];
    NSArray <UIColor *>*colorArray = @[kDeepGreen_Color, [UIColor colorWithRGBHex:0x32d2b1], [UIColor colorWithRGBHex:0xfc3545]];
    for (NSInteger index = 0; index < 3; index++) {
        UIView *detailView = [[UIView alloc] init];
        [self setView:detailView WithTitle:nameArray[index] andNumber:numArray[index] andUnit:unitArray[index] andTextColor:colorArray[index]];
        [self.topView addSubview:detailView];
        if (index == 0)
        {
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_topView).with.offset(20);
                make.width.mas_equalTo(77);
                make.top.equalTo(self.topView).with.offset(30);
                make.bottom.equalTo(self.topView).with.offset(-30);
            }];
        } else if (index == 1) {
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.topView);
                make.width.mas_equalTo(77);
                make.top.equalTo(self.topView).with.offset(30);
                make.bottom.equalTo(self.topView).with.offset(-30);
            }];
        } else {
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_topView).with.offset(-20);
                make.width.mas_equalTo(77);
                make.top.equalTo(self.topView).with.offset(30);
                make.bottom.equalTo(self.topView).with.offset(-30);
            }];
        }
            
        if (index != 2)
        {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = kCommonGray_Color;
            [self.topView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(detailView).with.offset((self.view.frame.size.width - 40 - 77*3)/4);
                make.centerY.equalTo(detailView);
                make.size.mas_equalTo(CGSizeMake(1, 30));
            }];
        }
    }
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kDeepGray_Color;
    [self.view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)initTipLabel
{
    self.tipLabel = [[UILabel alloc] init];
    [self.tipLabel setFont:kFont(kStandardPx(50)) andText:@"本学期没有借书记录哦～～～" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    self.tipLabel.hidden = YES;
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.equalTo(self.view);
    }];
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
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error)
        {
            DDLogError(@"%@", error);
            if (!_userHaveData)
//            self.tipLabel.text = @"网络开小差啦～～～";
                [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
            return;
        }
        self.bookList = response[@"data"][@"book_list"];
        self.debtString = response[@"data"][@"dbet"];
        self.totalBookString = response[@"data"][@"books_num"];
        self.historyString = response[@"data"][@"history"];
        [ZCYUserMgr sharedMgr].lendBookDic = response;
        if ([response[@"data"][@"book_list"]  isEqual: @""])
        {
            self.tipLabel.text = @"本学期没有借书记录哦～～～";
            self.tipLabel.hidden = NO;
        } else {
            self.tipLabel.hidden = YES;
            [self.mainTableView reloadData];
        }
        self.topView = nil;
        [self initTopView];
    }];
}

- (void)setView:(UIView *)bgView WithTitle:(NSString *)title andNumber:(NSString *)number andUnit:(NSString *)perUnit andTextColor:(UIColor *)color
{
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:kFont(kStandardPx(36)) andText:title andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(bgView);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [numLabel setFont:kFont(kStandardPx(34)) andText:number andTextColor:color andBackgroundColor:kTransparentColor];
    [bgView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(bgView.mas_bottom).with.offset(10);
    }];
    
    UILabel *unitLabel = [[UILabel alloc] init];
    [unitLabel setFont:kFont(kStandardPx(28)) andText:perUnit andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [bgView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLabel.mas_right).with.offset(5);
        make.bottom.equalTo(numLabel).with.offset(-1);
    }];
}
@end
