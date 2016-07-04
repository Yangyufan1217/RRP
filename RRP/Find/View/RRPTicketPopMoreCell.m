//
//  RRPTicketPopMoreCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/24.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPTicketPopMoreCell.h"

@implementation RRPTicketPopMoreCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
    self.popMoreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.popMoreButton.frame = CGRectMake(8, 0, RRPWidth-16, 20);
    [self.popMoreButton setBackgroundImage:[UIImage imageNamed:@"更多票"] forState:(UIControlStateNormal)];
    [self addSubview:self.popMoreButton];
    [self.popMoreButton addTarget:self action:@selector(popMoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
//弹出更多
- (void)popMoreAction:(UIButton *)bt
{
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"弹出更多门票" object:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
