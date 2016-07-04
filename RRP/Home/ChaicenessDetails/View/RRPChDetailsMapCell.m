//
//  RRPChDetailsMapCell.m
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetailsMapCell.h"
#import "RRPHomeSelectedDetailModel.h"
@implementation RRPChDetailsMapCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.mapImageView.image = [UIImage imageNamed:@"sign-list-gps"];
    self.mapLabel.backgroundColor = [UIColor clearColor];
    self.mapLabel.text = @"北京市密云县石城镇大关桥黑龙潭景区";
    self.mapLabel.adjustsFontSizeToFitWidth = YES;//改变字体大小填满label
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
}

//控件赋值
- (void)showData:(RRPHomeSelectedDetailModel *)homeSelectedDetail
{
 
    self.mapLabel.text = homeSelectedDetail.address;
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
