//
//  ZCYHomePageViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYHomePageViewController.h"
#import "ZCYClassViewController.h";
@interface ZCYHomePageViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 背景下拉板 */
@property (strong, nonatomic) UICollectionView *functionCollectionView;  /**< 功能板块 */
@property (strong, nonatomic) UIImageView *backgroundImageView;  /**< 背景图画 */
@end

@implementation ZCYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)initUI
{
    self.view.backgroundColor = kAppBg_Color;
    [self setNavigationBar];
    [self initBackgroundScrollView];
    [self initFunctionCollectionView];
    
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
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
    [self.backgroundScrollView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.backgroundScrollView).with.offset(-20);
        make.height.mas_equalTo(215);
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
    self.functionCollectionView.delegate = self;
    self.functionCollectionView.dataSource = self;
    [self.backgroundScrollView addSubview:self.functionCollectionView];
    [self.functionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(82);
    }];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.functionCollectionView dequeueReusableCellWithReuseIdentifier:@"functionCollectionViewCellID" forIndexPath:indexPath];
    
    return cell;
}

- (NSArray *)functionDefines
{
    return [NSArray arrayWithObjects:@{@"funcName" : @"课表",
                                       @"iconName" : @"课表",
                                       @"nextController" : NSStringFromClass([ZCYClassViewController class])}, nil];
}
@end
