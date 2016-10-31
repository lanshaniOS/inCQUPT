//
//  ZCYHomePageViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHomePageViewController.h"
#import "ZCYClassViewController.h"
#import "ZCYSchoolCardViewController.h"
#import "ZCYHydroelectricViewController.h"
#import "ZCYPropertyRepairViewController.h"
#import "ZCYTimeTableHelper.h"
#import "ZCYTimeTableModel.h"
#import "ZCYCourseView.h"
#import "ZCYCourseViewController.h"

@interface ZCYHomePageViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 背景下拉板 */
@property (strong, nonatomic) UICollectionView *functionCollectionView;  /**< 功能板块 */
@property (strong, nonatomic) UIImageView *backgroundImageView;  /**< 背景图画 */
@property (strong, nonatomic) UIScrollView *courseScrollView;  /**< 课程滑动视图 */
@property (strong, nonatomic) UIView *cardView;  /**< 一卡通视图 */
@property (strong, nonatomic) UILabel *timeLabel;  /**< 时间标签 */
@property (strong, nonatomic) UILabel *summaryLabel;  /**< 课程数标签 */
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
    [self setNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0f;
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
}

- (void)setNavigationBar
{
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)initBackgroundScrollView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.backgroundColor = kCommonWhite_Color;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.scrollEnabled = YES;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
    }];
    
    
}

- (void)initHeaderView
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
    [self.backgroundScrollView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.backgroundScrollView).with.offset(-20);
        make.height.mas_equalTo(255);
    }];
    
    UILabel *topicLabel = [[UILabel alloc] init];
    [self setLabel:topicLabel withText:@"首页" andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(80))];
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
    __block NSUInteger courseNum = 0;
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        NSArray *todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
        
        [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            if (array.count != 0 && array != nil)
            courseNum = courseNum + 2;
        }];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天只有 %02ld 节课，爽到爆炸", courseNum]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:kStandardPx(64)] range:NSMakeRange(5, 2)];
    
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
        make.height.mas_equalTo(100);
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
        make.top.equalTo(self.backgroundScrollView).with.offset(350);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(90);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.textColor = kDeepGray_Color;
    weekLabel.text = @"第  周";
    weekLabel.font = [UIFont fontWithName:@"Futra" size:16];
    [self.backgroundScrollView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topicView.mas_right).with.offset(12);
        make.bottom.equalTo(topicView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
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
    //    self.courseScrollView.delegate = self;
    NSArray *todayCourseArray = [NSArray array];
    
    if (!([ZCYUserMgr sharedMgr].courseArray == nil || [ZCYUserMgr sharedMgr].courseArray.count == 0))
    {
        todayCourseArray = [ZCYUserMgr sharedMgr].courseArray[[NSDate date].week - 1];
    }
    self.courseScrollView.contentSize = CGSizeMake((todayCourseArray.count)*((self.view.frame.size.width-40)/2) + 20, 230);
    self.courseScrollView.scrollEnabled = YES;
    self.courseScrollView.showsHorizontalScrollIndicator = NO;
    self.courseScrollView.showsVerticalScrollIndicator = NO;
    self.courseScrollView.backgroundColor = kCommonWhite_Color;
    [self.backgroundScrollView addSubview:self.courseScrollView];
    [self.courseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicView.mas_bottom).with.offset(13);
        make.height.mas_equalTo(230);
        make.left.and.right.equalTo(self.view);
    }];
    
    NSArray <UIColor *> *commonArray = @[kCommonGreen_Color, kCommonYellow_Color, kCommonPink_Color];
    NSArray <UIColor *> *deepArray = @[kDeepGreen_Color, kDeepYellow_Color, kDeepPink_Color];
    __block NSInteger index = 0;
    [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        if (array == nil || array.count == 0)
        {
            //        UILabel *tipLabel = [[UILabel alloc] init];
            //        tipLabel.text = @"今天没课哦";
            //        tipLabel.textColor = kDeepGray_Color;
            //        tipLabel.font = [UIFont systemFontOfSize:20 weight:2];
            //        tipLabel.textAlignment = NSTextAlignmentCenter;
            //        [self.courseScrollView addSubview:tipLabel];
            //        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.equalTo(self.view);
            //            make.centerY.equalTo(self.courseScrollView);
            //            make.width.mas_equalTo(100);
            //            make.height.mas_equalTo(26);
            //        }];
        } else {
            ZCYTimeTableModel *model = array[0];
            ZCYCourseView *courseView = [[ZCYCourseView alloc] initWithCourseName:model.courseName andClassID:model.coursePlace andCourseTime:idx];
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
    }];

    
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
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor colorWithRGBHex:0xd8d8d8];
    [self.backgroundScrollView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.cardView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == -20)
    {
        _isTop = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.alpha = (scrollView.contentOffset.y+20)/355 * 2.0;
    
    if (scrollView.contentOffset.y <= -20.0f)
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
                    make.height.mas_equalTo(255);
                }];
            } else {
                
                [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.backgroundScrollView).with.offset(-20);
                    make.height.mas_equalTo(255);
                }];
                
            }
        } else { //上拉
            
            if (!_isTop)
            [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.backgroundScrollView).with.offset(-20);
                make.height.mas_equalTo(255);
            }];
           
        }
    
    y_oldContentOffset = scrollView.contentOffset.y;
}

- (void)updateUIWithArray:(NSArray *)courseArray
{
    
    self.timeLabel.text = [NSString stringWithFormat:@"星期%@ %@月%@号", [NSDate date].weekString, @([NSDate date].month), @([NSDate date].day)];
    
    NSArray *todayCourseArray = courseArray[[NSDate date].week - 1];
    
    __block NSUInteger courseNum = 0;
    
    [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        if (array.count != 0 && array != nil)
        courseNum = courseNum + 2;
    }];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天只有 %02ld 节课，爽到爆炸", courseNum]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:kStandardPx(64)] range:NSMakeRange(5, 2)];
    
    self.summaryLabel.attributedText = attributedString;
    
    for (UIView *subview in [self.courseScrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    NSArray <UIColor *> *commonArray = @[kCommonGreen_Color, kCommonYellow_Color, kCommonPink_Color];
    NSArray <UIColor *> *deepArray = @[kDeepGreen_Color, kDeepYellow_Color, kDeepPink_Color];
    __block NSInteger index = 0;
    
    [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        if (array == nil || array.count == 0)
        {
            //        UILabel *tipLabel = [[UILabel alloc] init];
            //        tipLabel.text = @"今天没课哦";
            //        tipLabel.textColor = kDeepGray_Color;
            //        tipLabel.font = [UIFont systemFontOfSize:20 weight:2];
            //        tipLabel.textAlignment = NSTextAlignmentCenter;
            //        [self.courseScrollView addSubview:tipLabel];
            //        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.equalTo(self.view);
            //            make.centerY.equalTo(self.courseScrollView);
            //            make.width.mas_equalTo(100);
            //            make.height.mas_equalTo(26);
            //        }];
        } else {
            //        for (NSInteger i = 0; i<array.count; i++)
            //        {
            ZCYTimeTableModel *model = array[0];
            ZCYCourseView *courseView = [[ZCYCourseView alloc] initWithCourseName:model.courseName andClassID:model.coursePlace andCourseTime:idx];
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
            //        }
        }

    }];
}

#pragma mark - 点击事件
- (void)pushToCourseVC
{
    ZCYCourseViewController *courseVC = [[ZCYCourseViewController alloc] init];
    courseVC.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:courseVC animated:YES];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.functionCollectionView dequeueReusableCellWithReuseIdentifier:@"functionCollectionViewCellID" forIndexPath:indexPath];
    UIImageView *functionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self functionDefines][indexPath.row][@"iconName"]]];
    functionImageView.frame = cell.bounds;
    
    [cell addSubview:functionImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(cell.bounds.origin.x - 5, cell.bounds.origin.y+48, cell.bounds.size.width + 10, 15);
    nameLabel.font = kFont(kStandardPx(22));
    nameLabel.textColor = kText_Color_Default;
    nameLabel.text = [self functionDefines][indexPath.row][@"funcName"];
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
    return (self.view.frame.size.width - 38*4 - 120) / 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 30, 0, 30);
}

#pragma mark - tools

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
              @"nextController" : NSStringFromClass([ZCYClassViewController class])},
            
            @{@"funcName" : @"一卡通",
              @"iconName" : @"一卡通",
              @"nextController" : NSStringFromClass([ZCYSchoolCardViewController class])},
            
            @{@"funcName" : @"水电查询",
              @"iconName" : @"水电查询",
              @"nextController" : NSStringFromClass([ZCYHydroelectricViewController class])},
            
            @{@"funcName" : @"物业报修",
              @"iconName" : @"物业报修",
              @"nextController" : NSStringFromClass([ZCYPropertyRepairViewController class])},
            nil];
}

@end
