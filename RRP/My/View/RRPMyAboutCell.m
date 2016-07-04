//
//  RRPMyAboutCell.m
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyAboutCell.h"

@implementation RRPMyAboutCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.RRPtitleLabel.backgroundColor = [UIColor clearColor];
    self.RRPtitleLabel.font = [UIFont systemFontOfSize:17];
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
