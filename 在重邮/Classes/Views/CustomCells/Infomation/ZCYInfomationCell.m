//
//  ZCYInfomationCell.m
//  i重邮
//
//  Created by 谭培 on 2017/3/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYInfomationCell.h"

@interface ZCYInfomationCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZCYInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title Time:(NSString *)time type:(NSString *)type{
    self.titleLabel.text = title;
    self.timeLabel.text = time;
    if ([type isEqualToString:@"oa"]) {
        _colorView.backgroundColor = [UIColor colorWithRed:241/255.0 green:185/255.0 blue:9/255.0 alpha:1];
    }else if ([type isEqualToString:@"jw"]) {
        _colorView.backgroundColor = [UIColor colorWithRed:252/255.0 green:23/255.0 blue:102/255.0 alpha:1];
    }else if ([type isEqualToString:@"new"]) {
        _colorView.backgroundColor = [UIColor colorWithRed:64/255.0 green:194/255.0 blue:37/255.0 alpha:1];
    }else if ([type isEqualToString:@"jz"]) {
        _colorView.backgroundColor = [UIColor colorWithRed:253/255.0 green:138/255.0 blue:9/255.0 alpha:1];
    }else //if ([type isEqualToString:@"hy"]) {
    {
        _colorView.backgroundColor = [UIColor colorWithRed:47/255.0 green:202/255.0 blue:161/255.0 alpha:1];
    }
}

@end
