//
//  ZCYLoginViewControoler.m
//  在重邮
//
//  Created by 孤岛 on 2016/10/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYLoginViewControoler.h"

@interface ZCYLoginViewControoler ()<UITextFieldDelegate>

@property(strong,nonatomic) UITextField *AccountTF;  /**< 账号框      */
@property(strong,nonatomic) UITextField *PasswordTF; /**< 密码框      */
@property(strong,nonatomic) UIImageView *TopImage;   /**< 顶部背景图   */
@property(strong,nonatomic) UIImageView *LogoImage;  /**< 在重邮logo  */
@property(strong,nonatomic) UIButton    *LoginBT;    /**< 登录按钮    */
@property(strong,nonatomic) UIButton    *ForgetBT;   /**< 忘记密码按钮 */
@end

@implementation ZCYLoginViewControoler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.AccountTF resignFirstResponder];
    [self.PasswordTF resignFirstResponder];
}

-(void) initUI{
    [self TopInit];
    [self TFinit];
    [self Bottominit];
}
-(void) TopInit{
    self.TopImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_main_bg"]];
    [self.view addSubview:self.TopImage];
    [self.TopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(213);
    }];
  self.LogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zcy-appIcon-180"]];
    [self.view addSubview:self.LogoImage];
    [self.LogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(75);
        make.top.equalTo(self.TopImage.mas_bottom).with.offset(-50);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];

}
-(void) TFinit{
    UIView *underline1 = [[UIView alloc]init];
    underline1.backgroundColor=[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
    self.AccountTF = [[UITextField alloc]init];
    self.AccountTF.delegate  = self;
    self.AccountTF.placeholder = @"学号";
    [self.AccountTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.AccountTF];
    [self.AccountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.TopImage.mas_bottom).with.offset(85);
        make.left.equalTo(self.view.mas_left).with.offset(50.6);
    }];
    [self.view addSubview:underline1];
    [underline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.AccountTF.mas_width);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.AccountTF.mas_bottom);
        make.left.equalTo(self.AccountTF.mas_left);
    }];
    UIView *underline2 = [[UIView alloc]init];
    underline2.backgroundColor=[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
    self.PasswordTF = [[UITextField alloc]init];
    self.PasswordTF.delegate = self;
    self.PasswordTF.placeholder = @"密码";
    [self.PasswordTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.PasswordTF setSecureTextEntry:YES];
    [self.view addSubview:self.PasswordTF];
    [self.PasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.AccountTF.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(50.6);
    }];
    [self.view addSubview:underline2];
    [underline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.PasswordTF.mas_width);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.PasswordTF.mas_bottom);
        make.left.equalTo(self.PasswordTF.mas_left);
    }];
}
-(void) Bottominit{
    self.LoginBT = [[UIButton alloc]init];
    [self.LoginBT setTitle:@"登陆" forState:UIControlStateNormal];
    self.LoginBT.backgroundColor = [UIColor colorWithRed:0x65/255.0 green:0xb2/255.0 blue:0x2f/255.0 alpha:1];
    [self.LoginBT.layer setCornerRadius:17];
    [self.LoginBT.layer setMasksToBounds:YES];
    self.LoginBT.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:self.LoginBT];
    [self.LoginBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(156);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.PasswordTF.mas_bottom).with.offset(52);
    }];
    self.ForgetBT =[[UIButton alloc]init];
    [self.ForgetBT setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.ForgetBT.titleLabel.font =[UIFont systemFontOfSize:10.0];
    [self.ForgetBT setTitleColor:[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:self.ForgetBT];
    [self.ForgetBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.PasswordTF.mas_bottom).with.offset(4);
        make.right.equalTo(self.view.mas_right).with.offset(-60);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate
/* 随着键盘上移*/
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -55, self.view.frame.size.width, self.view.frame.size.height);
        }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
