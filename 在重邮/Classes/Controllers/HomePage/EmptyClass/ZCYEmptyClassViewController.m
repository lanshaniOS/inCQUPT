//
//  ZCYEmptyClassViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYEmptyClassViewController.h"

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
    _shcoolWeekArray = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", nil];
    _weekArray = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", nil];
    _sectionArray = [NSArray arrayWithObjects:@"1-2节", @"3-4节", @"5-6节", @"7-8节", @"9-10节", @"11-12节", nil];
    [self initBackgroundView];
    [self initClassIDButton];
    [self initBottomView];
    [self initTimePicker];
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
        make.height.mas_equalTo(68+kStandardPx(18)/2);
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
    line.backgroundColor = kDeepGray_Color;
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
        make.left.equalTo(self.view).with.offset(16*375/self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(382*667/_screenHeight);
        make.size.mas_equalTo(CGSizeMake(85, 109));
    }];
    
    self.threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.threeButton setBackgroundImage:[UIImage imageNamed:@"empty_3"] forState:UIControlStateNormal];
    [self.threeButton addTarget:self action:@selector(clickThree) forControlEvents:UIControlEventTouchUpInside];
    [self.threeButton setBackgroundImage:[UIImage imageNamed:@"empty_3s"] forState:UIControlStateSelected];
    [self.view addSubview:self.threeButton];
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(201*375/self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(330*667/_screenHeight);
        make.size.mas_equalTo(CGSizeMake(85, 109));
    }];
    
    self.fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fourButton setBackgroundImage:[UIImage imageNamed:@"empty_4"] forState:UIControlStateNormal];
    [self.fourButton addTarget:self action:@selector(clickFour) forControlEvents:UIControlEventTouchUpInside];
    [self.fourButton setBackgroundImage:[UIImage imageNamed:@"empty_4s"] forState:UIControlStateSelected];
    [self.view addSubview:self.fourButton];
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(110*375/self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(190*667/_screenHeight);
        make.size.mas_equalTo(CGSizeMake(85, 109));
    }];
    
    self.fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"empty_5"] forState:UIControlStateNormal];
    [self.fiveButton addTarget:self action:@selector(clickFive) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"empty_5s"] forState:UIControlStateSelected];
    [self.view addSubview:self.fiveButton];
    [self.fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(214*375/self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(69*667/_screenHeight);
        make.size.mas_equalTo(CGSizeMake(85, 109));
    }];
    
    self.eightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eightButton setBackgroundImage:[UIImage imageNamed:@"empty_8"] forState:UIControlStateNormal];
    [self.eightButton addTarget:self action:@selector(clickEight) forControlEvents:UIControlEventTouchUpInside];
    [self.eightButton setBackgroundImage:[UIImage imageNamed:@"empty_8s"] forState:UIControlStateSelected];
    [self.view addSubview:self.eightButton];
    [self.eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(280*375/self.view.frame.size.width);
        make.top.equalTo(self.view).with.offset(212*667/_screenHeight);
        make.size.mas_equalTo(CGSizeMake(85, 109));
    }];
}

- (void)initTimePicker
{
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.timePicker];
    [self.timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(215);
    }];
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
        return _shcoolWeekArray.count;
    } else if (component == 1) {
        return _weekArray.count;
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
        return [NSString stringWithFormat:@"第%@周", _shcoolWeekArray[row]];
    } else if (component == 1) {
        return [NSString stringWithFormat:@"星期%@", _weekArray[row]];
    } else {
        return [NSString stringWithFormat:@"%@", _sectionArray[row]];
    }

}

#pragma mark - 点击事件
- (void)clickTwo
{
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
    self.finishButton.hidden = NO;
    sum_yOffset = -215;
    [UIView animateWithDuration:animationTime animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-215);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];

}

- (void)hideTimePickerView
{
    [self.timePicker selectedRowInComponent:0];
    [self.timePicker selectedRowInComponent:1];
    self.weekTimeLabel.text = [NSString stringWithFormat:@"第%@周 星期%@", _shcoolWeekArray[[self.timePicker selectedRowInComponent:0]], _weekArray[[self.timePicker selectedRowInComponent:1]]];
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
@end
