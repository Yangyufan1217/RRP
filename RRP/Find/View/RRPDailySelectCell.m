//
//  RRPDailySelectCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/27.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDailySelectCell.h"
#import "RRPDailySelectModel.h"

@implementation RRPDailySelectCell

- (void)awakeFromNib {
    // Initialization code
    
    self.editeNumber.hidden = YES;
    self.edit.hidden = YES;
    
    //cell切圆
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 3;
    self.introduceLabel.backgroundColor = self.wirter.backgroundColor = self.positionDate.backgroundColor = [UIColor clearColor];
    self.centerView.image = [UIImage imageNamed:@"top_card"];
    self.bottomBackView.image = [UIImage imageNamed:@"bottom_card"];
    
    self.wirter.text = @"作者 : Chris Wan";
    self.positionDate.text = @"江苏-连云港|2013-5-15";
    
    
    
  }

- (void)show:(RRPDailySelectModel *)model {
    NSURL *url = [NSURL URLWithString:model.imgurl];
    [self.topPicView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"点评124-124"]];
    self.titleLabel.text = model.sceneryname;
    self.wirter.text = model.author;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.updatetime intValue]];
    NSString *time = [formatter stringFromDate:date];
    self.positionDate.text = [NSString stringWithFormat:@"%@|%@",model.addres,@"2016.5.23"];
    
    NSString *introduce = model.summary;
    self.introduceLabel.text = introduce;
    //设置自动换行
    //    self.introduceLabel.backgroundColor = [UIColor yellowColor];
    self.introduceLabel.font = [UIFont systemFontOfSize:9];
    //自动折行设置
    self.introduceLabel.lineBreakMode = 0;
    self.introduceLabel.numberOfLines = 7;//0 代表自动换行，1234...... 数字是几代表几行
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:introduce];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//行距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [introduce length])];
    [self.introduceLabel setAttributedText:attributedString];
    [self.introduceLabel sizeToFit];
    
    
    if (RRPWidth == 320 && RRPHeight == 480)
    {
        
        NSString *introduce = model.summary;
        self.introduceLabel.text = introduce;
        //设置自动换行
        //    self.introduceLabel.backgroundColor = [UIColor yellowColor];
        self.introduceLabel.font = [UIFont systemFontOfSize:9];
        //自动折行设置
        self.introduceLabel.lineBreakMode = 0;
        self.introduceLabel.numberOfLines = 3;//0 代表自动换行，1234...... 数字是几代表几行
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:introduce];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];//行距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [introduce length])];
        [self.introduceLabel setAttributedText:attributedString];
        [self.introduceLabel sizeToFit];
        
    }

}





@end
