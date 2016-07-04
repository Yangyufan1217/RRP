//
//  RRPCoverViewCell.m
//  RRP
//
//  Created by sks on 16/2/26.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCoverViewCell.h"

@implementation RRPCoverViewCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.contentView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.headImageView.image = [UIImage imageNamed:@"scanWindow-phoneCall"];
    
    self.nameLabel.backgroundColor = self.numberLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = IWColor(23, 23, 23);
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    self.nameLabel.text = @"国内固话";
    
    self.numberLabel.textColor = IWColor(160, 160, 160);
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.text = @"4006982666";
    
    [self.touchButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) touchButton:(UIButton *)sender {
    NSInteger status = [RRPFindTopModel shareRRPFindTopModel].status;
    if (status == 1) {
        //统计:电话客服点击
        [MobClick event:@"23"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006982666"]];
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
