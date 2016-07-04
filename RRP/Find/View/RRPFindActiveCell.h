//
//  RRPFindActiveCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RRPFindActiveCell : UICollectionViewCell
@property (nonatomic,strong)UIView *leftBackView;
@property (nonatomic,strong)UIView *centerBackView;
@property (nonatomic,strong)UIView *rightBackView;
//左侧
@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UILabel *leftTitleLable;
@property (nonatomic,strong)UILabel *leftDetailLabel;
//中间
@property (nonatomic,strong)UIImageView *centerImageView;
@property (nonatomic,strong)UILabel *centerTitleLabel;
@property (nonatomic,strong)UILabel *centerDeatilLabel;
//右侧
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *rightTitleLabel;
@property (nonatomic,strong)UILabel *rightDetailLabel;


@end
