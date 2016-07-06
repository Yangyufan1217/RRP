//
//  RRPSaleDetailPicCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPSaleDetailPicCell.h"

@implementation RRPSaleDetailPicCell

- (void)awakeFromNib {
    // Initialization code
    
    self.saleDetailBackView.image = [UIImage imageNamed:@"saleList"];
    
    
}
//赋值
- (void)showDataWithArray:(NSMutableArray *)imageUrlArr topImage:(NSString *)topimage
{
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",topimage]];
    [self.saleDetailBackView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"发现750-285"]];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld张",imageUrlArr.count];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
