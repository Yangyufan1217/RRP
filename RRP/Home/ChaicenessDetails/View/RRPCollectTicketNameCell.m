//
//  RRPCollectTicketNameCell.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCollectTicketNameCell.h"
#import "RRPTicketContactModel.h"
@implementation RRPCollectTicketNameCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.nameLabel.backgroundColor = self.nameTextLabel.backgroundColor = self.phoneLabel.backgroundColor = self.phoneNumberLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = self.nameTextLabel.font = self.phoneLabel.font = self.phoneNumberLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = self.nameTextLabel.textColor = self.phoneNumberLabel.textColor = self.phoneLabel.textColor = IWColor(73, 73, 73);
    self.nameLabel.text = @"姓名:";
    self.nameTextLabel.text = @"非洲胚胎";
    self.phoneLabel.text = @"手机号:";
    self.phoneNumberLabel.text = @"0887—136-8879-1933";
    
}
//赋值
- (void)showDataWithModel:(RRPTicketContactModel *)model
{
    self.nameTextLabel.text = model.r_name;
    self.phoneNumberLabel.text = model.r_mobile;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
