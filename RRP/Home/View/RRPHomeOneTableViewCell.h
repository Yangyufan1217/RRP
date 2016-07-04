//
//  RRPHomeOneTableViewCell.h
//  RRP
//
//  Created by sks on 16/2/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelected;
@interface RRPHomeOneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;//级别
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//背景图
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;//介绍

@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;//定位
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//距离

@property (weak, nonatomic) IBOutlet UIView *moneyBackView;
@property (nonatomic, strong)UILabel *moneyNumberLabel;//现价起
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;//原价

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//钱图标
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量
@property (nonatomic,strong) UILabel *siteLabel;//地址

//赋值
- (void)showDateWithRRPHomeSelected:(RRPHomeSelected *)homeSelected;


@end
