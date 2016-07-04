//
//  RRPMySwitchCell.m
//  RRP
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMySwitchCell.h"
#import "DKNightVersion.h"


@implementation RRPMySwitchCell

- (void)awakeFromNib {
    
    self.titleImageView.image = [UIImage imageNamed:@"home-family"];
    self.titleImageView.clipsToBounds = YES;
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.RRPTitleLabel.font = [UIFont systemFontOfSize:15];
    self.RRPTitleLabel.text = @"夜间模式";
    self.RRPTitleLabel.textColor = IWColor(15, 15, 15);
    self.RRPTitleLabel.backgroundColor = [UIColor clearColor];
    self.RRPSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(RRPWidth - 60, 10, 45, 20)];
//    RRPSwitch.onTintColor = [UIColor yellowColor];//开启颜色
//    RRPSwitch.tintColor = [UIColor brownColor];//关闭颜色
//    RRPSwitch.onImage = [UIImage imageNamed:@"save"];//开启图片
//    RRPSwitch.offImage = [UIImage imageNamed:@"bookTicket"];//关闭图片
//    RRPSwitch.thumbTintColor = [UIColor blackColor];//圆形按钮颜色
    [self.RRPSwitch setOn:NO animated:YES];//设置开关状态和动画效果
    [self.RRPSwitch addTarget:self action:@selector(switchSlideYesOrNo:) forControlEvents:(UIControlEventValueChanged)];
    
    [self addSubview:self.RRPSwitch];
    
    
}
- (void)switchSlideYesOrNo:(UISwitch *)sender {
    if (sender.isOn) {
        //开启夜间模式
        [DKNightVersionManager nightFalling];
        //统计:夜间模式点击
        NSDictionary *dict = @{@"type":@"夜间模式"};
        [MobClick event:@"94" attributes:dict];
    }else{
        //开启白天模式
        [DKNightVersionManager dawnComing];
        //统计:夜间模式点击
         NSDictionary *dict = @{@"type":@"白天模式"};
         [MobClick event:@"94" attributes:dict];


    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
