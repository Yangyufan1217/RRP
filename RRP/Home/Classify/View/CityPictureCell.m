//
//  CityPictureCell.m
//  RRP
//
//  Created by sks on 16/2/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "CityPictureCell.h"
#import "RRPClassifyListModel.h"
@implementation CityPictureCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.contentView.dk_backgroundColorPicker =
    DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.cityPictureImage.image = [UIImage imageNamed:@"东方明珠"];
    self.orderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.cityName.textColor = [UIColor whiteColor];
    self.cityName.text = @"━东方明珠━";
    
    
}
//赋值
- (void)showDataWithModel:(RRPClassifyListModel *)model
{
    [self.cityPictureImage sd_setImageWithURL:model.imgurl placeholderImage:[UIImage imageNamed:@"更多240-300"]];
    self.cityName.text = [NSString stringWithFormat:@"━%@━",model.sceneryname];
}
@end
