//
//  ZCYRepairApllyModel.h
//  在重邮
//
//  Created by 蓝山工作室 on 2016/11/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZCYRepairApplyModel : NSObject

@property (nonatomic,strong)NSString *studentId;
@property (nonatomic,strong)NSString *studentName;
@property (nonatomic,strong)NSString *studentIp;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *CategoryId;
@property (nonatomic,strong)NSString *SpecificId;
@property (nonatomic,strong)NSString *Phone;
@property (nonatomic,strong)NSString *AddressId;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *Address;
+(NSDictionary *)initToDataWithId:(NSString *)studentId name:(NSString *)name Ip:(NSString *)ip title:(NSString *)title CategoryId:(NSString *)categoryId specificId:(NSString *)specificId phone:(NSString *)phone addressId:(NSString *)addressId content:(NSString   *)content address:(NSString *)address;



@end
