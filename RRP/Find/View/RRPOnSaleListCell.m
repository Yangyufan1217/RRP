//
//  RRPOnSaleListCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPOnSaleListCell.h"
#import "RRPFindSaleListModel.h"

@implementation RRPOnSaleListCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
    self.bottomBackView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.priviligePriceLabel.adjustsFontSizeToFitWidth = YES;
    self.stopDateLabel.adjustsFontSizeToFitWidth = YES;
    self.activityIntroduceLabel.adjustsFontSizeToFitWidth = YES;
    self.currentPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.originalPriceLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)showCell:(RRPFindSaleListModel *)model {
    [self.topBackPicView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"发现750-285"]];
    self.priviligePriceLabel.text = [NSString stringWithFormat:@"￥%ld",[model.marketprice integerValue] - [model.sellerprice integerValue]];
    self.seberyNameLabel.text = model.ticketname;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.stopselldate intValue]];
    NSString *time = [formatter stringFromDate:date];
    self.stopDateLabel.text = [NSString stringWithFormat:@"截止时间:%@",time];
    self.activityIntroduceLabel.text = [NSString stringWithFormat:@"活动期间:低至%@",model.sellerprice];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.sellerprice];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.marketprice];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
