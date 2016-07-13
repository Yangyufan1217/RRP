//
//  RRPLightIntroduceCell.m
//  RRP
//
//  Created by WangZhaZha on 16/7/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPLightIntroduceCell.h"

@implementation RRPLightIntroduceCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = IWColor(242, 245, 247);
    self.backView.backgroundColor = IWColor(250, 250, 250);
    self.ticketName.textColor = IWColor(127, 127, 127);
    self.ticketIntroduce.textColor = IWColor(109, 109, 109);
    self.originPrice.textColor = IWColor(178, 178, 178);
    self.lineLabel.backgroundColor = IWColor(178, 178, 178);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
