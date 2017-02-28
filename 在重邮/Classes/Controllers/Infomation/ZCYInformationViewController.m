//
//  ZCYInformationViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYInformationViewController.h"
#import "InfomationHelper.h"
#import "InformationModel.h"
#import "ZCYInfomationDetailController.h"


#define kButtonWidth 50
#define kScreenWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height
#define kNavagationHeight self.navigationController.navigationBar.frame.size.height
#define kAspact 10

@interface ZCYInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIScrollView *headScroll;
@property (nonatomic,strong)UITableView *listTable;
@property (nonatomic,strong)NSArray *buttonNames;
@property (nonatomic,strong)NSMutableArray *news;
@property (nonatomic,strong)NSString *newsAPI;

@end

@implementation ZCYInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonNames = @[@"头条",@"教务公告",@"OA公告",@"会议通知",@"学术讲座",@"综合新闻"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_news.count == 0) {
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
    }
    
}

- (void)initUI
{
    self.view.backgroundColor = kAppBg_Color;
    [self initHeadScroll];
    [self initListTable];
    [self getNews];
}

-(void)initHeadScroll{
    self.headScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kButtonWidth+kAspact*2)];
    self.headScroll.contentSize = CGSizeMake(kButtonWidth*6+kAspact*7, kButtonWidth+kAspact*2);
    _headScroll.showsVerticalScrollIndicator = NO;
    _headScroll.showsHorizontalScrollIndicator = NO;
    _headScroll.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_headScroll];
    for (int i = 0; i < 6; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kButtonWidth+(i+1)*kAspact, kAspact, kButtonWidth, kButtonWidth)];
        button.backgroundColor = [UIColor blackColor];
        button.tag = 100+i;
        [button setTitle:_buttonNames[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(choseInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [_headScroll addSubview:button];
    }
}

-(void)choseInfomation:(UIButton *)button{
    NSLog(@"0000");
}


-(void)initListTable{
    NSLog(@"%f",self.tabBarController.tabBar.frame.size.height);
    CGFloat tableHeight = kViewHeight-(64+kButtonWidth+kAspact*2)-self.tabBarController.tabBar.frame.size.height;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+kButtonWidth+kAspact*2, kScreenWidth, tableHeight) style:UITableViewStylePlain];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    [self.view addSubview:_listTable];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InformationModel *model = _news[indexPath.row];
    ZCYInfomationDetailController *detailVC = [[ZCYInfomationDetailController alloc]init];
    [detailVC getInfomationType:model.type andId:model.articleid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _news.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    InformationModel *model = _news[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.time;
    return cell;
}

-(void)getNews{
    _news = [NSMutableArray array];
    [InfomationHelper getInfomationList:^(NSError *erro, NSArray *arr) {
        if (erro) {
            NSLog(@"%@",erro);
        }else{
            for (int i = 0; i < arr.count; i++) {
                InformationModel *model = [[InformationModel alloc]init];
                NSDictionary *dic = arr[i];
                model.articleid = dic[@"articleid"];
                model.title = dic[@"title"];
                model.time = dic[@"time"];
                model.type = dic[@"type"];
                NSLog(@"%@",model.title);
                [_news addObject:model];
                
            }
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0];
            [_listTable reloadData];
        }
    }];
}


@end
