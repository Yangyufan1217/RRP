//
//  RRPCommonLinkmanCell.m
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCommonLinkmanCell.h"
#import "RRPAddContactPersonController.h"
#import "RRPTicketContactModel.h"
@implementation RRPCommonLinkmanCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.nameLabel.backgroundColor =  self.phoneLabel.backgroundColor = self.phoneNumberLabel.backgroundColor  = self.compileButton.backgroundColor = self.perfectRemindLabel.backgroundColor = [UIColor clearColor];
    self.compileImageView.userInteractionEnabled = YES;
    self.compileImageView.image = [UIImage imageNamed:@"编辑"];
    
    self.nameLabel.text = @"王超";
    self.nameLabel.textColor = IWColor(100, 100, 100);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = 0;
    
    self.perfectRemindLabel.textColor = self.phoneLabel.textColor = self.phoneNumberLabel.textColor = IWColor(145, 145, 145);
    self.phoneNumberLabel.font = self.perfectRemindLabel.font = self.phoneLabel.font = [UIFont systemFontOfSize:14];
    self.perfectRemindLabel.text = @"证件信息待完善";
    self.phoneLabel.text = @"手机号:";
    self.phoneNumberLabel.text = @"18348035201";
    
    
    [self.compileButton addTarget:self action:@selector(compileButton:) forControlEvents:(UIControlEventTouchUpInside)];
}
//编辑按钮
- (void)compileButton:(UIButton *)sender {
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editContact" object:self userInfo:@{@"value":sender}];
}

//赋值
- (void)showDataWithModel:(RRPTicketContactModel *)model
{
    self.nameLabel.text = model.r_name;
    self.perfectRemindLabel.text = model.r_idcardno;
    self.phoneNumberLabel.text = model.r_mobile;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
