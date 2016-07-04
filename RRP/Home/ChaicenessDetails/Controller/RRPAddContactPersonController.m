//
//  RRPAddContactPersonController.m
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAddContactPersonController.h"
#import "RRPTicketContactModel.h"
@interface RRPAddContactPersonController ()<UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *contactArray;
@property (nonatomic, strong)NSMutableDictionary *contactDic;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,assign)NSInteger resultcode;
@end

@implementation RRPAddContactPersonController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200,200, 200));
    self.contactArray = [@[] mutableCopy];
    self.contactDic = [[NSMutableDictionary alloc] init];
    self.nameLabel.backgroundColor = self.typeLabel.backgroundColor = self.certificateNumberLabel.backgroundColor = self.phoneNumberLabel.backgroundColor = self.identityLabel.backgroundColor =  [UIColor clearColor];
    self.nameTextField.textColor = [UIColor blackColor];
    self.submitButton.backgroundColor = IWColor(251, 105, 42);
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];

    //注册通知 编辑 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitButtonAction:) name:@" editContact" object:nil];
//    NSLog(@"%@",self.submitType);
    
    //给背景图片添加轻拍手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:self.tap];
    
    //设置限制字数和控制键盘回收
    //输入身份证号
    //限制输入字符个数
    [self.certificateNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.certificateNumberTextField.delegate = self;
    //弹出数字键盘
    self.certificateNumberTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    //输入手机号
    //限制输入密码个数
    [self.iphoneNumberLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.iphoneNumberLabel.delegate = self;
    self.iphoneNumberLabel.keyboardType = UIKeyboardTypeNumberPad;
}
//返回
- (void)returnAction:(UIBarButtonItem *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交事件
- (void)submitButtonAction:(UIButton *)bt
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    [manager GET:[NSString stringWithFormat:@"http://apis.juhe.cn/idcard/index?key=de7c5e185bd8b3758e1831b0f7605c23&cardno=%@",self.certificateNumberTextField.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"response = %@",dic);
//        NSLog(@"reason = %@",dic[@"reason"]);
        self.resultcode = [dic[@"resultcode"] integerValue];
        
        //正则判断
        BOOL isNameTure =  [self validateUserName:self.nameTextField.text];
        BOOL isTeleNumberTure = [Utility checkUserTelNumber:self.iphoneNumberLabel.text];
        if (isNameTure == YES && self.resultcode == 200 && isTeleNumberTure == YES) {
            [self submitAction];
        }else
        {
//            NSLog(@"%d %ld %d",isNameTure,self.resultcode,isTeleNumberTure);
            if (isNameTure != 1) {
                [[MyAlertView sharedInstance]showFrom:@"姓名不能为空"];
            }else if (self.resultcode != 200)
            {
                [[MyAlertView sharedInstance]showFrom:@"请输入正确的身份证号"];
                
            }else if(isTeleNumberTure != 1)
            {
                [[MyAlertView sharedInstance]showFrom:@"请输入正确的手机号"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)submitAction
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([self.submitType isEqualToString:@"编辑"]) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"normal_modify" forKey:@"method"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.editModel.mr_id forKey:@"mr_id"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"user_id"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.nameTextField.text forKey:@"r_name"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.certificateNumberTextField.text forKey:@"r_idcardno"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.iphoneNumberLabel.text forKey:@"r_mobile"];
        NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
//        NSLog(@"%@",dic);
        [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
        [[NetWorkManager sharedManager] POST:GetPriceCanlender parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"编辑联系人%@",dict);
            NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
            if (code == 1000)  {
                NSString *msg = [dict[@"ResponseBody"] valueForKey:@"msg"];
                [[MyAlertView sharedInstance]showFrom:msg];
                if ([[dict[@"ResponseBody"] valueForKey:@"code"] integerValue] == 2000) {
                    NSString *msg = [dict[@"ResponseBody"] valueForKey:@"msg"];
                    [[MyAlertView sharedInstance]showFrom:msg];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }else
    {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"normal_add" forKey:@"method"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"user_id"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.nameTextField.text forKey:@"r_name"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.certificateNumberTextField.text forKey:@"r_idcardno"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.iphoneNumberLabel.text forKey:@"r_mobile"];
        NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
//        NSLog(@"%@",dic);
        [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
        [[NetWorkManager sharedManager] POST:GetPriceCanlender parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"添加联系人%@",dict);
            NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
            if (code == 1000)  {
                NSString *msg = [dict[@"ResponseBody"] valueForKey:@"msg"];
               [[MyAlertView sharedInstance]showFrom:msg];
                if ([[dict[@"ResponseBody"] valueForKey:@"code"] integerValue] == 2000) {
                    NSString *msg = [dict[@"ResponseBody"] valueForKey:@"msg"];
                    [[MyAlertView sharedInstance]showFrom:msg];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }


}
#pragma mark - 正则判断
//用户名
- (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"[\u4E00-\u9FA5]{1,10}(?:·[\u4E00-\u9FA5]{1,10})*";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
#pragma mark - 控制字数和键盘回收事件
//输入手机号码 限制输入字符个数
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.certificateNumberTextField) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }else if (textField == self.iphoneNumberLabel)
    {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
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
    [self.nameTextField resignFirstResponder];
    [self.certificateNumberTextField resignFirstResponder];
    [self.iphoneNumberLabel resignFirstResponder];
    
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
