//
//  RRPClassityFDetailCell.m
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPClassityFDetailCell.h"
#import "RRPClassifyListModel.h"
@implementation RRPClassityFDetailCell

- (void)awakeFromNib {
    
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.contentView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.themImageView.image = [UIImage imageNamed:@"故宫"];
    self.themImageView.layer.masksToBounds = YES;
    self.themImageView.layer.cornerRadius = 3;

    
   //布局价格
    [self layoutPriceView];
    
    
}
//布局价格
- (void)layoutPriceView
{
    self.priceView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    //￥
    self.priceLogo = [[UILabel alloc] initWithFrame:CGRectMake(0,self.priceView.frame.size.height-13, 13, 13)];
    self.priceLogo.font = [UIFont systemFontOfSize:12];
    self.priceLogo.textAlignment = NSTextAlignmentCenter;
    self.priceLogo.textColor = IWColor(255, 56, 0);
    self.priceLogo.text = @"￥";
    self.priceLogo.adjustsFontSizeToFitWidth = YES;
    [self.priceView addSubview:self.priceLogo];
    //价格
    self.PriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLogo.frame)+1, self.priceView.frame.size.height-21, 50, 21)];
    self.PriceLabel.font = [UIFont systemFontOfSize:20];
    self.PriceLabel.textAlignment = NSTextAlignmentCenter;
    self.PriceLabel.textColor = IWColor(255, 56, 0);
    self.PriceLabel.text = @"1799";
    self.PriceLabel.adjustsFontSizeToFitWidth = YES;
    [self.priceView addSubview:self.PriceLabel];
    //起
    self.upPriceLogo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.PriceLabel.frame)+1, self.priceView.frame.size.height-13, 13, 13)];
    self.upPriceLogo.font = [UIFont systemFontOfSize:12];
    self.upPriceLogo.textAlignment = NSTextAlignmentCenter;
    self.upPriceLogo.adjustsFontSizeToFitWidth = YES;
    self.upPriceLogo.textColor = IWColor(121, 121, 121);
    self.upPriceLogo.text = @"起";
    [self.priceView addSubview:self.upPriceLogo];

}
- (void)showDataWithModel:(RRPClassifyListModel *)model
{
    //图片
   [self.themImageView sd_setImageWithURL:model.small_imgurl placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
    self.themTitleLabel.text = model.sceneryname;
    self.PriceLabel.text = model.sellerprice;
    self.commentLabel.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    self.satisfyLabel.text = [NSString stringWithFormat:@"%@满意",model.satisfied];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
