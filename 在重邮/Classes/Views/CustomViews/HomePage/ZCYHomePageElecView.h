//
//  ZCYHomePageElecView.h
//  在重邮
//
//  Created by 周维康 on 16/12/12.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^detailButtonClickedBlock)();

@interface ZCYHomePageElecView : UIView

- (instancetype)initWithElecString:(NSString *)elecString;

- (void)updateViewWithElecString:(NSString *)elecString;
@property (strong, nonatomic) detailButtonClickedBlock clickedBlock;  /**< 点击事件 */

@end
