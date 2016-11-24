//
//  BaoXiuCollectionViewCell.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/13.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoXiuCell : UITableViewCell


@property (nonatomic,strong)NSString *BXID;
@property (nonatomic,strong)NSString *BXStates;
@property (nonatomic,strong)NSString *BXfwlx;
@property (nonatomic,strong)NSString *BXfwsj;
@property (nonatomic,strong)NSString *BXfwxm;
@property (nonatomic,strong) UIButton *detailButton;

@end
