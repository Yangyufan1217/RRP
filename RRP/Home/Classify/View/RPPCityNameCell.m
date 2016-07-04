//
//  RPPCityNameCell.m
//  RRP
//
//  Created by sks on 16/3/2.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RPPCityNameCell.h"

@implementation RPPCityNameCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.contentView.dk_backgroundColorPicker =
    DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
