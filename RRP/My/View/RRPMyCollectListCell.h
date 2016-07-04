//
//  RRPMyCollectListCell.h
//  RRP
//
//  Created by sks on 16/3/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPCollectionModel;
@interface RRPMyCollectListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *RRPtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *satisfyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *journeyLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *seneryLabel;//景区

//赋值
- (void)showDataWithModel:(RRPCollectionModel *)model;

@end
