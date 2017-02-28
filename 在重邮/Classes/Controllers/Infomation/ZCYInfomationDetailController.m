//
//  ZCYInfomationController.m
//  i重邮
//
//  Created by 谭培 on 2017/2/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ZCYInfomationDetailController.h"
#import "InfomationDetailModel.h"
#import "InfomationDetailHelper.h"

@interface ZCYInfomationDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;
@property (nonatomic,strong)NSString *infomationType;
@property (nonatomic,strong)NSString *infomationId;
@end

@implementation ZCYInfomationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{@"iw":@"教务公告",@"oa":@"OA公告",@"new":@"综合新闻",@"":@"",@"":@""};
    self.title = [dic objectForKey:_infomationType];
    [self getNews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)getNews{
    if (_infomationId&&_infomationType) {
        [InfomationDetailHelper getInfomationDetailWithType:_infomationType andId:_infomationId andCompletionBlock:^(NSError *erro, InfomationDetailModel *detail) {
            if (erro) {
                NSLog(@"%@",erro);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0];
                    self.titleLabel.text = detail.title;
                    self.timeLabel.text = detail.time;
                    self.bodyText.text = detail.body;
                    NSLog(@"%@---%@",_titleLabel,detail.time);
                });
            }
        }];
    }
}

-(void)getInfomationType:(NSString *)type andId:(NSString *)infomationId{
    _infomationId = infomationId;
    _infomationType = type;
}

@end
