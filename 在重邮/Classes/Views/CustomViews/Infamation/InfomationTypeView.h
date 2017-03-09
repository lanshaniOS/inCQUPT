//
//  InfomationTypeView.h
//  i重邮
//
//  Created by 谭培 on 2017/3/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^viewBlock) (NSInteger tag);
@interface InfomationTypeView : UIView

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type;

@property (nonatomic,copy)viewBlock block;

@end
