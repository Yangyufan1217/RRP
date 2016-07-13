//
//  RRPGetTicketCell.m
//  RRP
//
//  Created by WangZhaZha on 16/7/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPGetTicketCell.h"

@implementation RRPGetTicketCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = IWColor(242, 245, 247);
    self.topLine.backgroundColor = IWColor(242, 245, 247);
    self.centerTopLine.backgroundColor = IWColor(242, 245, 247);
    self.centerBottonLine.backgroundColor = IWColor(242, 245, 247);
    self.titleLabel.textColor = IWColor(103, 103, 103);
    self.nameLabel.textColor = IWColor(103, 103, 103);
    self.phoneLabel.textColor = IWColor(103, 103, 103);
    self.IDLabel.textColor = IWColor(103, 103, 103);
    self.nameTf.textColor = IWColor(103, 103, 103);
    self.phoneTf.textColor = IWColor(103, 103, 103);
    self.IDTf.textColor = IWColor(103, 103, 103);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
