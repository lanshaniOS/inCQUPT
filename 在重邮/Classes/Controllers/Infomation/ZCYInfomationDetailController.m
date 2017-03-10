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

@interface ZCYInfomationDetailController ()<YYTextViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)InfomationDetailModel *detailModel;
@property (nonatomic,strong)NSString *infomationType;
@property (nonatomic,strong)NSString *infomationId;
@property (strong, nonatomic) YYTextView *textView;  /**< 文字试图 */
@property (strong, nonatomic) YYTextView *tipView;  /**< 提示 */
@end

@implementation ZCYInfomationDetailController

- (NSString *)title
{
    return @"教务公告";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{@"iw":@"教务公告",@"oa":@"OA公告",@"new":@"综合新闻",@"":@"",@"":@""};
    self.title = [dic objectForKey:_infomationType];
    self.textView = [[YYTextView alloc] init];
    self.textView.font = kFont(16);
    self.textView.delegate = self;
    self.textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(0);
    }];
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
                        if (self.detailModel.title)
                        {
                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", self.detailModel.title] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:3], NSForegroundColorAttributeName : [UIColor colorWithRGBHex:0x545454]}];
                            [attributeString appendAttributedString:titleString];
                        }
                        if (self.detailModel.time)
                        {
                            NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.detailModel.time] attributes:@{NSFontAttributeName : kFont(10), NSForegroundColorAttributeName : [UIColor colorWithRGBHex:0xb2b2b2]}];
                            [attributeString appendAttributedString:timeString];

                        }
                        if (self.detailModel.body)
                        {
                            NSAttributedString *textString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.detailModel.body] attributes:@{NSFontAttributeName : kFont(16), NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x7F8389]}];
                            [attributeString appendAttributedString:textString];
                        }

                        dispatch_async(dispatch_get_main_queue(), ^{
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

<<<<<<< HEAD

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = self.detailModel.title;
    NSString *author = self.detailModel.time;
    NSString *body = self.detailModel.body;
    NSString *changeTitle = [NSString stringWithFormat:@"document.getElementsByClassName('title')[0].innerText = '%@';",title];
    [webView stringByEvaluatingJavaScriptFromString:changeTitle];
    NSString *changeAuthor = [NSString stringWithFormat:@"document.getElementsByClassName('info')[0].innerText = '%@';",author];
    [webView stringByEvaluatingJavaScriptFromString:changeAuthor];
    NSString *changeBody = [NSString stringWithFormat:@"document.getElementsByClassName('detail')[0].innerText = '%@';",body];
    NSLog(@"%@",changeBody);
    [webView stringByEvaluatingJavaScriptFromString:changeBody];
=======
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    return NO;
>>>>>>> 1dc1aa7783f5eaf1d2d8479fdd99bd192a366a66
}



@end
