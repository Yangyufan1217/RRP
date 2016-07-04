//
//  RRPNoticeCell.h
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelectedDetailModel;
@interface RRPNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bigtiteLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)showDataWithSelectedDetailStr:(NSString  *)str;

+ (CGFloat)cellHeight:(NSString *)str;


@end
