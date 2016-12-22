//
//  ZCYAlertView.m
//  在重邮
//
//  Created by 周维康 on 16/12/5.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYAlertView.h"

@interface ZCYAlertView()

@property (strong, nonatomic) NSArray *buttonNameArray;  /**< 按钮 */
@property (strong, nonatomic) UIControl *blackControl;  /**< 背景 */

@end

@implementation ZCYAlertView


- (instancetype)initWithFuncArray:(NSArray *)funcArray
{
    if (self = [super init])
    {
        self.buttonNameArray = funcArray;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFuncArray:nil];
}

- (void)setup
{
    self.backgroundColor = kCommonGray_Color;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).with.offset(0);
        make.left.and.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(60+self.buttonNameArray.count*51);
    }];
    
    self.blackControl = [[UIControl alloc] init];
    self.blackControl.backgroundColor = kCommonText_Color;
    [self.blackControl addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    self.blackControl.alpha = 0.5f;
    self.blackControl.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackControl];
    [self.blackControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([UIApplication sharedApplication].keyWindow);
        make.left.and.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo(self.mas_top);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = kCommonWhite_Color;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kCommonText_Color forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.and.left.equalTo(self);
        make.height.mas_offset(50);
    }];
    for (NSInteger index=0; index<self.buttonNameArray.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.buttonNameArray[index] forState:UIControlStateNormal];
        [button setTag:10000+index];
        [button setTitleColor:kCommonText_Color forState:UIControlStateNormal];
        button.backgroundColor = kCommonWhite_Color;
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cancelButton.mas_top).with.offset(-10-index*51);
            make.height.mas_equalTo(50);
            make.left.and.right.equalTo(self);
        }];
    }
    
}

- (void)show
{
    self.blackControl.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).with.offset(-60-self.buttonNameArray.count*51);
            make.left.and.right.equalTo([UIApplication sharedApplication].keyWindow);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            make.height.mas_offset(60+self.buttonNameArray.count*51);
        }];
        [self.superview layoutIfNeeded];
    }];
}

- (void)hide
{
    self.blackControl.hidden = YES;
    [UIView animateWithDuration:0.2f animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(60+self.buttonNameArray.count*51);
        }];
        [self.superview layoutIfNeeded];
    }];
}
- (void)didClickCancelButton
{
    self.blackControl.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonDidClick)])
    {
        [self.delegate cancelButtonDidClick];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(60+self.buttonNameArray.count*51);
        }];
        [self.superview layoutIfNeeded];
    }];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView: didClickAtIndex:)])
    {
        [self.delegate alertView:self didClickAtIndex:button.tag - 10000];
    }
}
@end
