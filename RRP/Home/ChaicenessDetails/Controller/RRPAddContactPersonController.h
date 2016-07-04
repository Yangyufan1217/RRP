//
//  RRPAddContactPersonController.h
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPTicketContactModel;
@interface RRPAddContactPersonController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//证件类型
@property (weak, nonatomic) IBOutlet UILabel *certificateNumberLabel;//证件号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;//电话号码
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//名字输入
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;//身份证
@property (weak, nonatomic) IBOutlet UITextField *certificateNumberTextField;//证件号输入

@property (weak, nonatomic) IBOutlet UITextField *iphoneNumberLabel;//手机号输入

@property (weak, nonatomic) IBOutlet UIButton *submitButton;//提交
@property (nonatomic,strong)RRPTicketContactModel *editModel;
@property (nonatomic,strong)NSString *submitType;//提交类型


@end
