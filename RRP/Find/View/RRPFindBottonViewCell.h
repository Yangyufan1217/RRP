//
//  RRPFindBottonViewCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRPFindModel;
@interface RRPFindBottonViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomBackImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomCoverView;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UILabel *bottomLabel;


//控件赋值
- (void)show:(RRPFindModel *)model;


@end
