//
//  RRPFindTopViewCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindTopViewCell.h"
#import "RRPFindModel.h"

@implementation RRPFindTopViewCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor clearColor], IWColor(200, 200, 200));
    self.topBackImageView.image = [UIImage imageNamed:@"cate"];
    self.topBackImageView.layer.masksToBounds = YES;
    self.topBackImageView.layer.cornerRadius = 5;
    self.coverView.layer.masksToBounds = YES;
    self.coverView.layer.cornerRadius = 5;
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //topLabel
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, (RRPWidth-32)/8-18, (RRPWidth-32)/2-26, 17)];
    self.topLabel.backgroundColor = [UIColor yellowColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:14];
    [self.coverView addSubview:self.topLabel];
    //bottomLabel
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,CGRectGetMaxY(self.topLabel.frame)+2, (RRPWidth-32)/2-26, 17)];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.backgroundColor = [UIColor yellowColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    [self.coverView addSubview:self.bottomLabel];
    
    
    self.topLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = self.bottomLabel.backgroundColor = [UIColor clearColor];
    
    self.topLabel.text = @"美食";
    self.bottomLabel.text = @"cate";
    
}

- (void)show:(RRPFindModel *)model {
    self.topLabel.text = model.name;
}

@end
