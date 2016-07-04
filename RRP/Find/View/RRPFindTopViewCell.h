//
//  RRPFindTopViewCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRPFindModel;
@interface RRPFindTopViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topBackImageView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UILabel *bottomLabel;

//控件赋值
- (void)show:(RRPFindModel *)model;


@end
