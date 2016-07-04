//
//  RRPChDetilsInformCell.h
//  RRP
//
//  Created by sks on 16/2/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelectedDetailModel;
@interface RRPChDetilsInformCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *informImageView;
@property (weak, nonatomic) IBOutlet UILabel *informNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferentialLabel;
@property (nonatomic,strong)UILabel *preferetialContentLabel;//特惠政策
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

- (void)showDataWithSelectedDetailModel:(RRPHomeSelectedDetailModel *)model;


+(CGFloat)cellHeight:(RRPHomeSelectedDetailModel *)model;
@end
