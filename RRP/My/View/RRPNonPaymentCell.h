//
//  RRPNonPaymentCell.h
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPNoPayModel;
@class RRPNoTravelModel;
@class RRPNoCommentModel;
@interface RRPNonPaymentCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;//景点名
@property (weak, nonatomic) IBOutlet UIImageView *scenicHeadImageView;//风景头像图片
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;//时间内容
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//票数量
@property (weak, nonatomic) IBOutlet UILabel *numberContentLabel;//票数量内容
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//价钱
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;//支付按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;//取消按钮
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//背景View
@property (nonatomic, assign) NSInteger number;

+ (CGFloat)cellHeight:(RRPNoPayModel *)model;
//未支付赋值
- (void)showDataWithNoPayModel:(RRPNoPayModel *)model;
//未出行赋值
- (void)showDataWithNoTravelModel:(RRPNoTravelModel *)model;
//待评价赋值
- (void)showDataWithNoCommentModel:(RRPNoCommentModel *)model;

@end
