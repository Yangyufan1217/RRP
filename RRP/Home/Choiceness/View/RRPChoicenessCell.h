//
//  RRPChoicenessCell.h
//  RRP
//
//  Created by sks on 16/2/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPPeripheryModel;
@class RRPHomeSelected;
@interface RRPChoicenessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *RRPtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *satisfyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenerLabel;//景区
@property (weak, nonatomic) IBOutlet UILabel *journeyLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//周边推荐赋值
- (void)showDataWithModel:(RRPPeripheryModel *)model;
//门票精选赋值
- (void)showDataWithTicketSelectedModel:(RRPHomeSelected *)model;


@end
