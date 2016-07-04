//
//  RRPCollectTicketNameCell.h
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPTicketContactModel;
@interface RRPCollectTicketNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//赋值
- (void)showDataWithModel:(RRPTicketContactModel *)model;

@end
