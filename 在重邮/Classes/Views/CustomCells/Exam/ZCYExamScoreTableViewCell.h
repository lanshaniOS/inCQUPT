//
//  ZCYExamScoreTableViewCell.h
//  在重邮
//
//  Created by 周维康 on 16/12/1.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCYExamScoreTableViewCell : UITableViewCell

- (void)setCellWithScoreInfo:(NSDictionary *)examInfo;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithScoreDic:(NSDictionary *)scoreDic;
@end
