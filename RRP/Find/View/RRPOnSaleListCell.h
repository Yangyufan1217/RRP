//
//  RRPOnSaleListCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRPFindSaleListModel;
@interface RRPOnSaleListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet UIImageView *topBackPicView;//景点图片
@property (weak, nonatomic) IBOutlet UIImageView *privilegePicView;//优惠图片
@property (weak, nonatomic) IBOutlet UILabel *privilegeTopLabel;//立减
@property (weak, nonatomic) IBOutlet UILabel *priviligePriceLabel;//立减价格
@property (weak, nonatomic) IBOutlet UILabel *seberyNameLabel;//景点名称
@property (weak, nonatomic) IBOutlet UILabel *stopDateLabel;//截止日期
@property (weak, nonatomic) IBOutlet UILabel *activityIntroduceLabel;//活动简介
@property (weak, nonatomic) IBOutlet UIImageView *currentPricePic;//现价背景图
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;//现价
@property (weak, nonatomic) IBOutlet UIImageView *originalPricePic;//原价背景图
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;//原价

- (void)showCell:(RRPFindSaleListModel *)model;








@end
