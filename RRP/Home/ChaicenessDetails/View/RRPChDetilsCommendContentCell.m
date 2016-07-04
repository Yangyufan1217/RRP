//
//  RRPChDetilsCommendContentCell.m
//  RRP
//
//  Created by sks on 16/2/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetilsCommendContentCell.h"
#import "RRPPeripheryModel.h"
@implementation RRPChDetilsCommendContentCell

- (void)awakeFromNib {
    self.contentView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));;
    //修改参数
    self.nameLabel.backgroundColor = self.moneyLabel.backgroundColor = self.riseLabel.backgroundColor = self.distanceLabel.backgroundColor = self.commentNumberLabel.backgroundColor = self.typeLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = self.moneyLabel.font = self.riseLabel.font = self.distanceLabel.font = self.commentNumberLabel.font = self.typeLabel.font =[UIFont systemFontOfSize:12];
    self.moneyLabel.textColor = IWColor(255, 13, 69);
    self.riseLabel.textColor = IWColor(255, 13, 69);
    self.distanceLabel.textColor = IWColor(159, 159, 159);
    self.commentNumberLabel.textColor =  IWColor(250, 250, 250);
    self.typeLabel.textColor =  IWColor(250, 250, 250);
    self.dimeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //赋值
    self.contentImageView.image = [UIImage imageNamed:@"故宫"];
    self.nameLabel.text = @"故宫故宫故宫故宫故宫故宫故宫故宫";
    self.moneyLabel.text = @"￥9999";
    self.riseLabel.text = @"起";
    self.distanceLabel.text = @"距景点9999km";
    self.commentNumberLabel.text = @"9999条评论";
    self.typeLabel.text = @"新品上线";
    self.typeLabel.hidden = YES;
    
}
//赋值
- (void)showDataWithModel:(RRPPeripheryModel *)model
{
    [self.contentImageView sd_setImageWithURL:model.imgurl placeholderImage:[UIImage imageNamed:@"当季热玩750-326"]];
    self.nameLabel.text = model.sceneryname;
    NSString *price = [model.sellerprice substringWithRange:NSMakeRange(0, [model.sellerprice length]-3)];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",price];
    if ([model.distance length] > 0) {
        NSString *distance = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]];
        self.distanceLabel.text = [NSString stringWithFormat:@"距景点%@km",distance];
    }
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    self.typeLabel.text = model.label;
    
}
@end
