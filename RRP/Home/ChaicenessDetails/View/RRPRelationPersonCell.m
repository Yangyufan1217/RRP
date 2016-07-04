//
//  RRPRelationPersonCell.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPRelationPersonCell.h"
#import "RRPAddContactPersonController.h"
#import "RRPTicketContactModel.h"
#import "RRPContactController.h"
@interface RRPRelationPersonCell ()
{
    BOOL click;
}
@end

@implementation RRPRelationPersonCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.nameLabel.backgroundColor = self.perfectRemindLabel.backgroundColor = self.phoneLabel.backgroundColor = self.phoneNumberLabel.backgroundColor = self.selectButton.backgroundColor = self.compileButton.backgroundColor = [UIColor clearColor];
    self.selectImageView.userInteractionEnabled = YES;
    self.selectImageView.image = [UIImage imageNamed:@"可选择"];
    self.selectImageView.userInteractionEnabled = YES;
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
    
    [self.selectButton addTarget:self action:@selector(selectButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.compileButton addTarget:self action:@selector(compileButton:) forControlEvents:(UIControlEventTouchUpInside)];
}
//赋值
- (void)showDataWithModel:(RRPTicketContactModel *)model
{
    self.nameLabel.text = model.r_name;
    self.perfectRemindLabel.text = model.r_idcardno;
    self.phoneNumberLabel.text = model.r_mobile;
    
}
//选中按钮
- (void)selectButton:(UIButton *)sender {
    if (click == NO) {
        self.selectImageView.image = [UIImage imageNamed:@"已选择"];
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"加星" object:self userInfo:@{@"value":sender}];
        click = YES;
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"可选择"];
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"减星" object:self userInfo:@{@"value":sender}];
        click = NO;
    }
}
//编辑按钮
- (void)compileButton:(UIButton *)sender {
    //统计:联系人编辑点击
    [MobClick event:@"28"];
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editContact" object:self userInfo:@{@"value":sender}];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
