//
//  RRPRefundCell.h
//  RRP
//
//  Created by sks on 16/3/14.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPRefundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *RRPcontentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UILabel *mostLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//最多多少钱
@property (weak, nonatomic) IBOutlet UILabel *deductContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *deductMoneyLabel;//扣除手续费多少钱
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;



@end
