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
#import "ZCYInfomationCell.h"
#import "InfomationTypeView.h"

#define kButtonWidth 50
#define kButtonheight 55
#define kVerticalAspact 10
#define kScreenWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height
#define kNavagationHeight self.navigationController.navigationBar.frame.size.height

@interface ZCYInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIScrollView *headScroll;
@property (nonatomic,strong)UITableView *listTable;
@property (nonatomic,strong)NSArray *buttonNames;
@property (nonatomic,strong)NSMutableArray *news;
//@property (nonatomic,strong)NSString *newsAPI;
@property (nonatomic,assign)NSInteger currentNews;
@property (nonatomic,strong)NSArray *newsApi;

@end

@implementation ZCYInformationViewController
{
    CGFloat kAspact;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonNames = @[@"头条",@"教务公告",@"OA公告",@"会议通知",@"学术讲座",@"综合新闻"];
    _newsApi = @[@"/api/get_newslist.php?page=1",@"/api/news/oa_list.php",@"/api/news/oa_list.php",@"/api/news/hy_list.php",@"/api/news/jz_list.php",@"/api/news/new_list.php"];
    _currentNews = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    kAspact = (kScreenWidth-kButtonWidth*6)/7;
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
    self.headScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kButtonheight+kVerticalAspact)];
    self.headScroll.contentSize = CGSizeMake(kButtonWidth*6+kAspact*7, kButtonheight+kVerticalAspact);
    _headScroll.showsVerticalScrollIndicator = NO;
    _headScroll.showsHorizontalScrollIndicator = NO;
//    _headScroll.backgroundColor = kDeepGreen_Color;
    [self.view addSubview:_headScroll];
    for (int i = 0; i < 6; i++) {
        InfomationTypeView *title = [[InfomationTypeView alloc]initWithFrame:CGRectMake(kButtonWidth*i+kAspact*(i+1), 4, kButtonWidth, kButtonheight) andType:_buttonNames[i]];
        title.tag = 200+i;
        //title.backgroundColor = [UIColor blackColor];
        [_headScroll addSubview:title];
        title.block = ^(NSInteger tag){
            _currentNews = tag-200;
            [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
            [self getNews];
        };
    }
}


-(void)initListTable{
    CGFloat tableHeight = kViewHeight-(64+kButtonheight+kVerticalAspact)-self.tabBarController.tabBar.frame.size.height;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+kButtonheight+kVerticalAspact, kScreenWidth, tableHeight)];
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTable.showsVerticalScrollIndicator = NO;
    [self.listTable registerNib:[UINib nibWithNibName:@"ZCYInfomationCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
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
    static NSString *cellID = @"cellId";
    ZCYInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    InformationModel *model = _news[indexPath.row];
    [cell setTitle:model.title Time:model.time type:model.type];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(void)getNews{
    _news = [NSMutableArray array];
    [InfomationHelper getInfomationListWithNewsApi:_newsApi[_currentNews] andBlock:^(NSError *erro, NSArray *arr) {
        if (erro) {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0];
            [[ZCYProgressHUD sharedHUD] showWithText:erro.localizedDescription inView:self.view hideAfterDelay:1.0f];
        }else{
            for (int i = 0; i < arr.count; i++) {
                InformationModel *model = [[InformationModel alloc]init];
                NSDictionary *dic = arr[i];
                model.articleid = dic[@"articleid"];
                model.title = dic[@"title"];
                model.time = dic[@"time"];
                model.type = dic[@"type"];
                [_news addObject:model];
                
            }
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0];
            [_listTable reloadData];
        }

    }];

}
@end
