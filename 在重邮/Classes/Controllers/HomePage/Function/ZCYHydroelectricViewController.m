//
//  ZCYHydroelectricViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/25.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHydroelectricViewController.h"
#import "ZCYDormitoryHelper.h"

@interface ZCYHydroelectricViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *bindPickerView;  /**< 绑定寝室 */
@property (strong, nonatomic) UIView *pickerTopView;  /**< 选择蓝顶部 */
@property (strong, nonatomic) UIControl *backgroundControl;  /**< 背景黑框 */
@property (strong, nonatomic) NSArray *buildArray;  /**< 楼栋 */
@property (strong, nonatomic) NSArray *buildNumArray;  /**< 楼栋号 */
@property (strong, nonatomic) NSArray *floorArray;  /**< 楼层 */
@property (strong, nonatomic) NSArray *roomArray;  /**< 房间 */
@property (strong, nonatomic) UILabel *totalLabel;  /**< 用电度数 */
@property (strong, nonatomic) UILabel *timeLabel;  /**< 抄表时间 */
@property (strong, nonatomic) UILabel *startLabel;  /**< 起始度数 */
@property (strong, nonatomic) UILabel *endLabel;  /**< 终止度数 */
@property (strong, nonatomic) UILabel *freeLabel;  /**< 免费度数 */
@property (strong, nonatomic) UILabel *costLabel;  /**< 电费 */
@property (strong, nonatomic) UILabel *dormitoryLabel;  /**< 寝室号 */
@property (strong, nonatomic) NSDictionary *dormitoryDic;  /**< 寝室详情 */

@end

@implementation ZCYHydroelectricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}


- (NSString *)title
{
    return @"水电查询";
}

- (void)initUI
{
    [self initDetailView];
    [self initPickerView];
    self.buildArray = @[@"1栋（知行苑1舍）",@"2栋（知行苑2舍）", @"3栋（知行苑3舍）", @"4栋（知行苑4舍）", @"5栋（知行苑5舍）", @"6栋（知行苑6舍）", @"8栋（宁静苑1舍）", @"9栋（宁静苑2舍）", @"10栋（宁静苑3舍）", @"11栋（宁静苑4舍）", @"12栋（宁静苑5舍）", @"15栋（知行苑7舍）", @"16栋（知行苑8舍）", @"17栋（兴业苑1舍）", @"18栋（兴业苑2舍）", @"19栋（兴业苑3舍）", @"20栋（兴业苑4舍）", @"21栋（兴业苑5舍）", @"22栋（兴业苑6舍）", @"23A栋（兴业苑7舍）", @"23B栋（兴业苑8舍）", @"24栋（明理苑1舍）", @"25栋（明理苑2舍）", @"26栋（明理苑3舍）", @"27栋（明理苑4舍）", @"28栋（明理苑5舍）", @"29栋（明理苑6舍）", @"30栋（明理苑7舍）", @"31栋（明理苑8舍）", @"32栋（宁静苑6舍）", @"33栋（宁静苑7舍）", @"34栋（宁静苑8舍）", @"35栋（宁静苑9舍）", @"36栋（四海苑1舍）", @"37栋（四海苑2舍）", @"39栋（四海苑9舍）"];
    self.buildNumArray =  @[@"1",@"2", @"3", @"4", @"5", @"6", @"8", @"9", @"10", @"11", @"12", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23A", @"23B", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"39"];
    self.floorArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    self.roomArray = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48"];
    if ([ZCYUserMgr sharedMgr].dormitoryArray)
    {
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中..." inView:self.view];
        [ZCYDormitoryHelper getElectricDetailWithBuilding:[ZCYUserMgr sharedMgr].dormitoryArray[0] andFloor:[[ZCYUserMgr sharedMgr].dormitoryArray[2] integerValue] andRoom:[[ZCYUserMgr sharedMgr].dormitoryArray[3] integerValue] withCompeletionBlock:^(NSError *error, NSDictionary *resultDic) {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
            if (error || resultDic == nil || !resultDic || resultDic == NULL)
            {
                if (error)
                    [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
                else {
                    [[ZCYProgressHUD sharedHUD] showWithText:@"寝室号不正确" inView:self.view hideAfterDelay:1.0f];
                }
                return;
            }
            
//            [ZCYUserMgr sharedMgr].dormitoryArray  = @[self.buildNumArray[[self.bindPickerView selectedRowInComponent:0]], self.buildArray[[self.bindPickerView selectedRowInComponent:0]], self.floorArray[[self.bindPickerView selectedRowInComponent:1]], self.roomArray[[self.bindPickerView selectedRowInComponent:2]]];
            self.dormitoryDic = resultDic;
            
            [self updateDetailView];
        }];

    } else {
        [self bindDomitory];
    }
}

- (void)initPickerView
{
    self.pickerTopView = [[UIView alloc] init];
    self.pickerTopView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.pickerTopView];
    [self.pickerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerTopView addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pickerTopView).with.offset(-10);
        make.centerY.equalTo(self.pickerTopView);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbutton setBackgroundColor:kTransparentColor andTitle:@"取消" WithTitleColor:kDeepGray_Color andTarget:self WithClickAction:@selector(cancelButtonDidClick)];
    [self.pickerTopView addSubview:cancelbutton];
    [cancelbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickerTopView).with.offset(10);
        make.centerY.equalTo(finishButton);
        make.size.equalTo(finishButton);
    }];
    
    self.bindPickerView = [[UIPickerView alloc] init];
    self.bindPickerView.delegate = self;
    self.bindPickerView.dataSource = self;
    self.bindPickerView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.bindPickerView];
    if ([kDeviceVersion floatValue] >= 9.0)
    {
        [self.bindPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(self.pickerTopView.mas_bottom);
            make.height.mas_equalTo(215);
        }];
    } else {
        [self.bindPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(self.pickerTopView.mas_bottom).with.offset(-20);
            make.height.mas_equalTo(215+40);
        }];
    }
    
    
    self.backgroundControl = [[UIControl alloc] init];
    self.backgroundControl.backgroundColor = kCommonText_Color;
    self.backgroundControl.alpha = 0.6;
    [self.backgroundControl addTarget:self action:@selector(cancelButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundControl];
    [self.backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-255);
    }];
    self.backgroundControl.hidden = YES;
}

- (void)initDetailView
{
    UIView *dormitoryView = [[UIView alloc] init];
    dormitoryView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:dormitoryView];
    [dormitoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.view).with.offset(84);
        make.height.mas_equalTo(100);
    }];
    
    self.dormitoryLabel = [[UILabel alloc] init];
    [self.dormitoryLabel setFont:kFont(kStandardPx(50)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [dormitoryView addSubview:self.dormitoryLabel];
    [self.dormitoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dormitoryView).with.offset(18);
        make.top.equalTo(dormitoryView).with.offset(25);
    }];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.layer.masksToBounds = YES;
    resetButton.layer.cornerRadius = 4.0f;
    [resetButton setTitle:@"修改寝室" forState:UIControlStateNormal];
    [resetButton setTitleColor:kCommonWhite_Color forState:UIControlStateNormal];
    resetButton.backgroundColor = kDeepGreen_Color;
    resetButton.titleLabel.font = kFont(kStandardPx(26));
    [resetButton addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
    [dormitoryView addSubview:resetButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dormitoryView).with.offset(-18);
        make.top.equalTo(self.dormitoryLabel);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setFont:kFont(kStandardPx(28)) andText:@"" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [dormitoryView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dormitoryLabel);
        make.top.equalTo(self.dormitoryLabel.mas_bottom).with.offset(8);
    }];
    
    UIView *monthEleView = [[UIView alloc] init];
    monthEleView.backgroundColor  = kCommonLightGray_Color;
    [self.view addSubview:monthEleView];
    [monthEleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dormitoryView);
        make.top.equalTo(dormitoryView.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake((self.view.frame.size.width-40)/2, 100));
    }];
    
    UILabel *monthEleLabel = [[UILabel alloc] init];
    [monthEleLabel setFont:kFont(kStandardPx(28)) andText:@"当月用电" andTextColor:kCommonText_Color
        andBackgroundColor:kTransparentColor];
    [monthEleView addSubview:monthEleLabel];
    [monthEleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthEleView).with.offset(18);
        make.top.equalTo(monthEleView).with.offset(20);
    }];
    
    self.totalLabel = [[UILabel alloc] init];
    [self.totalLabel setFont:kFont(kStandardPx(80)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [monthEleView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(monthEleView);
        make.top.equalTo(monthEleLabel.mas_bottom).with.offset(10);
    }];
    
    UIView *monthCostView = [[UIView alloc] init];
    monthCostView.backgroundColor  = kCommonLightGray_Color;
    [self.view addSubview:monthCostView];
    [monthCostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthEleView.mas_right).with.offset(10);
        make.top.and.width.and.height.equalTo(monthEleView);
    }];
    
    UILabel *monthCostLabel = [[UILabel alloc] init];
    [monthCostLabel setFont:kFont(kStandardPx(28)) andText:@"当月电费" andTextColor:kCommonText_Color
        andBackgroundColor:kTransparentColor];
    [monthCostView addSubview:monthCostLabel];
    [monthCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthCostView).with.offset(18);
        make.top.equalTo(monthCostView).with.offset(20);
    }];
    
    self.costLabel = [[UILabel alloc] init];
    [self.costLabel setFont:kFont(kStandardPx(80)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [monthCostView addSubview:self.costLabel];
    [self.costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(monthCostView);
        make.top.equalTo(monthCostLabel.mas_bottom).with.offset(10);
    }];
    
    UIView *electricView = [[UIView alloc] init];
    electricView.backgroundColor  = kCommonLightGray_Color;
    [self.view addSubview:electricView];
    [electricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthEleView);
        make.top.equalTo(monthCostView.mas_bottom).with.offset(12);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];

    UIView *startView = [[UIView alloc] init];
    self.startLabel = [[UILabel alloc] init];
    [self setView:startView WithTitle:@"电费起始度数" andLabel:self.startLabel andLabelText:@""];
    [electricView addSubview:startView];
    
    UIView *endView = [[UIView alloc] init];
    self.endLabel = [[UILabel alloc] init];
    [self setView:endView WithTitle:@"电费截止度数" andLabel:self.endLabel andLabelText:@""];
    [electricView addSubview:endView];
    
    UIView *freeView = [[UIView alloc] init];
    self.freeLabel = [[UILabel alloc] init];
    [self setView:freeView WithTitle:@"当月免费电量" andLabel:self.freeLabel andLabelText:@""];
    [electricView addSubview:freeView];
    
    NSArray *viewArray = @[startView, endView, freeView];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:25 leadSpacing:25 tailSpacing:15];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(electricView).with.offset(18);
        make.centerX.equalTo(electricView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电费"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30.f;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

- (void)bindDomitory
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你还没有绑定寝室号哦～～～" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bindAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerView];
    }];
    [alertController addAction:bindAction];
    [self presentViewController:alertController animated:NO completion:nil];
    
}

#pragma mark - UIPickerViewDelegate&&UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.buildArray.count;
    } else if (component == 1) {
        return self.floorArray.count;
    } else {
        return self.roomArray.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.view.frame.size.width/1.39;
    } else if (component == 1) {
        return self.view.frame.size.width/9.1;
    } else {
        return self.view.frame.size.width/8.1;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.buildArray[row];
    } else if (component == 1) {
        return self.floorArray[row];
    } else {
        return self.roomArray[row];
    }
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.pickerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        [self.pickerTopView.superview layoutIfNeeded];
        self.backgroundControl.hidden = YES;
    }];

    [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中..." inView:self.view];
    [ZCYDormitoryHelper getElectricDetailWithBuilding:self.buildNumArray[[self.bindPickerView selectedRowInComponent:0]] andFloor:[self.bindPickerView selectedRowInComponent:1]+1 andRoom:[self.bindPickerView selectedRowInComponent:2]+1 withCompeletionBlock:^(NSError *error, NSDictionary *resultDic) {
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error || resultDic == nil || !resultDic || resultDic == NULL)
        {
            if (error)
            [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
            else {
                [[ZCYProgressHUD sharedHUD] showWithText:@"寝室号不正确" inView:self.view hideAfterDelay:1.0f];
            }
            return;
        }
        
        [ZCYUserMgr sharedMgr].dormitoryArray  = @[self.buildNumArray[[self.bindPickerView selectedRowInComponent:0]], self.buildArray[[self.bindPickerView selectedRowInComponent:0]], self.floorArray[[self.bindPickerView selectedRowInComponent:1]], self.roomArray[[self.bindPickerView selectedRowInComponent:2]]];
        ZCYUserMgr *userMgr = [ZCYUserMgr sharedMgr];
        NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:userMgr];
        [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
        self.dormitoryDic = resultDic;
        [self updateDetailView];
    }];
}

- (void)cancelButtonDidClick
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.pickerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        [self.pickerTopView.superview layoutIfNeeded];
        self.backgroundControl.hidden = YES;
    }];
}
- (void)updateDetailView
{
    self.dormitoryLabel.text = [NSString stringWithFormat:@"%@栋%@%@寝室", [ZCYUserMgr sharedMgr].dormitoryArray[0],  [ZCYUserMgr sharedMgr].dormitoryArray[2],  [ZCYUserMgr sharedMgr].dormitoryArray[3]];
    self.timeLabel.text = [NSString stringWithFormat:@"抄表时间：%@", self.dormitoryDic[@"record_time"]];
    NSString *totalString = [NSString stringWithFormat:@"%@度", self.dormitoryDic[@"elec_spend"]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attrString addAttribute:NSFontAttributeName value:kFont(kStandardPx(28)) range:NSMakeRange(totalString.length-1, 1)];
    self.totalLabel.attributedText = attrString;
    NSString *costString = [NSString stringWithFormat:@"%@元", self.dormitoryDic[@"elec_cost"]];
    NSMutableAttributedString *attrCostString = [[NSMutableAttributedString alloc] initWithString:costString];
    [attrCostString addAttribute:NSFontAttributeName value:kFont(kStandardPx(28)) range:NSMakeRange(costString.length-1, 1)];
    self.costLabel.attributedText = attrCostString;
    self.startLabel.text = self.dormitoryDic[@"elec_start"];
    self.endLabel.text = self.dormitoryDic[@"elec_end"];
    self.freeLabel.text = self.dormitoryDic[@"elec_free"];
    [ZCYUserMgr sharedMgr].dormitoryDic = self.dormitoryDic;
}
- (void)showPickerView
{
    [UIView animateWithDuration:0.0f animations:^{
        [self.pickerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(-255);
        }];
        [self.pickerTopView.superview layoutIfNeeded];
        self.backgroundControl.hidden = NO;
    }];

}

- (void)setView:(UIView *)view WithTitle:(NSString *)title andLabel:(UILabel *)label andLabelText:(NSString *)labelText
{
    view.backgroundColor = kTransparentColor;
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont(kStandardPx(28)) andText:title andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(8);
        make.top.equalTo(view);
    }];
    
    [label setFont:kFont(kStandardPx(40)) andText:labelText andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-8);
        make.top.equalTo(view);
    }];
    
}
@end
