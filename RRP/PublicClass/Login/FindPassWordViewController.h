//
//  FindPassWordViewController.h
//  RRP
//
//  Created by WangZhaZha on 16/3/31.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPassWordViewController : UIViewController
@property (nonatomic,strong)UIImageView *backImageView;//背景图片
@property (nonatomic,strong)UITextField *phoneNumberTf;//手机号码TF
@property (nonatomic,strong)UITextField *vertificationCode;//验证码TF
@property (nonatomic,strong)UILabel *phoneNumberLine;//手机号底线
@property (nonatomic,strong)UILabel *vertificationCodeLine;//验证码底线
@property (nonatomic,strong)UIImageView *getCodeView;//获取验证码背景
@property (nonatomic,strong)UIButton *getCodeButton;//获取验证码按钮
@property (nonatomic,strong)UIImageView *submitBackView;//提交背景
@property (nonatomic,strong)UIButton *submitButton;//提交按钮
@property (nonatomic,strong)UILabel *noticeLabel;//提示Label
@property (nonatomic,strong)UITextField *passWordTF;//密码TF
@property (nonatomic,strong)UILabel *passWordLine;//密码底线



@end
