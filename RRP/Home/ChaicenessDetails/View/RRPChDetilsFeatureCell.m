//
//  RRPChDetilsFeatureCell.m
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetilsFeatureCell.h"

@implementation RRPChDetilsFeatureCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.scenicImageView.image = [UIImage imageNamed:@"sign-list-scenic"];
    self.scenicNameLabel.backgroundColor = [UIColor clearColor];
    self.scenicNameLabel.font = [UIFont systemFontOfSize:17];
    self.scenicNameLabel.text = @"景点特色";
    self.scenicNameLabel.adjustsFontSizeToFitWidth = YES;
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
