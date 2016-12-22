//
//  ZCYFeedBackViewController.m
//  在重邮
//
//  Created by 周维康 on 16/12/18.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYFeedBackViewController.h"
#import "ZCYAlertView.h"
#import "YYText.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface ZCYFeedBackViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZCYAlertViewDelegate, UITextFieldDelegate, SKPSMTPMessageDelegate>

@property (strong, nonatomic) YYTextView *topTextView;  /**< 顶部意见反馈 */
@property (strong, nonatomic) UIView *addPicView;  /**< 添加图片 */
@property (strong, nonatomic) ZCYAlertView *alertView;  /**< 提示 */
@property (strong, nonatomic) UIButton *addPicButton;  /**< 添加图片按钮 */
@property (strong, nonatomic) UIImage *pickImage;  /**< 选中的图片 */
@property (strong, nonatomic) UIImageView *selectedImageView;  /**< 选中图片 */
@property (strong, nonatomic) YYTextView *describeTextView;  /**< 照片描述 */
@property (strong, nonatomic) UITextField *contactTextField;  /**< 联系方式 */
@property (strong, nonatomic) UIButton *commitButton;  /**< 提交 */
@property (assign, nonatomic) CGSize imageSize;  /**< 选取的图片的大小  */
@property (strong, nonatomic) SKPSMTPMessage *feedMessage;  /**< 反馈信息 */
@property (strong, nonatomic) UIControl *blackView;  /**< 黑色 */
@property (strong, nonatomic) UIButton *deleteButton;  /**< 删除按钮 */
@end

@implementation ZCYFeedBackViewController
{
    BOOL _isSelectedImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (NSString *)title
{
    return @"反馈意见";
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kCommonGray_Color;
    [self initTopTextView];
    [self initAddPicView];
    [self initContactView];
    [self initCommitButton];
}

- (void)initTopTextView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kCommonWhite_Color;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.height.mas_equalTo(120);
    }];
    
    self.topTextView = [[YYTextView alloc] init];
    self.topTextView.placeholderText = @"请输入遇到的问题或建议...";
    self.topTextView.font = kFont(kStandardPx(32));
    self.topTextView.backgroundColor = kCommonWhite_Color;
    self.topTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.topTextView.placeholderFont = kFont(kStandardPx(32));
    [topView addSubview:self.topTextView];
    [self.topTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView);
        make.height.mas_equalTo(120);
        make.left.equalTo(topView).with.offset(15);
        make.centerX.equalTo(self.view);
    }];
    
    
}

- (void)initAddPicView
{
    self.blackView = [[UIControl alloc] init];
    self.blackView.backgroundColor = kCommonText_Color;
    self.blackView.hidden = YES;
    [self.blackView addTarget:self action:@selector(hidePickerImageView) forControlEvents:UIControlEventTouchUpInside];

    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    self.addPicView = [[UIView alloc] init];
    self.addPicView.backgroundColor = kCommonWhite_Color;
    [self.view addSubview:self.addPicView];
    [self.addPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTextView.mas_bottom);
        make.left.equalTo(self.view).with.offset(0);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    self.addPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPicButton setTitle:@"+" forState:UIControlStateNormal];
    [self.addPicButton setTitleColor:kCommonBorder_Color forState:UIControlStateNormal];
    self.addPicButton.backgroundColor = kTransparentColor;
    self.addPicButton.layer.borderWidth = 1.5f;
    self.addPicButton.titleLabel.font = kFont(kStandardPx(80));
    self.addPicButton.layer.borderColor = kCommonBorder_Color.CGColor;
    [self.addPicButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.addPicView addSubview:self.addPicButton];
    [self.addPicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPicView).with.offset(15);
        make.top.equalTo(self.addPicView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    self.alertView = [[ZCYAlertView alloc] initWithFuncArray:@[@"拍照", @"从相册中选取"]];
    self.alertView.delegate = self;
    
    self.selectedImageView = [[UIImageView alloc] init];
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerImageView)];
    [self.selectedImageView setUserInteractionEnabled:YES];
    [self.selectedImageView setMultipleTouchEnabled:YES];
    [self.selectedImageView addGestureRecognizer:tapImageView];
    [self addGestureRecognizerToView:self.selectedImageView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-self.view.frame.size.width+95);
        make.left.equalTo([UIApplication sharedApplication].keyWindow).with.offset(15);
        make.top.equalTo([UIApplication sharedApplication].keyWindow).with.offset(64+130);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-self.view.frame.size.height+274);
    }];
    self.selectedImageView.hidden = YES;
    
    self.describeTextView = [[YYTextView alloc] init];
    self.describeTextView.placeholderFont = kFont(kStandardPx(32));
    self.describeTextView.placeholderText = @"添加图片说明";
    self.describeTextView.font = kFont(kStandardPx(32));
//    self.describeTextView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.addPicView addSubview:self.describeTextView];
    [self.describeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPicButton.mas_right).with.offset(10);
        make.top.and.bottom.equalTo(self.addPicButton);
        make.right.equalTo(self.addPicView).with.offset(-15);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.hidden = YES;
    [self.view addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addPicButton).with.offset(5);
        make.top.equalTo(self.addPicButton).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

- (void)addPicture
{
    [self.topTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.describeTextView resignFirstResponder];
    if (_isSelectedImage)
    {
        self.blackView.hidden = NO;
        self.selectedImageView.image = self.pickImage;;
        self.selectedImageView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo([UIApplication sharedApplication].keyWindow).with.offset((self.view.frame.size.width-self.imageSize.width)/2);
                make.right.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-(self.view.frame.size.width-self.imageSize.width)/2);
                make.top.equalTo([UIApplication sharedApplication].keyWindow).with.offset((self.view.frame.size.height-self.imageSize.height)/2);
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-(self.view.frame.size.height-self.imageSize.height)/2);
            }];
            [self.selectedImageView.superview layoutIfNeeded];
        }];
    } else {
        [self.alertView show];
    }
}

- (void)initContactView
{
    UIView *contactView = [[UIView alloc] init];
    contactView.backgroundColor = kCommonWhite_Color;
    [self.view addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.addPicView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:kFont(kStandardPx(30)) andText:@"联系方式" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [contactView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactView).with.offset(15);
        make.centerY.equalTo(contactView);
        make.top.equalTo(contactView).with.offset(5);
        make.width.mas_equalTo(70);
    }];
    
    self.contactTextField = [[UITextField alloc] init];
    self.contactTextField.placeholder = @"QQ、微信、手机号等（选填）";
    self.contactTextField.delegate = self;
    self.contactTextField.font = kFont(kStandardPx(30));
    [contactView addSubview:self.contactTextField];
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).with.offset(10);
        make.right.equalTo(contactView).with.offset(-15);
        make.top.equalTo(contactView).with.offset(5);
        make.height.mas_equalTo(40);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.topTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.describeTextView resignFirstResponder];
}

- (void)initCommitButton
{
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = [UIColor colorWithRGBHex:0x56db3c];
    [self.commitButton.layer setCornerRadius:5];
    [self.commitButton.layer setMasksToBounds:YES];
    self.commitButton.titleLabel.font = kFont(kStandardPx(32));
    [self.commitButton addTarget:self action:@selector(commitFeedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.contactTextField.mas_bottom).with.offset(25);
    }];
    
    self.feedMessage = [[SKPSMTPMessage alloc] init];
    self.feedMessage.toEmail = @"1051851627@qq.com";
    self.feedMessage.fromEmail = @"18883994033@163.com";
    self.feedMessage.subject = @"在重邮反馈";
    self.feedMessage.relayHost = @"smtp.163.com";
    
    self.feedMessage.requiresAuth = YES;
    self.feedMessage.login = @"18883994033@163.com";
    self.feedMessage.pass = @"zwk198677";
    self.feedMessage.wantsSecure = YES;
    self.feedMessage.delegate = self;
    

}
- (void)showImageView
{
//    self.selectedImageView.
}

- (void)hidePickerImageView
{
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.2f animations:^{
        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-self.view.frame.size.width+95);
            make.left.equalTo([UIApplication sharedApplication].keyWindow).with.offset(15);
            make.top.equalTo([UIApplication sharedApplication].keyWindow).with.offset(64+130);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow).with.offset(-self.view.frame.size.height+274);
        }];
        [self.selectedImageView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.selectedImageView.hidden = YES;
    }];
}

- (void)commitFeedBack
{
    [self.topTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.describeTextView resignFirstResponder];
    if ([self.topTextView.text  isEqual: @""])
    {
        [[ZCYProgressHUD sharedHUD] showWithText:@"请填写反馈内容" inView:self.view hideAfterDelay:1.0f];
        return;
    }
//    [[ZCYProgressHUD sharedHUD] rotateWithText:@"提交中..." inView:self.view WithExcutingBlock:^{
    
//    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
//    NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
//    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.vcf\"",kSKPSMTPPartContentTypeKey,
//                             @"attachment;\r\n\tfilename=\"test.vcf\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"提交中" inView:self.view];
    NSString *sendString = [NSString stringWithFormat:@"姓名：%@, 账号：%@, 密码：%@, 反馈内容：%@, 图片描述：%@, 联系方式：%@", [ZCYUserMgr sharedMgr].userName, [ZCYUserMgr sharedMgr].cardID,  [[NSUserDefaults standardUserDefaults] objectForKey:@"ZCYUSERPASSWORD"], self.topTextView.text, self.describeTextView.text, self.contactTextField.text];
//    NSString *content = [NSString stringWithCString:@"ceshi" encoding:NSUTF8StringEncoding];
//    NSString *content = [NSString stringWithCString:sendString encoding:NSUTF8StringEncoding];
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,
                               sendString,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    if (_isSelectedImage)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.pickImage, 0);
//        NSDictionary *imagePart = [NSDictionary dictionaryWithObjectsAndKeys:@"image/png;\r\n\tx-unix-mode=0644;\r\n\tname=\"image.png\"",kSKPSMTPPartContentTypeKey,
//                                   @"attachment;\r\n\tfilename=\"image.png\"",kSKPSMTPPartContentDispositionKey,[imageData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        NSDictionary *imagePart = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"image.jpg\"",kSKPSMTPPartContentTypeKey,
                                   @"attachment;\r\n\tfilename=\"image.jpg\"",kSKPSMTPPartContentDispositionKey,[imageData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
         self.feedMessage.parts = [NSArray arrayWithObjects:plainPart,imagePart, nil];
    } else {
         self.feedMessage.parts = [NSArray arrayWithObjects:plainPart, nil];
    }
    
    [self.feedMessage send];
    //    [[ZCYProgressHUD sharedHUD] showWithText:@"提交成功" inView:self.view hideAfterDelay:1.5f];
//    }];
//    [[ZCYProgressHUD sharedHUD] hideAfterDelay:2.0f];
    
}
#pragma mark - ZCYAlertViewDelegate
- (void)alertView:(ZCYAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    [self.alertView hide];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;

    if (index == 0)
    {
       imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (index == 1){
       imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.deleteButton.hidden = NO;
    _isSelectedImage = YES;
    [self.addPicButton setTitle:@"" forState:UIControlStateNormal];
    self.addPicButton.layer.borderWidth = 0.0f;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickImage = image;
    [self.addPicButton setBackgroundImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self.imageSize = CGSizeMake(self.view.frame.size.width, 500);
    } else {
        CGFloat width = image.size.width,height = image.size.height;
        for (;;) {
            width = width/2;
            height = height/2;
            if (width <= self.view.frame.size.width)
            {
                break;
            }
        }
        
        self.imageSize = CGSizeMake(width, height);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.topTextView resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.describeTextView resignFirstResponder];
    return YES;
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];

    [[ZCYProgressHUD sharedHUD] showWithText:@"提交失败" inView:self.view hideAfterDelay:1.0f];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];

    [[ZCYProgressHUD sharedHUD] showWithText:@"提交成功" inView:self.view hideAfterDelay:1.0f WithCompletionBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)deleteImage
{
    [self.addPicButton setTitle:@"+" forState:UIControlStateNormal];
    [self.addPicButton setBackgroundImage:nil forState:UIControlStateNormal];
    _isSelectedImage = NO;
    self.addPicButton.layer.borderWidth = 2.0f;
    self.selectedImageView.hidden = YES;
    self.deleteButton.hidden = YES;
}
- (void) addGestureRecognizerToView:(UIView *)view
{
//    // 旋转手势
//    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
//    [view addGestureRecognizer:rotationGestureRecognizer];
//    
//    // 缩放手势
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    [view addGestureRecognizer:pinchGestureRecognizer];
//    
//    // 移动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [view addGestureRecognizer:panGestureRecognizer];
//}
//
//// 处理旋转手势
//- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
//{
//    UIView *view = rotationGestureRecognizer.view;
//    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
//        [rotationGestureRecognizer setRotation:0];
//    }
}
//
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
//
// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
