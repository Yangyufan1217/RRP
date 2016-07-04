//
//  RRPScenicTicketCell.h
//  RRP
//
//  Created by WangZhaZha on 16/4/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPSelectedTicketModel;
@interface RRPScenicTicketCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backFrameView;//背景图
@property (nonatomic,strong)NSString *ticketName;//票名
@property (nonatomic,strong)UILabel *ticketNameLabel;//景区票名
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;//须知
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;//虚线
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;//人人票标志
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLogo;//现价标志
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;//现价

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;//原价
@property (weak, nonatomic) IBOutlet UIButton *orderImageView;//预定按钮



//赋值
- (void)showDataWithModel:(RRPSelectedTicketModel *)model;

//自适应高度
+(CGFloat)cellHeight:(RRPSelectedTicketModel *)model;










@end
