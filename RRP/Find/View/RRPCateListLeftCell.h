//
//  RRPCateListLeftCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/18.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindRecreationModel;
@interface RRPCateListLeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (nonatomic, strong) UIView *coverView;//蒙层
@property (nonatomic,strong)UILabel *RRPtitleLabel;//标题
@property (nonatomic,strong)UILabel *RRPcenterLabel;//中间label
@property (nonatomic,strong)UILabel *detailLabel;//简介


- (void)show:(FindRecreationModel *)model;

@end
