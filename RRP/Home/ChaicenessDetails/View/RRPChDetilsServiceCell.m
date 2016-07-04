//
//  RRPChDetilsServiceCell.m
//  RRP
//
//  Created by sks on 16/2/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetilsServiceCell.h"

@implementation RRPChDetilsServiceCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.serviceImageView.image = [UIImage imageNamed:@"sign-list-online"];
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
