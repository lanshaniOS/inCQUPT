//
//  ZCYHomePageViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHomePageViewController.h"
#import "ZCYSchoolCardViewController.h"
#import "ZCYHydroelectricViewController.h"
#import "ZCYPropertyRepairViewController.h"
#import "ZCYTimeTableHelper.h"
#import "ZCYTimeTableModel.h"
#import "ZCYCourseView.h"
#import "ZCYCourseViewController.h"
#import "ZCYCardDetailViewController.h"
#import "ZCYMoreFunctionViewController.h"
#import "ZCYCardHelper.h"
#import "ZCYCardDetailViewController.h"
#import "ZCYLendBookViewController.h"
#import "ZCYEmptyClassViewController.h"
#import "ZCYStudentSearchViewController.h"
#import "ZCYExaminationViewController.h"
#import "ZCYHomePageElecView.h"
#import "ZCYDormitoryHelper.h"


@interface ZCYHomePageViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 背景下拉板 */
@property (strong, nonatomic) UICollectionView *functionCollectionView;  /**< 功能板块 */
@property (strong, nonatomic) UIImageView *backgroundImageView;  /**< 背景图画 */
@property (strong, nonatomic) UIScrollView *courseScrollView;  /**< 课程滑动视图 */
@property (strong, nonatomic) UIView *cardView;  /**< 一卡通视图 */
@property (strong, nonatomic) UILabel *timeLabel;  /**< 时间标签 */
@property (strong, nonatomic) UILabel *summaryLabel;  /**< 课程数标签 */
@property (strong, nonatomic) UILabel *cardLabel;  /**< 余额 */
@property (strong, nonatomic) UILabel *weekLabel;  /**< 周次 */
@property (strong, nonatomic) ZCYHomePageElecView *electricView;  /**< 水电视图 */
@end

@implementation ZCYHomePageViewController
{
    CGFloat y_oldContentOffset;
    BOOL _isTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    if ([ZCYUserMgr sharedMgr].dormitoryArray)
    {
        [ZCYDormitoryHelper getElectricDetailWithBuilding:[ZCYUserMgr sharedMgr].dormitoryArray[0] andFloor:[[ZCYUserMgr sharedMgr].dormitoryArray[2] integerValue] andRoom:[[ZCYUserMgr sharedMgr].dormitoryArray[3] integerValue] withCompeletionBlock:^(NSError *error, NSDictionary *resultDic) {
            if (error)
            {
                [self.electricView updateViewWithElecString:@"数据加载似乎出现了问题"];
                return;
            }
            [ZCYUserMgr sharedMgr].dormitoryDic = resultDic;
            [self.electricView updateViewWithElecString:[NSString stringWithFormat:@"%@元",@([resultDic[@"elec_cost"] floatValue])]];
        }];
         
    }
    [ZCYCardHelper getCardDetailWithCardID:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"] withCompletionBlock:^(NSError *error, NSArray *array) {

        if (error)
        {
            self.cardLabel.text = @"数据加载途中出现了问题哦";
            return;
        }
        if (array || array.count!=0)
        {
            NSString *balanceString = [NSString stringWithFormat:@"%@元", @([array[0][@"balance"] floatValue])];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:balanceString];
            [attributeString addAttribute:NSFontAttributeName value:kFont(kStandardPx(120)) range:NSMakeRange(0, balanceString.length-1)];
            self.cardLabel.attributedText = attributeString;
        } else {
            self.cardLabel.text = @"数据加载途中似乎出现了问题哦";
        }
    }];
//    self.navigationController.navigationBar.alpha = (self.backgroundScrollView.contentOffset.y)/355 * 2.0;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [ZCYTimeTableHelper getTimeTableWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber shouldSaveTime:YES withCompeletionBlock:^(NSError *error, NSArray *array) {
        if (error)
        {
            return;
        }
        [ZCYUserMgr sharedMgr].courseArray = array;
        //            self.courseArray = [ZCYUserMgr sharedMgr].courseArray;
        NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ZCYUserMgr sharedMgr]];
        [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self updateUIWithArray:[ZCYUserMgr sharedMgr].courseArray];
        });
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.alpha = (self.backgroundScrollView.contentOffset.y)/355 * 2.0;
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.alpha = 1.0f;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initUI
{
    self.view.backgroundColor = kAppBg_Color;
    _isTop = YES;
    [self initBackgroundScrollView];
    [self initHeaderView];
    [self initFunctionCollectionView];
    [self initCourseScrollView];
    [self initCardView];
    [self setNavigationBar];
}

- (void)setNavigationBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initBackgroundScrollView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.backgroundColor = kCommonWhite_Color;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.scrollEnabled = YES;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 675+self.view.frame.size.height*467/667);
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    
}

- (void)initHeaderView
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
    [self.backgroundScrollView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.backgroundScrollView);
        make.height.mas_equalTo(self.view.frame.size.height * 255/667);
    }];
    
    UILabel *topicLabel = [[UILabel alloc] init];
    [self setLabel:topicLabel withText:@"今日" andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(80))];
    topicLabel.font = [UIFont systemFontOfSize:kStandardPx(80) weight:3.0f];
    [self.backgroundScrollView addSubview:topicLabel];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView).with.offset(50);
        make.left.equalTo(self.view).with.offset(18);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    [self setLabel:self.timeLabel withText: [NSString stringWithFormat:@"星期%@ %@月%@号", [NSDate date].weekString, @([NSDate date].month), @([NSDate date].day)] andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(22))];
    [self.backgroundScrollView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kCommonWhite_Color;
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = 1;
    [self.backgroundScrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(18);
        make.left.equalTo(self.timeLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(1);
    }];
    
    self.summaryLabel = [[UILabel alloc] init];
    __block NSInteger courseNum = 0;
    NSArray *todayCourseArray = [NSArray array];
    
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
    }

    
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        NSArray *todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
        
        [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZCYTimeTableModel *model = obj;
                NSArray *courseWeeks = model.courseWeeks;
                for (NSInteger i = 0; i<courseWeeks.count; i++)
                {
                    if ([courseWeeks[i] integerValue] == [ZCYUserMgr sharedMgr].shcoolWeek)
                    {
                         courseNum = courseNum + [model.courseNumber integerValue];
                    }
                }
            }];
        }];
    }
    NSString *tipString;
    if (courseNum>=0 && courseNum<4)
    {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课，放松一下吧", (long)courseNum];
    } else if (courseNum >=4 && courseNum < 8) {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课哦～，多撑一会吧", (long)courseNum];
    } else if (courseNum >=8 && courseNum <= 12) {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课...生无可恋", (long)courseNum];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:kStandardPx(64)] range:NSMakeRange(3, 2)];
    
    [self setLabel:self.summaryLabel withText:@"" andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(36))];
    self.summaryLabel.attributedText = attributedString;
    [self.backgroundScrollView addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(13);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)initFunctionCollectionView
{
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(38, 38);
    collectionLayout.minimumLineSpacing = 0;
    collectionLayout.minimumInteritemSpacing = 0;
    
    self.functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    [self.functionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"functionCollectionViewCellID"];
    self.functionCollectionView.backgroundColor = kCommonWhite_Color;
    self.functionCollectionView.scrollEnabled = NO;
    self.functionCollectionView.delegate = self;
    self.functionCollectionView.dataSource = self;
    [self.backgroundScrollView addSubview:self.functionCollectionView];
    [self.functionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor colorWithRGBHex:0xd8d8d8];
    [self.backgroundScrollView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.functionCollectionView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)initCourseScrollView
{
    UILabel *topicView = [[UILabel alloc] init];
    topicView.text = @"今日课表";
    topicView.textColor = kCommonText_Color;
    topicView.font = [UIFont systemFontOfSize:20 weight:2];
    [self.backgroundScrollView addSubview:topicView];
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundScrollView).with.offset(165+self.view.frame.size.height * 255/667);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(90);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
    self.weekLabel = [[UILabel alloc] init];
    self.weekLabel.textColor = kDeepGray_Color;
    self.weekLabel.text = [NSString stringWithFormat:@"第 %@ 周", @([ZCYUserMgr sharedMgr].shcoolWeek)];
    self.weekLabel.font = [UIFont fontWithName:@"Futra" size:16];
    [self.backgroundScrollView addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topicView.mas_right).with.offset(12);
        make.bottom.equalTo(topicView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *allCourseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [allCourseButton setTitle:@"全部课表" forState:UIControlStateNormal];
    [allCourseButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    allCourseButton.layer.masksToBounds = YES;
    allCourseButton.titleLabel.font = kFont(16);
    [allCourseButton addTarget:self action:@selector(pushToCourseVC) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:allCourseButton];
    [allCourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right).with.offset(-90);
        make.bottom.equalTo(topicView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    self.courseScrollView = [[UIScrollView alloc] init];
    NSArray *todayCourseArray = [NSArray array];
    
    self.courseScrollView.scrollEnabled = YES;
    self.courseScrollView.showsHorizontalScrollIndicator = NO;
    self.courseScrollView.showsVerticalScrollIndicator = NO;
    self.courseScrollView.backgroundColor = kCommonWhite_Color;
    [self.backgroundScrollView addSubview:self.courseScrollView];
    [self.courseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicView.mas_bottom).with.offset(13);
        make.height.mas_equalTo((self.view.frame.size.width-40)/2 + 38);
        make.left.and.right.equalTo(self.view);
    }];
    
    NSArray <UIColor *> *commonArray = @[kCommonGreen_Color, kCommonOrigin_Color, kCommonPink_Color];
    NSArray <UIColor *> *deepArray = @[kDeepGreen_Color, kDeepOrigin_Color, kDeepPink_Color];
    __block NSInteger index = 0;
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
        
        [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            NSUInteger timeIdx = idx;
            if (!(array == nil || array.count == 0))
            {
                
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZCYTimeTableModel *model = obj;
                    
                    NSArray *courseWeeks = model.courseWeeks;
                    for (NSInteger i = 0; i<courseWeeks.count; i++)
                    {
                        if ([courseWeeks[i] integerValue] == [ZCYUserMgr sharedMgr].shcoolWeek)
                        {
                            ZCYCourseView *courseView = [[ZCYCourseView alloc] initWithCourseName:model.courseName andClassID:model.coursePlace andCourseTime:timeIdx];
                            [courseView setTextColor:deepArray[index%3] andBackgroundColor:commonArray[index%3]];
                            [self.courseScrollView addSubview:courseView];
                            self.courseScrollView.contentSize = CGSizeMake((index+1)*(self.view.frame.size.width-30)/2 , (self.view.frame.size.width-40)/2 - 15);
                            [courseView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.courseScrollView).with.offset(index*(self.view.frame.size.width-40)/2 + 20);
                                make.top.equalTo(self.courseScrollView);
                                make.width.mas_equalTo((self.view.frame.size.width-40)/2);
                                make.height.mas_equalTo((self.view.frame.size.width-40)/2 - 15);
                            }];
                            index++;
                        }
                    }
                }];
                
            }
           
        }];
        
    }
    if (index == 0)
    {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"今天没课哦";
        tipLabel.textColor = kDeepGray_Color;
        tipLabel.font = [UIFont systemFontOfSize:20 weight:2];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.courseScrollView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.courseScrollView);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(26);
        }];
    }

    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor colorWithRGBHex:0xd8d8d8];
    [self.backgroundScrollView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.courseScrollView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)initCardView
{
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = kCommonWhite_Color;
    [self.backgroundScrollView addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseScrollView.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(210);
    }];
    
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"一卡通余额";
    cardLabel.font = [UIFont systemFontOfSize:20 weight:2];
    cardLabel.textColor = kCommonText_Color;
    [self.cardView addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).with.offset(14);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(110);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
    self.cardLabel = [[UILabel alloc] init];
    [self.cardLabel setFont:kFont(kStandardPx(40)) andText:@"数据加载中" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.cardView addSubview:self.cardLabel];
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self.cardView);
    }];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [detailButton setTitle:@"一卡通详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    detailButton.layer.masksToBounds = YES;
    detailButton.titleLabel.font = kFont(16);
    [detailButton addTarget:self action:@selector(pushToCardDetailVC) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right).with.offset(-110);
        make.bottom.equalTo(cardLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    [tipLabel setFont:kFont(kStandardPx(26)) andText:@"截止今日00:00" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    [self.cardView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).with.offset(-10);
        make.bottom.equalTo(self.cardView).with.offset(-5);
    }];

    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor colorWithRGBHex:0xd8d8d8];
    
    [self.backgroundScrollView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.cardView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
   
    if ([ZCYUserMgr sharedMgr].dormitoryArray)
    {
        self.electricView = [[ZCYHomePageElecView alloc] initWithElecString:@"数据加载中..."];
    } else {
        self.electricView = [[ZCYHomePageElecView alloc] initWithElecString:@"00"];
    }
    [self.backgroundScrollView addSubview:self.electricView];
    [self.electricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(grayLine.mas_bottom);
        make.height.mas_equalTo(215);
    }];

    @weakify(self);
    [self.electricView setClickedBlock:^{
        @strongify(self);
        ZCYHydroelectricViewController *elecC = [[ZCYHydroelectricViewController alloc] init];
        [self.navigationController pushViewController:elecC animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0)
    {
        _isTop = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.navigationController.navigationBar.alpha = (scrollView.contentOffset.y)/355 * 2.0;
    
    if (scrollView.contentOffset. y <= 0.0f)
    {
        _isTop = YES;
    } else {
        _isTop = NO;
    }
        if (scrollView.contentOffset.y < y_oldContentOffset) //下拉
        {
            
            if (_isTop)
            {
            
                [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.view);
                    make.height.mas_equalTo(self.view.frame.size.height * 255/667);
                }];
            } else {
                
                [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.backgroundScrollView);
                    make.height.mas_equalTo(self.view.frame.size.height * 255/667);
                }];
                
            }
        } else { //上拉
            
            if (!_isTop)
            [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.backgroundScrollView);
                make.height.mas_equalTo(self.view.frame.size.height * 255/667);
            }];
           
        }
    
    y_oldContentOffset = scrollView.contentOffset.y;
}

- (void)updateUIWithArray:(NSArray *)courseArray
{
    
    self.timeLabel.text = [NSString stringWithFormat:@"星期%@ %@月%@号", [NSDate date].weekString, @([NSDate date].month), @([NSDate date].day)];
    self.weekLabel.text = [NSString stringWithFormat:@"第 %@ 周", @([ZCYUserMgr sharedMgr].shcoolWeek)];
    for (UIView *subview in [self.courseScrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    NSArray *todayCourseArray = courseArray[[NSDate date].week - 1];
    
    NSArray <UIColor *> *commonArray = @[kCommonGreen_Color, kCommonOrigin_Color, kCommonPink_Color];
    NSArray <UIColor *> *deepArray = @[kDeepGreen_Color, kDeepOrigin_Color, kDeepPink_Color];
    __block NSInteger index = 0;
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
        
        [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            NSUInteger timeIdx = idx;
            if (!(array == nil || array.count == 0))
            {
                
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZCYTimeTableModel *model = obj;
                    
                    NSArray *courseWeeks = model.courseWeeks;
                    for (NSInteger i = 0; i<courseWeeks.count; i++)
                    {
                        if ([courseWeeks[i] integerValue] == [ZCYUserMgr sharedMgr].shcoolWeek)
                        {
                            ZCYCourseView *courseView = [[ZCYCourseView alloc] initWithCourseName:model.courseName andClassID:model.coursePlace andCourseTime:timeIdx];
                            [courseView setTextColor:deepArray[index%3] andBackgroundColor:commonArray[index%3]];
                            [self.courseScrollView addSubview:courseView];
                            self.courseScrollView.contentSize = CGSizeMake((index+1)*(self.view.frame.size.width-30)/2 , (self.view.frame.size.width-40)/2 - 15);
                            [courseView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.courseScrollView).with.offset(index*(self.view.frame.size.width-40)/2 + 20);
                                make.top.equalTo(self.courseScrollView);
                                make.width.mas_equalTo((self.view.frame.size.width-40)/2);
                                make.height.mas_equalTo((self.view.frame.size.width-40)/2 - 15);
                            }];
                            index++;
                        }
                    }
                }];
                
            }
            
        }];
        
    }
    if (index == 0)
    {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"今天没课哦";
        tipLabel.textColor = kDeepGray_Color;
        tipLabel.font = [UIFont systemFontOfSize:20 weight:2];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.courseScrollView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.courseScrollView);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(26);
        }];
    }
    __block NSUInteger courseNum = 0;
    
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
    }
    
    
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        NSArray *todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
        
        [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZCYTimeTableModel *model = obj;
                NSArray *courseWeeks = model.courseWeeks;
                for (NSInteger i = 0; i<courseWeeks.count; i++)
                {
                    if ([courseWeeks[i] integerValue] == [ZCYUserMgr sharedMgr].shcoolWeek)
                    {
                        courseNum = courseNum + [model.courseNumber integerValue];
                    }
                }
            }];
        }];
    }
    
    NSString *tipString;
    
    if (courseNum<4)
    {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课，放松一下吧", (long)courseNum];
    } else if (courseNum >=4 && courseNum < 8) {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课哦～，多撑一会吧", (long)courseNum];
    } else if (courseNum >=8 && courseNum <= 12) {
        tipString = [NSString stringWithFormat:@"今天有%02ld节课...生无可恋", (long)courseNum];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:kStandardPx(64)] range:NSMakeRange(3, 2)];
    
    self.summaryLabel.attributedText = attributedString;
    
    
}

#pragma mark - 点击事件
- (void)pushToCourseVC
{
    ZCYCourseViewController *courseVC = [[ZCYCourseViewController alloc] init];
    [self.navigationController pushViewController:courseVC animated:YES];
}

- (void)pushToCardDetailVC
{
    ZCYCardDetailViewController *cardDetailVC = [[ZCYCardDetailViewController alloc] init];
    [self.navigationController pushViewController:cardDetailVC animated:YES];
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.functionCollectionView dequeueReusableCellWithReuseIdentifier:@"functionCollectionViewCellID" forIndexPath:indexPath];
    UIImageView *functionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self functionDefines][indexPath.section*4 + indexPath.row][@"iconName"]]];
    functionImageView.frame = cell.bounds;
    
    [cell addSubview:functionImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(cell.bounds.origin.x - 10, cell.bounds.origin.y+43, cell.bounds.size.width + 20, 15);
    nameLabel.font = kFont(kStandardPx(22));
    nameLabel.textColor = kText_Color_Default;
    nameLabel.text = [self functionDefines][indexPath.section*4 + indexPath.row][@"funcName"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:nameLabel];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (self.view.frame.size.width - 38*4 - 60) / 4;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 30, 15, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *classString = [self functionDefines][indexPath.section*4 + indexPath.row][@"nextController"];
    Class vcClass = NSClassFromString(classString);
    UIViewController *nextViewController = [[vcClass alloc] init];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

//设置基础标签
-(void)setLabel:(UILabel *)label withText:(NSString *)text andTextColor:(UIColor *)textColor andTextFont:(UIFont *)textFont
{
    label.textColor = textColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = textFont;
}

//功能点对应
- (NSArray *)functionDefines
{
    return [NSArray arrayWithObjects:
            @{@"funcName" : @"课表",
              @"iconName" : @"课表",
              @"nextController" : NSStringFromClass([ZCYCourseViewController class])},
            
            @{@"funcName" : @"一卡通",
              @"iconName" : @"一卡通",
              @"nextController" : NSStringFromClass([ZCYCardDetailViewController class])},
            
            @{@"funcName" : @"水电查询",
              @"iconName" : @"水电查询",
              @"nextController" : NSStringFromClass([ZCYHydroelectricViewController class])},
            
            @{@"funcName" : @"物业报修",
              @"iconName" : @"物业报修",
              @"nextController" : NSStringFromClass([ZCYPropertyRepairViewController class])},
            
            @{@"funcName" : @"借阅信息",
              @"iconName" : @"借阅信息",
              @"nextController" : NSStringFromClass([ZCYLendBookViewController class])},
            
            @{@"funcName" : @"学生查询",
              @"iconName" : @"学生查询",
              @"nextController" : NSStringFromClass([ZCYStudentSearchViewController class])},
            
            @{@"funcName" : @"考试查询",
              @"iconName" : @"考试查询",
              @"nextController" : NSStringFromClass([ZCYExaminationViewController class])},
            
            @{@"funcName" : @"空教室",
              @"iconName" : @"空教室",
              @"nextController" : NSStringFromClass([ZCYEmptyClassViewController class])},
            nil];
}

@end
