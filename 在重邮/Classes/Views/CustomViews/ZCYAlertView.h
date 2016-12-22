//
//  ZCYAlertView.h
//  在重邮
//
//  Created by 周维康 on 16/12/5.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCYAlertView;
@protocol ZCYAlertViewDelegate <NSObject>

@required
- (void)alertView:(ZCYAlertView *)alertView didClickAtIndex:(NSInteger)index;

@optional
- (void)cancelButtonDidClick;

@end
@interface ZCYAlertView : UIView

- (instancetype)initWithFuncArray:(NSArray *)funcArray;

@property (nonatomic, weak) id <ZCYAlertViewDelegate>delegate;

- (void)show;

- (void)hide;
@end
