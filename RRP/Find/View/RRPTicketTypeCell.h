//
//  RRPTicketTypeCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPTicketTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ticketTypeView;
@property (weak, nonatomic) IBOutlet UILabel *ticketTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *topLine;

@end
