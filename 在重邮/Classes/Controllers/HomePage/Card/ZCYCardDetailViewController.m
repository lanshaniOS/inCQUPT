//
//  ZCYCardDetailViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/31.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCardDetailViewController.h"
#import "ZCYCardHelper.h"
#import "ZCYBezierPath.h"

@interface ZCYCardDetailViewController ()

@property (strong, nonatomic) UIView *bottomView;  /**< 底部视图 */
@property (strong, nonatomic) UILabel *balanceLabel;  /**< 余额 */
@property (strong, nonatomic) UIButton *payDetailButton;  /**< 消费详情 */
@property (strong, nonatomic) UILabel *closeDayLabel;  /**< 截止日期 */
@property (strong, nonatomic) UILabel *tipLabel;  /**< 提示 */
@property (strong, nonatomic) NSString *balanceString;  /**< 余额 */
@property (strong, nonatomic) UIButton *finishButton;  /**< 完成按钮 */
@property (strong, nonatomic) NSArray *cardArray;  /**< 消费 */
@property (strong, nonatomic) NSMutableArray *balanceArray;  /**< 消费数组 */

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
    [ZCYCardHelper getCardDetailWithCardID:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"] withCompletionBlock:^(NSError *error, NSArray *array) {
        if (error)
        {
            self.tipLabel.text = @"网络开小差啦～～～";
        } else {
            self.tipLabel.hidden = YES;
            self.balanceString = array[0][@"balance"];
            self.cardArray = array;
            [self initBottomView];
            
            NSMutableArray <NSValue *> *pointArray = [NSMutableArray array];
            for (NSInteger index = 0; index<10; index++)
            {
                CGFloat y = [self.cardArray[index][@"balance"] floatValue];
                [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/10 * index, (self.view.frame.size.height - 68 - y*6.67))]];
            }
            ZCYBezierPath *path = [[ZCYBezierPath alloc] initWithPointArray:pointArray];
            [path drawThirdBezierPathWithWidth:self.view.frame.size.width];
            path.backgroundColor = kCommonWhite_Color;
            [self.view addSubview:path];
            [path mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(self.view.frame.size.width/5/2);
                make.bottom.equalTo(self.view).with.offset(-68);
                make.right.equalTo(self.view);
                make.top.equalTo(self.view).with.offset(64);
            }];
            
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
        make.top.equalTo(self.bottomView).with.offset(10);
    }];
    
    self.closeDayLabel = [[UILabel alloc] init];
    [self.closeDayLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"截止昨日00:00"] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.bottomView addSubview:self.closeDayLabel];
    [self.closeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).with.offset(2);
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

#pragma mark - 冒泡排序
- (NSArray *)bubbleSortWithArray:(NSMutableArray *)mutableArray
{
    float bubble[10] = {[mutableArray[0] floatValue], [mutableArray[1] floatValue], [mutableArray[2] floatValue], [mutableArray[3] floatValue], [mutableArray[4] floatValue], [mutableArray[5] floatValue], [mutableArray[6] floatValue], [mutableArray[7] floatValue], [mutableArray[8] floatValue], [mutableArray[9] floatValue]};
    
    for (int i = 0; i<10; i++)
    {
        for (int j = 0; j<10-i; j++)
        {
            float temp;
            if (bubble[j] > bubble[j+1])
            {
                temp = bubble[j];
                bubble[j] = bubble[j+1];
                bubble[j+1] = temp;
            }
        }
    }
    return @[@(bubble[0]), @(bubble[1]), @(bubble[2]), @(bubble[3]), @(bubble[4]), @(bubble[5]), @(bubble[6]), @(bubble[7]), @(bubble[8]), @(bubble[9])];
}
@end
