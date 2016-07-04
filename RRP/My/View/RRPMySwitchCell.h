//
//  RRPMySwitchCell.h
//  RRP
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPMySwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *RRPTitleLabel;
@property (nonatomic, strong) UISwitch *RRPSwitch;

@end
