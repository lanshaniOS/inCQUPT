//
//  ZCYCardDetailView.h
//  在重邮
//
//  Created by 周维康 on 16/12/6.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCYCardDetailView : UIView

- (instancetype)initWithCardArray:(NSArray *)cardArray;

- (void)updateCardDetailViewWithCardArray:(NSArray *)cardArray;

@end
