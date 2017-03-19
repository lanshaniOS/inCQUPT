//
//  ZCYUserMgr.h
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZCYCuurentTimeModel;

@interface ZCYUserMgr : NSObject

@property (strong, nonatomic) NSString *studentNumber;  /**< 学号 */
@property (strong, nonatomic) NSArray *courseArray;  /**< 课程总述 */
@property (strong, nonatomic) NSString *collegeName;  /**< 学校名称 */
@property (strong, nonatomic) NSString *userName;  /**< 用户名称 */
@property (strong, nonatomic) NSString *eduType;  /**< 教育水平（本科生、研究生） */
//@property (strong, nonatomic) NSString *eduMajor;  /**< 专业 */
@property (strong, nonatomic) NSString *identityID;  /**< 身份证后六位 */
@property (strong, nonatomic) NSDictionary *lendBookDic;  /**< 借阅信息 */
@property (strong, nonatomic) NSArray *examRecord;  /**< 考试安排 */
@property (strong, nonatomic) NSArray *dormitoryArray;  /**< 寝室 */
@property (nonatomic,strong) NSDictionary *repairInfomation;
@property (nonatomic,strong) NSArray *repairAddressChoices;
@property (strong, nonatomic) NSString *cardID;  /**< 一卡通号 */
@property (strong, nonatomic) NSDictionary *dormitoryDic;  /**< 水电详情 */
@property (strong, nonatomic) NSData *settingImageData;  /**< 设置顶部图片 */
@property (assign, nonatomic) NSInteger shcoolWeek;  /**< 开学周数 */
@property (nonatomic,strong) ZCYCuurentTimeModel *schoolTimeModel;
@property (nonatomic,strong) NSMutableArray *notificationIdentifiers;

+ (ZCYUserMgr *)sharedMgr;

- (void)removeMgr;
@end
