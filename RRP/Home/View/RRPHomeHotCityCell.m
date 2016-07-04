//
//  RRPHomeHotCityCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeHotCityCell.h"

@implementation RRPHomeHotCityCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
}
- (void)showData:(RRPAllCityModel *)model
{
    
    self.cityNameLabel.text = model.city_name;
}
@end
