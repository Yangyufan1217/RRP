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

@property (weak, nonatomic) IBOutlet UIView *backView;
//头部图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//景区名字
@property (weak, nonatomic) IBOutlet UILabel *senicName;
//满意度
@property (weak, nonatomic) IBOutlet UILabel *satisfactionLabel;
//满意度数量
@property (weak, nonatomic) IBOutlet UILabel *satisfactionNumber;

//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

//景区介绍
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;

//价格
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//评论数量
@property (weak, nonatomic) IBOutlet UILabel *comNumberLabel;






//周边推荐赋值
- (void)showDataWithModel:(RRPPeripheryModel *)model;
//门票精选赋值
- (void)showDataWithTicketSelectedModel:(RRPHomeSelected *)model;


@end
