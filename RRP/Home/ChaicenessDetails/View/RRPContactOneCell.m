//
//  RRPContactOneCell.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPContactOneCell.h"

@implementation RRPContactOneCell

- (void)awakeFromNib {
    //颜色
    self.asteriskLabel.backgroundColor = self.needLabel.backgroundColor = self.needNumberLabel.backgroundColor = self.collectTicketLabel.backgroundColor = self.frontBracketLabel.backgroundColor = self.selectNumberLabel.backgroundColor = self.lineLabel.backgroundColor = self.grossNumberLabel.backgroundColor = self.backBracket.backgroundColor = [UIColor clearColor];
    //字体
    self.asteriskLabel.font = self.needLabel.font = self.collectTicketLabel.font = self.frontBracketLabel.font = self.selectNumberLabel.font = self.lineLabel.font = self.grossNumberLabel.font = self.backBracket.font = [UIFont systemFontOfSize:12];
    self.needNumberLabel.font = [UIFont systemFontOfSize:14];
    //字体颜色
    self.needLabel.textColor = self.collectTicketLabel.textColor = self.frontBracketLabel.textColor = self.selectNumberLabel.textColor = self.lineLabel.textColor = self.grossNumberLabel.textColor = self.backBracket.textColor = IWColor(125, 125, 125);
    self.asteriskLabel.textColor = self.needNumberLabel.textColor = IWColor(238, 66, 18);
    //赋值
    self.needNumberLabel.text = @"9";
    self.selectNumberLabel.text = @"9";
    self.grossNumberLabel.text = @"9";
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
