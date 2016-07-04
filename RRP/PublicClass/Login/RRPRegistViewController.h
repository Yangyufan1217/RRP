//
//  RRPRegistViewController.h
//  RRP
//
//  Created by WangZhaZha on 16/3/31.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPRegistViewController : UIViewController
@property (nonatomic,strong)UIImageView *backImageView;//背景图片
@property (nonatomic,strong)UITextField *phoneNumberTf;//手机号码TF
@property (nonatomic,strong)UITextField *vertificationCodeTf;//验证码TF
@property (nonatomic,strong)UITextField *passWordTF;//密码TF
@property (nonatomic,strong)UILabel *phoneNumberLine;//手机号码底线
@property (nonatomic,strong)UILabel *vertificationCodeLine;//验证码底线
@property (nonatomic,strong)UILabel *passWordLine;//密码底线
@property (nonatomic,strong)UIImageView *getCodeBackView;//获取验证码背景图
@property (nonatomic,strong)UIButton *getCodeButton;//获取验证码按钮
@property (nonatomic,strong)UIImageView *registBackView;//立即注册背景
@property (nonatomic,strong)UIButton *registButton;//立即注册按钮



@end
