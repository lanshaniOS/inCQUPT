
//
//  InfomationTypeView.m
//  i重邮
//
//  Created by 谭培 on 2017/3/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "InfomationTypeView.h"

@interface InfomationTypeView ()

@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation InfomationTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(3.5, 0, 40, 40)];
        [self addSubview:_iconImage];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, 50, 13)];
        //[_titleLabel sizeToFit];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClicked:)];
        [self addGestureRecognizer:reg];
    }
    return self;
}

-(void)viewClicked:(UITapGestureRecognizer *)reg{
    
    if (self.block) {
        self.block(reg.view.tag);
    }
}

//@[@"头条",@"教务公告",@"OA公告",@"会议通知",@"学术讲座",@"综合新闻"]
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type{
    self = [self initWithFrame:frame];
    if (self) {
        _titleLabel.text = type;
        if ([type isEqualToString:@"头条"]) {
            _iconImage.image = [UIImage imageNamed:@"Oval-green"];
        }else if([type isEqualToString:@"教务公告"]){
            _iconImage.image = [UIImage imageNamed:@"Oval-pink"];
        }else if ([type isEqualToString:@"OA公告"]){
            _iconImage.image = [UIImage imageNamed:@"Oval-yellow"];
        }else if ([type isEqualToString:@"会议通知"]){
            _iconImage.image = [UIImage imageNamed:@"Oval-blue"];
        }else if ([type isEqualToString:@"学术讲座"]){
            _iconImage.image = [UIImage imageNamed:@"Oval-orange"];
        }else{
            _iconImage.image = [UIImage imageNamed:@"Oval-green"];
        }
    }
    return self;
}

@end
