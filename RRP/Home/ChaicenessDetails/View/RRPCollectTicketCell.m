//
//  RRPCollectTicketCell.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCollectTicketCell.h"

@implementation RRPCollectTicketCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.headImageView.image = [UIImage imageNamed:@"填写取票人"];
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.text = @"取票人";
    self.nameLabel.textColor = IWColor(73, 73, 73);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
