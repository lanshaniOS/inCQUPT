//
//  ZCYCardDetailViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/31.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCardDetailViewController.h"
#import "ZCYCardHelper.h"

@interface ZCYCardDetailViewController ()

@property (strong, nonatomic) UIView *bottomView;  /**< 底部视图 */
@property (strong, nonatomic) UILabel *balanceLabel;  /**< 余额 */
@property (strong, nonatomic) UIButton *payDetailButton;  /**< 消费详情 */
@property (strong, nonatomic) UILabel *closeDayLabel;  /**< 截止日期 */
@property (strong, nonatomic) UILabel *tipLabel;  /**< 提示 */
@property (strong, nonatomic) NSString *balanceString;  /**< 余额 */
@property (strong, nonatomic) UIButton *finishButton;  /**< 完成按钮 */

@end

@implementation ZCYCardDetailViewController

- (NSString *)title
{
    return @"一卡通";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI
{

    [self initTipLabel];
    [ZCYCardHelper getCardDetailWithCardID:@"1639777" withCompletionBlock:^(NSError *error, NSArray *array) {
        if (error)
        {
            self.tipLabel.text = @"网络开小差啦～～～";
        } else {
            self.tipLabel.hidden = YES;
            [self initBottomView];
        }
    }];
}

- (void)initTipLabel
{
    self.tipLabel = [[UILabel alloc] init];
    [self.tipLabel setFont:kFont(kStandardPx(50)) andText:@"获取数据中..." andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.equalTo(self.view);
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
    
    self.balanceLabel = [[UILabel alloc] init];
    NSString *balcanc = [NSString stringWithFormat:@"余额%@元",self.balanceString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:balcanc];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepGreen_Color range:NSMakeRange(2, balcanc.length - 3)];
    [self.balanceLabel setFont:kFont(kStandardPx(40)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.balanceLabel.attributedText = attributedString;
    [self.bottomView addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.top.equalTo(self.bottomView).with.offset(15);
    }];
    
    self.closeDayLabel = [[UILabel alloc] init];
    [self.closeDayLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"截止昨日00:00"] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.bottomView addSubview:self.closeDayLabel];
    [self.closeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).with.offset(5);
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
    
    self.payDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payDetailButton setTitle:@"消费详情" forState:UIControlStateNormal];
    [self.payDetailButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    self.payDetailButton.titleLabel.font = kFont(kStandardPx(34));
    [self.payDetailButton addTarget:self action:@selector(showPayDetailedView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.payDetailButton];
    [self.payDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(hidePayDetailedView) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.titleLabel.font = kFont(kStandardPx(34));
    self.finishButton.hidden = YES;
    [self.bottomView addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
//    UISwipeGestureRecognizer *upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showWeekSelectedView)];
//    upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.bottomView addGestureRecognizer:upGestureRecognizer];
//    
//    UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideWeekSelectedView)];
//    downGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.bottomView addGestureRecognizer:downGestureRecognizer];
//    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeekSelectedView:)];
//    [self.bottomView addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - 点击事件
- (void)showPayDetailedView
{
    
}

- (void)hidePayDetailedView
{
    
}
@end
