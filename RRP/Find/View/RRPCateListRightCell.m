//
//  RRPCateListRightCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/18.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCateListRightCell.h"
#import "FindRecreationModel.h"

@interface RRPCateListRightCell ()

@end
@implementation RRPCateListRightCell

- (void)awakeFromNib {
    // Initialization code
    
    //设置蒙层
    [self layoutCoverView];
    //设置喷枪打字
    [self layoutPrintLabel];
    
}

- (void)showData:(FindRecreationModel *)model {
    self.RRPtitleLabel.text = model.sceneryname;
    self.centerLabel.text = [self getNameWithChineseName:model.sceneryname];
    self.detailLabel.text = model.summary;
    //图片异步加载
    [self.backView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"发现750-285"]];
}
-(NSString *)getNameWithChineseName:(NSString *)name
{
    //转化为可变字符串
    NSMutableString *muName = [NSMutableString stringWithFormat:@"%@",name];
    //转化为带音调的拼音
    CFStringTransform((CFMutableStringRef)muName , NULL, kCFStringTransformMandarinLatin, NO);
    //转化为不带音调的拼音
    CFStringTransform((CFMutableStringRef)muName, NULL, kCFStringTransformStripDiacritics, NO);
    
    return muName;
    
}
//设置蒙层
- (void)layoutCoverView
{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/2, 0, RRPWidth/2,RRPWidth/750*370)];
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.backView addSubview:_coverView];
    
}
//设置喷枪打字
- (void)layoutPrintLabel
{
    //标题
    self.RRPtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 23, self.coverView.frame.size.width - 50, 32)];
    self.RRPtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    //居中
    self.RRPtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.RRPtitleLabel.numberOfLines = 0;
    self.RRPtitleLabel.textColor = [UIColor whiteColor];
    self.RRPtitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.coverView addSubview:self.RRPtitleLabel];
    
    //英文
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.RRPtitleLabel.frame)+4, self.coverView.frame.size.width - 50, 18)];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.numberOfLines = 0;
    self.centerLabel.font = [UIFont systemFontOfSize:8];
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    self.centerLabel.textAlignment= NSTextAlignmentCenter;
    self.centerLabel.textColor = [UIColor whiteColor];
    
    [self.coverView addSubview:_centerLabel];
    
    //简介
    //在这里label行间距，实现原理是通过字符串长度和label宽度来计算可以显示在多少行，然后设置行与行间的间距
//    self.string = @"北京新世纪日航饭店毗邻西外大街,地理位置优越,是商旅客人理想的下榻之地";
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.centerLabel.frame)+10, self.coverView.frame.size.width - 50, 70)];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.font = [UIFont systemFontOfSize:10];
    self.detailLabel.textAlignment = 0;
    self.detailLabel.lineBreakMode = 0;
    self.detailLabel.numberOfLines = 0;//0 代表自动换行，1234...... 数字是几代表几行
    [self.coverView addSubview:self.detailLabel];
    
 }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
