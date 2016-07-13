//
//  RRPOpenTimeCell.m
//  RRP
//
//  Created by WangZhaZha on 16/7/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPOpenTimeCell.h"

@implementation RRPOpenTimeCell

- (void)awakeFromNib {

    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *openTimeLavel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,RRPWidth-20, 50)];
    openTimeLavel.textColor = IWColor(174, 174, 174);
    openTimeLavel.font = [UIFont systemFontOfSize:13];
    openTimeLavel.numberOfLines = 0;
    openTimeLavel.text = @"开放时间: 旺季早8:00-晚17:00不得以让部分由日本毕业人部分也日光浴护肤乳液放";
    [self.contentView addSubview:openTimeLavel];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
