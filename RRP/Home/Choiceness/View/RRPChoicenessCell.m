//
//  RRPChoicenessCell.m
//  RRP
//
//  Created by sks on 16/2/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChoicenessCell.h"
#import "RRPPeripheryModel.h"
#import "RRPHomeSelected.h"
@interface RRPChoicenessCell ()

@property (nonatomic, strong)NSString *string;

@end

@implementation RRPChoicenessCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
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
    
    
    self.commentNumberLabel.textColor = IWColor(159, 159, 159);
    self.commentNumberLabel.font = [UIFont systemFontOfSize:12];
    self.commentNumberLabel.backgroundColor = [UIColor clearColor];
    
    self.satisfyLabel.textColor = IWColor(255, 13, 69);
    self.satisfyLabel.font = [UIFont systemFontOfSize:12];
    self.satisfyLabel.backgroundColor = [UIColor clearColor];
    self.satisfyLabel.adjustsFontSizeToFitWidth = YES;
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
    self.scenerLabel.text = @"景区";
    self.cityLabel.hidden = YES;
}
//周边推荐赋值
- (void)showDataWithModel:(RRPPeripheryModel *)model
{
    [self.contentImageView sd_setImageWithURL:model.small_imgurl placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
    self.RRPtitleLabel.text = model.sceneryname;
    NSString *price = [model.sellerprice substringWithRange:NSMakeRange(0, [model.sellerprice length]-3)];
    self.moneyLabel.text = price;
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    if ([model.grade isEqualToString:@"0"]) {
        self.typeLabel.hidden = YES;
        self.scenerLabel.hidden = YES;
    }else
    {
        self.typeLabel.hidden = NO;
        self.scenerLabel.hidden = NO;
        self.typeLabel.text = [NSString stringWithFormat:@"%@A",model.grade];
    }
    if ([model.distance length] > 0) {
        NSString *distance = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]];
        self.journeyLabel.text = [NSString stringWithFormat:@"%@km",distance];
    }
    self.cityLabel.text = model.label;
    self.satisfyLabel.text = model.satisfied;
    NSString *originalPrice = [NSString stringWithFormat:@"%@",[model.marketprice substringWithRange:NSMakeRange(0, [model.marketprice length]-3)]];
    //原价横线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1.5, self.originalLabel.frame.size.height/2, [originalPrice length]*13.0, 1)];
    label.backgroundColor = IWColor(152, 152, 152);
    [self.originalLabel addSubview:label];

    self.originalLabel.text = [NSString stringWithFormat:@"￥%@",originalPrice];
    
}
//门票精选赋值
- (void)showDataWithTicketSelectedModel:(RRPHomeSelected *)model
{
    [self.contentImageView sd_setImageWithURL:model.small_imgurl placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
    self.RRPtitleLabel.text =model.sceneryname;
    NSString *price = [model.sellerprice substringWithRange:NSMakeRange(0, [model.sellerprice length]-3)];
    self.moneyLabel.text = price;
    NSString *originalPrice = [model.marketprice substringWithRange:NSMakeRange(0, [model.marketprice length]-3)];
    self.originalLabel.text = [NSString stringWithFormat:@"￥%@",originalPrice];
//    CGSize detailSize = [originalPrice sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:0];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 6, detailSize.width, 1)];
//    view.backgroundColor = IWColor(159, 159, 159);
//    [self.originalLabel addSubview:view];

    //原价横线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1.5, self.originalLabel.frame.size.height/2, [originalPrice length]*12.0, 1)];
    label.backgroundColor = IWColor(152, 152, 152);
    [self.originalLabel addSubview:label];
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    self.satisfyLabel.text = model.satisfied;
    if ([model.grade isEqualToString:@"0"]) {
        self.typeLabel.hidden = YES;
        self.scenerLabel.hidden = YES;
    }else
    {
        self.typeLabel.hidden = NO;
        self.scenerLabel.hidden = NO;
       self.typeLabel.text = [NSString stringWithFormat:@"%@A",model.grade];
    }
    NSString *distance = [NSString stringWithFormat:@"%.2fkm",[model.distance floatValue]];
    self.journeyLabel.text = distance;
      self.cityLabel.text = model.label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
