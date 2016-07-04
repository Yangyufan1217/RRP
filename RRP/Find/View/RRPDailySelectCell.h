//
//  RRPDailySelectCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/27.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRPDailySelectModel;
@interface RRPDailySelectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shandowView;//阴影图
@property (weak, nonatomic) IBOutlet UIImageView *topPicView;//顶部图片
@property (weak, nonatomic) IBOutlet UILabel *editeNumber;//第几期
@property (weak, nonatomic) IBOutlet UILabel *edit;//期
@property (weak, nonatomic) IBOutlet UIImageView *centerView;//中间边框背景图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UIImageView *bottomBackView;//底部背景图
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;//介绍
@property (weak, nonatomic) IBOutlet UILabel *wirter;//作者
@property (weak, nonatomic) IBOutlet UILabel *positionDate;//地点日期
@property (nonatomic, strong) UILabel *ycShortLabel;


- (void)show:(RRPDailySelectModel *)model;



@end
