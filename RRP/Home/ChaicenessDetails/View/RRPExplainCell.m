//
//  RRPExplainCell.m
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPExplainCell.h"

@implementation RRPExplainCell

- (void)awakeFromNib {
    self.numberLabel.backgroundColor = self.explainNameLabel.backgroundColor = self.explainLabel.backgroundColor = self.timeLabel.backgroundColor = self.timeContentLabel.backgroundColor = self.validLabel.backgroundColor = self.moneyLabel.backgroundColor = self.moneyNumberLabel.backgroundColor = [UIColor clearColor];
    self.numberLabel.font = self.explainNameLabel.font = self.explainLabel.font = self.timeLabel.font = self.timeContentLabel.font = self.validLabel.font = self.moneyLabel.font = self.moneyNumberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.textColor = self.explainLabel.textColor = self.timeLabel.textColor = self.moneyLabel.textColor = IWColor(174, 174, 174);
    self.explainLabel.text = @"产品名称：";
    self.explainNameLabel.text = @"世界大观园成人票";
    self.timeLabel.text = @"出行日期：";
    self.timeContentLabel.text = @"2016-03-07";
    self.numberLabel.text = @"购票数量：";
    self.validLabel.text = @"两张";
    self.moneyLabel.text = @"单价金额：";
    self.moneyNumberLabel.text = @" ";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
