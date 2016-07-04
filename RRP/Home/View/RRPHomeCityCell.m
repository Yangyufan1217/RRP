//
//  RRPHomeCityCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeCityCell.h"

@implementation RRPHomeCityCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
