//
//  RRPMessageCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/28.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backPicView;//背景
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *topLine;//上部分割线
@property (weak, nonatomic) IBOutlet UILabel *firstLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *forthLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *forthRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;//底部分割线
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;//时间日期




@end
