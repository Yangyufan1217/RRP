//
//  RRPHomeOneTableViewCell.m
//  RRP
//
//  Created by sks on 16/2/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeOneTableViewCell.h"
#import "RRPHomeSelected.h"
@implementation RRPHomeOneTableViewCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.rankLabel.text = @"5A景区";
    self.rankLabel.font = [UIFont systemFontOfSize:12];
    self.rankLabel.textColor = IWColor(250, 250, 250);
    self.rankLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    self.nameLabel.text = @"故宫";
    self.backImageView.image = [UIImage imageNamed:@"故宫"];
    
    self.introduceLabel.text = @"东方宫殿建筑代表东方宫殿建筑代表，世界宫殿建筑典范";
    self.introduceLabel.textColor = IWColor(140, 139, 140);
//    self.introduceLabel.adjustsFontSizeToFitWidth = YES;//改变字体大小填满label
    self.introduceLabel.font = [UIFont systemFontOfSize:15];
    self.introduceLabel.backgroundColor = [UIColor clearColor];
    
    self.locationImageView.image = [UIImage imageNamed:@"sign-list-GPS"];
    self.locationImageView.backgroundColor = [UIColor clearColor];
    
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.text = @"37.5km";
    self.distanceLabel.textColor = IWColor(140, 139, 140);
    
    self.moneyBackView.backgroundColor = [UIColor clearColor];
    self.numberLabel.textColor = IWColor(235, 0, 68);
    self.numberLabel.text = @"200";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    self.numberLabel.textAlignment = NSTextAlignmentLeft;
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.numberLabel.textColor = IWColor(255, 42, 26);
    self.moneyLabel.textColor = IWColor(235, 0, 68);
    self.moneyLabel.font = [UIFont systemFontOfSize:15];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.originalLabel.textColor = IWColor(152, 152, 152);
    self.siteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.introduceLabel.frame)+10, 220, 18)];
    self.siteLabel.textColor = IWColor(140, 139, 140);
//    self.siteLabel.text = @"地址：北京市东城区景山前街4号";
    self.siteLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.siteLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//赋值
- (void)showDateWithRRPHomeSelected:(RRPHomeSelected *)homeSelected
{
    if ([homeSelected.grade isEqualToString:@"0"]) {
        self.rankLabel.hidden = YES;
    }else{
    self.rankLabel.hidden = NO;
     self.rankLabel.text = [NSString stringWithFormat:@"%@A景区",homeSelected.grade];
    }
    self.nameLabel.text = homeSelected.sceneryname;
    [self.backImageView sd_setImageWithURL:homeSelected.imgurl placeholderImage:[UIImage imageNamed:@"740-350"]];
    self.introduceLabel.text = homeSelected.summary;
    if ([homeSelected.sellerprice length] > 0) {
        NSString *price = [homeSelected.sellerprice substringWithRange:NSMakeRange(0, [homeSelected.sellerprice length]-3)];
        NSString *nowPrice = [NSString stringWithFormat:@"%@起",price];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nowPrice];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [price length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,[price length])];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange([price length],1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([price length], 1)];
        self.numberLabel.attributedText = str;
    }
    NSString *price = [homeSelected.marketprice substringWithRange:NSMakeRange(0, [homeSelected.marketprice length]-3)];
    NSString *originalPriceStr = [NSString stringWithFormat:@"￥%@",price];
    self.originalLabel.text = originalPriceStr;
    //原价横线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1.5, self.originalLabel.frame.size.height/2, [originalPriceStr length]*10.0, 1)];
    label.backgroundColor = IWColor(152, 152, 152);
    [self.originalLabel addSubview:label];
    //距离
    NSString *distance = [NSString stringWithFormat:@"%.2f",[homeSelected.distance floatValue]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",distance];
}






@end
