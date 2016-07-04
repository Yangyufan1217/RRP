//
//  RRPChDetilsInformCell.m
//  RRP
//
//  Created by sks on 16/2/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetilsInformCell.h"
#import "RRPNoticeController.h"
#import "RRPHomeSelectedDetailModel.h"
@implementation RRPChDetilsInformCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    //去掉背景颜色
    self.informNameLabel.backgroundColor = self.timeLabel.backgroundColor = self.timeContentLabel.backgroundColor = self.preferentialLabel.backgroundColor = self.preferetialContentLabel.backgroundColor = self.moreButton.backgroundColor =  [UIColor clearColor];
    [self.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
    //确定字体
    self.informNameLabel.font = [UIFont systemFontOfSize:16];
    self.timeLabel.font = self.preferentialLabel.font = [UIFont systemFontOfSize:14];
    self.timeContentLabel.font = self.preferetialContentLabel.font = [UIFont systemFontOfSize:12];
    
    self.informImageView.image = [UIImage imageNamed:@"sign-list-notice"];
    self.informNameLabel.text = @"须知";
    self.timeLabel.text = @"开放时间";
    self.timeContentLabel.text = @"夏季08：00-18：00冬季09：00-16：00";
     self.preferentialLabel.text = @"特惠政策";
    
    self.preferetialContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.preferentialLabel.frame)+15, RRPWidth-20, 40)];
    self.preferetialContentLabel.numberOfLines = 0;
    [self addSubview:self.preferetialContentLabel];
    self.preferetialContentLabel.font = [UIFont systemFontOfSize:12];
    NSString *string = @"儿童身高1.2米以下免费；";
    NSString *str = @"65周岁（不包含65周岁）以上老年人凭老年证免费";
    self.preferetialContentLabel.text = [NSString stringWithFormat:@"%@%@",string,str];
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];

}
- (void)moreButton:(UIButton *)sender {
    
    //统计:须知点击
    [MobClick event:@"18"];
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"全部评论" object:self userInfo:@{@"value":sender}];
}
//赋值
- (void)showDataWithSelectedDetailModel:(RRPHomeSelectedDetailModel *)model
{
    self.timeContentLabel.text = model.businesshours;
    //特惠政策高度
    self.preferetialContentLabel.text = model.favouredpolicy;
    //内容高度自适应
    CGSize size = CGSizeMake(self.preferetialContentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect rect = [model.favouredpolicy boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.preferetialContentLabel.frame;
    frame.size.height = rect.size.height;
    self.preferetialContentLabel.frame = frame;
}

+(CGFloat)cellHeight:(RRPHomeSelectedDetailModel *)model{
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth - 20, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect rect = [model.favouredpolicy boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  210 + rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
