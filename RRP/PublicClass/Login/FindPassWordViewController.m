//
//  FindPassWordViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/31.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "FindPassWordViewController.h"

@interface FindPassWordViewController ()<UITextFieldDelegate> {
    BOOL click;
    BOOL phoneNumber;
    BOOL password;
}
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *returnButton;//返回按钮
@property (nonatomic,strong)UILabel *resetPassWordTitle;//重设密码Title
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,strong) NSString *strTime;
@end

@implementation FindPassWordViewController

- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //布局topView
    [self layoutTopView];
    //布局重置密码界面
    [self layoutResetPassWordView];
    self.backImageView.userInteractionEnabled = YES;
    self.getCodeView.userInteractionEnabled = YES;
    self.submitBackView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
    [self.backImageView addSubview:self.topView];
    //给背景图片添加轻拍手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backImageView addGestureRecognizer:self.tap];
    
    //设置限制字数和控制键盘回收
    //输入手机号码
    //限制输入字符个数
    [self.phoneNumberTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumberTf.delegate = self;
    //弹出数字键盘
    self.phoneNumberTf.keyboardType = UIKeyboardTypeNumberPad;
    //self.phoneNumberTf.returnKeyType = UIReturnKeySend;
    
    //输入密码
    //限制输入密码个数
    [self.vertificationCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.vertificationCode.delegate = self;
    self.vertificationCode.keyboardType = UIKeyboardTypeNumberPad;
    //    self.passWordTf.returnKeyType = UIReturnKeyGoogle;
    //输入密码
    //限制输入密码个数
    [self.passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.passWordTF.delegate = self;
    self.passWordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    //    self.passWordTf.returnKeyType = UIReturnKeyGoogle;
    UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureAction:)];
    [self.noticeLabel addGestureRecognizer:TapGesture];
    self.noticeLabel.userInteractionEnabled = YES;
}


//布局topView
- (void)layoutTopView
{
    //topView
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 64)];
    self.topView.backgroundColor = [UIColor clearColor];
    //返回按钮
    self.returnButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.returnButton.frame =CGRectMake(15, 32, 50, 20);
    //    self.returnButton.backgroundColor = [UIColor orangeColor];
    [self.returnButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.returnButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.returnButton];
    //登录
    self.resetPassWordTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.resetPassWordTitle.center = CGPointMake(RRPWidth/2, 40);
    self.resetPassWordTitle.textAlignment = NSTextAlignmentCenter;
    self.resetPassWordTitle.font = [UIFont systemFontOfSize:18];
    self.resetPassWordTitle.text = @"重置密码";
    self.resetPassWordTitle.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.resetPassWordTitle];
    

}
//布局重置密码界面
- (void)layoutResetPassWordView
{
    //背景图片
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
    self.backImageView.image = [UIImage imageNamed:@"登录背景"];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4], NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    //4s
    if (RRPWidth == 320 && RRPHeight == 480) {

      //手机号码
      self.phoneNumberTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.topView.frame)+80, RRPWidth-74, 18)];
      self.phoneNumberTf.backgroundColor = [UIColor clearColor];
      self.phoneNumberTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入注册手机号码" attributes:dic];
      [self.backImageView addSubview:self.phoneNumberTf];
        //手机号码底线
        self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTf.frame)+9, RRPWidth-54, 1)];
        self.phoneNumberLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.phoneNumberLine];
        //获取验证码
        self.vertificationCode = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, self.phoneNumberLine.frame.size.width/2, 18)];
        self.vertificationCode.backgroundColor = [UIColor clearColor];
        self.vertificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:dic];
        [self.backImageView addSubview:self.vertificationCode];
        //获取验证码底线
        self.vertificationCodeLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.vertificationCode.frame)+9, RRPWidth-54, 1)];
        self.vertificationCodeLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.vertificationCodeLine];
        //获取验证码背景
        self.getCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth-28-80, CGRectGetMaxY(self.phoneNumberLine.frame)+12, 80, 27)];
        self.getCodeView.image = [UIImage imageNamed:@"获取验证码"];
        [self.backImageView addSubview:self.getCodeView];
        //获取验证码Button
        self.getCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.getCodeButton.frame = CGRectMake(0, 0, 80, 27);
        [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.getCodeView addSubview:self.getCodeButton];
        [self.getCodeButton addTarget:self action:@selector(getVertificationCode:) forControlEvents:(UIControlEventTouchUpInside)];
        //输入密码
        self.passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.vertificationCodeLine.frame)+20, RRPWidth-74, 18)];
        self.passWordTF.backgroundColor = [UIColor clearColor];
        self.passWordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:dic];
        self.passWordTF.secureTextEntry = YES;
        [self.backImageView addSubview:self.passWordTF];
        //输入密码底线
        self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordTF.frame)+9, RRPWidth-54, 1)];
        self.passWordLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.passWordLine];

        //提交背景
        self.submitBackView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.submitBackView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.submitBackView];
        //立即注册按钮
        self.submitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.submitButton.frame = CGRectMake(0, 0, RRPWidth-54, 45);
        [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.submitBackView addSubview:self.submitButton];
        [self.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:(UIControlEventTouchUpInside)];
        //提示信息
        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, CGRectGetMaxY(self.submitBackView.frame)+10, RRPWidth-62, 40)];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.font = [UIFont systemFontOfSize:12];
        [self.backImageView addSubview:self.noticeLabel];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"收取不到验证码,请查看手机是否被软件拦截,如还有疑问,请咨询 4006-982-666"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 30)];
        [str addAttribute:NSForegroundColorAttributeName value:IWColor(250, 196, 101) range:NSMakeRange(30, 14)];
        self.noticeLabel.attributedText= str;



        

    }else
    {
        //非4s手机
        //手机号码
        self.phoneNumberTf = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.topView.frame)+100, RRPWidth-74, 18)];
        self.phoneNumberTf.backgroundColor = [UIColor clearColor];
        self.phoneNumberTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入注册手机号码" attributes:dic];
        [self.backImageView addSubview:self.phoneNumberTf];
        //手机号码底线
        self.phoneNumberLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.phoneNumberTf.frame)+9, RRPWidth-54, 1)];
        self.phoneNumberLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.phoneNumberLine];
        //获取验证码
        self.vertificationCode = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.phoneNumberLine.frame)+20, self.phoneNumberLine.frame.size.width/2, 18)];
        self.vertificationCode.backgroundColor = [UIColor clearColor];
        self.vertificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:dic];
        [self.backImageView addSubview:self.vertificationCode];
        //获取验证码底线
        self.vertificationCodeLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.vertificationCode.frame)+9, RRPWidth-54, 1)];
        self.vertificationCodeLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.vertificationCodeLine];
        //获取验证码背景
        self.getCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth-28-80, CGRectGetMaxY(self.phoneNumberLine.frame)+12, 80, 27)];
        self.getCodeView.image = [UIImage imageNamed:@"获取验证码"];
        [self.backImageView addSubview:self.getCodeView];
        //获取验证码Button
        self.getCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.getCodeButton.frame = CGRectMake(0, 0, 80, 27);
        
        [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.getCodeView addSubview:self.getCodeButton];
        [self.getCodeButton addTarget:self action:@selector(getVertificationCode:) forControlEvents:(UIControlEventTouchUpInside)];
        //输入密码
        self.passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(37, CGRectGetMaxY(self.vertificationCodeLine.frame)+20, RRPWidth-74, 18)];
        self.passWordTF.backgroundColor = [UIColor clearColor];
        self.passWordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:dic];
        self.passWordTF.secureTextEntry = YES;
        [self.backImageView addSubview:self.passWordTF];
        //输入密码底线
        self.passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordTF.frame)+9, RRPWidth-54, 1)];
        self.passWordLine.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self.backImageView addSubview:self.passWordLine];

        //提交背景
        self.submitBackView = [[UIImageView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.passWordLine.frame)+30, RRPWidth-54, 45)];
        self.submitBackView.image = [UIImage imageNamed:@"登录注册按钮"];
        [self.backImageView addSubview:self.submitBackView];
        //立即注册按钮
        self.submitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.submitButton.frame = CGRectMake(0, 0, RRPWidth-54, 45);
        [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.submitBackView addSubview:self.submitButton];
        [self.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //提示信息
        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, CGRectGetMaxY(self.submitBackView.frame)+10, RRPWidth-62, 40)];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.font = [UIFont systemFontOfSize:12];
        [self.backImageView addSubview:self.noticeLabel];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"收取不到验证码,请查看手机是否被软件拦截,如还有疑问,请咨询4006-982-666"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 30)];
        [str addAttribute:NSForegroundColorAttributeName value:IWColor(250, 196, 101) range:NSMakeRange(30, 12)];
        self.noticeLabel.attributedText= str;
    }
}

#pragma mark - 点击方法
//返回按钮
- (void)backAction:(UIButton *)bt
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
//获取验证码
- (void)getVertificationCode:(UIButton *)bt
{
    //统计:重置密码页面获取验证码点击
    [MobClick event:@"105"];
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
//提交
- (void)submitAction:(UIButton *)bt
{
    //正则判断手机号
    phoneNumber = [Utility checkUserTelNumber:self.phoneNumberTf.text];
    //判断密码在6-16之间
    if (self.passWordTF.text.length > 5 && self.passWordTF.text.length < 17) {
        password = YES;
    }
    if (phoneNumber == YES && password == YES) {
        [SMSSDK commitVerificationCode:self.vertificationCode.text phoneNumber:self.phoneNumberTf.text zone:@"86" result:^(NSError *error) {
            if (error == NULL) {
                //请求找回密码接口
                [self requestFindPassWord];
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
//请求找回密码接口
- (void)requestFindPassWord
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"found_pass" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.phoneNumberTf.text forKey:@"mobile"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.passWordTF.text forKey:@"password"];
    
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:Regist parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [RRPFindTopModel shareRRPFindTopModel].password = self.passWordTF.text;
            [RRPFindTopModel shareRRPFindTopModel].mobile = self.phoneNumberTf.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mobile" object:self.phoneNumberTf.text];
            //统计:重置密码页面提交按钮点击
            [MobClick event:@"106"];
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
    }else if (textField == self.vertificationCode)
    {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }else if (textField == self.passWordTF)
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
    [self.phoneNumberTf resignFirstResponder];
    [self.vertificationCode resignFirstResponder];
    
}
- (void)TapGestureAction:(UITapGestureRecognizer *)tap
{
    
    NSInteger status = [RRPFindTopModel shareRRPFindTopModel].status;
    if (status == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006982666"]];
        //统计:重置密码页面电话咨询点击
        [MobClick event:@"107"];
    }
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
