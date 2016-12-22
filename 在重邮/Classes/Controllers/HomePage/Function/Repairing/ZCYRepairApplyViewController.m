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

#define kCellHeight 40
#define kselfWidth CGRectGetWidth(self.view.frame)

@interface ZCYRepairApplyViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIView *firstView;
@property (nonatomic,strong)UIView *secondView;
@property (strong, nonatomic) UIView *thirdView;  /**< 第三板块 */
@property (nonatomic,strong)UILabel *FWLXLabel;
@property (nonatomic,strong)UILabel *FWXMLabel;
@property (nonatomic,strong)UILabel *FWQYLabel;
@property (nonatomic,strong)UITextField *addressText;
@property (nonatomic,strong)UITextField *numberText;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSArray *LXArray;
@property (nonatomic,strong)NSArray *choicedXmArray;
@property (nonatomic,strong)NSArray *QYMArray;
@property (nonatomic,strong)NSDictionary *choicedInfo;
@property (nonatomic,strong)NSDictionary *choicedQY;
@property (nonatomic,strong)UIPickerView *pickView;
@property (strong, nonatomic) UIView *pickerTopView;  /**< 选择栏顶部 */
@property (strong, nonatomic) UIButton *commitButton;  /**< 提交按钮 */
@property (strong, nonatomic) UIControl *backgroundControl;  /**< 背景控制板 */

@end

typedef enum tableType{
    FWLXTable = 0,
    FWXMTable = 1,
    FWQYTable = 2,
}tableType;

@implementation ZCYRepairApplyViewController
{
    tableType myTableType;
    CGFloat y_commitButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _repairDates = [NSDictionary dictionaryWithDictionary:[ZCYUserMgr sharedMgr].repairInfomation];
    _LXArray = [_repairDates allKeys];
    _QYMArray = [NSArray arrayWithArray:[ZCYUserMgr sharedMgr].repairAddressChoices];
    
    self.view.backgroundColor = kCommonLightGray_Color;
    self.title = @"服务申报";
    [self initPickerView];
    [self addFirstView];
    [self addSecondView];
    [self addThirdView];
    [self addCommitButton];
    if ([ZCYUserMgr sharedMgr].repairInfomation == nil) {
        [[ZCYProgressHUD sharedHUD]showWithText:@"服务申报暂时产生错误" inView:self.view hideAfterDelay:1];
//        _FWLXButton.enabled = NO;
//        _FWXMButton.enabled = NO;
//        _FWQYButton.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    y_commitButton = self.commitButton.frame.origin.y+self.commitButton.frame.size.height;
    
}
-(void)addFirstView
{
    self.firstView = [[UIView alloc]init];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(80+20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kCellHeight*3);
    }];
    //第一行
    UIView *cell1 = [[UIView alloc]init];
    [self.firstView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel1 = [[UILabel alloc]init];
    leftLabel1.text = @"服务类型";
    leftLabel1.font = kFont(14);
    [cell1 addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell1);
    }];
    
    UILabel *next1Label = [[UILabel alloc] init];
    [next1Label setFont:kFont(17) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell1 addSubview:next1Label];
    [next1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell1).with.offset(-10);
        make.centerY.equalTo(cell1);
    }];
    
    _FWLXLabel = [[UILabel alloc]init];
    [_FWLXLabel setFont:kFont(14) andText:@"服务类型" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
   ;
    [cell1 addSubview:_FWLXLabel];
    [_FWLXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(next1Label.mas_left).offset(-5);
        make.centerY.equalTo(cell1);
    }];
    UITapGestureRecognizer *tapCell1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceFWLX)];
    [cell1 addGestureRecognizer:tapCell1];

    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, kCellHeight, kselfWidth, 0.5)];
    line1.backgroundColor = kCommonGray_Color;
    [self.firstView addSubview:line1];
    //第二行
    UIView *cell2 = [[UIView alloc]init];
    [self.firstView addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel2 = [[UILabel alloc]init];
    leftLabel2.text = @"服务项目";
    leftLabel2.font = kFont(14);
    [cell2 addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.center.equalTo(cell2);
    }];
    
    UILabel *next2Label = [[UILabel alloc] init];
    [next2Label setFont:kFont(17) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell2 addSubview:next2Label];
    [next2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell2).with.offset(-10);
        make.centerY.equalTo(cell2);
    }];
    
    _FWXMLabel = [[UILabel alloc]init];
    [_FWXMLabel setFont:kFont(14) andText:@"具体服务项目" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell2 addSubview:_FWXMLabel];
    [_FWXMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(next2Label.mas_left).offset(-5);
        make.centerY.equalTo(cell2);
    }];

    UITapGestureRecognizer *tapCell2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceFWXM)];
    [cell2 addGestureRecognizer:tapCell2];
    
    //分割线
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, kCellHeight*2, kselfWidth, 0.5)];
    line2.backgroundColor = kCommonGray_Color;
    [self.firstView addSubview:line2];
    //第三行
    UIView *cell3 = [[UIView alloc]init];
    [self.firstView addSubview:cell3];
    [cell3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight*2);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel3 = [[UILabel alloc]init];
    leftLabel3.text = @"服务区域";
    leftLabel3.font = kFont(14);
    [cell3 addSubview:leftLabel3];
    [leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell3);
    }];
    
    UILabel *next3Label = [[UILabel alloc] init];
    [next3Label setFont:kFont(17) andText:@">" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell3 addSubview:next3Label];
    [next3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell3).with.offset(-10);
        make.centerY.equalTo(cell3);
    }];
    _FWQYLabel = [[UILabel alloc]init];
    [_FWQYLabel setFont:kFont(14) andText:@"服务区域" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [cell3 addSubview:_FWQYLabel];
    [_FWQYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(next3Label.mas_left).offset(-5);
        make.centerY.equalTo(cell3);
    }];
    UITapGestureRecognizer *tapCell3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceFWQY)];
    [cell3 addGestureRecognizer:tapCell3];
}

-(void)choiceFWQY
{
    myTableType = FWQYTable;
//    if (_pickView != nil) {
//        [_pickView removeFromSuperview];
//        _pickView = nil;
//    }
    [self.pickView reloadAllComponents];
    NSDictionary *dic = _QYMArray[[self.pickView selectedRowInComponent:0]];
    _choicedQY = [NSDictionary dictionaryWithDictionary:dic];
    
    [self addChoiceTableView];
}

-(void)choiceFWXM
{
    if ([_FWLXLabel.text  isEqualToString: @"服务类型"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请先选择服务类型" inView:self.view hideAfterDelay:1];
        return;
    }
    myTableType = FWXMTable;
    
    NSString *key = _FWLXLabel.text;
    NSArray *detailArr = [NSArray arrayWithArray:_repairDates[key]];
    _choicedXmArray = [NSArray arrayWithArray:detailArr];
    
//    NSDictionary *dic = _choicedXmArray[[self.pickView selectedRowInComponent:0]];
//    _choicedInfo = [NSDictionary dictionaryWithDictionary:dic];
//    if (_pickView != nil) {
//        [_pickView removeFromSuperview];
//        _pickView = nil;
//    }
    [self.pickView reloadAllComponents];
    [self addChoiceTableView];
    
}

-(void)choiceFWLX
{
    myTableType = FWLXTable;
//    if (_pickView != nil) {
//        [_pickView removeFromSuperview];
//        _pickView = nil;
//    }
    [self.pickView reloadAllComponents];
    [self addChoiceTableView];
    
}

- (void)initPickerView
{
    self.pickerTopView = [[UIView alloc] init];
    self.pickerTopView.backgroundColor = kCommonGray_Color;
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerTopView];
    [self.pickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        make.left.and.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerTopView addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pickerTopView).with.offset(-15);
        make.centerY.equalTo(self.pickerTopView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.pickView = [[UIPickerView alloc]init];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = kCommonWhite_Color;
    [[UIApplication sharedApplication].keyWindow addSubview:_pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.pickerTopView.mas_bottom);
        make.height.mas_equalTo(160);
    }];
    
    self.backgroundControl = [[UIControl alloc] init];
    self.backgroundControl.backgroundColor = kCommonText_Color;
    [self.backgroundControl addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundControl.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundControl];
    [self.backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo(self.pickerTopView.mas_top);
    }];

}

-(void)addChoiceTableView
{
    [self showPickerView];
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
        _FWLXLabel.text = _LXArray[row];
    }else if (myTableType == FWXMTable){
        NSDictionary *dic = _choicedXmArray[row];
        _choicedInfo = [NSDictionary dictionaryWithDictionary:dic];
        _FWXMLabel.text = _choicedInfo[@"Name"];
    }else{
        NSDictionary *dic = _QYMArray[row];
        _choicedQY = [NSDictionary dictionaryWithDictionary:dic];
        _FWQYLabel.text = dic[@"Name"];
    }
    //    [_pickView removeFromSuperview];
    //    _pickView = nil;
}



-(void)addSecondView
{
    self.secondView = [[UIView alloc]init];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom).with.offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight*2);
    }];
    
    //第一行
    UIView *cell1 = [[UIView alloc]init];
    [self.secondView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kselfWidth, kCellHeight));
        make.top.mas_equalTo(0);
    }];
    
    UILabel *leftLabel1 = [[UILabel alloc]init];
    leftLabel1.text = @"报修地址";
    leftLabel1.textColor = [UIColor blackColor];
    [leftLabel1 sizeToFit];
    [leftLabel1 setFont:kFont(14)];
    leftLabel1.adjustsFontSizeToFitWidth = YES;
    [cell1 addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell1).with.offset(10);
        make.centerY.equalTo(cell1);
    }];
    _addressText = [[UITextField alloc]init];
    _addressText.delegate = self;
    _addressText.placeholder = @"请输入地址";
    _addressText.font = kFont(14);
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
    [self.secondView addSubview:firstLine];
    
    //第二行
    UIView *cell2 = [[UIView alloc]init];
    [self.secondView addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCellHeight);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kCellHeight);
    }];
    UILabel *leftLabel2 = [[UILabel alloc]init];
    leftLabel2.text = @"联系电话";
    leftLabel2.font = kFont(14);
    leftLabel2.textColor = [UIColor blackColor];
    [cell2 addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(cell2);
    }];
    _numberText = [[UITextField alloc]init];
    _numberText.delegate = self;
    _numberText.placeholder = @"请输入联系电话";
    _numberText.font = kFont(14);
    [cell2 addSubview:_numberText];
    [_numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel2.mas_right).offset(20);
        make.centerY.equalTo(cell2);
        make.right.mas_equalTo(-10);
    }];
}

-(void)addThirdView
{
    self.thirdView = [[UIView alloc]init];
    [self.view addSubview:self.thirdView];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom).with.offset(20);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(140);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"申报内容";
    label.font = kFont(14);
    label.textColor = kText_Color_Gray;
    [self.thirdView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    _contentText = [[UITextView alloc]init];
    _contentText.pagingEnabled = NO;
    _contentText.text = @"  请输入报修详情";
    _contentText.textColor = kCommonGray_Color;
    _contentText.backgroundColor = [UIColor whiteColor];
    _contentText.font = [UIFont systemFontOfSize:14];
    _contentText.delegate = self;
    [self.thirdView addSubview:_contentText];
    [_contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.and.right.mas_equalTo(0);
        make.bottom.equalTo(self.thirdView.mas_bottom);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if (_pickView != nil) {
//        
//        [self hidePickerView];
//        
//    }
    if ([_contentText.text isEqualToString:@"  请输入报修详情"]) {
        _contentText.text = @"";
        _contentText.textColor = [UIColor blackColor];
        _contentText.font = [UIFont systemFontOfSize:14];
    }
//    //滑动效果（动画）
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
//    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_contentText.text == nil || [_contentText.text isEqualToString:@""]) {
        _contentText.text = @"  请输入报修详情";
        _contentText.textColor = kCommonGray_Color;
        _contentText.font = [UIFont systemFontOfSize:14];
    }
    
    //滑动效果
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //恢复屏幕
//    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
//    
//    [UIView commitAnimations];
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    if (_pickView != nil) {
//        [self hidePickerView];
//    }
//    //滑动效果（动画）
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
//    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
//    
//    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    //滑动效果
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //恢复屏幕
//    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
//    
//    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrameAfterShow = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.2f animations:^{
        [self.firstView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(100+(keyboardFrameAfterShow.origin.y - y_commitButton));
        }];
        [self.firstView.superview layoutIfNeeded];
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.firstView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(100);
        }];
        [self.firstView.superview layoutIfNeeded];
    }];
}

-(void)addCommitButton
{
    self.commitButton = [[UIButton alloc]init];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = kDeepGreen_Color;
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitButton.layer.cornerRadius = 5;
    [self.view addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.commitButton addTarget:self action:@selector(commitAplly) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self hidePickerView];
}

-(void)commitAplly
{
    if ([_FWLXLabel.text isEqualToString:@"服务类型"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请选择服务类型" inView:self.view hideAfterDelay:1];
        return;
    }
    if ([_FWXMLabel.text isEqualToString:@"具体服务项目"]) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请选择服务项目" inView:self.view hideAfterDelay:1];
        return;
    }
    if ([_FWQYLabel.text isEqualToString:@"重庆邮电大学"]) {
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
    NSDictionary *dic = [ZCYRepairApplyModel initToDataWithId:studentId name:name Ip:@"172.22.113.200" title:title CategoryId:CategoryId specificId:SpecificId phone:phone addressId:AddressId content:title address:address];
    [ZCYRepairApplyHelper CommitRepairApplyWithData:dic andCompeletionBlock:^(NSError *erro, NSString *str) {
        if (erro) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交错误" inView:self.view hideAfterDelay:1];
            return ;
        }
        if ([str isEqualToString:@"ok"]) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交成功" inView:self.view hideAfterDelay:1.5f WithCompletionBlock:^{
                 [self.navigationController popViewControllerAnimated:YES];
            }];
           
        }else{
            [[ZCYProgressHUD sharedHUD] showWithText:@"提交错误" inView:self.view hideAfterDelay:1];
        }
    }];
    
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.pickerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];

        [self.pickerTopView.superview layoutIfNeeded];
        self.backgroundControl.alpha = 0.0f;
    }];
    [self.pickView selectRow:[self.pickView selectedRowInComponent:0] inComponent:0 animated:NO];
    switch (myTableType) {
        case 0:
        {
            if (self.FWXMLabel.text != _LXArray[[self.pickView selectedRowInComponent:0]])
                self.FWXMLabel.text = @"具体服务项目";
            self.FWLXLabel.text = _LXArray[[self.pickView selectedRowInComponent:0]];
            break;
        }
        case 1:
            self.FWXMLabel.text = _choicedXmArray[[self.pickView selectedRowInComponent:0]][@"Name"];
            break;
        case 2:
            self.FWQYLabel.text = _QYMArray[[self.pickView selectedRowInComponent:0]][@"Name"];
        default:
            break;
    }
//    self.pickView = nil;
}

- (void)showPickerView
{
    
    if (myTableType == FWXMTable){
        NSDictionary *dic = _choicedXmArray[[self.pickView selectedRowInComponent:0]];
        _choicedInfo = [NSDictionary dictionaryWithDictionary:dic];
        _FWXMLabel.text = _choicedInfo[@"Name"];
    }else if (myTableType == FWQYTable) {
        NSDictionary *dic = _QYMArray[[self.pickView selectedRowInComponent:0]];
        _choicedQY = [NSDictionary dictionaryWithDictionary:dic];
        _FWQYLabel.text = dic[@"Name"];
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self.pickerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).with.offset(-200);
        }];
        self.backgroundControl.alpha = 0.6f;
        [self.pickerTopView.superview layoutIfNeeded];
    }];
}
@end
