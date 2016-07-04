//
//  RRPAllOrderCell.h
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPAllOrderModel;
@interface RRPAllOrderCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;//景区名
@property (weak, nonatomic) IBOutlet UIImageView *scenicHeadImageView;//风景头像图片
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;//时间内容
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//票数量
@property (weak, nonatomic) IBOutlet UILabel *numberContentLabel;//票数量内容
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//价钱
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;//支付按钮
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//背景View

@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;

+ (CGFloat)cellHeight:(RRPAllOrderModel *)model;
//赋值
- (void)showDataWithModel:(RRPAllOrderModel *)model;

@end
