//
//  RRPCollectionCell.h
//  RRP
//
//  Created by sks on 16/2/24.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelected;
@interface RRPCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *riseLabel;

//控件赋值
- (void)showDate:(RRPHomeSelected *)homeSelected;



@end
