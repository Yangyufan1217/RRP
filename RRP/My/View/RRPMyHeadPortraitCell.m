//
//  RRPMyHeadPortraitCell.m
//  RRP
//
//  Created by sks on 16/3/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyHeadPortraitCell.h"

@implementation RRPMyHeadPortraitCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150,150, 150));
    self.titleNameLabel.backgroundColor = [UIColor clearColor];
    self.titleNameLabel.text = @"头像";
    self.titleNameLabel.font = [UIFont systemFontOfSize:16];
    self.titleNameLabel.textColor = IWColor(73, 73, 73);
    
    self.headPortaitButton.backgroundColor = [UIColor clearColor];
    self.headPortaitButton.layer.cornerRadius = self.headPortaitButton.frame.size.width/2;
    self.headPortaitButton.layer.masksToBounds = YES;
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"home-middleList-more"] forState:(UIControlStateNormal)];
    self.moreButton.backgroundColor = [UIColor clearColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
