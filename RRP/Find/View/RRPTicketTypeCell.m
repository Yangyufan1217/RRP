//
//  RRPTicketTypeCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPTicketTypeCell.h"

@implementation RRPTicketTypeCell

- (void)awakeFromNib {
   
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.ticketTypeView.image = [UIImage imageNamed:@"ticket-type"];
    self.ticketTypeLabel.text = @"门票类型";
    self.bottomLine.backgroundColor = IWColor(244, 245, 247);
    self.topLine.backgroundColor = IWColor(244, 245, 247);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
