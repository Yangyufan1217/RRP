//
//  RRPMyCell.m
//  RRP
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCell.h"

@implementation RRPMyCell

- (void)awakeFromNib {
    
    self.titleImageView.image = [UIImage imageNamed:@"home-more"];
    self.titleImageView.clipsToBounds = YES;
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.RRPTitleLabel.backgroundColor = [UIColor clearColor];
    self.RRPTitleLabel.textColor = IWColor(15, 15, 15);
    self.RRPTitleLabel.font = [UIFont systemFontOfSize:15];
    self.RRPTitleLabel.text = @"我的收藏";
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
