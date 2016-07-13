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
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.string = @"￥80";
    self.senicName.font = [UIFont systemFontOfSize:15];
    self.senicName.textColor = IWColor(106, 106, 106);
    self.senicName.backgroundColor = [UIColor clearColor];
    self.senicName.lineBreakMode = NSLineBreakByCharWrapping;//以单词为显示单位显示，后面部分省略不显示。
    
    self.recommendLabel.font = [UIFont systemFontOfSize:10];
    self.recommendLabel.textColor = IWColor(106, 106, 106);
    self.recommendLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.moneyLabel.textColor = IWColor(255, 13, 69);
    self.moneyLabel.font = [UIFont systemFontOfSize:10];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    
    self.comNumberLabel.textColor = IWColor(159, 159, 159);
    self.comNumberLabel.font = [UIFont systemFontOfSize:10];
    self.comNumberLabel.backgroundColor = [UIColor clearColor];
    
    self.satisfactionNumber.textColor = IWColor(255, 13, 69);
    self.satisfactionNumber.font = [UIFont systemFontOfSize:10];
    self.satisfactionNumber.backgroundColor = [UIColor clearColor];
    
    self.satisfactionLabel.textColor = IWColor(167, 167, 167);
    self.satisfactionLabel.text = @"景区满意度:";
    self.satisfactionLabel.font = [UIFont systemFontOfSize:10];
    
    
    self.distanceLabel.textColor = IWColor(159, 159, 159);
    self.distanceLabel.font = [UIFont systemFontOfSize:10];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    
    self.headImageView.image = [UIImage imageNamed:@"精选内容图"];
    self.senicName.text = @"凤凰古城";
    self.moneyLabel.text = @"￥200";
    self.comNumberLabel.text = @"1090条评论";
    self.satisfactionNumber.text = @"99%";
    self.distanceLabel.text = @"30km以上";
    self.distanceLabel.hidden = YES;
}
//赋值
- (void)showDataWithModel:(RRPCollectionModel *)model
{
    [self.headImageView sd_setImageWithURL:model.imgurl placeholderImage:[UIImage imageNamed:@"节日700-350"]];
    self.senicName.text = model.sname;
    NSString *price = [model.sellerprice substringWithRange:NSMakeRange(0, [model.sellerprice length]-3)];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@元起",price];
    self.comNumberLabel.text = [NSString stringWithFormat:@"%@条评论",model.commentnum];
    self.satisfactionNumber.text = model.Praisepercentage;
    self.recommendLabel.text = model.summary;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
