//
//  ZCYLoginViewControoler.m
//  在重邮
//
//  Created by 孤岛 on 2016/10/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLoginViewController.h"
#import "ZCYHomeTabBarController.h"
#import "ZCYTimeTableHelper.h"
#import "ZCYUserValidateHelper.h"
#import "ZCYTextField.h"
#import "ZCYUserInfoHelper.h"


@interface ZCYLoginViewController ()<UITextFieldDelegate>

@property(strong,nonatomic) ZCYTextField *accountTF;  /**< 账号框      */
@property(strong,nonatomic) ZCYTextField *passwordTF; /**< 密码框      */
//@property(strong,nonatomic) UIImageView *topImage;   /**< 顶部背景图   */
@property(strong,nonatomic) UIImageView *logoImage;  /**< 在重邮logo  */
@property(strong,nonatomic) UIButton    *loginBT;    /**< 登录按钮    */
@property(strong,nonatomic) UIButton    *forgetBT;   /**< 忘记密码按钮 */
@end

@implementation ZCYLoginViewController

{
    CGFloat y_loginButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.accountTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    y_loginButton = self.loginBT.frame.origin.y;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) initUI{
    [self TopInit];
    [self TFinit];
    [self Bottominit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void) TopInit{
//    self.topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
//    [self.view addSubview:self.topImage];
//    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.top.mas_equalTo(self.view);
//        make.height.mas_equalTo(255);
//    }];
  self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appiconImage"]];
    [self.view addSubview:self.logoImage];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(92);
        make.top.equalTo(self.view).with.offset(84);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];

//    UILabel *nameLabel = [[UILabel alloc] init];
//    [nameLabel setFont:[UIFont fontWithName:@"SimHei" size:kStandardPx(80)] andText:@"在重邮" andTextColor:kDeepGreen_Color andBackgroundColor:kTransparentColor];
//    
//    [self.view addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.logoImage);
//        make.top.equalTo(self.logoImage.mas_bottom).with.offset(4);
//    }];
}
-(void) TFinit{
    UIView *underline1 = [[UIView alloc]init];
    underline1.backgroundColor = kCommonLightGray_Color;
    self.accountTF = [[ZCYTextField alloc]init];
    self.accountTF.delegate  = self;
    self.accountTF.placeholder = @"   一卡通统一识别码";
    self.accountTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"];
    self.accountTF.textAlignment = NSTextAlignmentLeft;
    
    self.accountTF.clearButtonMode = UITextFieldViewModeAlways;
    self.accountTF.font = kFont(kStandardPx(32));
    UILabel *userLabel = [[UILabel alloc] init];
    [userLabel setFont:kFont(kStandardPx(32)) andText:@"账号" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    userLabel.frame = CGRectMake(0, 0, 40, 20);
    self.accountTF.leftView = userLabel;
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(30);
        make.top.equalTo(self.logoImage.mas_bottom).with.offset(65);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [self.view addSubview:underline1];
    [underline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.accountTF.mas_width);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.accountTF.mas_bottom).with.offset(8);
        make.left.and.right.equalTo(self.view);
    }];
    
    UIView *underline3 = [[UIView alloc]init];
    underline3.backgroundColor = kCommonLightGray_Color;
    [self.view addSubview:underline3];
    [underline3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.accountTF.mas_top).with.offset(-8);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    UIView *underline2 = [[UIView alloc]init];
    underline2.backgroundColor = kCommonLightGray_Color;
    self.passwordTF = [[ZCYTextField alloc]init];
    self.passwordTF.delegate = self;
    self.passwordTF.placeholder = @"   身份证后6位";
    UILabel *pwdLabel = [[UILabel alloc] init];
    [pwdLabel setFont:kFont(kStandardPx(32)) andText:@"密码" andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
    pwdLabel.frame = CGRectMake(0, 0, 40, 20);
    self.passwordTF.leftView = pwdLabel;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    self.passwordTF.font = kFont(kStandardPx(32));
    [self.passwordTF setSecureTextEntry:YES];
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(underline1.mas_bottom).with.offset(8);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [self.view addSubview:underline2];
    [underline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(8);
        make.left.and.right.equalTo(self.view);
        
    }];
}
-(void) Bottominit{
    self.loginBT = [[UIButton alloc]init];
    [self.loginBT setTitle:@"登陆" forState:UIControlStateNormal];
    self.loginBT.backgroundColor = [UIColor colorWithRGBHex:0x56db3c];
    [self.loginBT.layer setCornerRadius:5];
    [self.loginBT.layer setMasksToBounds:YES];
    self.loginBT.titleLabel.font = kFont(kStandardPx(32));
    [self.loginBT addTarget:self action:@selector(pushToHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBT];
    [self.loginBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(28);
    }];
    
//    self.forgetBT =[[UIButton alloc]init];
//    [self.forgetBT setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [self.forgetBT setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
//    self.forgetBT.titleLabel.font = kFont(kStandardPx(50));
//    [self.view addSubview:self.forgetBT];
//    [self.forgetBT mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(30);
//        make.top.equalTo(self.loginBT.mas_bottom).with.offset(12);
//        make.right.equalTo(self.passwordTF);
//    }];
}

- (void)pushToHomePage
{

    if ([self.accountTF.text  isEqualToString: @""] || [self.passwordTF.text isEqualToString:@""])
    {
        [[ZCYProgressHUD sharedHUD] showWithText:@"账号或密码不能为空" inView:self.view hideAfterDelay:1];
        return;
    }
    [ZCYUserMgr sharedMgr].studentNumber = self.accountTF.text;
    
    
    ZCYHomeTabBarController *tabBarC = [[ZCYHomeTabBarController alloc] init];
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"登录中" inView:self.view];
    @weakify(self);
    [ZCYUserValidateHelper getUserInfoWithUserName:self.accountTF.text andPassword:self.passwordTF.text andCompletionBlock:^(NSError *error, id response) {
        @strongify(self)
        if (error)
        {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
            [[ZCYProgressHUD sharedHUD] showWithText:@"用户名或密码错误" inView:self.view hideAfterDelay:1.0f];
            return;
        }
        if ([response[@"status"] longValue] == 50002)
        {
            [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
            [[ZCYProgressHUD sharedHUD] showWithText:@"用户名或密码错误" inView:self.view hideAfterDelay:1.0f];
        } else if ([response[@"status"] longValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:@"ZCYUSERPASSWORD"];
            NSDictionary *userMessage = response[@"data"];
            [[ZCYUserMgr sharedMgr] yy_modelSetWithDictionary:userMessage];
                [ZCYTimeTableHelper getTimeTableWithStdNumber:[ZCYUserMgr sharedMgr].studentNumber shouldSaveTime:YES withCompeletionBlock:^(NSError *error, NSArray *array) {
                    @strongify(self);
                    
                    if (error)
                    {
                        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];

                        [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
                        [ZCYUserMgr sharedMgr].courseArray = array;
                        ZCYUserMgr *userMgr = [ZCYUserMgr sharedMgr];
                        userMgr.cardID = self.accountTF.text;
                        NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:userMgr];
                        [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"USERMGR"];
                        
                        //共享数据
                        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wakeen.ios.dog"];
                        [userDefaults setObject:archiveUserData forKey:@"shared_usermgr"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.accountTF.text forKey:@"private_userNumber"];
                        [[ZCYProgressHUD sharedHUD] showWithText:@"登录成功" inView:self.view hideAfterDelay:1.0f  WithCompletionBlock:^{
                            [self presentViewController:tabBarC animated:YES completion:nil];
                        }];
                        
                    });
            }];

        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegdate
// 随着键盘上移
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.topImage mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.left.and.right.and.equalTo(self.view);
//        //        make.top.equalTo(self.view).with.offset(keyboardHeight/2);
//        make.top.equalTo(self.view.mas_top).with.offset(-120);
//    }];
//    [self.topImage setNeedsUpdateConstraints];
//    [self.topImage updateConstraintsIfNeeded];
//    
//    [UIView animateWithDuration:10.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.topImage layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
//    [self.topImage layoutIfNeeded];
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:5 animations:^{
//        
//        [self.topImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.and.right.and.equalTo(self.view);
//            make.top.equalTo(self.view);
//            make.height.mas_equalTo(255);
//            
//        }];
//        [self.topImage layoutIfNeeded];
//    }];
//}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrameAfterShow = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    [self.topImage mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(-(keyboardFrameAfterShow.size.height - (self.view.frame.size.height - 47.5 - y_loginButton)));
//    }];
//    [self.topImage setNeedsUpdateConstraints];
//    [self.topImage updateConstraintsIfNeeded];
    if(self.view.frame.size.height - y_loginButton - 40 < keyboardFrameAfterShow.size.height)
    {
        [UIView animateWithDuration:0.2f animations:^{
            [self.logoImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(84-(keyboardFrameAfterShow.size.height-self.view.frame.size.height + y_loginButton + 40));
            }];
            [self.logoImage.superview layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
            [self.logoImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(74);
            }];
            [self.logoImage.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];

    }
}


- (void)keyboardWillHide:(NSNotification *)notification
{
//    [self.topImage setNeedsUpdateConstraints];
//    [self.topImage updateConstraintsIfNeeded];
//    
//    [self.topImage mas_updateConstraints:^(MASConstraintMaker *make) {
//    
//        make.top.equalTo(self.view);
//    }];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.topImage.superview layoutIfNeeded];
        [self.logoImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(84);
        }];
        [self.logoImage.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
