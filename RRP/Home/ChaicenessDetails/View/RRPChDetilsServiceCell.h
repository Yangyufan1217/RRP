//
//  RRPChDetilsServiceCell.h
//  RRP
//
//  Created by sks on 16/2/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPChDetilsServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end
