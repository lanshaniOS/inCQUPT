//
//  ZCYUserMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserMgr.h"


@interface ZCYUserMgr() <NSCoding>

@end
@implementation ZCYUserMgr

static ZCYUserMgr *sharedMgr = nil;

+ (ZCYUserMgr *)sharedMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[self alloc] init];
        sharedMgr.studentNumber = @"";
        sharedMgr.courseArray = [[NSArray alloc] init];
    });
    return sharedMgr;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.studentNumber forKey:@"STUDENTNUMBER"];
    [aCoder encodeObject:self.courseArray forKey:@"COURSEARRAY"];
    [aCoder encodeObject:self.schoolName forKey:@"SCHOOLNAME"];
    [aCoder encodeObject:self.eduType forKey:@"EDUTYPE"];
    [aCoder encodeObject:self.eduMajor forKey:@"EDUMAJOR"];
    [aCoder encodeObject:self.userName forKey:@"USERNAME"];
    [aCoder encodeObject:self.dormitoryArray forKey:@"DORMITORYARRAY"];
    [aCoder encodeObject:self.repairInfomation forKey:@"REPAIRINFOMATION"];
    [aCoder encodeObject:self.repairAddressChoices forKey:@"REPAIRADDRESS"];
    [aCoder encodeObject:self.cardID forKey:@"CARDID"];
    [aCoder encodeObject:self.settingImageData forKey:@"SETTINGIMAGEDATA"];
    [aCoder encodeObject:self.identityCard forKey:@"IDENTITYCARD"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [ZCYUserMgr sharedMgr];
    if (self)
    {
        self.studentNumber = [aDecoder decodeObjectForKey:@"STUDENTNUMBER"];
        self.courseArray = [aDecoder decodeObjectForKey:@"COURSEARRAY"];
        self.schoolName = [aDecoder decodeObjectForKey:@"SCHOOLNAME"];
        self.eduType = [aDecoder decodeObjectForKey:@"EDUTYPE"];
        self.eduMajor = [aDecoder decodeObjectForKey:@"EDUMAJOR"];
        self.userName = [aDecoder decodeObjectForKey:@"USERNAME"];
        self.dormitoryArray = [aDecoder decodeObjectForKey:@"DORMITORYARRAY"];
        self.repairInfomation = [aDecoder decodeObjectForKey:@"REPAIRINFOMATION"];
        self.repairAddressChoices = [aDecoder decodeObjectForKey:@"REPAIRADDRESS"];
        self.cardID = [aDecoder decodeObjectForKey:@"CARDID"];
        self.settingImageData = [aDecoder decodeObjectForKey:@"SETTINGIMAGEDATA"];
        self.identityCard = [aDecoder decodeObjectForKey:@"IDENTITYCARD"];
    }
    return self;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(schoolName)) : @"school",
             NSStringFromSelector(@selector(eduType)) : @"edutype",
             NSStringFromSelector(@selector(eduMajor)) : @"edumajor",
             NSStringFromSelector(@selector(userName)) : @"name",
             NSStringFromSelector(@selector(studentNumber)) : @"userNumber",
             NSStringFromSelector(@selector(identityCard))  : @"identityCard"
             };
}

- (void)removeMgr
{
    self.studentNumber = nil;  /**< 学号 */
    self.courseArray = nil;  /**< 课程总述 */
    self.schoolName = nil; /**< 学校名称 */
    self.userName = nil; /**< 用户名称 */
    self.eduType = nil; /**< 教育水平（本科生、研究生） */
    self.eduMajor = nil;  /**< 专业 */
    self.lendBookDic = nil; /**< 借阅信息 */
    self.examRecord = nil; /**< 考试安排 */
    self.dormitoryArray = nil; /**< 寝室 */
    self.repairInfomation = nil;
    self.repairAddressChoices = nil;
    self.cardID = nil; /**< 一卡通号 */
    self.dormitoryDic = nil;
    self.settingImageData = nil;
    self.identityCard = nil;
}
@end
