//
//  ZCYCardDetailView.h
//  在重邮
//
//  Created by 周维康 on 16/12/6.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reportErrorDidClick)();
@interface ZCYCardDetailView : UIView

- (instancetype)initWithCardArray:(NSArray *)cardArray;

- (void)updateCardDetailViewWithCardArray:(NSArray *)cardArray;

@property (strong, nonatomic) reportErrorDidClick clickBlock;  /**< 报告错误按钮  */
@end
