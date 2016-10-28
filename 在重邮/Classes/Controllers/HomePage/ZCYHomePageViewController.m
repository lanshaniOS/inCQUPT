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

@interface ZCYHomePageViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 背景下拉板 */
@property (strong, nonatomic) UICollectionView *functionCollectionView;  /**< 功能板块 */
@property (strong, nonatomic) UIImageView *backgroundImageView;  /**< 背景图画 */
@property (strong, nonatomic) NSArray *courseArray;  /**< 课程数组 */
@end

@implementation ZCYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)initUI
{
    self.view.backgroundColor = kAppBg_Color;
    [self setNavigationBar];
    self.courseArray = [NSArray array];
    [ZCYTimeTableHelper getTimeTableWithStdNumber:@"2014213913" withCompeletionBlock:^(NSArray *array) {
        self.courseArray = array;
        [self initBackgroundScrollView];
        [self initFunctionCollectionView];
        
    }];
    
}


- (void)setNavigationBar
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initBackgroundScrollView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.backgroundColor = kCommonWhite_Color;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.bottom.equalTo(self.view);
    }];
    
    [self initHeaderView];
    
}

- (void)initHeaderView
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
    [self.backgroundScrollView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.backgroundScrollView).with.offset(-20);
        make.height.mas_equalTo(215);
    }];

    UILabel *topicLabel = [[UILabel alloc] init];
    [self setLabel:topicLabel withText:@"首页" andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(60))];
    [self.backgroundScrollView addSubview:topicLabel];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundScrollView).with.offset(25);
        make.left.equalTo(self.view).with.offset(18);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self setLabel:timeLabel withText: [NSString stringWithFormat:@"星期%@ %@月%@号", @([NSDate date].week), @([NSDate date].month), @([NSDate date].day)] andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(22))];
    [self.backgroundScrollView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicLabel.mas_bottom).with.offset(12);
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
        make.top.equalTo(timeLabel.mas_bottom).with.offset(18);
        make.left.equalTo(timeLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *summaryLabel = [[UILabel alloc] init];

    
    NSArray *todayCourseArray = self.courseArray[[NSDate date].week - 1];
    
    __block NSUInteger courseNum = 0;
    
    [todayCourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        if (array.count != 0 && array != nil)
            courseNum = courseNum + 2;
    }];

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天只有%02ld节课，爽到爆炸", courseNum]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:kStandardPx(64)] range:NSMakeRange(4, 2)];
    [self setLabel:summaryLabel withText:@"" andTextColor:kCommonWhite_Color andTextFont:kFont(kStandardPx(36))];
    summaryLabel.attributedText = attributedString;
    [self.backgroundScrollView addSubview:summaryLabel];
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    functionImageView.frame = cell.frame;
    
    [cell addSubview:functionImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(cell.frame.origin.x - 5, cell.frame.origin.y+48, cell.frame.size.width + 10, 15);
    nameLabel.font = kFont(kStandardPx(22));
    nameLabel.textColor = kText_Color_Default;
    nameLabel.text = [self functionDefines][indexPath.row][@"funcName"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:nameLabel];
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 12.5, 0, 0);
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
