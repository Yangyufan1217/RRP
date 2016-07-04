//
//  RRPCollectionCell.m
//  RRP
//
//  Created by sks on 16/2/24.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCollectionCell.h"
#import "RRPHomeSelected.h"

@implementation RRPCollectionCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.rankLabel.text = @"5A景区";
    self.rankLabel.font = [UIFont systemFontOfSize:12];
    self.rankLabel.textColor = IWColor(250, 250, 250);
    self.rankLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.backImageView.image = [UIImage imageNamed:@"故宫"];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = IWColor(50, 50, 50);
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.text = @"故宫";
    
    self.introduceLabel.text = @"东方宫殿建筑代表，世界宫殿建筑典范";
//    self.introduceLabel.adjustsFontSizeToFitWidth = YES;//改变字体大小填满label
    self.introduceLabel.font = [UIFont systemFontOfSize:15];
    self.introduceLabel.backgroundColor = [UIColor clearColor];
    
    self.numberLabel.textColor = IWColor(235, 0, 68);
    self.numberLabel.text = @"9999";
    self.numberLabel.font = [UIFont systemFontOfSize:16];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.textColor = IWColor(235, 0, 68);
    self.moneyLabel.font = [UIFont systemFontOfSize:10];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.riseLabel.textColor = IWColor(235, 0, 68);
    self.riseLabel.font = [UIFont systemFontOfSize:10];
    self.riseLabel.backgroundColor = [UIColor clearColor];
    
}
//控件赋值
- (void)showDate:(RRPHomeSelected *)homeSelected
{
    //星级
    self.rankLabel.text = [NSString stringWithFormat:@"%@A景区",homeSelected.grade];
    [self.backImageView sd_setImageWithURL:homeSelected.imgurl placeholderImage:[UIImage imageNamed:@"首页精选门景区-田字排372-273"]];
    self.nameLabel.text = homeSelected.sceneryname;
    self.introduceLabel.text = homeSelected.summary;
    NSString *price = [homeSelected.sellerprice substringWithRange:NSMakeRange(0, [homeSelected.sellerprice length]-3)];
    self.numberLabel.text = price;

}



@end
