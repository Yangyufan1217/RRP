//
//  RRPClassityFDetailCell.h
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPClassifyListModel;
@interface RRPClassityFDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *themImageView;
@property (weak, nonatomic) IBOutlet UILabel *themTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;//价格View

@property (nonatomic,strong)UILabel *priceLogo;//价格标志
@property (nonatomic,strong)UILabel *PriceLabel;//价格
@property (nonatomic,strong)UILabel *upPriceLogo;//起
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//评论
@property (weak, nonatomic) IBOutlet UILabel *satisfyLabel;//满意
//赋值
- (void)showDataWithModel:(RRPClassifyListModel *)model;

@end
