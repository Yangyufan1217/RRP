//
//  RRPExplainCell.h
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPExplainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *explainNameLabel;//产品名称
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;//产品
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;//日期内容
@property (weak, nonatomic) IBOutlet UILabel *validLabel;//有效期
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyNumberLabel;//金额数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//票数量



@end
