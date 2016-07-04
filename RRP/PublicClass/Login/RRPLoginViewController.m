//
//  RRPLoginViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPLoginViewController.h"
#import "RRPRegistViewController.h"
#import "FindPassWordViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface RRPLoginViewController ()<UITextFieldDelegate> {
    BOOL phoneNumber;
    BOOL password;
}
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *returnButton;//返回按钮
@property (nonatomic,strong)UILabel *loginTitle;//登录标题
@property (nonatomic,strong)UIButton *registButton;//跳转注册按钮
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSMutableDictionary *dicti;

@end


@implementation RRPLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        //布局topView
    self.mobile = @"请输入手机号码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobile:) name:@"mobile" object:nil];
    self.dicti = [NSMutableDictionary dictionary];
    [self layoutTopView];
    //布局登录界面
    [self layoutLoginView];
    self.backImageView.userInteractionEnabled = YES;
    [self.backImageView addSubview:self.topView];
    [self.view addSubview:self.backImageView];
    
    //给背景图片添加轻拍手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backImageView addGestureRecognizer:self.tap];
    
    //设置限制字数和控制键盘回收
    //输入手机号码
    //限制输入字符个数
    [self.phoneNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumberTF.delegate = self;
    //弹出数字键盘
    self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    //    self.phoneNumberTf.returnKeyType = UIReturnKeySend;
    
    //输入密码
    //限制输入密码个数
    [self.passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTF.delegate = self;
    self.passwordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    //    self.passWordTf.returnKeyType = UIReturnKeyGoogle;
    
    
}

- (void)mobile:(NSNotification *)notification {
    self.mobile = [RRPFindTopModel shareRRPFindTopModel].mobile;
}

//布局topView
- (void)layoutTopView
{
    //顶部view
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 64)];
    self.topView.backgroundColor = [UIColor orangeColor];
    self.topView.backgroundColor = [UIColor clearColor];
    //返回
    self.returnButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.returnButton.frame =CGRectMake(15, 32, 50, 20);
    [self.returnButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.returnButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.returnButton];
    //登录
    self.loginTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.loginTitle.center = CGPointMake(RRPWidth/2, 40);
    self.loginTitle.textAlignment = NSTextAlignmentCenter;
    self.loginTitle.font = [UIFont systemFontOfSize:18];
    self.loginTitle.text = @"登录";
    self.loginTitle.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.loginTitle];
    //注册
    self.registButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.registButton.frame = CGRectMake(RRPWidth-15-50, 32, 50, 20);
    [self.registButton setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.registButton addTarget:self action:@selector(popToRegistAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.registButton];
    

}
//布局登录界面
- (void)layoutLoginView
{
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
    self.backImageView.image = [UIImage imageNamed:@"登录背景"];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4], NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    
    //4s
    if (RRPWidth == 320 && RRPHeight == 480) {
        //输入手机号码TF
        self.phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(37,CGRectGetMaxY(self.topView.frame)+100, RRPWidth-74, 18)];
        self.phoneNumberTF.backgroundColor = [UIColor clearColor];
        
        
        self.phoneNumberTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.mobile attributes:dic];
        [self.backImageView addSubview:self.phoneNumberTF];
        //手机号码底线
        self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTF.frame)+9, RRPWidth-54, 1)];
        self.phoneNumberLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.phoneNumberLine];
        //输入密码
        self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, RRPWidth-74, 18)];
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.backgroundColor = [UIColor clearColor];
        self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dic];
        [self.backImageView addSubview:self.passwordTF];
        //输入密码底线
        self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passwordTF.frame)+9, RRPWidth-54, 1)];
        self.passWordLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.passWordLine];
        
        //登录背景
        self.loginImageView.userInteractionEnabled = YES;
        self.loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.loginImageView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.loginImageView];
        //登录按钮
        self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.loginButton.frame = self.loginImageView.frame;
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        loginLabel.center = CGPointMake(self.loginImageView.frame.size.width/2,self.loginImageView.frame.size.height/2);
        loginLabel.textAlignment = NSTextAlignmentCenter;
        loginLabel.textColor = [UIColor whiteColor];
        loginLabel.font = [UIFont systemFontOfSize:18];
        loginLabel.text = @"登录";
        [self.loginButton addSubview:loginLabel];
//        [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.loginButton];
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //忘记密码
        self.forgetPassWordBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.forgetPassWordBt.frame = CGRectMake(RRPWidth-30-70, CGRectGetMaxY(self.loginImageView.frame)+10, 70, 15);
        [self.forgetPassWordBt setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
        [self.forgetPassWordBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.forgetPassWordBt];
        [self.forgetPassWordBt addTarget:self action:@selector(forgetPassWordAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //微博
        self.weiBoLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.weiBoLoginBt.frame = CGRectMake(50, CGRectGetMaxY(self.loginImageView.frame)+47, 62, 50);
//        [self.weiBoLoginBt setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"微博"]]];
        [self.weiBoLoginBt setBackgroundImage:[UIImage imageNamed:@"微博"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.weiBoLoginBt];
        [self.weiBoLoginBt addTarget:self action:@selector(weiBoLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //QQ
        self.qqLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.qqLoginBt.frame = CGRectMake(0, 0, 62, 50);
        self.qqLoginBt.center = CGPointMake(RRPWidth/2, CGRectGetMaxY(self.loginImageView.frame)+47+25);
        [self.qqLoginBt setBackgroundImage:[UIImage imageNamed:@"腾讯"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.qqLoginBt];
         [self.qqLoginBt addTarget:self action:@selector(qqLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //微信
        self.weiChatLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.weiChatLoginBt.frame = CGRectMake(RRPWidth-50-62, CGRectGetMaxY(self.loginImageView.frame)+47, 62, 50);
        [self.weiChatLoginBt setBackgroundImage:[UIImage imageNamed:@"微信"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.weiChatLoginBt];
         [self.weiChatLoginBt addTarget:self action:@selector(weiChatLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];

        
        
        
    }else{
    //非4s时的布局
    //输入手机号码TF
    self.phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(37,CGRectGetMaxY(self.topView.frame)+115, RRPWidth-74, 18)];
    self.phoneNumberTF.backgroundColor = [UIColor clearColor];
    self.phoneNumberTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.mobile attributes:dic];
    [self.backImageView addSubview:self.phoneNumberTF];
    //手机号码底线
    self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTF.frame)+9, RRPWidth-54, 1)];
    self.phoneNumberLine.backgroundColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.phoneNumberLine];
    //输入密码
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, RRPWidth-74, 18)];
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.backgroundColor = [UIColor clearColor];
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dic];
    [self.backImageView addSubview:self.passwordTF];
    //输入密码底线
    self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passwordTF.frame)+9, RRPWidth-54, 1)];
    self.passWordLine.backgroundColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.passWordLine];

        //登录背景
        self.loginImageView.userInteractionEnabled = YES;
        self.loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.loginImageView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.loginImageView];
        //登录按钮
        self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.loginButton.frame = self.loginImageView.frame;
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        loginLabel.center = CGPointMake(self.loginImageView.frame.size.width/2,self.loginImageView.frame.size.height/2);
        loginLabel.textAlignment = NSTextAlignmentCenter;
        loginLabel.textColor = [UIColor whiteColor];
        loginLabel.font = [UIFont systemFontOfSize:18];
        loginLabel.text = @"登录";
        [self.loginButton addSubview:loginLabel];
        //        [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.loginButton];
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //忘记密码
        self.forgetPassWordBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.forgetPassWordBt.frame = CGRectMake(RRPWidth-30-70, CGRectGetMaxY(self.loginImageView.frame)+10, 70, 15);
        [self.forgetPassWordBt setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
        [self.forgetPassWordBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.forgetPassWordBt];
        [self.forgetPassWordBt addTarget:self action:@selector(forgetPassWordAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //微博
        self.weiBoLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.weiBoLoginBt.frame = CGRectMake(50, CGRectGetMaxY(self.loginImageView.frame)+47, 62, 50);
//        [self.weiBoLoginBt setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"微博"]]];
        [self.weiBoLoginBt setBackgroundImage:[UIImage imageNamed:@"微博"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.weiBoLoginBt];
         [self.weiBoLoginBt addTarget:self action:@selector(weiBoLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //QQ
        self.qqLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.qqLoginBt.frame = CGRectMake(0, 0, 62, 50);
        self.qqLoginBt.center = CGPointMake(RRPWidth/2, CGRectGetMaxY(self.loginImageView.frame)+47+25);
        [self.qqLoginBt setBackgroundImage:[UIImage imageNamed:@"腾讯"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.qqLoginBt];
        [self.qqLoginBt addTarget:self action:@selector(qqLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //微信
        self.weiChatLoginBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.weiChatLoginBt.frame = CGRectMake(RRPWidth-50-62, CGRectGetMaxY(self.loginImageView.frame)+47, 62, 50);
        [self.weiChatLoginBt setBackgroundImage:[UIImage imageNamed:@"微信"] forState:(UIControlStateNormal)];
        [self.backImageView addSubview:self.weiChatLoginBt];
        [self.weiChatLoginBt addTarget:self action:@selector(weiChatLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }

}

#pragma mark - button点击事件
//返回
- (void)backAction:(UIButton *)bt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//跳转注册界面
- (void)popToRegistAction:(UIButton *)bt
{
    RRPRegistViewController *registVC = [[RRPRegistViewController alloc] init];
    [self presentViewController:registVC animated:YES completion:nil];
}


//登录
- (void)loginAction:(UIButton *)bt
{
    //正则判断手机号
    phoneNumber = [Utility checkUserTelNumber:self.phoneNumberTF.text];
    //判断密码在6-16之间
    if (self.passwordTF.text.length > 5 && self.passwordTF.text.length < 17) {
        password = YES;
    }
    if (phoneNumber == YES && password == YES) {
        //请求登录接口
        [self requestLogin:@"user_login" Dict:nil];//user_login登录方式
    }else if (phoneNumber != YES) {
        [[MyAlertView sharedInstance]showFrom:@"请输入正确的手机号"];
    }else if (password != YES) {
        [[MyAlertView sharedInstance]showFrom:@"密码在6-16位之间"];
    }
}




//跳转找回密码界面
- (void)forgetPassWordAction:(UIButton *)bt
{
    FindPassWordViewController *findPassWordVC = [[FindPassWordViewController alloc] init];
    //统计:登录页面忘记密码按钮点击
    [MobClick event:@"104"];
    [self presentViewController:findPassWordVC animated:YES completion:nil];
}
//微博登录
- (void)weiBoLoginAction:(UIButton *)bt
{
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             [self.dicti setValue:user.uid forKey:@"uid"];
             [self.dicti setValue:user.icon forKey:@"headimgurl"];
             [self.dicti setValue:user.nickname forKey:@"nickname"];
             SSDKGender gender = user.gender;
             [self.dicti setValue:[NSString stringWithFormat:@"%lu",(unsigned long)gender] forKey:@"sex"];
             //请求登录接口
             [self requestLogin:@"third_login" Dict:self.dicti];//third_login  登录方式         }else{
             //统计:登录页面微博登录按钮点击
             [MobClick event:@"101"];
             NSLog(@"%@",error);
         }
     }];
    
}
//QQ登录
- (void)qqLoginAction:(UIButton *)bt
{
    
    
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
            [self.dicti setValue:user.uid forKey:@"uid"];
            [self.dicti setValue:user.icon forKey:@"headimgurl"];
            [self.dicti setValue:user.nickname forKey:@"nickname"];
            SSDKGender gender = user.gender;
            [self.dicti setValue:[NSString stringWithFormat:@"%lu",(unsigned long)gender] forKey:@"sex"];
            //请求登录接口
            [self requestLogin:@"third_login" Dict:self.dicti];//third_login  登录方式
             //统计:登录页面QQ登录按钮点击
             [MobClick event:@"102"];
         }else{
             NSLog(@"%@",error);
         }
         
     }];
}



//微信登录
- (void)weiChatLoginAction:(UIButton *)bt
{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             [self.dicti setValue:user.uid forKey:@"uid"];
             [self.dicti setValue:user.icon forKey:@"headimgurl"];
             [self.dicti setValue:user.nickname forKey:@"nickname"];
             SSDKGender gender = user.gender;
             [self.dicti setValue:[NSString stringWithFormat:@"%lu",(unsigned long)gender] forKey:@"sex"];
             //请求登录接口
             [self requestLogin:@"third_login" Dict:self.dicti];//third_login  登录方式
             //统计:登录页面微信登录按钮点击
             [MobClick event:@"103"];
         }else{
             NSLog(@"%@",error);
         }
         
     }];
}

//登录
- (void)requestLogin:(NSString *)method Dict:(NSMutableDictionary *)dicti
{
    
    if ([method isEqualToString:@"user_login"]) {
        //手机号登录
        if (![self.phoneNumberTF.text isEqualToString:@""]) {
            [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.phoneNumberTF.text forKey:@"mobile"];
        }else {
            [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.mobile forKey:@"mobile"];
        }
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"three"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.passwordTF.text forKey:@"password"];
        //统计:登录页面登录按钮点击
        [MobClick event:@"100"];
    }else if ([method isEqualToString:@"third_login"]) {
        //第三方登录
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:dicti[@"uid"] forKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"three"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:dicti[@"headimgurl"] forKey:@"headimgurl"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:dicti[@"nickname"] forKey:@"nickname"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:dicti[@"sex"] forKey:@"sex"];
    }
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:method forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:Regist parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dico = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dico];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            if ([dict[@"ResponseBody"][@"code"] integerValue] == 2000) {
                //标记用户是否登
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"register"];
                [[NSUserDefaults standardUserDefaults] setValue:dict[@"ResponseBody"][@"user_id"] forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setValue:dict[@"ResponseBody"][@"head_img"] forKey:@"head_img"];
                [[NSUserDefaults standardUserDefaults] setValue:dict[@"ResponseBody"][@"nickname"] forKey:@"nickname"];
                [[NSUserDefaults standardUserDefaults] setValue:dict[@"ResponseBody"][@"per_note"] forKey:@"per_note"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if ([dict[@"ResponseBody"][@"code"] integerValue] == 4002) {
                [[MyAlertView sharedInstance]showFrom:@"密码输入错误"];
            }else if ([dict[@"ResponseBody"][@"code"] integerValue] == 4003) {
                [[MyAlertView sharedInstance]showFrom:@"该用户不存在"];
            }else if ([dict[@"ResponseBody"][@"code"] integerValue] == 4001) {
                [[MyAlertView sharedInstance]showFrom:@"登录失败"];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark - 控制字数和键盘回收事件
//输入手机号码 限制输入字符个数
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == self.passwordTF)
    {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}
//轻拍事件 点击空白处回收键盘
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.phoneNumberTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
