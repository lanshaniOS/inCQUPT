//
//  ZCYNotificationMenu.m
//  i重邮
//
//  Created by 谭培 on 2017/3/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYNotificationMenu.h"
#import "CMPopTipView.h"

@interface ZCYNotificationMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *menuArray;
@property (nonatomic,strong)UITableView *menu;
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIView *atView;
@end

@implementation ZCYNotificationMenu

-(instancetype)initWithArr:(NSArray *)arr containerView:(UIView *)containerView atView:(UIView *)view{
    if (self = [super init]) {
        _menuArray = [NSArray arrayWithArray:arr];
        _containerView = containerView;
        _atView = view;
        [self setup];
    }
    return self;
}

-(void)setup{

    self.menu.frame = CGRectMake(0, 0, 100, 180);
    self.menu.backgroundColor = [UIColor blackColor];
    self.menu.alwaysBounceVertical = YES;
    CMPopTipView *popView = [[CMPopTipView alloc] initWithCustomView:self.menu];
//    popView.delegate = self;
    popView.cornerRadius = 5;
    popView.backgroundColor = [UIColor blackColor];
    popView.textColor = [UIColor whiteColor];
    // 0是Slide  1是pop  2是Fade但是有问题，用前两个就好了
    popView.animation = arc4random() % 1;
    // 立体效果，默认是YES
    popView.has3DStyle = arc4random() % 1;
    //        popView.dismissTapAnywhere = YES;
    //        [popView autoDismissAnimated:YES atTimeInterval:5.0];
    
    [popView presentPointingAtView:_atView inView:_containerView animated:YES];
    
    // 如果是原生的UIBarButtonItem，那么就调用这个方法
    //        popView presentPointingAtBarButtonItem:(UIBarButtonItem *) animated:(BOOL)
}

#pragma mark - uitableViewDeleagete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.menuArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate itemClickedAtIndex:indexPath.row];
}

@end
