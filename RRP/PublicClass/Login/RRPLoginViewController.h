//
//  RRPLoginViewController.h
//  RRP
//
//  Created by WangZhaZha on 16/3/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPLoginViewController : UIViewController
@property (nonatomic,strong)UIImageView *backImageView;//背景图片
@property (nonatomic,strong)UILabel *phoneNumberLine;//手机号底线
@property (nonatomic,strong)UILabel *passWordLine;//密码底线
@property (nonatomic,strong)UITextField *phoneNumberTF;//电话号码TF
@property (nonatomic,strong)UITextField *passwordTF;//密码TF
@property (nonatomic,strong)UIImageView *loginImageView;//登录背景图
@property (nonatomic,strong)UIButton *loginButton;//登录按钮
@property (nonatomic,strong)UIButton *forgetPassWordBt;//忘记密码按钮
@property (nonatomic,strong)UIButton *weiBoLoginBt;//微博登录按钮
@property (nonatomic,strong)UIButton *qqLoginBt;//QQ登录按钮
@property (nonatomic,strong)UIButton *weiChatLoginBt;//微信登录按钮


@end
