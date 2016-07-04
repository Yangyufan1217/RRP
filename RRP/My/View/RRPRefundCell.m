//
//  RRPRefundCell.m
//  RRP
//
//  Created by sks on 16/3/14.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPRefundCell.h"

@implementation RRPRefundCell

- (void)awakeFromNib {
    
    self.typeLabel.backgroundColor = self.RRPcontentLabel.backgroundColor = self.mostLabel.backgroundColor = self.totalLabel.backgroundColor = self.deductContentLabel.backgroundColor = self.deductMoneyLabel.backgroundColor = self.unitLabel.backgroundColor = self.moreImageView.backgroundColor = self.moreButton.backgroundColor =  [UIColor clearColor];
    self.typeLabel.font = self.RRPcontentLabel.font = [UIFont systemFontOfSize:15];
    self.typeLabel.textColor = IWColor(169, 169, 169);
    
    self.RRPcontentLabel.textColor = IWColor(253, 134, 46);
    self.RRPcontentLabel.text = @"9999";
    self.mostLabel.font = self.totalLabel.font = self.deductContentLabel.font = self.deductMoneyLabel.font = self.unitLabel.font = [UIFont systemFontOfSize:12];
    self.mostLabel.textColor = self.totalLabel.textColor = self.deductContentLabel.textColor = self.deductMoneyLabel.textColor = self.unitLabel.textColor = IWColor(169, 169, 169);
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
    self.totalLabel.text = @"9999";
    self.deductMoneyLabel.text = @"999";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
