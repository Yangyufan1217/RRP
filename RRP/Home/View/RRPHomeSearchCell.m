//
//  RRPHomeSearchCell.m
//  RRP
//
//  Created by WangZhaZha on 16/4/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeSearchCell.h"

@implementation RRPHomeSearchCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
