//
//  RRPRegistViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/31.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPRegistViewController.h"
#import "RRPMyViewController.h"

@interface RRPRegistViewController ()<UITextFieldDelegate> {
    BOOL click;
    BOOL phoneNumber;
    BOOL password;
}
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *returnButton;//返回按钮
@property (nonatomic,strong)UILabel *registTitle;//注册标题
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@end

@implementation RRPRegistViewController

- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //布局TopView
    [self layoutTopView];
    //布局注册页面
    [self layoutRegistView];
    self.backImageView.userInteractionEnabled = YES;
    self.getCodeBackView.userInteractionEnabled = YES;
    self.registBackView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
    [self.backImageView addSubview:self.topView];
    //给背景图片添加轻拍手势
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.backImageView addGestureRecognizer:self.tap];
    
    //设置限制字数和控制键盘回收
    //输入手机号码
    //限制输入字符个数
    [self.phoneNumberTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumberTf.delegate = self;
    //弹出数字键盘
    self.phoneNumberTf.keyboardType = UIKeyboardTypeNumberPad;
    //    self.phoneNumberTf.returnKeyType = UIReturnKeySend;
    //输入验证码 限制输入字符个数
    [self.vertificationCodeTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.vertificationCodeTf.delegate = self;
    //弹出数字键盘
    self.vertificationCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    //输入密码
    //限制输入密码个数
    [self.passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.passWordTF.delegate = self;
    self.passWordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    //    self.passWordTf.returnKeyType = UIReturnKeyGoogle;
}
//布局TopView
- (void)layoutTopView
{
       //topView
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 64)];
    self.topView.backgroundColor = [UIColor clearColor];
    //返回
    self.returnButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.returnButton.frame =CGRectMake(15, 32, 50, 20);
//    self.returnButton.backgroundColor = [UIColor orangeColor];
    [self.returnButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.returnButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.returnButton];
    //登录
    self.registTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.registTitle.center = CGPointMake(RRPWidth/2, 40);
    self.registTitle.textAlignment = NSTextAlignmentCenter;
    self.registTitle.font = [UIFont systemFontOfSize:18];
    self.registTitle.text = @"注册";
    self.registTitle.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.registTitle];

    

}
//布局注册页面
- (void)layoutRegistView
{
    //背景图
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
    self.backImageView.image = [UIImage imageNamed:@"登录背景"];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4], NSFontAttributeName:[UIFont systemFontOfSize:17]};

    //4s
    if (RRPWidth == 320 && RRPHeight == 480) {

        //输入手机号码
        self.phoneNumberTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.topView.frame)+38, RRPWidth-74, 18)];
        self.phoneNumberTf.backgroundColor = [UIColor clearColor];
        self.phoneNumberTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:dic];
        [self.backImageView addSubview:self.phoneNumberTf];
        //手机号底线
        self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTf.frame)+9, RRPWidth-54, 1)];
        self.phoneNumberLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.phoneNumberLine];
        //输入验证码
        self.vertificationCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, self.phoneNumberLine.frame.size.width/2, 18)];
        self.vertificationCodeTf.backgroundColor= [UIColor clearColor];
        self.vertificationCodeTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:dic];
        [self.backImageView addSubview:self.vertificationCodeTf];
        //验证码底线
        self.vertificationCodeLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.vertificationCodeTf.frame)+9, RRPWidth-54, 1)];
        self.vertificationCodeLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.vertificationCodeLine];
        //获取验证码
        self.getCodeBackView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth-28-90, CGRectGetMaxY(self.phoneNumberLine.frame)+12, 90, 27)];
        self.getCodeBackView.image = [UIImage imageNamed:@"获取验证码"];
        [self.backImageView addSubview:self.getCodeBackView];
        //获取验证码Button
        self.getCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.getCodeButton.frame = CGRectMake(0, 0, 90, 27);
        [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.getCodeBackView addSubview:self.getCodeButton];
        [self.getCodeButton addTarget:self action:@selector(getVertificationCode:) forControlEvents:(UIControlEventTouchUpInside)];
        //输入密码
        self.passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.vertificationCodeLine.frame)+20, RRPWidth-74, 18)];
        self.passWordTF.backgroundColor = [UIColor clearColor];
        self.passWordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dic];
        self.passWordTF.secureTextEntry = YES;
        [self.backImageView addSubview:self.passWordTF];
        //输入密码底线
        self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordTF.frame)+9, RRPWidth-54, 1)];
        self.passWordLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.passWordLine];
        //立即注册背景
        self.registBackView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.registBackView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.registBackView];
        //立即注册按钮
        self.registButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.registButton.frame = CGRectMake(0, 0, RRPWidth-54, 45);
        [self.registButton setTitle:@"立即注册" forState:(UIControlStateNormal)];
        [self.registButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.registButton.titleLabel.font =[UIFont systemFontOfSize:18];
        [self.registBackView addSubview:self.registButton];
        [self.registButton addTarget:self action:@selector(registAction:) forControlEvents:(UIControlEventTouchUpInside)];


    
    }else
    {
       //非4s
       //输入手机号码
       self.phoneNumberTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.topView.frame)+100, RRPWidth-74, 18)];
        self.phoneNumberTf.backgroundColor = [UIColor clearColor];
        self.phoneNumberTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:dic];
        [self.backImageView addSubview:self.phoneNumberTf];
        //手机号底线
        self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTf.frame)+9, RRPWidth-54, 1)];
        self.phoneNumberLine.backgroundColor = [UIColor whiteColor];
        [self.backImageView addSubview:self.phoneNumberLine];
        //输入验证码
        self.vertificationCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, self.phoneNumberLine.frame.size.width/2, 18)];
        self.vertificationCodeTf.backgroundColor= [UIColor clearColor];
        self.vertificationCodeTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:dic];
        [self.backImageView addSubview:self.vertificationCodeTf];
        //验证码底线
        self.vertificationCodeLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.vertificationCodeTf.frame)+9, RRPWidth-54, 1)];
        self.vertificationCodeLine.backgroundColor = [UIColor whiteColor];
        [self.backImageView addSubview:self.vertificationCodeLine];
        //获取验证码
        self.getCodeBackView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth-28-80, CGRectGetMaxY(self.phoneNumberLine.frame)+12, 80, 27)];
        self.getCodeBackView.image = [UIImage imageNamed:@"获取验证码"];
        [self.backImageView addSubview:self.getCodeBackView];
        //获取验证码Button
        self.getCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.getCodeButton.frame = CGRectMake(0, 0, 80, 27);
        [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.getCodeBackView addSubview:self.getCodeButton];
        [self.getCodeButton addTarget:self action:@selector(getVertificationCode:) forControlEvents:(UIControlEventTouchUpInside)];
        //输入密码
        self.passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.vertificationCodeLine.frame)+20, RRPWidth-74, 18)];
        self.passWordTF.backgroundColor = [UIColor clearColor];
        self.passWordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dic];
        self.passWordTF.secureTextEntry = YES;
        [self.backImageView addSubview:self.passWordTF];
        //输入密码底线
        self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordTF.frame)+9, RRPWidth-54, 1)];
        self.passWordLine.backgroundColor = [UIColor whiteColor];
        [self.backImageView addSubview:self.passWordLine];
        //立即注册背景
        self.registBackView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.registBackView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.registBackView];
        //立即注册按钮
        self.registButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.registButton.frame = CGRectMake(0, 0, RRPWidth-54, 45);
        [self.registButton setTitle:@"立即注册" forState:(UIControlStateNormal)];
        [self.registButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.registButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.registBackView addSubview:self.registButton];
        [self.registButton addTarget:self action:@selector(registAction:) forControlEvents:(UIControlEventTouchUpInside)];



    
    }
    

}

#pragma mark - 按钮方法
//返回
- (void)backAction:(UIButton *)bt
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
//获取验证码
- (void)getVertificationCode:(UIButton *)bt
{
    //统计:注册页面获取验证码点击
    [MobClick event:@"108"];
    BOOL TelNumber = [Utility checkUserTelNumber:self.phoneNumberTf.text];
    if (TelNumber == YES) {
        if (click == NO) {
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumberTf.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                __block int timeout=59; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if( timeout <= 0 ) { //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [self.getCodeButton setTitle:@"重发验证码" forState:(UIControlStateNormal)];
                            click = NO;
                        });
                    }else {
                        int seconds = timeout % 60;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d秒重发", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [self.getCodeButton setTitle:strTime forState:(UIControlStateNormal)];
                            self.getCodeButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
                            click = YES;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }];
      }
    }else {
        [[MyAlertView sharedInstance]showFrom:@"请输入正确的手机号"];
    }
}


//立即注册
- (void)registAction:(UIButton *)bt
{
    
    //正则判断手机号
    phoneNumber = [Utility checkUserTelNumber:self.phoneNumberTf.text];
    //判断密码在6-16之间
    if (self.passWordTF.text.length > 5 && self.passWordTF.text.length < 17) {
        password = YES;
    }
    if (phoneNumber == YES && password == YES) {
        [SMSSDK commitVerificationCode:self.vertificationCodeTf.text phoneNumber:self.phoneNumberTf.text zone:@"86" result:^(NSError *error) {
            if (error == NULL) {
                //请求注册接口
                [self requestRegist];
            }else {
                [[MyAlertView sharedInstance]showFrom:@"验证码错误"];
            }
        }];
    }else if (phoneNumber != YES) {
            [[MyAlertView sharedInstance]showFrom:@"请输入正确的手机号"];
    }else if (password != YES) {
            [[MyAlertView sharedInstance]showFrom:@"密码在6-16位之间"];
    }
    
    
}

//请求注册接口
- (void)requestRegist
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"user_register" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.phoneNumberTf.text forKey:@"mobile"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.passWordTF.text forKey:@"password"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:Regist parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [RRPFindTopModel shareRRPFindTopModel].password = self.passWordTF.text;
            [RRPFindTopModel shareRRPFindTopModel].mobile = self.phoneNumberTf.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mobile" object:self.phoneNumberTf.text];
            //统计:注册页面立即注册按钮点击
            [MobClick event:@"109"]; 
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark - 控制字数和键盘回收事件
//输入手机号码 限制输入字符个数
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTf) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == self.passWordTF)
    {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }else if (textField == self.vertificationCodeTf)
    {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
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
    [self.phoneNumberTf resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.vertificationCodeTf resignFirstResponder];
    
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
