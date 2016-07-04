//
//  RRPHomeHotCityCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRPAllCityModel.h"
@interface RRPHomeHotCityCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

//赋值
- (void)showData:(RRPAllCityModel *)model;

@end
