//
//  RRPMessageCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/28.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMessageCell.h"

@implementation RRPMessageCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors(IWColor(244, 244, 244), IWColor(200, 200, 200));
    self.backPicView.image = [UIImage imageNamed:@"消息提醒背景"];
    
    self.titleLabel.textColor = IWColor(75, 75, 75);
    self.topLine.backgroundColor = self.bottomLine.backgroundColor = IWColor(224, 223, 223);
    self.firstLeftLabel.textColor = self.secondLeftLabel.textColor = self.thirdLeftLabel.textColor = self.forthLeftLabel.textColor = self.fifthLeftLabel.textColor = IWColor(75, 75, 75);
    self.firstRightLabel.textColor = self.secondRightLabel.textColor = self.thirdRightLabel.textColor = self.fifthRightLabel.textColor = IWColor(75, 75, 75);
    self.firstRightLabel.backgroundColor = self.secondRightLabel.backgroundColor = self.thirdRightLabel.backgroundColor = self.forthRightLabel.backgroundColor = self.fifthRightLabel.backgroundColor = [UIColor clearColor];
    self.forthRightLabel.textColor = IWColor(25, 97, 158);
    self.dateTimeLabel.textColor = IWColor(170, 170, 170);
    
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
