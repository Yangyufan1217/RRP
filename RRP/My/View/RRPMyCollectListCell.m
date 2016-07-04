//
//  RRPMyCollectListCell.m
//  RRP
//
//  Created by sks on 16/3/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCollectListCell.h"
#import "RRPCollectionModel.h"
@interface RRPMyCollectListCell ()

@property (nonatomic, strong)NSString *string;

@end

@implementation RRPMyCollectListCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.string = @"￥80";
    self.RRPtitleLabel.font = [UIFont systemFontOfSize:16];
    self.RRPtitleLabel.textColor = IWColor(106, 106, 106);
    self.RRPtitleLabel.backgroundColor = [UIColor clearColor];
    
    self.moneyLabel.textColor = IWColor(255, 13, 69);
    self.moneyLabel.font = [UIFont systemFontOfSize:23];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    
    self.originalLabel.textColor = IWColor(159, 159, 159);
    self.originalLabel.font = [UIFont systemFontOfSize:12];
    self.originalLabel.backgroundColor = [UIColor clearColor];
    CGSize detailSize = [self.string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 6, detailSize.width, 1)];
    view.backgroundColor = IWColor(159, 159, 159);
    [self.originalLabel addSubview:view];
    
    
    self.commentNumberLabel.textColor = IWColor(159, 159, 159);
    self.commentNumberLabel.font = [UIFont systemFontOfSize:12];
    self.commentNumberLabel.backgroundColor = [UIColor clearColor];
    
    self.satisfyLabel.textColor = IWColor(255, 13, 69);
    self.satisfyLabel.font = [UIFont systemFontOfSize:12];
    self.satisfyLabel.backgroundColor = [UIColor clearColor];
    
    self.typeLabel.textColor = IWColor(255, 13, 69);
    self.typeLabel.font = [UIFont systemFontOfSize:12];
    self.typeLabel.backgroundColor = [UIColor clearColor];
    
    self.journeyLabel.textColor = IWColor(159, 159, 159);
    self.journeyLabel.font = [UIFont systemFontOfSize:12];
    self.journeyLabel.backgroundColor = [UIColor clearColor];
    
    self.cityLabel.textColor = IWColor(159, 159, 159);
    self.cityLabel.font = [UIFont systemFontOfSize:12];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    
    self.contentImageView.image = [UIImage imageNamed:@"精选内容图"];
    self.RRPtitleLabel.text = @"凤凰古城";
    self.moneyLabel.text = @"200";
    self.originalLabel.text = self.string;
    self.commentNumberLabel.text = @"1090条点评";
    self.satisfyLabel.text = @"99%";
    self.typeLabel.text = @"4A";
    self.journeyLabel.text = @"30km以上";
    self.cityLabel.text = @"城市观光";
    self.seneryLabel.text = @"景区";
    self.cityLabel.hidden = YES;
}
//赋值
- (void)showDataWithModel:(RRPCollectionModel *)model
{
    [self.contentImageView sd_setImageWithURL:model.imgurl placeholderImage:[UIImage imageNamed:@"节日700-350"]];
    self.RRPtitleLabel.text = model.sname;
    NSString *price = [model.sellerprice substringWithRange:NSMakeRange(0, [model.sellerprice length]-3)];
    self.moneyLabel.text = price;
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%@条评论",model.commentnum];
    self.satisfyLabel.text = model.Praisepercentage;
    if ([model.grade isEqualToString:@"0"]) {
        self.typeLabel.hidden = YES;
        self.seneryLabel.hidden = YES;
    }else
    {
      self.typeLabel.hidden = NO;
      self.seneryLabel.hidden = NO;
      self.typeLabel.text = [NSString stringWithFormat:@"%@A",model.grade];
    }
    self.journeyLabel.hidden = YES;
    self.cityLabel.text = model.classname;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
