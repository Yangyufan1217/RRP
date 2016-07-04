//
//  RRPMyCompileTwoCell.m
//  RRP
//
//  Created by sks on 16/3/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCompileTwoCell.h"

@implementation RRPMyCompileTwoCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.titleNameLabel.backgroundColor = [UIColor clearColor];
    self.titleNameLabel.textColor = IWColor(73, 73, 73);
    self.titleNameLabel.font = [UIFont systemFontOfSize:16];
    
    self.backView.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
