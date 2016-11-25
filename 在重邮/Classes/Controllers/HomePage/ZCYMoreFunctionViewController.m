//
//  ZCYMoreFunctionViewController.m
//  在重邮
//
//  Created by 周维康 on 16/11/22.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYMoreFunctionViewController.h"
#import "ZCYCourseViewController.h"
#import "ZCYHydroelectricViewController.h"
#import "ZCYSchoolCardViewController.h"
#import "ZCYPropertyRepairViewController.h"
#import "ZCYLendBookViewController.h"

@interface ZCYMoreFunctionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *funcCollectionView;  /**< 应用大全 */

@end

@implementation ZCYMoreFunctionViewController
{
    CGFloat _screenWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    _screenWidth = self.view.frame.size.width;
    [self initUI];
    // Do any additional setup after loading the view.
    
}

- (void)initUI
{
    [self initFuncCollectionView];
}

- (void)initFuncCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 12;
    layout.itemSize = CGSizeMake(_screenWidth/4 - 36 - 24, _screenWidth/4 - 36 - 24 + 20);
    self.funcCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.funcCollectionView.backgroundColor = kCommonWhite_Color;
    self.funcCollectionView.delegate = self;
    self.funcCollectionView.dataSource = self;
    [self.funcCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"moreFunctionCollectionViewCellIdentifier"];
    [self.view addSubview:self.funcCollectionView];
    [self.funcCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return [self functionDefines].count%4==0 ? [self functionDefines].count/4 : [self functionDefines].count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.funcCollectionView dequeueReusableCellWithReuseIdentifier:@"moreFunctionCollectionViewCellIdentifier" forIndexPath:indexPath];
    if (indexPath.section*4 + indexPath.row < [self functionDefines].count)
    {
        UIImageView *functionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self functionDefines][indexPath.section*4 + indexPath.row][@"iconName"]]];
        functionImageView.frame = CGRectMake(0, 0, _screenWidth/4 - 36 - 24, _screenWidth/4 - 36 - 24);
        
        [cell addSubview:functionImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(cell.bounds.origin.x - 5, cell.bounds.origin.y+48, cell.bounds.size.width + 10, 15);
        nameLabel.font = kFont(kStandardPx(22));
        nameLabel.textColor = kText_Color_Default;
        nameLabel.text = [self functionDefines][indexPath.section*4 + indexPath.row][@"funcName"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:nameLabel];
    }
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section*4 + indexPath.row < [self functionDefines].count)
    {
        NSString *classString = [self functionDefines][indexPath.section*4 + indexPath.row][@"nextController"];
        Class vcClass = NSClassFromString(classString);
        UIViewController *nextViewController = [[vcClass alloc] init];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
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
              @"nextController" : NSStringFromClass([ZCYSchoolCardViewController class])},
            
            @{@"funcName" : @"水电查询",
              @"iconName" : @"水电查询",
              @"nextController" : NSStringFromClass([ZCYHydroelectricViewController class])},
            
            @{@"funcName" : @"物业报修",
              @"iconName" : @"物业报修",
              @"nextController" : NSStringFromClass([ZCYPropertyRepairViewController class])},
            
            @{@"funcName" : @"借阅信息",
              @"iconName" : @"借阅信息",
              @"nextController" : NSStringFromClass([ZCYLendBookViewController class])},
            nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
