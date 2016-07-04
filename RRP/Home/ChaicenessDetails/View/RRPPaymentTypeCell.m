//
//  RRPPaymentTypeCell.m
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPPaymentTypeCell.h"

@interface RRPPaymentTypeCell (){
    BOOL click;
}

@end

@implementation RRPPaymentTypeCell

- (void)awakeFromNib {
    
    self.headImageView.image = [UIImage imageNamed:@"home-family"];
    self.selectImage.image = [UIImage imageNamed:@"可选择"];
    self.nameLabel.backgroundColor = self.explainLabel.backgroundColor = self.selectButton.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.explainLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.text = @"微信支付";
    self.explainLabel.text = @"使用微信支付安全快捷";
    self.selectButton.userInteractionEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
