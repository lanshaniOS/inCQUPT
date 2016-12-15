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

@interface ZCYRepairApplyViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIView *firstTable;
@property (nonatomic,strong)UIView *secondTable;
@property (nonatomic,strong)UIButton *FWLXButton;
@property (nonatomic,strong)UIButton *FWXMButton;
@property (nonatomic,strong)UIButton *FWQYButton;
@property (nonatomic,strong)UITextField *addressText;
@property (nonatomic,strong)UITextField *numberText;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSArray *LXArray;
@property (nonatomic,strong)NSArray *choicedXmArray;
@property (nonatomic,strong)NSArray *QYMArray;
@property (nonatomic,strong)NSDictionary *choicedInfo;
@property (nonatomic,strong)NSDictionary *choicedQY;
@property (nonatomic,strong)UIPickerView *pickView;

@end

typedef enum tableType{
    FWLXTable = 0,
    FWXMTable = 1,
    FWQYTable = 2,
}tableType;

@implementation ZCYRepairApplyViewController
{
    tableType myTableType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _repairDates = [NSDictionary dictionaryWithDictionary:[ZCYUserMgr sharedMgr].repairInfomation];
    _LXArray = [_repairDates allKeys];
    _QYMArray = [NSArray arrayWithArray:[ZCYUserMgr sharedMgr].repairAddressChoices];
    
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
    myTableType = FWQYTable;
    if (_pickView != nil) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    [self addChoiceTableView];
}

-(void)choiceFWXM
{
    if (_choicedXmArray.count == 0 ||_choicedXmArray == nil) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请先选择服务类型" inView:self.view hideAfterDelay:1];
        return;
    }
    myTableType = FWXMTable;
    if (_pickView != nil) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    [self addChoiceTableView];
    
}

-(void)choiceFWLX
{
    myTableType = FWLXTable;
    if (_pickView != nil) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    [self addChoiceTableView];
    
}


-(void)addChoiceTableView
{
    
    self.pickView = [[UIPickerView alloc]init];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = LGray_Line_Color;
    [self.view addSubview:_pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(160);
    }];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (myTableType == FWLXTable) {
        return _LXArray.count;
    }else if (myTableType == FWXMTable){
        return _choicedXmArray.count;
    }else{
        return _QYMArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (myTableType == FWLXTable) {
        return _LXArray[row];
    }else if (myTableType == FWXMTable){
        NSDictionary *dic = _choicedXmArray[row];
        return dic[@"Name"];
    }else{
        NSDictionary *dic = _QYMArray[row];
        return dic[@"Name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (myTableType == FWLXTable) {
        [_FWLXButton setTitle:_LXArray[row] forState:UIControlStateNormal];
        NSString *key = _LXArray[row];
        NSArray *detailArr = [NSArray arrayWithArray:_repairDates[key]];
        _choicedXmArray = [NSArray arrayWithArray:detailArr];
    }else if (myTableType == FWXMTable){
        NSDictionary *dic = _choicedXmArray[row];
        _choicedInfo = [NSDictionary dictionaryWithDictionary:dic];
        [_FWXMButton setTitle:_choicedInfo[@"Name"] forState:UIControlStateNormal];
    }else{
        NSDictionary *dic = _QYMArray[row];
        _choicedQY = [NSDictionary dictionaryWithDictionary:dic];
        [_FWQYButton setTitle:dic[@"Name"] forState:UIControlStateNormal];
    }
    //    [_pickView removeFromSuperview];
    //    _pickView = nil;
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
    _addressText.delegate = self;
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
    _numberText.delegate = self;
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
    if (_pickView != nil) {
        
        [_pickView removeFromSuperview];
        _pickView = nil;
        
    }
    if ([_contentText.text isEqualToString:@"  请输入"]) {
        _contentText.text = @"";
        _contentText.textColor = [UIColor blackColor];
        _contentText.font = [UIFont systemFontOfSize:18];
    }
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_contentText.text == nil || [_contentText.text isEqualToString:@""]) {
        _contentText.text = @"  请输入";
        _contentText.textColor = kText_Color_Gray;
        _contentText.font = [UIFont systemFontOfSize:20];
    }
    
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_pickView != nil) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
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
    [self.pickView removeFromSuperview];
    _pickView = nil;
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
    if ([_contentText.text length] > 20) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"输入内容请少于20字" inView:self.view hideAfterDelay:1];
        return;
    }
    
    NSString *studentId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"];
    NSString *name = [ZCYUserMgr sharedMgr].userName;
    NSString *CategoryId = _choicedInfo[@"CategId"];
    NSString *SpecificId = _choicedInfo[@"Id"];
    NSString *phone = _numberText.text;
    NSString *AddressId = _choicedQY[@"Id"];
    NSString *address = _addressText.text;
    NSString *content = _contentText.text;
    NSString *title =  content.length > 10 ? [content substringToIndex:10]:content;
    NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@",studentId,name,CategoryId,SpecificId,phone,AddressId,address,title);
    NSDictionary *dic = [ZCYRepairApplyModel initToDataWithId:studentId name:name Ip:@"172.22.113.200" title:title CategoryId:CategoryId specificId:SpecificId phone:phone addressId:AddressId content:title address:address];
    [ZCYRepairApplyHelper CommitRepairApplyWithData:dic andCompeletionBlock:^(NSError *erro, NSString *str) {
        if (erro) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交错误" inView:self.view hideAfterDelay:1];
            return ;
        }
        if ([str isEqualToString:@"ok"]) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交成功" inView:self.view hideAfterDelay:1];
        }else{
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交错误" inView:self.view hideAfterDelay:1];
        }
    }];
    
}



@end
