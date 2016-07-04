//
//  RRPMyCauseCell.h
//  RRP
//
//  Created by sks on 16/3/15.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPMyCauseCell : UITableViewCell

@property (strong, nonatomic) UILabel *contentLabel;
//赋值
- (void)showDataWithString:(NSString *)string;
//自适应高度
+ (CGFloat)cellHight:(NSString *)string;

@end
