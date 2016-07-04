//
//  RRPNoticeCell.m
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPNoticeCell.h"
#import "RRPHomeSelectedDetailModel.h"

@interface RRPNoticeCell ()

@property (nonatomic, strong) NSString *contentString;//内容字符串


@end

@implementation RRPNoticeCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.contentView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.bigtiteLabel.backgroundColor  = [UIColor clearColor];
    self.bigtiteLabel.text = @"温馨提示";
    self.bigtiteLabel.font = [UIFont boldSystemFontOfSize:12];
    self.bigtiteLabel.textColor = IWColor(21, 21, 21);
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bigtiteLabel.frame)+5, RRPWidth - 40, 50)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:10];
    self.contentLabel.textColor = IWColor(95, 95, 95);
    
    self.contentString = @"盛开着永不凋零，蓝莲花啊。。心中那自由世界，如此的清澈高远，盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊";
    self.contentLabel.text = self.contentString;
    self.contentLabel.numberOfLines = 0;
    
    //内容高度自适应
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [self.contentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;
    [self addSubview:self.contentLabel];
    
}
//赋值
- (void)showDataWithSelectedDetailStr:(NSString  *)str
{
    //特惠政策高度
    self.contentLabel.text = str;
    //内容高度自适应
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [str  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;

}
+ (CGFloat)cellHeight:(NSString *)str {
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth - 20, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  50 + rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
