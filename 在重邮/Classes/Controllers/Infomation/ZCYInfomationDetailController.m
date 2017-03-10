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

@interface ZCYInfomationDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)InfomationDetailModel *detailModel;
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
                    self.detailModel = detail;

                    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"detailNew" ofType:@"html"];
                    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
                    NSURL *url = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
                    [self.webView loadHTMLString:htmlCont baseURL:url];
                });
            }
        }];
    }
}

-(void)getInfomationType:(NSString *)type andId:(NSString *)infomationId{
    _infomationId = infomationId;
    _infomationType = type;
}


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
}

@end
