//
//  BXDetailModel.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/15.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCYRepairDetailModel : NSObject

@property (nonatomic,strong)NSString *wx_djh; //报修记录ID
@property (nonatomic,strong)NSString *wx_bxlxm; //报修类型
@property (nonatomic,strong)NSString *wx_wxztm; //报修状态
@property (nonatomic,strong)NSString *wx_bxsj;   //报修时间
@property (nonatomic,strong)NSString *wx_fwqym;   //服务区域
@property (nonatomic,strong)NSString *wx_bxdd;    //报修地址
@property (nonatomic,strong)NSString *wx_bxdh;    //报修电话
@property (nonatomic,strong)NSString *wx_bxr;   //报修人
@property (nonatomic,strong)NSString *wx_bxnr;  //报修内容
@property (nonatomic,strong)NSString *wx_slr;  //处理人

@end
