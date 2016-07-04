//
//  RRPMyCauseCell.m
//  RRP
//
//  Created by sks on 16/3/15.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCauseCell.h"

@interface RRPMyCauseCell ()

@property (nonatomic, strong) NSString *string;

@end

@implementation RRPMyCauseCell

- (void)awakeFromNib {
    self.string = @"谁，执我之手，敛我半世癫狂；谁，吻我之眸，遮我半世流离；";
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, RRPWidth/2-16-20, 30)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = IWColor(169, 169, 169);
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = self.string;
    //内容高度自适应
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [self.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;
    [self addSubview:self.contentLabel];
}
//赋值
- (void)showDataWithString:(NSString *)string
{
    self.contentLabel.text = string;
    //内容高度自适应
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;
}
+ (CGFloat)cellHight:(NSString *)string {
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth/2-16-20, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  10+rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
