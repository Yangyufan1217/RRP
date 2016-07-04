//
//  RRPmoneyCell.m
//  RRP
//
//  Created by sks on 16/3/3.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPmoneyCell.h"

@implementation RRPmoneyCell

- (void)awakeFromNib {
    
    self.RRPtitleLabel.backgroundColor = [UIColor clearColor];
    self.RRPtitleLabel.font = [UIFont systemFontOfSize:14];
    self.RRPtitleLabel.textColor = IWColor(225, 225, 225);
    self.RRPtitleLabel.text = @"1、预定时间";
    
    self.RRPcontentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.RRPtitleLabel.frame)+10, RRPWidth-60, 60)];
    self.RRPcontentLabel.numberOfLines = 0;
    self.RRPcontentLabel.backgroundColor = [UIColor clearColor];
    self.RRPcontentLabel.text = @"啦啦啦啦啦啦啦啦啦啦啦啦啦啊啦啦啦啦啦啦啦啦啦啦啦啦啦阿拉蕾啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦";
    self.RRPcontentLabel.numberOfLines = 0;
    self.RRPcontentLabel.textColor = IWColor(225, 225, 225);
    self.RRPcontentLabel.font = [UIFont systemFontOfSize:13];
    //内容高度自适应
    CGSize size = CGSizeMake(self.RRPcontentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [self.RRPcontentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.RRPcontentLabel.frame;
    frame.size.height = rect.size.height;
    self.RRPcontentLabel.frame = frame;
    [self addSubview:self.RRPcontentLabel];
    
}
//赋值
- (void)showDataWithString:(NSString *)str
{
    self.RRPcontentLabel.text = str;
    //内容高度自适应
    CGSize size = CGSizeMake(RRPWidth-60, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.RRPcontentLabel.frame;
    frame.size.height = rect.size.height;
    self.RRPcontentLabel.frame = frame;

}
//cell高度
+ (CGFloat)cellHeight:(NSString *)str
{
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth - 60, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return    40 + rect.size.height;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
