//
//  ZCYEmptyClassViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYEmptyClassViewController.h"
#import "ZCYEmptyClassHelpr.h"

static const float animationTime = 0.15f;

@interface ZCYEmptyClassViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIImageView *backgroundImageView;  /**< 背景图片 */
@property (strong, nonatomic) UIView *bottomView;  /**< 底部视图 */
@property (strong, nonatomic) UILabel *classLabel;  /**< 教学楼 */
@property (strong, nonatomic) UIButton *selectedTimeButton;  /**< 消费详情 */
@property (strong, nonatomic) UILabel *weekTimeLabel;  /**< 截止日期 */
@property (strong, nonatomic) NSString *classString;  /**< 教学楼字符串 */
@property (strong, nonatomic) UIButton *finishButton;  /**< 完成按钮 */
@property (strong, nonatomic) UIPickerView *timePicker;  /**< 时间选择 */
@property (strong, nonatomic) UIButton *twoButton;  /**< 二教 */
@property (strong, nonatomic) UIButton *threeButton;  /**< 三教 */
@property (strong, nonatomic) UIButton *fourButton;  /**< 四教 */
@property (strong, nonatomic) UIButton *fiveButton;  /**< 五教 */
@property (strong, nonatomic) UIButton *eightButton;  /**< 八教 */
@property (strong, nonatomic) UIScrollView *showEmptyHouseView;  /**< 空教室 */
@property (strong, nonatomic) UILabel *oneLabel;  /**< 一楼 */
@property (strong, nonatomic) UILabel *twoLabel;  /**< 二楼 */
@property (strong, nonatomic) UILabel *threeLabel;  /**< 三楼 */
@property (strong, nonatomic) UILabel *fourLabel;  /**< 四楼 */
@property (strong, nonatomic) UILabel *fiveLabel;  /**< 五楼 */
@property (strong, nonatomic) UILabel *tipLabel;  /**< 提示框 */
@property (strong, nonatomic) UIControl *backgroundControl;  /**< 北京视图 */

@end

@implementation ZCYEmptyClassViewController
{
    CGFloat _screenWidth;
    CGFloat _screenHeight;
    CGFloat y_oldPanpoint;
    CGFloat sum_yOffset;
    NSArray *_shcoolWeekArray;
    NSArray *_weekArray;
    NSArray *_sectionArray;
    NSInteger _selectedBuilding;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (NSString *)title
{
    return @"空教室";
}

- (void)initUI
{
    _screenWidth = self.view.frame.size.width;
    _screenHeight = self.view.frame.size.height;
    _selectedBuilding = 2;
    _shcoolWeekArray = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", nil];
    _weekArray = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", nil];
    _sectionArray = [NSArray arrayWithObjects:@"1-2节", @"3-4节", @"5-6节", @"7-8节", @"9-10节", @"11-12节", nil];
    [self initBackgroundView];
    [self initClassIDButton];
    [self initBottomView];
    [self initTimePicker];
    [self initEmptyClassView];
}

- (void)initBackgroundView
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_background"]];
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(65);
    }];
}

- (void)initBottomView
{
    self.bottomView = [[UIView alloc] init];
    
    self.bottomView.backgroundColor = kCommonLightGray_Color;
    self.bottomView.alpha = 0.95f;
    self.bottomView.layer.shadowOpacity = 0.95f;
    self.bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bottomView.layer.shadowRadius = 3;
    self.bottomView.layer.shadowOffset= CGSizeMake(0, -0.5);
    self.bottomView.layer.cornerRadius = kStandardPx(18);
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(kStandardPx(18)/2);
        make.height.mas_equalTo(68);
        make.left.and.right.equalTo(self.view);
    }];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.bottomView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.and.left.equalTo(self.bottomView);
    }];
    
    self.classString = @"二教";
    self.classLabel = [[UILabel alloc] init];
    [self.classLabel setFont:kFont(kStandardPx(40)) andText:self.classString andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.bottomView addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.top.equalTo(self.bottomView).with.offset(10);
    }];
    
    self.weekTimeLabel = [[UILabel alloc] init];
    [self.weekTimeLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"第%@周 星期%@", [NSDate date].schoolWeekString, [NSDate date].weekString] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.bottomView addSubview:self.weekTimeLabel];
    [self.weekTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classLabel);
        make.top.equalTo(self.classLabel.mas_bottom).with.offset(2);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kCommonGray_Color;
    line.layer.cornerRadius = kStandardPx(5);
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(36, 5));
    }];
    
    self.selectedTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedTimeButton setTitle:@"选择时间" forState:UIControlStateNormal];
    [self.selectedTimeButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    self.selectedTimeButton.titleLabel.font = kFont(kStandardPx(34));
    [self.selectedTimeButton addTarget:self action:@selector(showTimePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.selectedTimeButton];
    [self.selectedTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(hideTimePickerView) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.titleLabel.font = kFont(kStandardPx(34));
    self.finishButton.hidden = YES;
    [self.bottomView addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimeSelectedView:)];
    [self.bottomView addGestureRecognizer:panGestureRecognizer];
}

- (void)initClassIDButton
{
    self.twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twoButton setBackgroundImage:[UIImage imageNamed:@"empty_2"] forState:UIControlStateNormal];
    [self.twoButton addTarget:self action:@selector(clickTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.twoButton setBackgroundImage:[UIImage imageNamed:@"empty_2s"] forState:UIControlStateSelected];
    [self.view addSubview:self.twoButton];
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16*self.view.frame.size.width/375);
        make.top.equalTo(self.view).with.offset(424*_screenHeight/667);
        make.size.mas_equalTo(CGSizeMake(85*self.view.frame.size.width/375, 109*_screenHeight/667));
    }];
    
    self.threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.threeButton setBackgroundImage:[UIImage imageNamed:@"empty_3"] forState:UIControlStateNormal];
    [self.threeButton addTarget:self action:@selector(clickThree) forControlEvents:UIControlEventTouchUpInside];
    [self.threeButton setBackgroundImage:[UIImage imageNamed:@"empty_3s"] forState:UIControlStateSelected];
    [self.view addSubview:self.threeButton];
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(200*self.view.frame.size.width/375);
        make.top.equalTo(self.view).with.offset(362*_screenHeight/667);
        make.size.mas_equalTo(CGSizeMake(85*self.view.frame.size.width/375, 109*_screenHeight/667));
    }];
    
    self.fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fourButton setBackgroundImage:[UIImage imageNamed:@"empty_4"] forState:UIControlStateNormal];
    [self.fourButton addTarget:self action:@selector(clickFour) forControlEvents:UIControlEventTouchUpInside];
    [self.fourButton setBackgroundImage:[UIImage imageNamed:@"empty_4s"] forState:UIControlStateSelected];
    [self.view addSubview:self.fourButton];
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(108*self.view.frame.size.width/375);
        make.top.equalTo(self.view).with.offset(222*_screenHeight/667);
        make.size.mas_equalTo(CGSizeMake(85*self.view.frame.size.width/375, 109*_screenHeight/667));
    }];
    
    self.fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"empty_5"] forState:UIControlStateNormal];
    [self.fiveButton addTarget:self action:@selector(clickFive) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"empty_5s"] forState:UIControlStateSelected];
    [self.view addSubview:self.fiveButton];
    [self.fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(212*self.view.frame.size.width/375);
        make.top.equalTo(self.view).with.offset(87*_screenHeight/667);
        make.size.mas_equalTo(CGSizeMake(85*self.view.frame.size.width/375, 109*_screenHeight/667));
    }];
    
    self.eightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eightButton setBackgroundImage:[UIImage imageNamed:@"empty_8"] forState:UIControlStateNormal];
    [self.eightButton addTarget:self action:@selector(clickEight) forControlEvents:UIControlEventTouchUpInside];
    [self.eightButton setBackgroundImage:[UIImage imageNamed:@"empty_8s"] forState:UIControlStateSelected];
    [self.view addSubview:self.eightButton];
    [self.eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(278*self.view.frame.size.width/375);
        make.top.equalTo(self.view).with.offset(244*_screenHeight/667);
        make.size.mas_equalTo(CGSizeMake(85*self.view.frame.size.width/375, 109*_screenHeight/667));
    }];
}

- (void)initTimePicker
{
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.timePicker];
    if ([kDeviceVersion floatValue] >= 9.0)
    {
        [self.timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_bottom);
            make.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(215);
        }];

    } else {
        [self.timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_bottom).with.offset(-20);
            make.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(215+40);
        }];

    }
    
}

- (void)initEmptyClassView
{
    self.showEmptyHouseView = [[UIScrollView alloc] init];
    self.showEmptyHouseView.showsHorizontalScrollIndicator = NO;
    self.showEmptyHouseView.contentSize = CGSizeMake(self.view.frame.size.width, 220);
    self.showEmptyHouseView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.showEmptyHouseView];
    [self.showEmptyHouseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-215 - 68);
        make.height.mas_equalTo(220);
        make.left.and.right.equalTo(self.view);
    }];
    CGFloat fontSize = 30;
    self.oneLabel = [[UILabel alloc] init];
    [self.oneLabel setFont:kFont(kStandardPx(fontSize)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.oneLabel.numberOfLines = 0;
    [self.showEmptyHouseView addSubview:self.oneLabel];
    
    self.twoLabel = [[UILabel alloc] init];
    [self.twoLabel setFont:kFont(kStandardPx(fontSize)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.twoLabel.numberOfLines = 0;
    [self.showEmptyHouseView addSubview:self.twoLabel];
    
    self.threeLabel = [[UILabel alloc] init];
    [self.threeLabel setFont:kFont(kStandardPx(fontSize)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.threeLabel.numberOfLines = 0;
    [self.showEmptyHouseView addSubview:self.threeLabel];
    
    self.fourLabel = [[UILabel alloc] init];
    [self.fourLabel setFont:kFont(kStandardPx(fontSize)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.fourLabel.numberOfLines = 0;
    [self.showEmptyHouseView addSubview:self.fourLabel];
    
    self.fiveLabel = [[UILabel alloc] init];
    [self.fiveLabel setFont:kFont(kStandardPx(fontSize)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.fiveLabel.numberOfLines = 0;
    [self.showEmptyHouseView addSubview:self.fiveLabel];
    
    NSArray *viewArray = @[self.oneLabel, self.twoLabel, self.threeLabel, self.fourLabel, self.fiveLabel];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:8 leadSpacing:10 tailSpacing:0];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.width.mas_equalTo(self.view.frame.size.width - 15);
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    [self.tipLabel setFont:kFont(kStandardPx(40)) andText:@"加载中..." andTextColor:kCommonText_Color andBackgroundColor:kCommonLightGray_Color];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipLabel];
    self.tipLabel.hidden = YES;
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-215 - 68);
        make.height.mas_equalTo(220);
        make.left.and.right.equalTo(self.view);
    }];
    
    self.showEmptyHouseView.hidden = YES;
    
    self.backgroundControl = [[UIControl alloc] init];
    self.backgroundControl.backgroundColor = kCommonText_Color;
    self.backgroundControl.alpha = 0.8;
    [self.backgroundControl addTarget:self action:@selector(hideTimePickerView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundControl];
    [self.backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-215 - 68 - 220);
    }];
    self.backgroundControl.hidden = YES;
    
}
#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _shcoolWeekArray.count - [NSDate date].schoolWeek + 1;
    } else if (component == 1) {
        if ([self.timePicker selectedRowInComponent:0] != 0)
        {
            return _weekArray.count;
        } else {
            return _weekArray.count - [NSDate date].week;
        }
    } else {
        return _sectionArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width/3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"第%@周", _shcoolWeekArray[row + [NSDate date].schoolWeek - 1]];
    } else if (component == 1) {
        if ([self.timePicker selectedRowInComponent:0] != 0)
        {
            return [NSString stringWithFormat:@"星期%@", _weekArray[row]];
        } else {
            return [NSString stringWithFormat:@"星期%@", _weekArray[row + [NSDate date].week - 1]];
        }
    } else {
        return [NSString stringWithFormat:@"%@", _sectionArray[row]];
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.timePicker reloadComponent:1];
    NSInteger week = [self.timePicker selectedRowInComponent:0] == 0 ? [self.timePicker selectedRowInComponent:1] + [NSDate date].week + 1 : [self.timePicker selectedRowInComponent:1];
    [self getEmptyHouseWithBuilding:_selectedBuilding andSchoolWeek:[self.timePicker selectedRowInComponent:0] + [NSDate date].schoolWeek + 1 andWeek:week andSection:[self.timePicker selectedRowInComponent:2]];
    
    NSString *weekString;
    if ([self.timePicker selectedRowInComponent:0] == 0)
    {
        weekString = _weekArray[[self.timePicker selectedRowInComponent:1] + [NSDate date].week - 1];
    } else {
        weekString = _weekArray[[self.timePicker selectedRowInComponent:1]];
    }
    self.weekTimeLabel.text = [NSString stringWithFormat:@"第%@周 星期%@", _shcoolWeekArray[[self.timePicker selectedRowInComponent:0] + [NSDate date].schoolWeek - 1], weekString];

}
#pragma mark - 点击事件
- (void)clickTwo
{
    _selectedBuilding = 2;
    self.twoButton.selected = YES;
    self.threeButton.selected = NO;
    self.fourButton.selected = NO;
    self.fiveButton.selected = NO;
    self.eightButton.selected = NO;
    self.classLabel.text = @"二教";
    [self showTimePickerView];
}

- (void)clickThree
{
    _selectedBuilding = 3;
    self.twoButton.selected = NO;
    self.threeButton.selected = YES;
    self.fourButton.selected = NO;
    self.fiveButton.selected = NO;
    self.eightButton.selected = NO;

    self.classLabel.text = @"三教";
    [self showTimePickerView];
}

- (void)clickFive
{
    _selectedBuilding = 5;
    self.twoButton.selected = NO;
    self.threeButton.selected = NO;
    self.fourButton.selected = NO;
    self.fiveButton.selected = YES;
    self.eightButton.selected = NO;

    self.classLabel.text = @"五教";
    [self showTimePickerView];
}

- (void)clickFour
{
    _selectedBuilding = 4;
    self.twoButton.selected = NO;
    self.threeButton.selected = NO;
    self.fourButton.selected = YES;
    self.fiveButton.selected = NO;
    self.eightButton.selected = NO;
    self.classLabel.text = @"四教";
    
    [self showTimePickerView];
}

- (void)clickEight
{
    _selectedBuilding = 8;
    self.twoButton.selected = NO;
    self.threeButton.selected = NO;
    self.fourButton.selected = NO;
    self.fiveButton.selected = NO;
    self.eightButton.selected = YES;
    self.classLabel.text = @"八教";
    [self showTimePickerView];
}

- (void)showTimePickerView
{
    self.selectedTimeButton.hidden = YES;
    self.backgroundControl.hidden = NO;
    self.finishButton.hidden = NO;
    sum_yOffset = -215;
    [UIView animateWithDuration:animationTime animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-215);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];

    self.showEmptyHouseView.hidden = NO;
    NSInteger week = [self.timePicker selectedRowInComponent:0] == 0 ? [self.timePicker selectedRowInComponent:1] + [NSDate date].week + 1 : [self.timePicker selectedRowInComponent:1];
    [self getEmptyHouseWithBuilding:_selectedBuilding andSchoolWeek:[self.timePicker selectedRowInComponent:0] + [NSDate date].schoolWeek + 1 andWeek:week andSection:[self.timePicker selectedRowInComponent:2]];
}

- (void)hideTimePickerView
{
    self.showEmptyHouseView.hidden = YES;
    self.backgroundControl.hidden = YES;
    NSString *weekString;
    if ([self.timePicker selectedRowInComponent:0] == 0)
    {
        weekString = _weekArray[[self.timePicker selectedRowInComponent:1] + [NSDate date].week - 1];
    } else {
        weekString = _weekArray[[self.timePicker selectedRowInComponent:1]];
    }
    self.weekTimeLabel.text = [NSString stringWithFormat:@"第%@周 星期%@", _shcoolWeekArray[[self.timePicker selectedRowInComponent:0] + [NSDate date].schoolWeek - 1], weekString];
    self.selectedTimeButton.hidden = NO;
    self.finishButton.hidden = YES;
    sum_yOffset = 0;
    [UIView animateWithDuration:animationTime animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(kStandardPx(18)/2);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];

}

- (void)handleTimeSelectedView:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    if (gestureRecognizer.state != UIGestureRecognizerStateFailed)
    {
        if (y_oldPanpoint != 0)
            sum_yOffset = sum_yOffset + point.y - y_oldPanpoint;
        if (y_oldPanpoint != 0 && point.y > y_oldPanpoint) //下拉
        {
            
            if (self.bottomView.frame.size.height+self.bottomView.frame.origin.y != self.view.frame.size.height + 4.5)
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).with.offset(sum_yOffset+kStandardPx(18)/2);
                }];
            if (self.bottomView.frame.size.height+self.bottomView.frame.origin.y >= self.view.frame.size.height + kStandardPx(18)/2)
            {
                [self hideTimePickerView];
            }
            
            
            if (gestureRecognizer.state == 3)
            {
                [self hideTimePickerView];
            }
            
            point.y -= 0.5;
        } else if (point.y < y_oldPanpoint){
            if (sum_yOffset <= -215)
            {
                sum_yOffset = -215;
            }
            
            if (sum_yOffset >= 215)
            {
                sum_yOffset = 215;
            }
            
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(sum_yOffset+kStandardPx(18)/2);
            }];
            
            
            if (self.view.frame.size.height - self.bottomView.frame.origin.y - self.bottomView.frame.size.height >= 215)
            {
                [self showTimePickerView];
            }
            
            if (gestureRecognizer.state == 3)
            {
                
                [self showTimePickerView];
            }
            point.y += 0.5;
        }
    }
    y_oldPanpoint = point.y;
    if (gestureRecognizer.state == 3)
    {
        y_oldPanpoint = 0;
    }
}

#pragma mark - network
- (void)getEmptyHouseWithBuilding:(NSInteger)building andSchoolWeek:(NSInteger)schoolWeek
                          andWeek:(NSInteger)week andSection:(NSInteger)section
{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = @"加载中...";
    [ZCYEmptyClassHelpr getEmptyClassWithBuilding:building andSchoolWeek:schoolWeek andWeek:week andSection:section withCompletionBlock:^(NSError *error, NSArray *array) {
        self.tipLabel.hidden = YES;
        if (error)
        {
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"似乎没有数据哟...";
            return;
        }
        if (self.eightButton.selected == YES)
        {
            self.oneLabel.text = [NSString stringWithFormat:@"一楼: %@",[self stringWithArrary:array[0][@"room"]]];
            self.twoLabel.text = [NSString stringWithFormat:@"二楼: %@",[self stringWithArrary:array[1][@"room"]]];
            self.threeLabel.text = [NSString stringWithFormat:@"三楼: %@",[self stringWithArrary:array[2][@"room"]]];
            self.fiveLabel.hidden = YES;
            self.fourLabel.hidden = YES;

        } else {
            self.fiveLabel.hidden = NO;
            self.fourLabel.hidden = NO;
            self.oneLabel.text = [NSString stringWithFormat:@"一楼: %@",[self stringWithArrary:array[0][@"room"]]];
            self.twoLabel.text = [NSString stringWithFormat:@"二楼: %@",[self stringWithArrary:array[1][@"room"]]];
            self.threeLabel.text = [NSString stringWithFormat:@"三楼: %@",[self stringWithArrary:array[2][@"room"]]];
            self.fourLabel.text = [NSString stringWithFormat:@"四楼: %@",[self stringWithArrary:array[3][@"room"]]];
            self.fiveLabel.text = [NSString stringWithFormat:@"五楼: %@",[self stringWithArrary:array[4][@"room"]]];
        }
    }];
}

- (NSString *)stringWithArrary:(NSArray *)array
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *string in array)
    {
         [mutableString appendString:[NSString stringWithFormat:@"%@ | ", string]];
    }
    return mutableString;
}
@end
