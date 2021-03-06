//
//  ZCYCourseViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCourseViewController.h"
#import "ZCYTimeTableModel.h"
#import "ZCYDetailCourseView.h"
#import "ZCYTimeTableHelper.h"
#import "ZCYFeedBackViewController.h"
#import "ZCYCuurentTimeModel.h"
#import <UserNotiFications/UserNotifications.h>
#import "ZCYGetTimeHelper.h"
#import "CMPopTipView.h"

static const float animationTime = 0.2f;

@interface ZCYCourseViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, ZCYDetailCourseCloseButtonTouchedDelegate, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**<  滑动背景 */
@property (strong, nonatomic) UIView *leftTimeView;  /**< 左部上课节数 */
@property (strong, nonatomic) UIView *headerView;  /**< 顶部周次条 */
@property (strong, nonatomic) UICollectionView *courseCollectionView;  /**< 课表 */
@property (strong, nonatomic) UIView *bottomView;  /**< 底部 */
@property (strong, nonatomic) UIPickerView *weekPicker;  /**< 周数选择 */
@property (strong, nonatomic) UIButton *weekButton;  /**< 选择周次按钮 */
@property (strong, nonatomic) UIButton *finishButton;  /**< 完成周次选择按钮 */
@property (strong, nonatomic) ZCYDetailCourseView *detailCourseView;  /**< 课程详情 */
@property (strong, nonatomic) UIControl *backgroundControl;  /**< 背景控制 */
@property (strong, nonatomic) UILabel *weekLabel;  /**< 周数显示 */
@property (strong, nonatomic) NSString *studentNumber;  /**< 学号 */
//@property (strong, nonatomic) NSArray *courseArray;  /**< 课程数组 */
@property (nonatomic,strong) UITableView *notificationMenu;
@property (nonatomic,strong) NSMutableArray *menuArray;
@property (nonatomic,strong) CMPopTipView *popView;

@end

@implementation ZCYCourseViewController
{
    CGFloat _courseWidth;
    NSMutableArray *_weekArray;
    CGFloat y_oldPanpoint;
    CGFloat sum_yOffset;
    CGFloat y_oldCourseViewPoint;
    CGFloat sum_yCourseViewOffset;
    
    NSIndexPath *old_selectedIndexPath;
    NSIndexPath *currentSelectedIndexPath;
    BOOL _didTouchedFinishButton;
    BOOL _isFirstShowCourse;
    BOOL _isShowNotificationMenu;
}

- (instancetype)initWithStudentNumber:(NSString *)studentNumber
{
    if ([super init])
    {
        self.studentNumber = studentNumber;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.alpha = 1.0f;
    self.navigationController.navigationBar.hidden = NO;
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headerView.hidden = NO;
    self.navigationController.navigationBar.alpha = 1.0f;
    self.navigationController.navigationBar.hidden = NO;
    if (self.studentNumber && ![self.studentNumber  isEqual: @""])
    {
        [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取课表中" inView:self.view];
        [ZCYTimeTableHelper getTimeTableWithStdNumber:self.studentNumber  shouldSaveTime:NO withCompeletionBlock:^(NSError *error, NSArray *array) {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
            if (error)
            {
                [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
                return;
            }
            [self.courseCollectionView reloadData];
        }];
    } else {
        [ZCYTimeTableHelper getTimeTableWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber shouldSaveTime:NO withCompeletionBlock:^(NSError *error, NSArray *array) {
            if (error)
            {
                return;
            }
            [ZCYUserMgr sharedMgr].courseArray = array;
            //            self.courseArray = [ZCYUserMgr sharedMgr].courseArray;
            //            [self.courseCollectionView reloadData];
        }];
        
        //        self.courseArray = [ZCYUserMgr sharedMgr].courseArray;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 42+(_courseWidth+0.5)*6*1.26);
    [self.weekPicker selectRow:[ZCYUserMgr sharedMgr].shcoolWeek-1 inComponent:0 animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.headerView.hidden = YES;
    if (_isShowNotificationMenu) {
        [_popView dismissAnimated:YES];
        _isShowNotificationMenu = NO;
    }
}
#pragma mark - initUI
- (void)initUI
{
    _isFirstShowCourse = YES;
    _courseWidth = (self.view.frame.size.width-28)/5;
    old_selectedIndexPath = [[NSIndexPath alloc] init];
    self.view.backgroundColor = kCommonWhite_Color;
    self.title = @"课表";
    self.navigationController.navigationBar.alpha = 1.0f;
    [self initBackgroundView];
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor colorWithRGBHex:0xe4ffdf];
    [self.backgroundScrollView addSubview:greenView];
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundScrollView).with.offset(28+(_courseWidth+0.5)*([NSDate date].week-1));
        make.top.equalTo(self.backgroundScrollView).with.offset(-80);
        make.height.mas_equalTo(self.backgroundScrollView.contentSize.height+200);
        make.width.mas_equalTo(_courseWidth+0.5);
    }];
    [self initCourseCollectionView];
    [self initHeaderView];
    [self initLeftTimeView];
    [self initBottomView];
    [self initWeekPickerView];
    [self initCourseDetailView];
    [self initNotificationMenu];
    [self addBarItem];
}

- (void)initNotificationMenu
{
    _menuArray = [NSMutableArray arrayWithArray:[ZCYUserMgr sharedMgr].notificationIdentifiers];
    self.notificationMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, 180) style:UITableViewStylePlain];
    self.notificationMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.notificationMenu.delegate = self;
    self.notificationMenu.dataSource = self;
    [self.notificationMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
}

-(void)addBarItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeNotification:)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)initHeaderView
{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.backgroundScrollView).with.offset(-200);
        make.width.mas_equalTo(1000);
        make.height.mas_equalTo(42);
    }];
    
    NSArray *numArray = @[@"", @"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    for (NSUInteger index = 1; index <= 7; index++)
    {
        UIView *numView = [[UIView alloc] init];
        if ([NSDate date].week == index)
        {
            [self setView:numView WithNum:numArray[index] andSegColor:kDeepGreen_Color shouldShowSeg:YES];
        } else {
            [self setView:numView WithNum:numArray[index] andSegColor:kDeepGreen_Color shouldShowSeg:NO];
        }
        
        [self.headerView addSubview:numView];
        [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_courseWidth + 0.5);
            make.left.equalTo(self.headerView.mas_left).with.offset(200+28+(index-1)*(_courseWidth + 0.5));
            make.top.and.bottom.equalTo(self.headerView);
        }];
    }
}

- (void)initBackgroundView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 42+(_courseWidth+0.5)*6*1.26);
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.scrollEnabled = YES;
    self.backgroundScrollView.directionalLockEnabled = YES;
    
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-68);
    }];
    
    
}

- (void)initCourseCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(_courseWidth+0.5, _courseWidth*1.26 + 0.5);
    self.courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.courseCollectionView.backgroundColor = kTransparentColor;
    [self.courseCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"courseCollctionViewCellID"];
    self.courseCollectionView.delegate = self;
    
    self.courseCollectionView.dataSource = self;
    self.courseCollectionView.scrollEnabled = NO;
    
    self.courseCollectionView.showsVerticalScrollIndicator = NO;
    self.courseCollectionView.showsHorizontalScrollIndicator = NO;
    [self.backgroundScrollView addSubview:self.courseCollectionView];
    [self.courseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundScrollView).with.offset(42);
        make.left.equalTo(self.backgroundScrollView).with.offset(28);
        make.height.mas_equalTo(6*1.26*_courseWidth + 3);
        make.width.mas_equalTo(7*_courseWidth+3.5);
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
    
    self.weekLabel = [[UILabel alloc] init];
    self.weekLabel.textColor = kCommonText_Color;
    self.weekLabel.text = [NSString stringWithFormat:@"第%@周", [NSDate schoolWeekStringWithWeek:[ZCYUserMgr sharedMgr].shcoolWeek]];
    [self.weekLabel sizeToFit];
    self.weekLabel.font = kFont(kStandardPx(40));
    [self.bottomView addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.centerY.equalTo(self.bottomView);
        
        make.height.mas_offset(20);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    [dayLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"星期%@", [NSDate date].weekString] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [dayLabel sizeToFit];
    [self.bottomView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right).with.offset(10);
        make.bottom.equalTo(self.weekLabel);
        
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
    
    self.weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weekButton setTitle:@"选择周次" forState:UIControlStateNormal];
    [self.weekButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    self.weekButton.titleLabel.font = kFont(kStandardPx(34));
    [self.weekButton addTarget:self action:@selector(showWeekSelectedView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.weekButton];
    [self.weekButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.bottom.equalTo(self.weekLabel);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(hideWeekSelectedView) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.titleLabel.font = kFont(kStandardPx(34));
    self.finishButton.hidden = YES;
    [self.bottomView addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.bottom.equalTo(self.weekLabel);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    UISwipeGestureRecognizer *upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showWeekSelectedView)];
    upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.bottomView addGestureRecognizer:upGestureRecognizer];
    
    UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideWeekSelectedView)];
    downGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.bottomView addGestureRecognizer:downGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeekSelectedView:)];
    [self.bottomView addGestureRecognizer:panGestureRecognizer];
}
- (void)initLeftTimeView
{
    CGFloat _timeLabelWidth = _courseWidth * 1.26 / 2;
    self.leftTimeView = [[UIView alloc] init];
    self.leftTimeView.backgroundColor = kCommonLightGray_Color;
    [self.backgroundScrollView addSubview:self.leftTimeView];
    [self.leftTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(28);
        make.top.equalTo(self.backgroundScrollView).with.offset(-500);
        make.bottom.equalTo(self.courseCollectionView).with.offset(500);
    }];
    for (NSUInteger index = 1; index <= 12; index++)
    {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.text = [NSString stringWithFormat:@"%@", @(index)];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = kText_Color_Default;
        indexLabel.font = kFont(kStandardPx(26));
        [self.leftTimeView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.leftTimeView);
            make.top.equalTo(self.backgroundScrollView).with.offset((index - 1)*_timeLabelWidth + 42);
            make.height.mas_equalTo(_timeLabelWidth);
        }];
    }
}

- (void)initWeekPickerView
{
    if (!_weekPicker)
    {
        self.weekPicker = [[UIPickerView alloc] init];
        _weekArray = [NSMutableArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"二十一", @"二十二", @"二十三", @"二十四", @"二十五", @"二十六", @"二十七", @"二十八", @"二十九", @"三十", nil];
        _weekArray[[ZCYUserMgr sharedMgr].shcoolWeek - 1] = [NSString stringWithFormat:@"%@（本周)", [NSDate schoolWeekStringWithWeek:[ZCYUserMgr sharedMgr].shcoolWeek]];
        self.weekPicker.dataSource = self;
        self.weekPicker.delegate = self;
        self.weekPicker.backgroundColor = kCommonLightGray_Color;
        [self.view addSubview:self.weekPicker];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
        {
            [self.weekPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.bottomView);
                make.top.equalTo(self.bottomView.mas_bottom).with.offset(-kStandardPx(18)/2);
                make.height.mas_equalTo(215);
            }];
        } else {
            [self.weekPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.bottomView);
                make.top.equalTo(self.bottomView.mas_bottom).with.offset(-kStandardPx(18)/2-20);
                make.height.mas_equalTo(215+40);
            }];
        }
    }
}

- (void)initCourseDetailView
{
    if (!_detailCourseView)
    {
        self.detailCourseView = [[ZCYDetailCourseView alloc] init];
        self.detailCourseView.delegate = self;
        sum_yCourseViewOffset = -360;
        [self.view addSubview:self.detailCourseView];
        self.detailCourseView.hidden = YES;
        [self.detailCourseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(554);
        }];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithCourseDetailView:)];
        [self.detailCourseView addGestureRecognizer:panGestureRecognizer];
    }
}

#pragma mark - UItableViewDeleagete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.menuArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:92/255.0 green:255/255.0 blue:117/255.0 alpha:1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_notificationMenu setEditing:NO animated:YES];
    if ([[UIDevice currentDevice] systemVersion].integerValue >= 10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeDeliveredNotificationsWithIdentifiers:self.menuArray[indexPath.row]];
    }else{
        NSArray *locationArray = [UIApplication sharedApplication].scheduledLocalNotifications;
        for (UILocalNotification *location in locationArray) {
            NSDictionary *dic = location.userInfo;
            NSString *key = [[dic allKeys] firstObject];
            if ([key isEqualToString:[NSString stringWithFormat:@"%lu",indexPath.row]]) {
                [[UIApplication sharedApplication]cancelLocalNotification:location];
            }
        }
    }
    [_menuArray removeObjectAtIndex:indexPath.row];
    [[ZCYUserMgr sharedMgr].notificationIdentifiers removeObjectAtIndex:indexPath.row];
    ZCYUserMgr *userMgr = [ZCYUserMgr sharedMgr];
    NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:userMgr];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
}


#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _weekArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _weekArray[row];
}

#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.courseCollectionView dequeueReusableCellWithReuseIdentifier:@"courseCollctionViewCellID" forIndexPath:indexPath];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.layer.cornerRadius = 0.0f;
    UIColor *cellColor;
    switch (indexPath.section) {
        case 0:
        case 1:
            cellColor = kDeepGreen_Color;
            break;
        case 2:
        case 3:
            cellColor = kDeepOrigin_Color;
            break;
        case 4:
        case 5:
            cellColor = kDeepYellow_Color;
            break;
        default:
            cellColor = kCommonRed_Color;
            break;
    }
    NSArray *courseArray = [ZCYUserMgr sharedMgr].courseArray[indexPath.row];
    NSArray *colArray = courseArray[indexPath.section];
    
    //    if (indexPath.row == [NSDate date].week -1)
    //    {
    //        cell.backgroundColor = [UIColor colorWithRGBHex:0xe4ffdf];
    //    } else {
    //    cell.backgroundColor = kTransparentColor;
    //    }
    cell.backgroundColor = kTransparentColor;
    if (colArray.count >= 2)
    {
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = kCommonWhite_Color;
        dotView.frame = CGRectMake(cell.frame.size.width - 7.5, 2.5, 5, 5);
        [dotView setRadius:2.5];
        [cell addSubview:dotView];
    }
    NSInteger schoolWeek;
    if (_isFirstShowCourse)
    {
        schoolWeek = [ZCYUserMgr sharedMgr].shcoolWeek;
    } else {
        schoolWeek = [self.weekPicker selectedRowInComponent:0]+1;
    }
    
    
    cell.frame = CGRectMake((_courseWidth+0.5)*indexPath.row, (_courseWidth*1.26+0.5)*indexPath.section, _courseWidth, _courseWidth*1.26);
    __block BOOL haveCourse = NO;
    [colArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZCYTimeTableModel *model  = obj;
        
        for (NSUInteger i=0; i<model.courseWeeks.count; i++)
        {
            if ([model.courseWeeks[i] integerValue] == schoolWeek)
            {
                if (!haveCourse)
                {
                    
                    haveCourse = YES;
                    [self setCollectionViewCell:cell withColor:cellColor andCourseName:model.courseName andClassID:model.coursePlace];
                    //                [cell setRadius:5.0f]; //影响性能
                    cell.layer.cornerRadius = 5.0f;
                    cell.layer.shouldRasterize = YES;
                    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
                    if ([model.courseNumber integerValue] == 3)
                    {
                        cell.frame = CGRectMake((_courseWidth+0.5)*indexPath.row, (_courseWidth*1.26+0.5)*indexPath.section, _courseWidth, _courseWidth*3*0.63);
                    }
                    if ([model.courseNumber integerValue] == 4) {
                        cell.frame = CGRectMake((_courseWidth+0.5)*indexPath.row, (_courseWidth*1.26+0.5)*indexPath.section, _courseWidth, _courseWidth*4*0.63);
                    }
                }
            }
            
        }
        if (haveCourse)
        {
            *stop = YES;
        }
    }];
    if(indexPath.section != 5)
    {
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = kCommonGray_Color;
        [cell addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_bottom);
            make.left.and.right.equalTo(cell);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (indexPath.row != 6)
    {
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = kCommonGray_Color;
        [cell addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_right);
            make.top.and.bottom.equalTo(cell);
            make.width.mas_equalTo(0.5);
        }];
    }
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake( _courseWidth+0.5, _courseWidth*1.26 + 0.5);
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowNotificationMenu) {
        [_popView dismissAnimated:YES];
        _isShowNotificationMenu = NO;
    }
    currentSelectedIndexPath = indexPath;
    NSArray *courseArray = [ZCYUserMgr sharedMgr].courseArray[indexPath.row];
    NSArray *colArray = courseArray[indexPath.section];
    __block BOOL haveCourse = NO;
    
    NSInteger schoolWeek;
    if (_isFirstShowCourse)
    {
        schoolWeek = [ZCYUserMgr sharedMgr].shcoolWeek;
    } else {
        schoolWeek = [self.weekPicker selectedRowInComponent:0]+1;
    }
    [colArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZCYTimeTableModel *model  = obj;
        for (NSUInteger i=0; i<model.courseWeeks.count; i++)
        {
            if ([model.courseWeeks[i] integerValue] == schoolWeek)
            {
                haveCourse = YES;
            }
        }
    }];
    if (!haveCourse)
    {
        old_selectedIndexPath = nil;
        [self closeButtonDidPressed];
        return;
    }
    CGFloat x_offset = self.backgroundScrollView.contentOffset.x;
    old_selectedIndexPath = indexPath;
    if (indexPath.section != 0)
        self.backgroundScrollView.contentOffset = CGPointMake(x_offset, _courseWidth*1.26*indexPath.section - 2.2*_courseWidth);
    UICollectionViewCell *cell = [self.courseCollectionView cellForItemAtIndexPath:indexPath];
    
    cell.alpha = 0.5;
    
    self.bottomView.hidden = YES;
    self.weekPicker.hidden = YES;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + 360 - 68);
    [self.detailCourseView updateUIWithCourseArray:colArray andCourseTime:indexPath.section andWeekNum:indexPath.row];
    self.detailCourseView.hidden = NO;
    [self showDetailCourseView];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.courseCollectionView cellForItemAtIndexPath:indexPath];
    //    if (cell.backgroundColor == kCommonWhite_Color)
    //    {
    //        return;
    //    }
    if (old_selectedIndexPath)
    {
        //        UICollectionViewCell *cell = [self.courseCollectionView cellForItemAtIndexPath:old_selectedIndexPath];
        cell.alpha = 1.0f;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
    //    if (fabs(x_oldBGView - scrollView.contentOffset.x) > fabs(y_oldBGView - scrollView.contentOffset.y))
    //    {
    //
    //        self.backgroundScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, y_oldBGView);
    //        x_oldBGView = scrollView.contentOffset.x;
    //    } else if (fabs(x_oldBGView - scrollView.contentOffset.x) < fabs(y_oldBGView - scrollView.contentOffset.y)) {
    //        self.backgroundScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, y_oldBGView);
    //        y_oldBGView = scrollView.contentOffset.y;
    //    } else {
    //        self.backgroundScrollView.contentOffset = CGPointMake(x_oldBGView, y_oldBGView);
    //    }
    //    x_oldBGView = scrollView.contentOffset.x;
    //    y_oldBGView = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundScrollView).with.offset(-scrollView.contentOffset.x - 200);
    }];
}
#pragma mark - 手势
- (void)handleWeekSelectedView:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (_isShowNotificationMenu) {
        [_popView dismissAnimated:YES];
        _isShowNotificationMenu = NO;
    }
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
            _didTouchedFinishButton = NO;
            if (self.bottomView.frame.size.height+self.bottomView.frame.origin.y >= self.view.frame.size.height + kStandardPx(18)/2)
            {
                [self hideWeekSelectedView];
            }
            
            
            if (gestureRecognizer.state == 3)
            {
                [self hideWeekSelectedView];
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
                [self showWeekSelectedView];
            }
            
            if (gestureRecognizer.state == 3)
            {
                
                [self showWeekSelectedView];
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

- (void)handleWithCourseDetailView:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (_isShowNotificationMenu) {
        [_popView dismissAnimated:YES];
        _isShowNotificationMenu = NO;
    }
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    if (gestureRecognizer.state != UIGestureRecognizerStateFailed)
    {
        if (y_oldCourseViewPoint != 0)
            sum_yCourseViewOffset = sum_yCourseViewOffset + point.y - y_oldCourseViewPoint;
        if (y_oldCourseViewPoint != 0 && point.y > y_oldCourseViewPoint) //下拉
        {
            
            if (self.detailCourseView.frame.origin.y != self.view.frame.size.height - 78)
                [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_bottom).with.offset(sum_yCourseViewOffset);
                }];
            
            if (self.detailCourseView.frame.origin.y >= self.view.frame.size.height-78)
            {
                [self hideDetailCourseView];
            }
            
            
            if (gestureRecognizer.state == 3)
            {
                if (self.view.frame.size.height - self.detailCourseView.frame.origin.y >= 78 && self.view.frame.size.height - self.detailCourseView.frame.origin.y <= 360)
                {
                    [self hideDetailCourseView];
                }
                
                if (self.view.frame.size.height - self.detailCourseView.frame.origin.y >= 360)
                {
                    [self showDetailCourseView];
                }
                
            }
            
            point.y -= 0.5;
        } else if (point.y < y_oldCourseViewPoint) { //上拉
            
            if (self.detailCourseView.frame.origin.y != self.view.frame.size.height - 554)
                [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_bottom).with.offset(sum_yCourseViewOffset);
                }];
            
            if (self.view.frame.size.height - self.detailCourseView.frame.origin.y >= 554)
            {
                [self showAllDetailCourseView];
            }
            
            
            if (gestureRecognizer.state == 3)
            {
                if (self.view.frame.size.height - self.detailCourseView.frame.origin.y >= 360)
                {
                    [self showAllDetailCourseView];
                } else if (self.view.frame.size.height - self.detailCourseView.frame.origin.y <= 360)
                    [self showDetailCourseView];
                
            }
            point.y += 0.5;
        }
        
        
        
    }
    y_oldCourseViewPoint = point.y;
    if (gestureRecognizer.state == 3)
    {
        y_oldCourseViewPoint = 0;
    }
    
}

- (void)showDetailCourseView
{
    sum_yCourseViewOffset = -360;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + 360 - 68);
    
    [UIView animateWithDuration:animationTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(-360);
        }];
        [self.detailCourseView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideDetailCourseView
{
    sum_yCourseViewOffset = -78;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + 10);
    
    [UIView animateWithDuration:animationTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(-78);
        }];
        [self.detailCourseView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAllDetailCourseView
{
    sum_yCourseViewOffset = -554;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + 10);
    
    [UIView animateWithDuration:animationTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(-554);
        }];
        [self.detailCourseView.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - 点击事件
- (void)showWeekSelectedView
{
    self.weekButton.hidden = YES;
    self.finishButton.hidden = NO;
    sum_yOffset = -215;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + 215);
    [UIView animateWithDuration:animationTime animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-215);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];
    _didTouchedFinishButton = YES;
}

- (void)hideWeekSelectedView
{
    self.weekButton.hidden = NO;
    self.finishButton.hidden = YES;
    sum_yOffset = 0;
    
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3);
    [UIView animateWithDuration:animationTime animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(kStandardPx(18)/2);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];
    if (_didTouchedFinishButton)
    {
        _isFirstShowCourse = NO;
        if ([self.weekPicker selectedRowInComponent:0]+1 == [ZCYUserMgr sharedMgr].shcoolWeek)
            self.weekLabel.text = [NSString stringWithFormat:@"第%@周", [NSDate schoolWeekStringWithWeek:[ZCYUserMgr sharedMgr].shcoolWeek]];
        else
            self.weekLabel.text = [NSString stringWithFormat:@"第%@周", _weekArray[[self.weekPicker selectedRowInComponent:0]]];
        
        [self.courseCollectionView reloadData];
    }
}

#pragma mark - ZCYCloseButtonTouchedDelegate
- (void)closeButtonDidPressed
{
    if (self.weekPicker.hidden == NO) {
        return;
    }
    self.bottomView.hidden = NO;
    self.weekPicker.hidden = NO;
    UICollectionViewCell *cell = [self.courseCollectionView cellForItemAtIndexPath:old_selectedIndexPath];
    cell.alpha = 1.0f;
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3 + self.view.frame.size.height - self.weekPicker.frame.origin.y);
    [UIView animateWithDuration:0.2f animations:^{
        [self.detailCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        [self.detailCourseView.superview layoutIfNeeded];
    }];
}

- (void)reportErrorDidPressed
{
    ZCYFeedBackViewController *feedBack = [[ZCYFeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBack animated:YES];
}

-(void)addNotificationDidPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    ZCYCuurentTimeModel *timeModel = [ZCYUserMgr sharedMgr].schoolTimeModel;
    if (timeModel == nil) {
        [[ZCYProgressHUD sharedHUD]showWithText:@"请先打开网络哦～" inView:self.view hideAfterDelay:1.5];
        [ZCYGetTimeHelper getCurrentTimeWithCompletionBlock:^(NSError *error, ZCYCuurentTimeModel *timeModel) {
            if (error) {
                NSLog(@"%@",error);
            }else{
                [ZCYUserMgr sharedMgr].schoolTimeModel = timeModel;
            }
        }];
    }
    NSInteger currentWeek = [timeModel.currentWeek integerValue];
    NSInteger currentWeekDay = [timeModel.currentWeekDay integerValue];
    NSInteger selectedWeek = [self.weekPicker selectedRowInComponent:0]+1;
    NSInteger selectedDay = currentSelectedIndexPath.row + 1;
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",timeModel.term_start];
    NSDate *startTime = [formate dateFromString:startTimeStr];
    NSTimeInterval startInterval = [startTime timeIntervalSince1970];
    NSArray *courseArray = [ZCYUserMgr sharedMgr].courseArray[currentSelectedIndexPath.row];
    NSArray *colArray = courseArray[currentSelectedIndexPath.section];
    __block ZCYTimeTableModel *weekModel = [[ZCYTimeTableModel alloc]init];
    __weak typeof(self) weakself = self;
    //仅选当周
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"仅选本周" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakself) strongSelf = weakself;
            if (selectedWeek < currentWeek) {
            [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
            return ;
        }else if (selectedWeek == currentWeek){
            if (selectedDay < currentWeekDay) {
                [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                return;
            }
            if (selectedDay == currentWeekDay) {
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSString *strHour = [dateFormatter stringFromDate:date];
                NSDate *now = [dateFormatter dateFromString:strHour];
                NSDate *courseStartDate;
                NSString *courseStr;
                if (currentSelectedIndexPath.section == 0) {
                    courseStr = @"08:00:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                }
                if (currentSelectedIndexPath.section == 1) {
                    courseStr = @"10:05:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                    
                }
                if (currentSelectedIndexPath.section == 2) {
                    courseStr = @"14:00:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                    
                }
                if (currentSelectedIndexPath.section == 3) {
                    courseStr = @"16:05:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                }
                if (currentSelectedIndexPath.section == 4) {
                    courseStr = @"19:00:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                }
                if (currentSelectedIndexPath.section == 5) {
                    courseStr = @"20:50:00";
                    courseStartDate = [dateFormatter dateFromString:courseStr];
                    if ([courseStartDate compare:now] == NSOrderedAscending) {
                        [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经上过了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                        return;
                    }
                }
            }
        }
        
        for (int i = 0; i < colArray.count; i++) {
            ZCYTimeTableModel *model = colArray[i];
            NSArray *arr = model.courseWeeks;
            for (NSInteger i = 0; i < arr.count; i++) {
                if ([arr[i] integerValue] == selectedWeek) {
                    weekModel = model;
                }
            }
        }
        NSString *courseName = weekModel.courseName;
        
        NSTimeInterval dayInterval = (selectedDay-1+(selectedWeek-1)*7)*24*3600;
        NSTimeInterval hourInterval = 0;
        if (currentSelectedIndexPath.section == 0) {
            hourInterval = (7*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 1) {
            hourInterval = (9*60+55)*60;
        }
        if (currentSelectedIndexPath.section == 2) {
            hourInterval = (13*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 3) {
            hourInterval = (15*60+55)*60;
        }
        if (currentSelectedIndexPath.section == 4) {
            hourInterval = (18*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 5) {
            hourInterval = (20*60+45)*60;
        }
        NSTimeInterval allInterval = startInterval+dayInterval+hourInterval;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:allInterval];
        [self addNotificationWithFireDate:date andIdentifier:[NSString stringWithFormat:@"%@-第%lu周",courseName,selectedWeek]];
        [[ZCYProgressHUD sharedHUD] showWithText:@"设置成功" inView:strongSelf.view hideAfterDelay:1.0];
    }];
    [alert addAction:action];
    //所有周次
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"所有周次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakself;
        NSMutableArray *weeksArray = [NSMutableArray array];
        NSMutableArray *nameArray = [NSMutableArray array];
        for (int i = 0; i < colArray.count; i++) {
            ZCYTimeTableModel *model = colArray[i];
            NSArray *arr = model.courseWeeks;
            for (NSInteger i = 0; i < arr.count; i++) {
                if ([arr[i] integerValue] == selectedWeek) {
                    weekModel = model;
                }
            }
        }
        
        if (weekModel.courseWeeks[0] == [weekModel.courseWeeks lastObject])
        {
            if (selectedWeek < currentWeek) {
                [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经结束了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                return ;
            }else if (selectedWeek == currentWeek){
                if (currentSelectedIndexPath.row+1 < currentWeekDay) {
                    [[ZCYProgressHUD sharedHUD] showWithText:@"该课已经结束了哦～" inView:strongSelf.view hideAfterDelay:1.0];
                    return;
                }
            }
        }
        for (int i = 0; i < weekModel.courseWeeks.count; i++) {
            [weeksArray addObject:weekModel.courseWeeks[i]];
            [nameArray addObject:weekModel.courseName];
        }
        for (NSInteger i = weeksArray.count-1; i >= 0; i--) {
            if ([weeksArray[i] integerValue] < currentWeek) {
                [weeksArray removeObjectAtIndex:i];
                [nameArray removeObjectAtIndex:i];
            }
            if ([weeksArray[i] integerValue] == currentWeek) {
                if (currentWeekDay > selectedDay) {
                    [weeksArray removeObjectAtIndex:i];
                    [nameArray removeObjectAtIndex:i];
                }
            }
        }
        NSTimeInterval dayInterval = (selectedDay-1+(selectedWeek-1)*7)*24*3600;
        NSTimeInterval hourInterval = 0;
        if (currentSelectedIndexPath.section == 0) {
            hourInterval = (7*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 1) {
            hourInterval = (9*60+55)*60;
        }
        if (currentSelectedIndexPath.section == 2) {
            hourInterval = (13*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 3) {
            hourInterval = (15*60+55)*60;
        }
        if (currentSelectedIndexPath.section == 4) {
            hourInterval = (18*60+50)*60;
        }
        if (currentSelectedIndexPath.section == 5) {
            hourInterval = (20*60+40)*60;
        }
        for (int i = 0; i < weeksArray.count; i++) {
            NSTimeInterval weekInterval = ([weeksArray[i] integerValue]-currentWeek)*7*24*3600;
            NSTimeInterval allInterval = startInterval+dayInterval+hourInterval+weekInterval;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:allInterval];
            [self addNotificationWithFireDate:date andIdentifier:[NSString stringWithFormat:@"%@-第%@周",nameArray[i],weeksArray[i]]];
        }
        [[ZCYProgressHUD sharedHUD] showWithText:@"设置成功" inView:strongSelf.view hideAfterDelay:1.0];
    }];
    [alert addAction:act];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addNotificationWithFireDate:(NSDate *)date andIdentifier:(NSString *)identifier{
    if ([ZCYUserMgr sharedMgr].notificationIdentifiers == nil) {
        [ZCYUserMgr sharedMgr].notificationIdentifiers = [NSMutableArray array];
    }
    if (_menuArray == nil) {
        _menuArray = [NSMutableArray array];
    }
    [_menuArray addObject:identifier];
    [[ZCYUserMgr sharedMgr].notificationIdentifiers addObject:identifier];
    ZCYUserMgr *userMgr = [ZCYUserMgr sharedMgr];
    NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:userMgr];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
    NSLog(@"%@",[ZCYUserMgr sharedMgr].notificationIdentifiers);
    if ([[UIDevice currentDevice] systemVersion].integerValue >= 10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //通知内容对象
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.title = @"该上课啦！";
        content.body = [NSString stringWithFormat:@"同学，再过十分钟就要上课了，不要迟到哦～"];
        content.sound = [UNNotificationSound defaultSound];
        NSTimeInterval nowInterval = [date timeIntervalSinceNow];
        //通知触发机制
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:nowInterval repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        //推送成功后处理
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            [[ZCYUserMgr sharedMgr].notificationIdentifiers removeObject:identifier];
        }];
    }else{
        NSDictionary *dic = @{[NSString stringWithFormat:@"%lu",_menuArray.count]:identifier};
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.fireDate = date;
        notification.alertBody = @"同学，该上课了哦！";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.userInfo = dic;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

-(void)changeNotification:(UIBarButtonItem *)sender{
    if ([ZCYUserMgr sharedMgr].notificationIdentifiers == nil) {
        [[ZCYProgressHUD sharedHUD] showWithText:@"还没有添加课程提醒哦" inView:self.view hideAfterDelay:1.0];
        return;
    }
    if (_isShowNotificationMenu) {
        [_popView dismissAnimated:YES];
        _isShowNotificationMenu = NO;
    }else{
        self.notificationMenu.frame = CGRectMake(0, 0, 140, 200);
        self.notificationMenu.backgroundColor = [UIColor colorWithRed:92/255.0 green:255/255.0 blue:117/255.0 alpha:1];
        _notificationMenu.showsVerticalScrollIndicator = NO;
        _notificationMenu.separatorStyle = UITableViewCellSelectionStyleDefault;
        self.notificationMenu.alwaysBounceVertical = YES;
        [self.notificationMenu reloadData];
        _popView = [[CMPopTipView alloc] initWithCustomView:self.notificationMenu];
        //    popView.delegate = self;
        _popView.cornerRadius = 5;
        _popView.backgroundColor = [UIColor colorWithRed:92/255.0 green:255/255.0 blue:117/255.0 alpha:1];
        _popView.textColor = [UIColor whiteColor];
        // 0是Slide  1是pop  2是Fade但是有问题，用前两个就好了
        _popView.animation = arc4random() % 1;
        // 立体效果，默认是YES
        _popView.has3DStyle = arc4random() % 1;
        //        popView.dismissTapAnywhere = YES;
        //        [popView autoDismissAnimated:YES atTimeInterval:5.0];
        
        //    [popView presentPointingAtView:_atView inView:_containerView animated:YES];
        
        // 如果是原生的UIBarButtonItem，那么就调用这个方法
        [_popView presentPointingAtBarButtonItem:sender animated:YES];
        _isShowNotificationMenu = YES;
    }
    
}


#pragma mark - TOOL

- (void)setView:(UIView *)view WithNum:(NSString *)numString andSegColor:(UIColor *)color shouldShowSeg:(BOOL)showSeg
{
    view.backgroundColor = kCommonLightGray_Color;
    UILabel *label = [[UILabel alloc] init];
    [label setFont:kFont(kStandardPx(26)) andText:numString andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(view);
    }];
    
    if (showSeg == YES)
    {
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = kDeepGreen_Color;
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = 2.5;
        [view addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view.mas_bottom).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
    }
}

- (void)setCollectionViewCell:(UICollectionViewCell *)cell withColor:(UIColor *)cellColor andCourseName:(NSString *)courseName andClassID:(NSString *)classID
{
    NSInteger idc = [classID integerValue];
    NSString *classPlaceString;
    if (idc != 0)
    {
        classPlaceString = [NSString stringWithFormat:@"%@",@(idc)];
    } else {
        classPlaceString = [classID substringWithRange:NSMakeRange(0, [classID
                                                                       length])];
    }
    cell.backgroundColor = cellColor;
    
    UILabel *courseeLabel = [[UILabel alloc] init];
    courseeLabel.textAlignment = NSTextAlignmentCenter;
    courseeLabel.text = [NSString stringWithFormat:@"%@", courseName];
    courseeLabel.textColor = kCommonWhite_Color;
    courseeLabel.font = kFont(kStandardPx(24*self.view.frame.size.width/375));
    courseeLabel.numberOfLines = 0;
    [cell addSubview:courseeLabel];
    [courseeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(2.5);
        make.right.equalTo(cell).with.offset(-2.5);
        make.centerY.equalTo(cell).with.offset(-8);
    }];
    
    UILabel *classIDLabel = [[UILabel alloc] init];
    classIDLabel.text = [NSString stringWithFormat:@"%@", classPlaceString];
    classIDLabel.textColor = kCommonWhite_Color;
    classIDLabel.font = kFont(kStandardPx(24*self.view.frame.size.width/375));
    classIDLabel.textAlignment = NSTextAlignmentCenter;
    classIDLabel.numberOfLines = 0;
    [cell addSubview:classIDLabel];
    [classIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(2.5);
        make.right.equalTo(cell).with.offset(-2.5);
        make.top.equalTo(courseeLabel.mas_bottom);
    }];
}



@end
