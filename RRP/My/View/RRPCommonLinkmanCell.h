//
//  RRPCommonLinkmanCell.h
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPTicketContactModel;
@interface RRPCommonLinkmanCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *perfectRemindLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *compileImageView;
@property (weak, nonatomic) IBOutlet UIButton *compileButton;

//赋值
- (void)showDataWithModel:(RRPTicketContactModel *)model;

@end
