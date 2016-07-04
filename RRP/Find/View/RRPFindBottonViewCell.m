//
//  RRPFindBottonViewCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindBottonViewCell.h"
#import "RRPFindModel.h"

@implementation RRPFindBottonViewCell

- (void)awakeFromNib {
    
    self.bottomBackImageView.image = [UIImage imageNamed:@"bottomPic"];
    self.bottomCoverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    //topLabel
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,RRPWidth/750*335/2-26, RRPWidth-26, 25)];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:19];
    [self.bottomCoverView addSubview:self.topLabel];
    //bottomLabel
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(self.topLabel.frame)+2, RRPWidth-26, 17)];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomCoverView addSubview:self.bottomLabel];
    
    
    self.topLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.textColor = [UIColor whiteColor];
    
}
//控件赋值
- (void)show:(RRPFindModel *)model {
    self.topLabel.text = model.sceneryname;
//    NSLog(@"%@",self.topLabel.text);
    self.bottomLabel.text = model.summary;
    //图片异步加载
    NSString *string = model.imgurl;
    NSURL *url = [NSURL URLWithString:string];
    [self.bottomBackImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"发现750-285"]];
    
}



@end
