//
//  RRPSaleDetailPicCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPSaleDetailPicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *saleDetailBackView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

//赋值
- (void)showDataWithArray:(NSMutableArray *)imageUrlArr;

@end
