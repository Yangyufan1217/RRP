//
//  RRPChDetailsMapCell.h
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelectedDetailModel;
@interface RRPChDetailsMapCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

//控件赋值
- (void)showData:(RRPHomeSelectedDetailModel *)homeSelectedDetail;
@end
