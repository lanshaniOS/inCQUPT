//
//  BXApplyViewController.m
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/18.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYRepairApplyViewController.h"
#import "ZCYStyleDefine.h"
#import "ZCYProgressHUD.h"
#import "ZCYRepairApplyModel.h"
#import "ZCYRepairApplyHelper.h"
#import "ZCYUserMgr.h"

#define kCellHeight 50
#define kselfWidth CGRectGetWidth(self.view.frame)
@interface ZCYRepairApplyViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *firstTable;
@property (nonatomic,strong)UIView *secondTable;
@property (nonatomic,strong)UIButton *FWLXButton;
@property (nonatomic,strong)UIButton *FWXMButton;
@property (nonatomic,strong)UIButton *FWQYButton;
@property (nonatomic,strong)UITextField *addressText;
@property (nonatomic,strong)UITextField *numberText;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSArray *LXArray;
@property (nonatomic,strong)NSDictionary *LXDict;
@property (nonatomic,strong)NSMutableArray *choicedXmArray;
@property (nonatomic,strong)NSArray *QYMArray;
@property (nonatomic,strong)UITableView *choicedTableView;

@end

typedef enum tableType{
    FWLXTable,
    FWXMTable,
    FWQYTable,
}tableType;

@implementation ZCYRepairApplyViewController
{
    tableType myTableType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    _LXArray = @[@"水",@"电",@"光源类",@"木工",@"电器",@"泥水",@"管道疏通",@"换表",@"多媒体设备"];
    //    _LXDict = @{@"水":@[@"水龙头",@"水管",@"水阀"],@"电":@[@"室内用电维修",@"公共区域用电维修"],@"光源类":@[@"路灯",@"室内照明灯"],@"木工":@[@"门窗、锁",@"桌、椅、家具",@"窗帘",@"黑板",@"配钥匙"],@"电器":@[@"开关",@"插座",@"教室多媒体设备",@"电风扇",@"开水器"],@"泥水":@[@"土建维修"],@"管道疏通":@[@"疏通"],@"换表":@[@"换水表",@"换电表",@"高压表"],@"多媒体设备":@[@"教室投影仪设备",@"投影仪故障",@"电脑硬件故障",@"软件故障",@"网络故障",@"音响系统故障",@"电源故障",@"其他故障"]};
    //    _QYMArray = @[@"住宅区",@"教学区",@"校园公共区",@"办公区",@"学生公寓区"];
    NSLog(@"%@",[ZCYUserMgr sharedMgr].repairInfomation);
    
    _repairDates = [NSDictionary dictionaryWithDictionary:[ZCYUserMgr sharedMgr].repairInfomation];
    _LXArray = [_repairDates allKeys];
    _choicedXmArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCommonLightGray_Color;
    self.title = @"服务申报";
    [self addFirstView];
    [self addSecondView];
    [self addThirdView];
    [self addCommitButton];
    if ([ZCYUserMgr sharedMgr].repairInfomation == nil) {
        [[ZCYProgressHUD sharedHUD]showWithText:@"服务申报暂时产生错误" inView:self.view hideAfterDelay:1];
        _FWLXButton.enabled = NO;
        _FWXMButton.enabled = NO;
        _FWQYButton.enabled = NO;
    }
}

-(void)addFirstView
{
    UIView *firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80+20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight*3);
    }];
    //第一行
    UIView *cell1 = [[UIView alloc]init];
    [firstView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel1 = [[UILabel alloc]init];
    leftLabel1.text = @"服务类型";
    [cell1 addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell1);
    }];
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"angle-right"]];
    [cell1 addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(cell1);
    }];
    
    _FWLXButton = [[UIButton alloc]init];
    [_FWLXButton setTitle:@"服务类型" forState:UIControlStateNormal];
    [_FWLXButton setTitleColor:kText_Color_Gray forState:UIControlStateNormal];    [cell1 addSubview:_FWLXButton];
    [_FWLXButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(image1.mas_left).offset(-10);
        make.centerY.equalTo(cell1);
    }];
    [_FWLXButton addTarget:self action:@selector(choiceFWLX) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, kCellHeight, kselfWidth, 0.5)];
    line1.backgroundColor = kGray_Line_Color;
    [firstView addSubview:line1];
    //第二行
    UIView *cell2 = [[UIView alloc]init];
    [firstView addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel2 = [[UILabel alloc]init];
    leftLabel2.text = @"服务项目";
    [cell2 addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.center.equalTo(cell2);
    }];
    UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"angle-right"]];
    [cell2 addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(cell2);
    }];
    _FWXMButton = [[UIButton alloc]init];
    [_FWXMButton setTitle:@"具体服务项目" forState:UIControlStateNormal];
    [_FWXMButton setTitleColor:kText_Color_Gray forState:UIControlStateNormal];
    [cell2 addSubview:_FWXMButton];
    [_FWXMButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(image2.mas_left).offset(-10);
        make.centerY.equalTo(cell2);
    }];
    [_FWXMButton addTarget:self action:@selector(choiceFWXM) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, kCellHeight*2, kselfWidth, 0.5)];
    line2.backgroundColor = kGray_Line_Color;
    [firstView addSubview:line2];
    //第三行
    UIView *cell3 = [[UIView alloc]init];
    [firstView addSubview:cell3];
    [cell3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight*2);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel3 = [[UILabel alloc]init];
    leftLabel3.text = @"服务区域";
    [cell3 addSubview:leftLabel3];
    [leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell3);
    }];
    
    UIButton *image3 = [[UIButton alloc]init];
    [image3 setImage:[UIImage imageNamed:@"angle-right"] forState:UIControlStateNormal];
    [cell3 addSubview:image3];
    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(cell3);
    }];
    [image3 addTarget:self action:@selector(choiceFWQY) forControlEvents:UIControlEventTouchUpInside];
    
    _FWQYButton = [[UIButton alloc]init];
    [_FWQYButton setTitle:@"重庆邮电大学" forState:UIControlStateNormal];
    [_FWQYButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [cell3 addSubview:_FWQYButton];
    [_FWQYButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel3.mas_right).offset(20);
        make.centerY.equalTo(cell3);
    }];
    [_FWQYButton addTarget:self action:@selector(choiceFWQY) forControlEvents:UIControlEventTouchUpInside];
}

-(void)choiceFWQY
{
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择服务区域" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //    for (int i = 0; i < _QYMArray.count; i++) {
    //        [self QYMaddAlertActionWithTitle:_QYMArray[i] inAler:alert];
    //    }
    //    [self presentViewController:alert animated:YES completion:nil];
    myTableType = FWQYTable;
    _choicedTableView.alpha = 1;
    [_choicedTableView reloadData];
}

-(void)QYMaddAlertActionWithTitle:(NSString *)title inAler:(UIAlertController *)alert
{
    //    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [_FWQYButton setTitle:title forState:UIControlStateNormal];
    //    }];
    //    [alert addAction:action];
    
}


-(void)choiceFWXM
{
    
    //    if (_choicedXmArray.count > 0) {
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"集体服务项目" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //        for (int i = 0; i < _choicedXmArray.count; i++) {
    //            [self FWXMaddAlertActionWithTitle:_choicedXmArray[i] inAler:alert];
    //        }
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }else{
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先选择服务类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }
    _choicedTableView.alpha = 1;
    myTableType = FWXMTable;
    [_choicedTableView reloadData];
}

-(void)FWXMaddAlertActionWithTitle:(NSString *)title inAler:(UIAlertController *)alert
{
    //    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [_FWXMButton setTitle:title forState:UIControlStateNormal];
    //    }];
    //    [alert addAction:action];
}


-(void)choiceFWLX
{
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"服务类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //    for (int i = 0; i < _LXArray.count; i++) {
    //        [self FWLXaddAlertActionWithTitle:_LXArray[i] inAler:alert];
    //    }
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    myTableType = FWLXTable;
    _choicedTableView.alpha = 1;
    [_choicedTableView reloadData];
    
}

-(void)FWLXaddAlertActionWithTitle:(NSString *)title inAler:(UIAlertController *)alert
{
    //    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [_FWLXButton setTitle:title forState:UIControlStateNormal];
    //        NSLog(@"%@",title);
    //        NSArray *arr = _repairDates[title];
    //        [_choicedXmArray removeAllObjects];
    //        for (int i = 0; i < arr.count; i++) {
    //            NSDictionary *detail = arr[i];
    ////            NSDictionary *dic = detail[2];
    //            NSLog(@"%@",detail[@"Name"]);
    ////            [_choicedXmArray addObject:dic[@"Name"]];
    //        }
    //
    //    }];
    //    [alert addAction:action];
}




-(void)addChoiceTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.alpha = 0;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.mas_equalTo(50);
        make.height.mas_equalTo(220);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (myTableType == FWLXTable) {
        return _LXArray.count;
    }else if (myTableType == FWXMTable){
        return _choicedXmArray.count;
    }else{
        return _QYMArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (myTableType == FWLXTable) {
        cell.textLabel.text = _LXArray[indexPath.row];
    }else if (myTableType == FWXMTable){
        cell.textLabel.text = _choicedXmArray[indexPath.row];
    }else{
        cell.textLabel.text = _QYMArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (myTableType == FWLXTable) {
        [_FWLXButton setTitle:_LXArray[indexPath.row] forState:UIControlStateNormal];
    }else if (myTableType == FWXMTable){
        [_FWXMButton setTitle:_choicedXmArray[indexPath.row] forState:UIControlStateNormal];
    }else{
        [_FWQYButton setTitle:_QYMArray[indexPath.row] forState:UIControlStateNormal];
    }
    tableView.alpha = 0;
}








-(void)addSecondView
{
    UIView *secondView = [[UIView alloc]init];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80+kCellHeight*3+20*2);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight*2);
    }];
    
    //第一行
    UIView *cell1 = [[UIView alloc]init];
    [secondView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kselfWidth, kCellHeight));
        make.top.mas_equalTo(0);
    }];
    
    UILabel *leftLabel1 = [[UILabel alloc]init];
    leftLabel1.text = @"报修地址";
    leftLabel1.textColor = [UIColor blackColor];
    [leftLabel1 sizeToFit];
    leftLabel1.adjustsFontSizeToFitWidth = YES;
    [cell1 addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell1).with.offset(10);
        make.centerY.equalTo(cell1);
    }];
    _addressText = [[UITextField alloc]init];
    _addressText.placeholder = @"请输入地址";
    [cell1 addSubview:_addressText];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel1.mas_right).offset(20);
        make.centerY.equalTo(cell1);
        make.right.mas_equalTo(cell1).offset(-10);
        //make.size.width.mas_equalTo(200);
    }];
    
    //分割线
    UIView *firstLine = [[UIView alloc]initWithFrame:CGRectMake(10, kCellHeight, kselfWidth, 0.5)];
    firstLine.backgroundColor = kGray_Line_Color;
    [secondView addSubview:firstLine];
    
    //第二行
    UIView *cell2 = [[UIView alloc]init];
    [secondView addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel2 = [[UILabel alloc]init];
    leftLabel2.text = @"联系电话";
    leftLabel2.textColor = [UIColor blackColor];
    [cell2 addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell2);
    }];
    _numberText = [[UITextField alloc]init];
    _numberText.placeholder = @"请输入联系电话";
    [cell2 addSubview:_numberText];
    [_numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel2.mas_right).offset(20);
        make.centerY.equalTo(cell2);
        make.right.mas_equalTo(-10);
    }];
}

-(void)addThirdView
{
    UIView *thirdView = [[UIView alloc]init];
    [self.view addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80+20+kCellHeight*5+20+20);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(140);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"申报内容";
    label.textColor = kText_Color_Gray;
    [thirdView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    _contentText = [[UITextView alloc]init];
    _contentText.pagingEnabled = NO;
    _contentText.text = @"  请输入";
    _contentText.textColor = kText_Color_Gray;
    _contentText.backgroundColor = [UIColor whiteColor];
    _contentText.font = [UIFont systemFontOfSize:20];
    _contentText.delegate = self;
    [thirdView addSubview:_contentText];
    [_contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.and.right.mas_equalTo(0);
        make.bottom.equalTo(thirdView.mas_bottom);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_contentText.text isEqualToString:@"  请输入"]) {
        _contentText.text = @"";
        _contentText.textColor = [UIColor blackColor];
        _contentText.font = [UIFont systemFontOfSize:18];
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_contentText.text == nil || [_contentText.text isEqualToString:@""]) {
        _contentText.text = @"  请输入";
        _contentText.textColor = kText_Color_Gray;
        _contentText.font = [UIFont systemFontOfSize:20];
    }
}

-(void)addCommitButton
{
    UIButton *commitButton = [[UIButton alloc]init];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    commitButton.backgroundColor = kDeepGreen_Color;
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5;
    [self.view addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80+20+kCellHeight*5+20+20+140+20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [commitButton addTarget:self action:@selector(commitAplly) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _choicedTableView.alpha = 0;
}

-(void)commitAplly
{
    if ([_FWLXButton.titleLabel.text isEqualToString:@"服务类型"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请选择服务类型" inView:self.view hideAfterDelay:1];
        return;
    }
    if ([_FWXMButton.titleLabel.text isEqualToString:@"具体服务项目"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请选择服务项目" inView:self.view hideAfterDelay:1];
        return;
    }
    if ([_FWQYButton.titleLabel.text isEqualToString:@"重庆邮电大学"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请选择服务区域" inView:self.view hideAfterDelay:1];
        return;
    }
    if (_addressText.text == nil || [_addressText.text isEqualToString:@""]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请输入报修地址" inView:self.view hideAfterDelay:1];
        return;
    }
    if (_numberText.text == nil || [_numberText.text isEqualToString:@""]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请输入联系电话" inView:self.view hideAfterDelay:1];
        return;
    }
    NSString *studentId = [ZCYUserMgr sharedMgr].studentNumber;
    NSString *name = [ZCYUserMgr sharedMgr].userName;
    NSString *categoryId = _FWLXButton.titleLabel.text;
    NSString *specificId = _FWXMButton.titleLabel.text;
    NSString *phone = _numberText.text;
    NSString *addressId = _FWQYButton.titleLabel.text;
    NSString *address = _addressText.text;
    NSString *content = _contentText.text;
    
    NSDictionary *dic = [ZCYRepairApplyModel initToDataWithId:studentId name:name Ip:@"172.22.113.200" title:content CategoryId:categoryId specificId:specificId phone:phone addressId:addressId content:content address:address];
    
    [ZCYRepairApplyHelper CommitRepairApplyWithData:dic andCompeletionBlock:^(NSError *erro, NSString *str) {
        if ([str isEqualToString:@"OK"]) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交成功" inView:self.view hideAfterDelay:1];
        }else{
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交错误" inView:self.view hideAfterDelay:1];
        }
    }];
    
}



@end
