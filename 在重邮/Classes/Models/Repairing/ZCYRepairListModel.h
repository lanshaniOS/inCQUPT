//
//  BXListModel.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYRepairListModel : NSObject

@property (nonatomic,strong)NSString *wx_djh; //报修记录ID
@property (nonatomic,strong)NSString *wx_bxlxm; //报修类型
@property (nonatomic,strong)NSString *wx_wxztm; //报修状态
@property (nonatomic,strong)NSString *wx_bxsj;   //报修时间
@property (nonatomic,strong)NSString *wx_bt;   //标题
@property (nonatomic,strong)NSString *wx_bxnr;  //报修内容

@end
