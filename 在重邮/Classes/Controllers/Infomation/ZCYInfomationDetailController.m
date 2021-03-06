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
#import "YYTextView.h"

@interface ZCYInfomationDetailController ()<YYTextViewDelegate, UITextViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)InfomationDetailModel *detailModel;
@property (nonatomic,strong)NSString *infomationType;
@property (nonatomic,strong)NSString *infomationId;
@property (strong, nonatomic) YYTextView *textView;  /**< 文字试图 */
@property (strong, nonatomic) UILabel *titleLabel;  /**< 提示 */
@end

@implementation ZCYInfomationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{@"jw":@"教务公告",@"oa":@"OA公告",@"new":@"综合新闻",@"hy":@"会议通知",@"jz":@"学术讲座"};
    self.title = dic[_infomationType];

    self.textView = [[YYTextView alloc] init];
    self.textView.delegate = self;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(0);
    }];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:3];
    self.titleLabel.textColor = [UIColor colorWithRGBHex:0x545454];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.textView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView);
        make.left.and.right.equalTo(self.view);
    }];
    [self getNews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)getNews{
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"获取数据中" inView:self.view];
    if (_infomationId&&_infomationType) {
        @weakify(self)
        [InfomationDetailHelper getInfomationDetailWithType:_infomationType andId:_infomationId andCompletionBlock:^(NSError *erro, InfomationDetailModel *detail) {
            @strongify(self)
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0];
            if (erro) {
                [[ZCYProgressHUD sharedHUD] showWithText:erro.localizedDescription inView:self.view hideAfterDelay:1.0f];
            }else{
         
                    self.detailModel = detail;
                    
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
                    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                    dispatch_async(backgroundQueue, ^{
                        
                        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", self.detailModel.title] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20 weight:3],
                                                                                                    NSForegroundColorAttributeName : kCommonWhite_Color}];
                        [attributeString appendAttributedString:titleString];
                        if (self.detailModel.time)
                        {
                            NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", self.detailModel.time] attributes:@{NSFontAttributeName : kFont(12), NSForegroundColorAttributeName : [UIColor colorWithRGBHex:0xb2b2b2]}];
                            [attributeString appendAttributedString:timeString];

                        }
                        if (self.detailModel.body)
                        {
                            NSAttributedString *textString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", self.detailModel.body] attributes:@{NSFontAttributeName : kFont(16), NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x7F8389]}];
                            [attributeString appendAttributedString:textString];
                        }

                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.titleLabel.text = [NSString stringWithFormat:@"\n%@", self.detailModel.title];
                             self.textView.attributedText = attributeString;
    
                        });
                    
                });
            }
        }];
    }
}

-(void)getInfomationType:(NSString *)type andId:(NSString *)infomationId{
    _infomationId = infomationId;
    _infomationType = type;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return YES;
}



@end
