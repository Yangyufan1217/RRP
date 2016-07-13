//
//  RRPAddGetTicketView.m
//  RRP
//
//  Created by WangZhaZha on 16/7/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAddGetTicketView.h"

@implementation RRPAddGetTicketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //布局topView
        [self layoutAddView];
        
    }
    return self;
    
}
- (void)layoutAddView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = IWColor(251, 105, 42).CGColor;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,70,17)];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = IWColor(103, 103, 103);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"取票人信息";
    [backView addSubview:self.titleLabel];
    
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+10, self.frame.size.width, 1)];
    self.topLine.backgroundColor = IWColor(242, 245, 247);
    [backView addSubview:self.topLine];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 17)];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor =
 
}
@end
