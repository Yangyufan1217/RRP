//
//  RRPMyInviteFriendCell.h
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHContactModel;
@interface RRPMyInviteFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;


//控件赋值
- (void)showDate:(MHContactModel *)model;



@end
